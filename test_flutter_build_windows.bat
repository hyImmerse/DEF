@echo off
echo ========================================
echo Flutter Web Build Test (Windows)
echo ========================================
echo.

cd def_order_app

echo Testing Flutter web build without --web-renderer option...
echo.

REM Run the build command
flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [SUCCESS] Build completed successfully!
    echo ========================================
    echo.
    echo - The --web-renderer option has been removed
    echo - Flutter 3.32.5 uses CanvasKit renderer by default
    echo - Build output: def_order_app\build\web
    echo.
    
    REM Check if build output exists
    if exist "build\web\index.html" (
        echo Build artifacts verified:
        dir build\web\*.* /b | head -5
        echo.
        
        REM Check for CanvasKit in the build
        findstr /i "canvaskit" build\web\main.dart.js >nul 2>&1
        if %errorlevel% equ 0 (
            echo [INFO] CanvasKit renderer confirmed in build output
        )
    )
) else (
    echo.
    echo ========================================
    echo [ERROR] Build failed!
    echo ========================================
    echo.
    echo Please check the error message above.
    echo Common issues:
    echo - Ensure Flutter 3.32.5 is installed
    echo - Run 'flutter pub get' first
    echo - Check for dependency conflicts
)

cd ..
echo.
pause