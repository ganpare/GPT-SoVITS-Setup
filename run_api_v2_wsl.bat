@echo off
REM WSLでconda環境をアクティベートし、api_v2.pyを実行
wsl bash -c "source /home/conta/miniconda/etc/profile.d/conda.sh && conda activate /home/conta/miniconda/envs/GPTSoVits && cd /mnt/e/repository/claude-test/GPT-SoVITS && python api_v2.py"
pause 