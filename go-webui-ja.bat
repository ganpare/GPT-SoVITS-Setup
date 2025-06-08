@echo off
echo GPT-SoVITS WebUI (Japanese) Launcher
echo =====================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM Check pyopenjtalk dictionary
echo Checking Japanese dictionary...
python check_pyopenjtalk.py >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Japanese dictionary issue detected. Running installer...
    python check_pyopenjtalk.py
    if %errorlevel% neq 0 (
        echo Error: Failed to install Japanese dictionary.
        echo Please run fix-pyopenjtalk-windows.bat first.
        pause
        exit /b 1
    )
)

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