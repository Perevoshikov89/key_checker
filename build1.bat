@echo off
chcp 65001 > nul

echo ========================================
echo   BUILD 3_2 BASELINE CHECKER 2.0
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
if exist 3_2_baseline_gui_2.0.spec del /q 3_2_baseline_gui_2.0.spec

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

if exist "dist\key_checker_2.0.exe" (
    echo СБОРКА УСПЕШНА!
    echo.
    echo EXE:
    echo %CD%\dist\key_checker_2.0.exe
) else (
    echo ОШИБКА СБОРКИ!
)

echo ========================================
pause