Write-Host "Fixing pyopenjtalk dictionary for Windows" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

try {
    # Get Python and pyopenjtalk paths
    $pythonPath = python -c "import sys; print(sys.executable)"
    $pyopenjtalkPath = python -c "import pyopenjtalk; import os; print(os.path.dirname(pyopenjtalk.__file__))"
    
    Write-Host "Python path: $pythonPath" -ForegroundColor Yellow
    Write-Host "PyOpenJTalk path: $pyopenjtalkPath" -ForegroundColor Yellow
    
    $dictPath = Join-Path $pyopenjtalkPath "open_jtalk_dic_utf_8-1.11"
    
    if (Test-Path $dictPath) {
        Write-Host "Dictionary already exists: $dictPath" -ForegroundColor Green
    } else {
        Write-Host "Dictionary not found. Downloading and installing..." -ForegroundColor Yellow
        
        # Trigger dictionary download
        python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')"
        
        if (Test-Path $dictPath) {
            Write-Host "Dictionary installation completed!" -ForegroundColor Green
        } else {
            Write-Host "Dictionary installation failed. Manual installation required." -ForegroundColor Red
            Write-Host "Please run: python -c ""import pyopenjtalk; pyopenjtalk.g2p('テスト')""" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "Error occurred: $_" -ForegroundColor Red
    Write-Host "Please ensure Python and pyopenjtalk are properly installed." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Fix completed. You can now use Japanese text processing." -ForegroundColor Cyan
pause