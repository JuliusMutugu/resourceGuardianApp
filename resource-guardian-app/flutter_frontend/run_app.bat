@echo off
echo.
echo ===============================================
echo  Resource Guardian - Flutter App Launcher
echo ===============================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

echo Checking Flutter installation...
flutter doctor --android-licenses

echo.
echo Installing dependencies...
flutter pub get

echo.
echo Available devices:
flutter devices

echo.
echo Starting Resource Guardian Flutter app...
echo Press Ctrl+C to stop the app
echo.

REM Run the app (will use the first available device)
flutter run

echo.
echo App stopped.
pause
