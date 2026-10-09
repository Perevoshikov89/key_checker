```bat
@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo === NBKI KEY CHECKER DEBUG BUILD ===
echo.

if not exist "key_checker.py" (
    echo ERROR: rename the source to key_checker.py first,
    echo or change the filename in this BAT.
    pause
    exit /b 1
)

python -m pip show pyinstaller >nul 2>&1
if errorlevel 1 python -m pip install pyinstaller

if errorlevel 1 goto error

python -m PyInstaller ^
  --clean ^
  --noconfirm ^
  --onefile ^
  --console ^
  --debug=all ^
  --name key_checker_debug ^
  --collect-all ibm_db ^
  "key_checker.py" > build.log 2>&1

if errorlevel 1 goto error

echo.
echo Build completed.
echo EXE: dist\key_checker_debug.exe
echo Log: build.log
echo.
echo Run the EXE from CMD to inspect startup errors.
pause
exit /b 0

:error
echo.
echo BUILD FAILED. See build.log.
type build.log
pause
exit /b 1
```
