#!/bin/bash

# 复制FFmpeg二进制文件到应用包
echo "Copying FFmpeg binary to app bundle..."

# 获取构建目录
BUILD_DIR="${BUILT_PRODUCTS_DIR}"
APP_NAME="${PRODUCT_NAME}.app"
FFMPEG_SOURCE="${PROJECT_DIR}/depend/ffmpeg"
FFMPEG_DEST="${BUILD_DIR}/${APP_NAME}/Contents/MacOS/ffmpeg"

# 检查源文件是否存在
if [ -f "$FFMPEG_SOURCE" ]; then
    echo "Copying FFmpeg from $FFMPEG_SOURCE to $FFMPEG_DEST"
    cp "$FFMPEG_SOURCE" "$FFMPEG_DEST"
    chmod +x "$FFMPEG_DEST"
    echo "FFmpeg copied successfully"
else
    echo "Error: FFmpeg binary not found at $FFMPEG_SOURCE"
    exit 1
fi