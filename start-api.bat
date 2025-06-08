@echo off
setlocal EnableDelayedExpansion

echo GPT-SoVITS API Server Launcher
echo ================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM Default model version
set "MODEL_VERSION=%1"
if "%MODEL_VERSION%"=="" set "MODEL_VERSION=v2"

echo Starting GPT-SoVITS API Server with %MODEL_VERSION% model...

REM Kill existing API server processes
taskkill /F /IM python.exe /FI "WINDOWTITLE eq *api_v2.py*" >nul 2>&1

REM Model configurations
set "CONFIG_FILE=GPT_SoVITS\configs\tts_infer.yaml"

echo Configuring %MODEL_VERSION% model...

REM Update configuration based on model version
if "%MODEL_VERSION%"=="v2" (
    echo - v2 model ^(stable, fast^)
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'version: .*', 'version: v2' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2G2333k.pth' | Set-Content '%CONFIG_FILE%'"
) else if "%MODEL_VERSION%"=="v3" (
    echo - v3 model ^(high similarity^)
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'version: .*', 'version: v3' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/s2Gv3.pth' | Set-Content '%CONFIG_FILE%'"
) else if "%MODEL_VERSION%"=="v4" (
    echo - v4 model ^(best quality, 48kHz^)
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'version: .*', 'version: v4' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v4-pretrained/s2Gv4.pth' | Set-Content '%CONFIG_FILE%'"
) else if "%MODEL_VERSION%"=="v2pro" (
    echo - v2Pro model ^(balanced performance^)
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'version: .*', 'version: v2Pro' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2Pro.pth' | Set-Content '%CONFIG_FILE%'"
) else if "%MODEL_VERSION%"=="v2proplus" (
    echo - v2ProPlus model ^(enhanced v2Pro^)
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'version: .*', 'version: v2ProPlus' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 't2s_weights_path: .*', 't2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt' | Set-Content '%CONFIG_FILE%'"
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'vits_weights_path: .*', 'vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2ProPlus.pth' | Set-Content '%CONFIG_FILE%'"
) else (
    echo Unknown model version: %MODEL_VERSION%
    echo Available versions: v2, v3, v4, v2pro, v2proplus
    pause
    exit /b 1
)

echo Starting API server on port 9880...

REM Check if runtime exists (integrated package)
if exist "%SCRIPT_DIR%\runtime\python.exe" (
    echo Using integrated Python runtime...
    set "PATH=%SCRIPT_DIR%\runtime;%PATH%"
    start "GPT-SoVITS API Server (%MODEL_VERSION%)" runtime\python.exe api_v2.py -a 0.0.0.0 -p 9880 -c "%CONFIG_FILE%"
) else (
    REM Use system Python
    echo Using system Python...
    start "GPT-SoVITS API Server (%MODEL_VERSION%)" python api_v2.py -a 0.0.0.0 -p 9880 -c "%CONFIG_FILE%"
)

echo.
echo API Server starting in background...
echo.
echo Endpoint: http://localhost:9880/tts
echo API Docs: http://localhost:9880/docs
echo Model: %MODEL_VERSION%
echo.
echo Press any key to close this window...
pause >nul