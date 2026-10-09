@echo off
chcp 65001 > nul

echo ========================================
echo   BUILD KEY_CHECKER
echo ========================================
echo.

echo [1/3] Определяем clidriver...

for /f "delims=" %%P in ('python -c "import os,sysconfig; print(os.path.join(sysconfig.get_path('purelib'),'clidriver'))"') do set "CLIDRIVER=%%P"

echo CLIDRIVER:
echo %CLIDRIVER%
echo.

if not exist "%CLIDRIVER%\bin" (
    echo ОШИБКА: clidriver\bin не найден!
    pause
    exit /b 1
)

echo [2/3] Удаляем старую сборку...

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist key_checker.spec del /q key_checker.spec

echo.
echo [3/3] Собираем EXE...
echo.

pyinstaller ^
    --clean ^
    --noconfirm ^
    --onefile ^
    --windowed ^
    --collect-binaries ibm_db ^
    --add-data "%CLIDRIVER%;clidriver" ^
    key_checker.py

echo.
echo ========================================

if exist "dist\key_checker.exe" (
    echo СБОРКА УСПЕШНА!
    echo.
    echo EXE:
    echo %CD%\dist\key_checker.exe
) else (
    echo ОШИБКА СБОРКИ!
)

echo ========================================
pause