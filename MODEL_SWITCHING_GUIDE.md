# GPT-SoVITS モデル切り替えガイド

## 🚀 簡単起動方法

### スクリプトを使用した起動
```bash
# v4モデル（最高品質、48kHz）
./start_api.sh v4

# v2モデル（安定、高速）
./start_api.sh v2

# v3モデル（高い音色類似度）
./start_api.sh v3

# v2Proモデル（バランス重視）
./start_api.sh v2pro

# v2ProPlusモデル（v2Pro強化版）
./start_api.sh v2proplus
```

### 手動起動方法
```bash
# conda環境をアクティベート
source $HOME/miniconda/etc/profile.d/conda.sh
conda activate GPTSoVits

# 既存サーバーを停止
pkill -f "python api_v2.py"

# APIサーバーを起動
python api_v2.py -a 0.0.0.0 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml
```

## 📋 モデル比較表

| モデル | 特徴 | 音質 | 速度 | VRAM使用量 | 用途 |
|--------|------|------|------|------------|------|
| **v2** | 安定・高速 | 良好 | ⭐⭐⭐ | 中 | 一般用途・プロダクション |
| **v3** | 高音色類似度 | 優秀 | ⭐⭐ | 高 | 高品質音声生成 |
| **v4** | 最高品質・48kHz | 最高 | ⭐⭐ | 高 | 最高品質が必要な場合 |
| **v2Pro** | v2とv4の中間 | 優秀 | ⭐⭐⭐ | 中 | バランス重視 |
| **v2ProPlus** | v2Pro強化版 | 優秀+ | ⭐⭐ | 中+ | v2Proの上位版 |

## ⚙️ 手動設定方法

### 設定ファイルの場所
```
GPT_SoVITS/configs/tts_infer.yaml
```

### v2モデル設定
```yaml
custom:
  version: v2
  device: cuda
  is_half: true
  t2s_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt
  vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2G2333k.pth
  bert_base_path: GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large
  cnhuhbert_base_path: GPT_SoVITS/pretrained_models/chinese-hubert-base
```

### v3モデル設定
```yaml
custom:
  version: v3
  device: cuda
  is_half: true
  t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt
  vits_weights_path: GPT_SoVITS/pretrained_models/s2Gv3.pth
  bert_base_path: GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large
  cnhuhbert_base_path: GPT_SoVITS/pretrained_models/chinese-hubert-base
```

### v4モデル設定
```yaml
custom:
  version: v4
  device: cuda
  is_half: true
  t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt
  vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v4-pretrained/s2Gv4.pth
  vocoder_weights_path: GPT_SoVITS/pretrained_models/gsv-v4-pretrained/vocoder.pth
  bert_base_path: GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large
  cnhuhbert_base_path: GPT_SoVITS/pretrained_models/chinese-hubert-base
```

### v2Proモデル設定
```yaml
custom:
  version: v2Pro
  device: cuda
  is_half: true
  t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt
  vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2Pro.pth
  bert_base_path: GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large
  cnhuhbert_base_path: GPT_SoVITS/pretrained_models/chinese-hubert-base
```

### v2ProPlusモデル設定
```yaml
custom:
  version: v2ProPlus
  device: cuda
  is_half: true
  t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt
  vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2ProPlus.pth
  bert_base_path: GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large
  cnhuhbert_base_path: GPT_SoVITS/pretrained_models/chinese-hubert-base
```

## 🔧 設定項目の説明

### 必須パラメータ
- **version**: モデルバージョン（v2, v3, v4, v2Pro, v2ProPlus）
- **device**: 実行デバイス（cuda, cpu, mps）
- **is_half**: 半精度使用（true=高速・低VRAM, false=高精度・高VRAM）
- **t2s_weights_path**: Text2Semanticモデルのパス
- **vits_weights_path**: VITSモデルのパス

### オプションパラメータ
- **vocoder_weights_path**: v4専用ボコーダー（v4のみ必要）
- **bert_base_path**: BERT モデルのパス
- **cnhuhbert_base_path**: CNHuBERT モデルのパス

## 🚦 サーバー管理コマンド

### サーバー状況確認
```bash
# プロセス確認
ps aux | grep api_v2

# ポート確認
ss -tlnp | grep 9880

# ログ確認
tail -f api_server_v4.log
```

### サーバー停止
```bash
# API サーバーを停止
pkill -f "python api_v2.py"
```

## 🌐 API エンドポイント

### 基本情報
- **URL**: `http://172.20.134.38:9880/tts`
- **ドキュメント**: `http://172.20.134.38:9880/docs`
- **メソッド**: POST
- **レスポンス**: 音声ファイル（WAV形式）

### リクエスト例
```json
{
    "text": "こんにちは、GPT-SoVITSです",
    "text_lang": "ja",
    "ref_audio_path": "参考音声.wav",
    "prompt_text": "参考音声のテキスト",
    "prompt_lang": "ja",
    "streaming_mode": false
}
```

## 🐛 トラブルシューティング

### よくある問題と解決策

#### 1. CUDA メモリエラー
```bash
# 半精度を有効にする
is_half: true

# または軽量モデルを使用
./start_api.sh v2
```

#### 2. モデルファイルが見つからない
```bash
# モデルファイルの存在確認
ls -la GPT_SoVITS/pretrained_models/
```

#### 3. ポートが使用中
```bash
# 既存プロセスを停止
pkill -f "python api_v2.py"
```

#### 4. 日本語処理エラー
```bash
# NLTK パッケージを再インストール
python -c "import nltk; nltk.download('averaged_perceptron_tagger_eng')"
```

## 📈 パフォーマンス最適化

### GPU設定
```yaml
device: cuda      # GPU使用
is_half: true     # 半精度で高速化
```

### CPU設定（GPU非対応環境）
```yaml
device: cpu       # CPU使用
is_half: false    # CPUでは半精度無効
```

## 🎯 推奨用途別モデル選択

### 🚀 プロダクション環境
- **推奨**: v2, v2Pro
- **理由**: 安定性・速度・VRAM効率

### 🎨 高品質コンテンツ制作
- **推奨**: v4, v3
- **理由**: 最高音質・高音色類似度

### ⚖️ バランス重視
- **推奨**: v2Pro, v2ProPlus
- **理由**: 品質と速度の良いバランス

### 🧪 実験・開発
- **推奨**: v2
- **理由**: 高速・安定・デバッグしやすい