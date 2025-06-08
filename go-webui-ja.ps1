$ErrorActionPreference = "SilentlyContinue"
chcp 65001 | Out-Null

Write-Host "GPT-SoVITS WebUI (Japanese) Launcher" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

Set-Location $PSScriptRoot

# Check pyopenjtalk dictionary
Write-Host "Checking Japanese dictionary..." -ForegroundColor Yellow
try {
    python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Japanese dictionary not found. Installing..." -ForegroundColor Yellow
        python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Failed to install Japanese dictionary." -ForegroundColor Red
            Write-Host "Please run fix-pyopenjtalk-windows.ps1 first." -ForegroundColor Yellow
            pause
            exit 1
        }
    }
} catch {
    Write-Host "Error checking Japanese dictionary: $_" -ForegroundColor Red
}

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