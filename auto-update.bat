@echo off
:: 切換到腳本所在目錄
cd /d %~dp0

:: Step 1: Discard 所有修改與新檔案
echo [1/5] Resetting and cleaning repo...
git reset --hard
git clean -fd

:: Step 2: 執行你的程式
echo [2/5] Running your program...
call nvd-dl.exe -w %USERPROFILE% --cve-pack-mode 2
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Program execution failed. Stopping script.
    exit /b 1
)

:: Step 3: Stage 所有產生的變更
echo [3/5] Staging changes...
git add .

:: Step 4: 建立以目前時間為訊息的 commit
for /f "tokens=1-5 delims=/: " %%a in ("%date% %time%") do (
    set commit_time=%%a-%%b-%%c %%d:%%e
)
echo [4/5] Committing...
git commit -m "%commit_time%"

:: Step 5: 強制推送
echo [5/5] Force pushing...
git push --force
