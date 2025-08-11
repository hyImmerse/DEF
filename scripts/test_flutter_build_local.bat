@echo off
echo ========================================
echo Testing Flutter Web Build Command
echo ========================================
echo.

cd def_order_app

echo Testing build command WITHOUT --web-renderer option:
echo.

REM Test the exact command that will run in GitHub Actions
echo Command: flutter build web --release --dart-define=IS_DEMO=true --base-href /DEF/ --no-tree-shake-icons
echo.

REM Use FVM if available, otherwise use regular flutter
where fvm >nul 2>&1
if %errorlevel% equ 0 (
    echo Using FVM Flutter...
    fvm flutter build web --release --dart-define=IS_DEMO=true --base-href /DEF/ --no-tree-shake-icons
) else (
    echo Using system Flutter...
    flutter build web --release --dart-define=IS_DEMO=true --base-href /DEF/ --no-tree-shake-icons
)

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [SUCCESS] Build command works correctly!
    echo ========================================
    echo.
    echo The --web-renderer option has been successfully removed.
    echo Flutter 3.32.5 will use CanvasKit renderer by default.
    echo.
    echo Build output location: def_order_app\build\web
) else (
    echo.
    echo ========================================
    echo [ERROR] Build failed!
    echo ========================================
    echo.
    echo Please check the error message above.
)

cd ..
pause