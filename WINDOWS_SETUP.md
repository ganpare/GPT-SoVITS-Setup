# Windows環境でのGPT-SoVITS使用ガイド

## 🚀 簡単起動方法

### WebUI起動（日本語）
```cmd
# バッチファイルで起動
go-webui-ja.bat

# PowerShellで起動
powershell -ExecutionPolicy Bypass -File go-webui-ja.ps1
```

### APIサーバー起動
```cmd
# v4モデルで起動
start-api.bat v4

# v2モデルで起動（デフォルト）
start-api.bat

# PowerShellで起動
powershell -ExecutionPolicy Bypass -File start-api.ps1 -ModelVersion v4
```

## 📁 ファイル構成

### WebUI用バッチファイル
- `go-webui-ja.bat` - 日本語WebUI起動（バッチ）
- `go-webui-ja.ps1` - 日本語WebUI起動（PowerShell）
- `go-webui.bat` - 中国語WebUI起動（オリジナル）

### API用バッチファイル
- `start-api.bat` - APIサーバー起動（バッチ）
- `start-api.ps1` - APIサーバー起動（PowerShell）

### 設定・ガイド
- `MODEL_SWITCHING_GUIDE.md` - 詳細モデル切り替えガイド
- `WINDOWS_SETUP.md` - このファイル

## 🎯 モデル選択

利用可能なモデル：
- `v2` - 安定・高速（デフォルト）
- `v3` - 高い音色類似度
- `v4` - 最高品質・48kHz
- `v2pro` - バランス重視
- `v2proplus` - v2Pro強化版

### 使用例
```cmd
# v4モデル（最高品質）
start-api.bat v4

# v2Proモデル（バランス）
start-api.bat v2pro

# PowerShell版
powershell -File start-api.ps1 -ModelVersion v2proplus
```

## 💻 環境要件

### 統合パッケージ版
- Windows 10/11
- NVIDIA GPU（推奨）
- 16GB以上のRAM

### 手動インストール版
- Python 3.9-3.11
- PyTorch（CUDA対応）
- 必要な依存関係（requirements.txt）

## 🔧 トラブルシューティング

### 日本語処理エラー（pyopenjtalk）
```
ERROR: Mecab_load() in mecab.cpp: Cannot open C:\Python\...\pyopenjtalk\open_jtalk_dic_utf_8-1.11
```

**解決方法**:
```cmd
# 自動修正バッチを実行
fix-pyopenjtalk-windows.bat

# または PowerShell版
powershell -File fix-pyopenjtalk-windows.ps1

# 手動で辞書をダウンロード
python -c "import pyopenjtalk; pyopenjtalk.g2p('テスト')"
```

### Python環境が見つからない
```cmd
# Pythonのパスを確認
where python

# condaを使用している場合
conda activate your_environment_name
```

### ポートが使用中
```cmd
# プロセスを確認
netstat -ano | findstr :9880

# プロセスを終了
taskkill /PID [プロセスID] /F

# WebUIポート競合の場合
netstat -ano | findstr :9874
taskkill /PID [プロセスID] /F
```

### GPU使用時のエラー
- NVIDIA GeForceドライバーを最新に更新
- CUDA Toolkitのバージョンを確認
- PyTorchのCUDA対応版をインストール

### ファイアウォール設定
Windowsファイアウォールでポート9880の通信を許可：
```cmd
netsh advfirewall firewall add rule name="GPT-SoVITS API" dir=in action=allow protocol=TCP localport=9880
```

## 🌐 アクセス方法

### WebUI
- ローカル: http://localhost:9874
- ネットワーク: http://[コンピューターのIP]:9874

### API
- ローカル: http://localhost:9880/tts
- ドキュメント: http://localhost:9880/docs
- ネットワーク: http://[コンピューターのIP]:9880/tts

## 📝 実行ポリシー設定

PowerShellスクリプトが実行できない場合：
```powershell
# 実行ポリシーを確認
Get-ExecutionPolicy

# 実行ポリシーを変更（管理者権限で実行）
Set-ExecutionPolicy RemoteSigned

# 一時的に実行を許可
powershell -ExecutionPolicy Bypass -File start-api.ps1
```

## 🔄 自動起動設定

### タスクスケジューラーで自動起動
1. タスクスケジューラーを開く
2. 基本タスクの作成
3. 起動時にバッチファイルを実行するよう設定

### サービス化
Windows Serviceとして実行する場合は、NSSM（Non-Sucking Service Manager）を使用：
```cmd
# NSSMをダウンロード後
nssm install GPT-SoVITS-API
# Application Path: [pythonのパス]
# Arguments: api_v2.py -a 0.0.0.0 -p 9880 -c GPT_SoVITS\configs\tts_infer.yaml
```

## 📊 パフォーマンス最適化

### GPU設定
設定ファイル（`GPT_SoVITS/configs/tts_infer.yaml`）で調整：
```yaml
device: cuda      # GPU使用
is_half: true     # 半精度で高速化・VRAM節約
```

### CPU設定
```yaml
device: cpu       # CPU使用
is_half: false    # CPUでは半精度無効
```

## 🆘 ヘルプ

問題が発生した場合：
1. ログファイルを確認（`api_server_[model].log`）
2. 依存関係を再インストール
3. 設定ファイルをデフォルトに戻す
4. GitHubのIssuesを確認