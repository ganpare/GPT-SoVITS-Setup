$ErrorActionPreference = "SilentlyContinue"
chcp 65001 | Out-Null

Write-Host "GPT-SoVITS WebUI (Japanese) Launcher" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

Set-Location $PSScriptRoot
$runtimePath = Join-Path $PSScriptRoot "runtime"

if (Test-Path "$runtimePath\python.exe") {
    Write-Host "Using integrated Python runtime..." -ForegroundColor Yellow
    $env:PATH = "$runtimePath;$env:PATH"
    & "$runtimePath\python.exe" -I "$PSScriptRoot\webui.py" ja_JP
} else {
    Write-Host "Using system Python..." -ForegroundColor Yellow
    & python "$PSScriptRoot\webui.py" ja_JP
}

Write-Host ""
Write-Host "WebUI has been closed." -ForegroundColor Cyan
pause