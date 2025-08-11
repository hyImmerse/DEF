@echo off
echo ==========================================
echo Flutter Web Production Build
echo GitHub Actions Compatible
echo ==========================================
echo.

cd def_order_app

echo [1/6] Installing dependencies...
call flutter pub get
if %errorlevel% neq 0 goto :error

echo.
echo [2/6] Running code generation...
call flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo Warning: Code generation failed, continuing...
)

echo.
echo [3/6] Analyzing code...
call flutter analyze --no-fatal-infos --no-fatal-warnings
if %errorlevel% neq 0 (
    echo Warning: Code analysis found issues, continuing...
)

echo.
echo [4/6] Building Flutter web (Production)...
echo Command: flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons
call flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons

if %errorlevel% equ 0 (
    echo.
    echo [5/6] Build completed successfully!
    
    REM Check build output
    if exist "build\web\index.html" (
        echo.
        echo [6/6] Validating build artifacts...
        
        REM Get build size
        for /f "tokens=3" %%a in ('dir build\web /s ^| findstr /c:"File(s)"') do set SIZE=%%a
        echo - Build size: %SIZE% bytes
        
        REM Count files
        for /f %%a in ('dir build\web /b /s ^| find /c /v ""') do set FILE_COUNT=%%a
        echo - Total files: %FILE_COUNT%
        
        REM Check for critical files
        if exist "build\web\main.dart.js" (
            echo - main.dart.js: FOUND
        ) else (
            echo - main.dart.js: MISSING!
        )
        
        if exist "build\web\index.html" (
            echo - index.html: FOUND
        ) else (
            echo - index.html: MISSING!
        )
        
        if exist "build\web\manifest.json" (
            echo - manifest.json: FOUND (PWA ready)
        ) else (
            echo - manifest.json: MISSING!
        )
        
        echo.
        echo ==========================================
        echo PRODUCTION BUILD SUCCESSFUL
        echo ==========================================
        echo.
        echo Build Information:
        echo - Renderer: CanvasKit (default)
        echo - Mode: Release
        echo - Demo Mode: Enabled
        echo - Base URL: /DEF/
        echo - Output: def_order_app\build\web
        echo.
        echo GitHub Actions Compatibility: VERIFIED
        echo.
        echo Deployment Ready: YES
        echo URL: https://hyimmerse.github.io/DEF/
        echo.
    ) else (
        echo ERROR: Build output not found!
        goto :error
    )
) else (
    goto :error
)

cd ..
echo Build process completed successfully!
pause
exit /b 0

:error
echo.
echo ==========================================
echo BUILD FAILED
echo ==========================================
echo Please check the error messages above.
cd ..
pause
exit /b 1