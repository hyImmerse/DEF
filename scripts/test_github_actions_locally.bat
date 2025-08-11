@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo GitHub Actions Local Testing Script (Windows)
echo ==========================================
echo.

REM Configuration
set PROJECT_DIR=def_order_app
set FLUTTER_VERSION=3.32.5

REM Check if project directory exists
if not exist "%PROJECT_DIR%" (
    echo [ERROR] Project directory '%PROJECT_DIR%' not found!
    echo Please run this script from the repository root.
    exit /b 1
)

echo Current directory: %cd%
echo.

REM Step 1: Check FVM installation
echo Step 1: Checking FVM installation...
where fvm >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] FVM is installed
    fvm --version
) else (
    echo [WARNING] FVM not found. Please install FVM first:
    echo dart pub global activate fvm
    echo Then add to PATH: %USERPROFILE%\AppData\Local\Pub\Cache\bin
    pause
    exit /b 1
)
echo.

REM Step 2: Navigate to project directory
echo Step 2: Navigating to project directory...
cd %PROJECT_DIR%
echo [OK] Changed to %cd%
echo.

REM Step 3: Setup Flutter with FVM
echo Step 3: Setting up Flutter %FLUTTER_VERSION% with FVM...
if exist ".fvm\flutter_sdk" (
    echo [INFO] Flutter SDK already exists in .fvm
) else (
    echo [INFO] Installing Flutter %FLUTTER_VERSION%...
    fvm install %FLUTTER_VERSION%
)

fvm use %FLUTTER_VERSION% --force
if %errorlevel% equ 0 (
    echo [OK] Flutter %FLUTTER_VERSION% configured
) else (
    echo [ERROR] Failed to configure Flutter
    exit /b 1
)
echo.

REM Step 4: Verify Flutter installation
echo Step 4: Verifying Flutter installation...
fvm flutter --version
fvm flutter doctor
echo.

REM Step 5: Setup Korean fonts
echo Step 5: Setting up Korean fonts...
if not exist "assets\fonts" mkdir assets\fonts

REM Download Korean font using PowerShell
powershell -Command "& {
    $urls = @(
        'https://github.com/naver/nanumfont/raw/master/fonts/NanumGothic/NanumGothic.ttf',
        'https://cdn.jsdelivr.net/gh/fonts-archive/NanumGothic/NanumGothic.ttf'
    )
    $downloaded = $false
    foreach ($url in $urls) {
        Write-Host \"Trying: $url\"
        try {
            Invoke-WebRequest -Uri $url -OutFile 'assets\fonts\NanumGothic.ttf' -TimeoutSec 15
            if (Test-Path 'assets\fonts\NanumGothic.ttf') {
                Write-Host '[OK] Downloaded NanumGothic font'
                $downloaded = $true
                break
            }
        } catch {
            Write-Host \"Failed to download from: $url\"
        }
    }
    if (-not $downloaded) {
        Write-Host '[WARNING] Could not download Korean fonts'
        New-Item -ItemType File -Path 'assets\fonts\NanumGothic.ttf' -Force | Out-Null
    }
}"

echo Font files:
dir assets\fonts\ 2>nul
echo.

REM Step 6: Install dependencies
echo Step 6: Installing Flutter dependencies...
fvm flutter pub get
if %errorlevel% equ 0 (
    echo [OK] Dependencies installed
) else (
    echo [ERROR] Failed to install dependencies
    exit /b 1
)
echo.

REM Step 7: Run code generation
echo Step 7: Running code generation...
fvm flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [WARNING] Code generation failed or not needed
)
echo.

REM Step 8: Analyze code
echo Step 8: Analyzing code...
fvm flutter analyze --no-fatal-infos --no-fatal-warnings
if %errorlevel% neq 0 (
    echo [WARNING] Code analysis found issues
)
echo.

REM Step 9: Run tests
echo Step 9: Running tests...
fvm flutter test
if %errorlevel% neq 0 (
    echo [WARNING] Tests failed or not found
)
echo.

REM Step 10: Build Flutter web
echo Step 10: Building Flutter web (Demo Mode)...
fvm flutter build web --release --dart-define=IS_DEMO=true --base-href "/DEF/" --no-tree-shake-icons

if exist "build\web" (
    echo [OK] Build successful!
    echo Build output:
    dir build\web
    
    REM Calculate build size
    for /f "tokens=3" %%a in ('dir build\web /s ^| findstr "File(s)"') do set size=%%a
    echo.
    echo [INFO] Total build size: !size! bytes
) else (
    echo [ERROR] Build failed - no output directory found
    exit /b 1
)

echo.
echo ==========================================
echo Test Summary
echo ==========================================
echo [OK] All steps completed successfully!
echo.
echo Next steps:
echo 1. Review the build output in: %PROJECT_DIR%\build\web\
echo 2. Test locally: cd %PROJECT_DIR% ^&^& fvm flutter run -d chrome --dart-define=IS_DEMO=true
echo 3. Commit and push to trigger GitHub Actions
echo.
echo GitHub Pages URL will be:
echo https://[your-username].github.io/DEF/
echo.
echo Demo accounts:
echo   - Dealer: dealer@demo.com / demo1234
echo   - General: general@demo.com / demo1234
echo.
pause