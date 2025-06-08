@echo off
echo Fixing pyopenjtalk dictionary for Windows
echo ==========================================

REM Get Python path
for /f "tokens=*" %%i in ('python -c "import sys; print(sys.executable)"') do set PYTHON_PATH=%%i

REM Get pyopenjtalk package path
for /f "tokens=*" %%i in ('python -c "import pyopenjtalk; import os; print(os.path.dirname(pyopenjtalk.__file__))"') do set PYOPENJTALK_PATH=%%i

echo Python path: %PYTHON_PATH%
echo PyOpenJTalk path: %PYOPENJTALK_PATH%

REM Check if dictionary exists
if exist "%PYOPENJTALK_PATH%\open_jtalk_dic_utf_8-1.11" (
    echo Dictionary already exists: %PYOPENJTALK_PATH%\open_jtalk_dic_utf_8-1.11
) else (
    echo Dictionary not found. Downloading and installing...
    
    REM Download and install dictionary
    python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')"
    
    if exist "%PYOPENJTALK_PATH%\open_jtalk_dic_utf_8-1.11" (
        echo Dictionary installation completed!
    ) else (
        echo Dictionary installation failed. Manual installation required.
        echo Please run: python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')"
    )
)

echo.
echo Fix completed. You can now use Japanese text processing.
pause