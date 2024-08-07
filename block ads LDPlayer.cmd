@echo off
chcp 65001 >nul
setlocal

:: Check for administrative privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ======================================
    echo        BẠN PHẢI CHẠY VỚI QUYỀN QUẢN TRỊ! 
    echo             Run as Administrator!
    echo ======================================
    color 4F
    pause
    exit /b
)

:: Define the path to dnplayer.exe
set "dnplayer_path=%~dp0dnplayer.exe"
if not exist "%dnplayer_path%" (
    echo.
    echo ======================================
    echo Không tìm thấy dnplayer.exe trong cùng thư mục với script.
	echo dnplayer.exe was not found in the same directory as the script.
    echo ======================================
    pause
    exit /b
)

:: Menu options
:menu
cls
echo ======================================
echo           LỰA CHỌN CHỨC NĂNG
echo           FUNCTION SELECTION
echo ======================================
echo.
echo 1. Tắt quảng cáo (Block ads LDplayer)
echo 2. Xóa quy tắc đã thêm (Accept ads LDplayer)
echo 3. Thoát (Close)
echo.
set /p choice="Choose an option (1, 2, 3): "

if "%choice%"=="1" goto block_ads
if "%choice%"=="2" goto remove_rules
if "%choice%"=="3" goto exit

:: Invalid choice, re-display menu
goto menu

:block_ads
netsh advfirewall firewall delete rule name="Block ldplayer ads"
netsh advfirewall firewall add rule name="Block ldplayer ads" program="%dnplayer_path%" dir=in action=block
:: netsh advfirewall firewall add rule name="Block ldplayer ads" program="%dnplayer_path%" dir=out action=block

:: Rainbow effect for successful block message
echo.
echo ======================================
call :colorful_echo "Đã chặn quảng cáo thành công, bạn có thể tắt đi"
call :colorful_echo "Ads have been successfully blocked, you can turn them off"
echo ======================================
timeout /t 5 >nul
pause
goto menu

:remove_rules
netsh advfirewall firewall delete rule name="Block ldplayer ads"
echo.
echo ======================================
echo           Đã xóa quy tắc chặn quảng cáo
echo           Removed ad blocking rule
echo ======================================
pause
goto menu

:exit
endlocal
exit /b

:colorful_echo
setlocal
set "msg=%~1"
set "colors=4E 5E 6E 1F 2F 3F"
for /L %%i in (1,1,5) do (
    for %%C in (%colors%) do (
        color %%C
        echo %msg%
        timeout /t 1 >nul
    )
)
endlocal
goto :eof
