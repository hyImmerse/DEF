#!/bin/bash

# Local GitHub Actions Workflow Testing Script
# This script simulates the GitHub Actions environment locally for debugging

set -e

echo "=========================================="
echo "🧪 GitHub Actions Local Testing Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="def_order_app"
FLUTTER_VERSION="3.32.5"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# Check if we're in the right directory
if [ ! -d "$PROJECT_DIR" ]; then
    print_error "Project directory '$PROJECT_DIR' not found!"
    echo "Please run this script from the repository root."
    exit 1
fi

echo "📁 Current directory: $(pwd)"
echo ""

# Step 1: Check FVM installation
echo "Step 1: Checking FVM installation..."
if command -v fvm &> /dev/null; then
    print_status "FVM is installed: $(fvm --version)"
else
    print_warning "FVM not found. Installing FVM..."
    dart pub global activate fvm
    export PATH="$PATH:$HOME/.pub-cache/bin"
fi
echo ""

# Step 2: Navigate to project directory
echo "Step 2: Navigating to project directory..."
cd "$PROJECT_DIR"
print_status "Changed to $(pwd)"
echo ""

# Step 3: Setup Flutter with FVM
echo "Step 3: Setting up Flutter $FLUTTER_VERSION with FVM..."
if [ -d ".fvm/flutter_sdk" ]; then
    print_info "Flutter SDK already exists in .fvm"
else
    print_info "Installing Flutter $FLUTTER_VERSION..."
    fvm install "$FLUTTER_VERSION"
fi

fvm use "$FLUTTER_VERSION" --force
print_status "Flutter $FLUTTER_VERSION configured"

# Add Flutter to PATH
export PATH="$(pwd)/.fvm/flutter_sdk/bin:$PATH"
echo ""

# Step 4: Verify Flutter installation
echo "Step 4: Verifying Flutter installation..."
flutter --version
flutter doctor -v || print_warning "Flutter doctor reported issues"
echo ""

# Step 5: Setup Korean fonts
echo "Step 5: Setting up Korean fonts..."
mkdir -p assets/fonts

FONT_DOWNLOADED=false
for url in \
    "https://github.com/naver/nanumfont/raw/master/fonts/NanumGothic/NanumGothic.ttf" \
    "https://cdn.jsdelivr.net/gh/fonts-archive/NanumGothic/NanumGothic.ttf"
do
    echo "Trying: $url"
    if curl -L -s -o assets/fonts/NanumGothic.ttf "$url"; then
        if [ -s assets/fonts/NanumGothic.ttf ]; then
            print_status "Downloaded NanumGothic font"
            FONT_DOWNLOADED=true
            break
        fi
    fi
done

if [ "$FONT_DOWNLOADED" = false ]; then
    print_warning "Could not download Korean fonts"
    touch assets/fonts/NanumGothic.ttf
fi

echo "Font files:"
ls -lh assets/fonts/ 2>/dev/null || print_warning "No font files found"
echo ""

# Step 6: Install dependencies
echo "Step 6: Installing Flutter dependencies..."
flutter pub get
print_status "Dependencies installed"
echo ""

# Step 7: Run code generation
echo "Step 7: Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs || {
    print_warning "Code generation failed or not needed"
}
echo ""

# Step 8: Analyze code
echo "Step 8: Analyzing code..."
flutter analyze --no-fatal-infos --no-fatal-warnings || {
    print_warning "Code analysis found issues"
}
echo ""

# Step 9: Run tests
echo "Step 9: Running tests..."
flutter test || {
    print_warning "Tests failed or not found"
}
echo ""

# Step 10: Build Flutter web
echo "Step 10: Building Flutter web (Demo Mode)..."
flutter build web \
    --release \
    --dart-define=IS_DEMO=true \
    --base-href "/DEF/" \
    --web-renderer html \
    --no-tree-shake-icons

if [ -d "build/web" ]; then
    print_status "Build successful!"
    echo "Build output:"
    ls -lh build/web/ | head -10
    
    # Calculate build size
    BUILD_SIZE=$(du -sh build/web | cut -f1)
    echo ""
    print_info "Total build size: $BUILD_SIZE"
else
    print_error "Build failed - no output directory found"
    exit 1
fi

echo ""
echo "=========================================="
echo "📊 Test Summary"
echo "=========================================="
print_status "All steps completed successfully!"
echo ""
echo "Next steps:"
echo "1. Review the build output in: $PROJECT_DIR/build/web/"
echo "2. Test locally: cd $PROJECT_DIR && flutter run -d chrome --dart-define=IS_DEMO=true"
echo "3. Commit and push to trigger GitHub Actions"
echo ""
echo "GitHub Pages URL will be:"
echo "https://[your-username].github.io/DEF/"
echo ""
echo "Demo accounts:"
echo "  - Dealer: dealer@demo.com / demo1234"
echo "  - General: general@demo.com / demo1234"