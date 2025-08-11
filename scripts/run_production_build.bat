@echo off
cd def_order_app
flutter build web --release --dart-define=IS_DEMO=true --base-href=/DEF/ --no-tree-shake-icons
echo Build exit code: %errorlevel%
cd ..