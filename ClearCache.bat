@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Set console properties
color 0f
title FiveM Cache Cleaner V2 by Kamion
mode con: cols=100 lines=30

:: ASCII Art and Header
echo.
echo   ███████╗██╗██╗   ██╗███████╗███╗   ███╗     ██████╗██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
echo   ██╔════╝██║██║   ██║██╔════╝████╗ ████║    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
echo   █████╗  ██║██║   ██║█████╗  ██╔████╔██║    ██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██████╔╝
echo   ██╔══╝  ██║╚██╗ ██╔╝██╔══╝  ██║╚██╔╝██║    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗
echo   ██║     ██║ ╚████╔╝ ███████╗██║ ╚═╝ ██║    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║███████╗██║  ██║
echo   ╚═╝     ╚═╝  ╚═══╝  ╚══════╝╚═╝     ╚═╝     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
echo                                                                                                V2 by Kamion
echo.
echo [40;32m═══════════════════════════════════════════════════════════════════════════════════════════════════[40;37m
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [40;31m[ERROR] This script requires administrator privileges.[40;37m
    echo Please run this script as administrator.
    echo.
    pause
    exit /b 1
)

:: Initialize counters
set "deleted_files=0"
set "failed_deletes=0"

:: Function to delete files and count results
:DeleteFiles
set "folder=%~1"
if exist "%folder%" (
    echo [40;33m[CLEANING] %~2[40;37m
    for /f "delims=" %%i in ('dir /a-d /s /b "%folder%\*.*" 2^>nul') do (
        del "%%i" /f /q >nul 2>&1
        if !errorLevel! equ 0 (
            set /a deleted_files+=1
        ) else (
            set /a failed_deletes+=1
        )
    )
) else (
    echo [40;33m[INFO] %~2 not found, skipping...[40;37m
)
goto :eof

:: Main cleaning process
echo Starting cache cleaning process...
echo.

call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\logs" "FiveM Logs"
call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\crashes" "FiveM Crash Reports"
call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\data\cache" "FiveM Cache"
call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\data\nui-storage" "FiveM NUI Storage"
call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\data\server-cache" "FiveM Server Cache"
call :DeleteFiles "%userprofile%\AppData\Local\FiveM\FiveM.app\data\server-cache-priv" "FiveM Private Server Cache"
call :DeleteFiles "C:\Windows\Prefetch" "Windows Prefetch"
call :DeleteFiles "C:\Windows\Temp" "Windows Temp"
call :DeleteFiles "%USERPROFILE%\appdata\local\temp" "User Temp"

:: Display results
echo.
echo [40;32m═══════════════════════════════════════════════════════════════════════════════════════════════════[40;37m
echo.
echo Cache cleaning completed!
echo [40;32m[SUCCESS] Files deleted: %deleted_files%[40;37m
if %failed_deletes% gtr 0 echo [40;31m[WARNING] Failed deletions: %failed_deletes%[40;37m
echo.
echo [40;32m═══════════════════════════════════════════════════════════════════════════════════════════════════[40;37m
echo.

:: Prompt user to restart FiveM
echo Do you want to launch FiveM now? (Y/N)
choice /c YN /n
if %errorLevel% equ 1 (
    echo.
    echo [40;32m[INFO] Launching FiveM...[40;37m
    start "" "fivem://connect/localhost"
) else (
    echo.
    echo [40;33m[INFO] Remember to restart FiveM to apply the changes.[40;37m
)

echo.
timeout /t 5 >nul
exit /b 0
