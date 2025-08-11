@echo off
echo ==========================================
echo Flutter Web Production Build (Verbose)
echo ==========================================
echo.

cd def_order_app

echo Current directory: %cd%
echo.

echo Installing dependencies...
flutter pub get
echo.

echo Building web app...
echo Command: flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons
flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons

if %errorlevel% equ 0 (
    echo.
    echo BUILD SUCCESSFUL!
    echo.
    
    if exist "build\web" (
        echo Build output found at: %cd%\build\web
        dir build\web /b | head -5
    ) else (
        echo ERROR: Build directory not created!
    )
) else (
    echo.
    echo BUILD FAILED with exit code: %errorlevel%
)

cd ..
pause