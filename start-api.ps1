param(
    [string]$ModelVersion = "v2"
)

$ErrorActionPreference = "SilentlyContinue"
chcp 65001 | Out-Null

Write-Host "GPT-SoVITS API Server Launcher" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green

Set-Location $PSScriptRoot

Write-Host "Starting GPT-SoVITS API Server with $ModelVersion model..." -ForegroundColor Yellow

# Kill existing API server processes
Get-Process python -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*api_v2.py*" } | Stop-Process -Force

$configFile = "GPT_SoVITS\configs\tts_infer.yaml"

Write-Host "Configuring $ModelVersion model..." -ForegroundColor Cyan

# Update configuration based on model version
switch ($ModelVersion) {
    "v2" {
        Write-Host "- v2 model (stable, fast)" -ForegroundColor White
        (Get-Content $configFile) -replace 'version: .*', 'version: v2' | Set-Content $configFile
        (Get-Content $configFile) -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt' | Set-Content $configFile
        (Get-Content $configFile) -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2G2333k.pth' | Set-Content $configFile
    }
    "v3" {
        Write-Host "- v3 model (high similarity)" -ForegroundColor White
        (Get-Content $configFile) -replace 'version: .*', 'version: v3' | Set-Content $configFile
        (Get-Content $configFile) -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content $configFile
        (Get-Content $configFile) -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/s2Gv3.pth' | Set-Content $configFile
    }
    "v4" {
        Write-Host "- v4 model (best quality, 48kHz)" -ForegroundColor White
        (Get-Content $configFile) -replace 'version: .*', 'version: v4' | Set-Content $configFile
        (Get-Content $configFile) -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content $configFile
        (Get-Content $configFile) -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v4-pretrained/s2Gv4.pth' | Set-Content $configFile
    }
    "v2pro" {
        Write-Host "- v2Pro model (balanced performance)" -ForegroundColor White
        (Get-Content $configFile) -replace 'version: .*', 'version: v2Pro' | Set-Content $configFile
        (Get-Content $configFile) -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content $configFile
        (Get-Content $configFile) -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2Pro.pth' | Set-Content $configFile
    }
    "v2proplus" {
        Write-Host "- v2ProPlus model (enhanced v2Pro)" -ForegroundColor White
        (Get-Content $configFile) -replace 'version: .*', 'version: v2ProPlus' | Set-Content $configFile
        (Get-Content $configFile) -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content $configFile
        (Get-Content $configFile) -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2ProPlus.pth' | Set-Content $configFile
    }
    default {
        Write-Host "Unknown model version: $ModelVersion" -ForegroundColor Red
        Write-Host "Available versions: v2, v3, v4, v2pro, v2proplus" -ForegroundColor Yellow
        pause
        exit 1
    }
}

Write-Host "Starting API server on port 9880..." -ForegroundColor Green

$runtimePath = Join-Path $PSScriptRoot "runtime"

if (Test-Path "$runtimePath\python.exe") {
    Write-Host "Using integrated Python runtime..." -ForegroundColor Yellow
    $env:PATH = "$runtimePath;$env:PATH"
    Start-Process -FilePath "$runtimePath\python.exe" -ArgumentList "api_v2.py", "-a", "0.0.0.0", "-p", "9880", "-c", $configFile -WindowStyle Normal
} else {
    Write-Host "Using system Python..." -ForegroundColor Yellow
    Start-Process -FilePath "python" -ArgumentList "api_v2.py", "-a", "0.0.0.0", "-p", "9880", "-c", $configFile -WindowStyle Normal
}

Write-Host ""
Write-Host "API Server starting in background..." -ForegroundColor Green
Write-Host ""
Write-Host "Endpoint: http://localhost:9880/tts" -ForegroundColor Cyan
Write-Host "API Docs: http://localhost:9880/docs" -ForegroundColor Cyan
Write-Host "Model: $ModelVersion" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to close this window..." -ForegroundColor Yellow
pause