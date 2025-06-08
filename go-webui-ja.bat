@echo off
echo GPT-SoVITS WebUI (Japanese) Launcher
echo =====================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM Check if runtime exists (integrated package)
if exist "%SCRIPT_DIR%\runtime\python.exe" (
    echo Using integrated Python runtime...
    set "PATH=%SCRIPT_DIR%\runtime;%PATH%"
    runtime\python.exe -I webui.py ja_JP
) else (
    REM Use system Python or conda
    echo Using system Python...
    python webui.py ja_JP
)

echo.
echo WebUI has been closed.
pause