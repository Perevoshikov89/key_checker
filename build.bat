```bat
@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

title NBKI Key Checker - Build

echo ==========================================
echo       NBKI Key Checker - BUILD
echo ==========================================
echo.

REM Проверяем наличие Python
python --version
if errorlevel 1 (
    echo [ERROR] Python не найден или не добавлен в PATH.
    pause
    exit /b 1
)

echo.
echo [1/4] Устанавливаем зависимости...
python -m pip install --upgrade pip
if errorlevel 1 goto error

python -m pip install ibm_db openpyxl pyinstaller
if errorlevel 1 goto error

echo.
echo [2/4] Удаляем старую сборку...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist NBKI_Key_Checker.spec del /q NBKI_Key_Checker.spec

echo.
echo [3/4] Собираем приложение...
python -m PyInstaller ^
    --clean ^
    --noconfirm ^
    --onedir ^
    --console ^
    --name "NBKI_Key_Checker" ^
    --collect-all ibm_db ^
    --collect-all openpyxl ^
    key_checker.py

if errorlevel 1 goto error

echo.
echo [4/4] Проверяем результат...
if not exist "dist\NBKI_Key_Checker\NBKI_Key_Checker.exe" goto error

echo.
echo ==========================================
echo          BUILD SUCCESSFUL
echo ==========================================
echo.
echo EXE:
echo %~dp0dist\NBKI_Key_Checker\NBKI_Key_Checker.exe
echo.
echo Передайте пользователю всю папку:
echo %~dp0dist\NBKI_Key_Checker\
echo.
pause
exit /b 0

:error
echo.
echo ==========================================
echo              BUILD ERROR
echo ==========================================
echo Проверьте сообщения выше.
pause
exit /b 1
```
