#!/bin/bash

# GPT-SoVITS API Server Launcher
# Usage: ./start_api.sh [model_version]
# Example: ./start_api.sh v4

# Activate conda environment
source $HOME/miniconda/etc/profile.d/conda.sh
conda activate GPTSoVits

# Default model version
MODEL_VERSION=${1:-v2}

# Kill existing API server
pkill -f "python api_v2.py" 2>/dev/null
sleep 2

# Model configurations directory
CONFIG_DIR="GPT_SoVITS/configs"
CONFIG_FILE="$CONFIG_DIR/tts_infer.yaml"

echo "🚀 Starting GPT-SoVITS API Server with $MODEL_VERSION model..."

# Update configuration based on model version
case $MODEL_VERSION in
    "v2")
        echo "📝 Configuring v2 model (stable, fast)..."
        sed -i 's/version: .*/version: v2/' $CONFIG_FILE
        sed -i 's|t2s_weights_path: .*|t2s_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt|' $CONFIG_FILE
        sed -i 's|vits_weights_path: .*|vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2G2333k.pth|' $CONFIG_FILE
        ;;
    "v3")
        echo "📝 Configuring v3 model (high similarity)..."
        sed -i 's/version: .*/version: v3/' $CONFIG_FILE
        sed -i 's|t2s_weights_path: .*|t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt|' $CONFIG_FILE
        sed -i 's|vits_weights_path: .*|vits_weights_path: GPT_SoVITS/pretrained_models/s2Gv3.pth|' $CONFIG_FILE
        ;;
    "v4")
        echo "📝 Configuring v4 model (best quality, 48kHz)..."
        sed -i 's/version: .*/version: v4/' $CONFIG_FILE
        sed -i 's|t2s_weights_path: .*|t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt|' $CONFIG_FILE
        sed -i 's|vits_weights_path: .*|vits_weights_path: GPT_SoVITS/pretrained_models/gsv-v4-pretrained/s2Gv4.pth|' $CONFIG_FILE
        ;;
    "v2pro")
        echo "📝 Configuring v2Pro model (balanced performance)..."
        sed -i 's/version: .*/version: v2Pro/' $CONFIG_FILE
        sed -i 's|t2s_weights_path: .*|t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt|' $CONFIG_FILE
        sed -i 's|vits_weights_path: .*|vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2Pro.pth|' $CONFIG_FILE
        ;;
    "v2proplus")
        echo "📝 Configuring v2ProPlus model (enhanced v2Pro)..."
        sed -i 's/version: .*/version: v2ProPlus/' $CONFIG_FILE
        sed -i 's|t2s_weights_path: .*|t2s_weights_path: GPT_SoVITS/pretrained_models/s1v3.ckpt|' $CONFIG_FILE
        sed -i 's|vits_weights_path: .*|vits_weights_path: GPT_SoVITS/pretrained_models/v2Pro/s2Gv2ProPlus.pth|' $CONFIG_FILE
        ;;
    *)
        echo "❌ Unknown model version: $MODEL_VERSION"
        echo "Available versions: v2, v3, v4, v2pro, v2proplus"
        exit 1
        ;;
esac

# Start API server
echo "🔄 Starting API server on port 9880..."
nohup python api_v2.py -a 0.0.0.0 -p 9880 -c $CONFIG_FILE > api_server_${MODEL_VERSION}.log 2>&1 &

# Wait and check if server started successfully
sleep 5
if pgrep -f "python api_v2.py" > /dev/null; then
    echo "✅ API Server started successfully!"
    echo "📡 Endpoint: http://172.20.134.38:9880/tts"
    echo "📋 API Docs: http://172.20.134.38:9880/docs"
    echo "📝 Log file: api_server_${MODEL_VERSION}.log"
    echo ""
    echo "🎯 Model: $MODEL_VERSION"
    echo "🔧 Config: $CONFIG_FILE"
else
    echo "❌ Failed to start API server. Check the log file."
    tail -10 api_server_${MODEL_VERSION}.log
fi