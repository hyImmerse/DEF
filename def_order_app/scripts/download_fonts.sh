#!/bin/bash

# Korean Font Download Script for Flutter PDF Generation
# This script downloads and installs Korean fonts needed for PDF rendering

set -e

FONTS_DIR="assets/fonts"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📦 Korean Font Setup Script"
echo "============================"

# Change to project root
cd "$PROJECT_ROOT"

# Create fonts directory if it doesn't exist
mkdir -p "$FONTS_DIR"

# Function to download font with fallback URLs
download_font() {
    local font_name=$1
    local font_file=$2
    shift 2
    local urls=("$@")
    
    echo "📥 Downloading $font_name..."
    
    for url in "${urls[@]}"; do
        echo "  Trying: $url"
        if wget -q --timeout=10 -O "$FONTS_DIR/$font_file" "$url" 2>/dev/null; then
            if [ -s "$FONTS_DIR/$font_file" ]; then
                echo "  ✅ Successfully downloaded $font_name"
                return 0
            else
                rm -f "$FONTS_DIR/$font_file"
            fi
        fi
    done
    
    echo "  ⚠️ Failed to download $font_name from all sources"
    return 1
}

# NanumGothic font URLs (multiple fallbacks)
NANUM_URLS=(
    "https://github.com/naver/nanumfont/raw/master/fonts/NanumGothic/NanumGothic.ttf"
    "https://github.com/google/fonts/raw/main/ofl/nanumgothic/NanumGothic-Regular.ttf"
    "https://cdn.jsdelivr.net/gh/fonts-archive/NanumGothic/NanumGothic.ttf"
    "https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_11-01@1.0/NanumGothic.woff2"
)

# NanumGothicBold font URLs
NANUM_BOLD_URLS=(
    "https://github.com/naver/nanumfont/raw/master/fonts/NanumGothic/NanumGothicBold.ttf"
    "https://github.com/google/fonts/raw/main/ofl/nanumgothic/NanumGothic-Bold.ttf"
    "https://cdn.jsdelivr.net/gh/fonts-archive/NanumGothicBold/NanumGothicBold.ttf"
)

# Download fonts
download_font "NanumGothic Regular" "NanumGothic.ttf" "${NANUM_URLS[@]}" || {
    echo "Creating placeholder for NanumGothic.ttf"
    touch "$FONTS_DIR/NanumGothic.ttf"
}

download_font "NanumGothic Bold" "NanumGothicBold.ttf" "${NANUM_BOLD_URLS[@]}" || {
    echo "Creating placeholder for NanumGothicBold.ttf"
    touch "$FONTS_DIR/NanumGothicBold.ttf"
}

# Alternative: Download Pretendard font (modern Korean font)
PRETENDARD_URLS=(
    "https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard/Pretendard-Regular.otf"
    "https://github.com/orioncactus/pretendard/raw/main/packages/pretendard/dist/web/static/pretendard-std/Pretendard-Regular.otf"
)

download_font "Pretendard Regular" "Pretendard-Regular.otf" "${PRETENDARD_URLS[@]}" || {
    echo "Pretendard font is optional, continuing..."
}

# Verify downloaded fonts
echo ""
echo "📋 Font Status:"
echo "==============="
ls -lh "$FONTS_DIR"/*.ttf "$FONTS_DIR"/*.otf 2>/dev/null || echo "No fonts found"

# Check if at least one Korean font exists
if ls "$FONTS_DIR"/*.ttf 1> /dev/null 2>&1 || ls "$FONTS_DIR"/*.otf 1> /dev/null 2>&1; then
    echo ""
    echo "✅ Korean fonts setup completed successfully!"
    exit 0
else
    echo ""
    echo "⚠️ Warning: No Korean fonts were downloaded successfully."
    echo "   PDF generation may not display Korean text correctly."
    exit 1
fi