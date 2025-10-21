#!/bin/bash

# 确保FFmpeg被复制到应用包的脚本
# 这个脚本应该在每次构建后运行

echo "Ensuring FFmpeg is copied to app bundles..."

# 复制到Debug版本
DEBUG_APP_DIR="build/macos/Build/Products/Debug/video_rehasher.app/Contents/MacOS"
if [ -d "$DEBUG_APP_DIR" ]; then
    echo "Copying FFmpeg to Debug app bundle..."
    cp "macos/depend/ffmpeg" "$DEBUG_APP_DIR/ffmpeg"
    chmod +x "$DEBUG_APP_DIR/ffmpeg"
    echo "FFmpeg copied to Debug bundle"
else
    echo "Debug app bundle not found at $DEBUG_APP_DIR"
fi

# 复制到Release版本  
RELEASE_APP_DIR="build/macos/Build/Products/Release/video_rehasher.app/Contents/MacOS"
if [ -d "$RELEASE_APP_DIR" ]; then
    echo "Copying FFmpeg to Release app bundle..."
    cp "macos/depend/ffmpeg" "$RELEASE_APP_DIR/ffmpeg"
    chmod +x "$RELEASE_APP_DIR/ffmpeg"
    echo "FFmpeg copied to Release bundle"
else
    echo "Release app bundle not found at $RELEASE_APP_DIR"
fi

echo "FFmpeg copy process completed"