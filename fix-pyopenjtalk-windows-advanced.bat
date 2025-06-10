@echo off
echo Advanced pyopenjtalk fix for Windows
echo ====================================

echo Uninstalling current pyopenjtalk...
pip uninstall pyopenjtalk -y

echo.
echo Installing fresh pyopenjtalk...
pip install pyopenjtalk

echo.
echo Testing installation...
python check_pyopenjtalk.py

echo.
echo If still failing, trying alternative method...
pip uninstall pyopenjtalk -y
pip install pyopenjtalk-dict

echo.
echo Installing wordsegment for English text processing...
pip install wordsegment

echo.
echo Final test...
python check_pyopenjtalk.py

echo.
echo Fix completed.
pause