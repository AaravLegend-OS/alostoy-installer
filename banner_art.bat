@echo off
setlocal EnableExtensions EnableDelayedExpansion
rem UTF-8 console output.
chcp 65001 >nul
set "Automatic=0"
if /i "%~1"=="/PreInstall" (set "Text=        WELCOME TO THE INSTALLER. THANK YOU FOR CHOOSING TO INSTALL ALOSTOY V1.0.") else if /i "%~1"=="/PostInstall" (set "Text=    THANK YOU FOR INSTALLING ALOSTOY V1.0. YOU NOW HAVE THE BEST BOOTABLE USB DRIVE.") else (exit /b 1)
if /i "%~2"=="/Automatic" set "Automatic=1"
for /f %%A in ('"prompt $E & for %%B in (1) do rem"') do set "ESC=%%A"
mode con: cols=100 lines=40
set "C0=!ESC![30m"
set "C1=!ESC![31m"
set "C2=!ESC![32m"
set "C3=!ESC![33m"
set "C4=!ESC![34m"
set "C5=!ESC![35m"
set "C6=!ESC![36m"
set "C7=!ESC![37m"
set "C8=!ESC![90m"
set "C9=!ESC![91m"
set "C10=!ESC![92m"
set "C11=!ESC![93m"
set "C12=!ESC![94m"
set "C13=!ESC![95m"
set "C14=!ESC![96m"
set "C15=!ESC![97m"
rem Loop through colours.
for /l %%I in (0,1,15) do (
    call :Colour %%I TC
    cls
    echo(!ESC![H!ESC![2J
    echo(
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀▀!ESC![30;40m▀▀▀!ESC![30;44m▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![34;44m▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀!ESC![34;44m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀!ESC![30;44m▀!ESC![30;40m▀▀▀!ESC![30;44m▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![34;44m▀▀!ESC![30;40m▀!ESC![30;44m▀!ESC![34;44m▀!ESC![30;44m▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀!ESC![34;100m▀!ESC![90;47m▀!ESC![37;47m▀▀▀!ESC![90;47m▀!ESC![34;47m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![90;45m▀!ESC![37;45m▀!ESC![37;44m▀!ESC![90;44m▀!ESC![35;44m▀▀!ESC![90;44m▀!ESC![37;44m▀▀!ESC![90;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀!ESC![34;44m▀▀▀▀▀▀!ESC![90;45m▀!ESC![37;47m▀!ESC![90;107m▀▀!ESC![34;47m▀!ESC![34;100m▀!ESC![34;44m▀!ESC![90;100m▀!ESC![90;47m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![37;47m▀▀▀▀▀▀!ESC![35;47m▀!ESC![34;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀!ESC![37;44m▀!ESC![37;47m▀▀!ESC![97;47m▀!ESC![90;47m▀!ESC![34;44m▀!ESC![35;44m▀!ESC![90;44m▀▀▀▀▀!ESC![35;44m▀▀▀▀▀▀▀▀!ESC![35;100m▀!ESC![35;44m▀!ESC![37;44m▀!ESC![37;47m▀▀!ESC![90;100m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀!ESC![90;100m▀!ESC![37;107m▀!ESC![34;47m▀!ESC![34;44m▀▀▀!ESC![34;100m▀!ESC![37;47m▀▀▀▀!ESC![90;100m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![34;100m▀!ESC![34;47m▀!ESC![90;47m▀!ESC![37;47m▀▀!ESC![90;45m▀!ESC![34;44m▀!ESC![37;47m▀▀!ESC![90;100m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀!ESC![35;44m▀!ESC![37;47m▀▀▀!ESC![90;47m▀!ESC![37;47m▀▀▀▀▀▀!ESC![90;47m▀!ESC![34;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀!ESC![34;100m▀!ESC![37;47m▀▀!ESC![95;47m▀!ESC![37;47m▀!ESC![90;44m▀!ESC![34;44m▀▀!ESC![37;100m▀!ESC![37;105m▀!ESC![90;100m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![37;44m▀!ESC![37;45m▀!ESC![37;47m▀▀▀▀▀!ESC![37;105m▀▀!ESC![95;100m▀!ESC![37;105m▀!ESC![90;47m▀!ESC![34;100m▀!ESC![34;44m▀▀▀▀!ESC![34;47m▀!ESC![90;47m▀!ESC![37;105m▀!ESC![95;45m▀!ESC![35;44m▀▀!ESC![34;44m▀▀▀▀!ESC![90;100m▀!ESC![37;105m▀!ESC![35;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀!ESC![34;44m▀!ESC![34;40m▀!ESC![30;40m▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;100m▀▀!ESC![34;45m▀!ESC![34;44m▀▀▀▀!ESC![90;44m▀!ESC![37;45m▀!ESC![90;100m▀!ESC![94;104m▀▀!ESC![37;100m▀!ESC![90;44m▀!ESC![34;44m▀!ESC![34;47m▀!ESC![37;105m▀!ESC![95;45m▀!ESC![35;44m▀▀!ESC![34;44m▀▀▀▀▀▀▀!ESC![90;100m▀!ESC![95;100m▀!ESC![35;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀!ESC![34;44m▀!ESC![30;44m▀!ESC![30;40m▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![90;100m▀!ESC![37;100m▀!ESC![90;100m▀!ESC![34;44m▀▀▀▀▀▀!ESC![35;44m▀!ESC![37;45m▀!ESC![90;44m▀!ESC![34;45m▀!ESC![34;47m▀!ESC![37;104m▀!ESC![94;45m▀!ESC![35;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![90;100m▀▀!ESC![35;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀!ESC![90;100m▀▀▀!ESC![34;44m▀▀▀!ESC![34;46m▀!ESC![90;106m▀▀!ESC![36;106m▀!ESC![34;46m▀!ESC![34;44m▀!ESC![37;104m▀!ESC![94;44m▀!ESC![35;44m▀!ESC![34;104m▀!ESC![90;104m▀▀!ESC![34;100m▀▀!ESC![34;44m▀▀▀▀▀▀▀!ESC![90;100m▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![90;100m▀!ESC![90;104m▀!ESC![90;44m▀!ESC![34;44m▀!ESC![34;100m▀!ESC![36;106m▀!ESC![96;46m▀!ESC![96;44m▀!ESC![36;46m▀!ESC![94;104m▀!ESC![96;104m▀!ESC![36;104m▀!ESC![34;100m▀!ESC![34;44m▀!ESC![36;44m▀!ESC![94;104m▀▀▀▀!ESC![37;100m▀!ESC![90;47m▀!ESC![36;47m▀!ESC![90;100m▀▀▀!ESC![34;100m▀▀!ESC![34;44m▀!ESC![94;44m▀!ESC![90;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![36;44m▀!ESC![34;44m▀!ESC![34;46m▀!ESC![36;106m▀!ESC![96;46m▀!ESC![36;44m▀!ESC![34;46m▀!ESC![36;106m▀!ESC![96;46m▀!ESC![94;44m▀!ESC![94;46m▀!ESC![94;104m▀▀!ESC![36;44m▀!ESC![34;44m▀▀!ESC![36;44m▀!ESC![94;46m▀!ESC![94;104m▀▀▀▀▀▀▀▀▀▀!ESC![34;46m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;46m▀!ESC![36;106m▀!ESC![96;46m▀!ESC![36;44m▀!ESC![34;46m▀!ESC![36;106m▀!ESC![96;46m▀!ESC![36;44m▀!ESC![34;46m▀!ESC![36;104m▀!ESC![94;104m▀!ESC![94;44m▀!ESC![34;44m▀▀▀▀▀!ESC![34;46m▀!ESC![94;104m▀▀▀▀!ESC![94;46m▀!ESC![36;44m▀!ESC![34;44m▀▀!ESC![94;44m▀!ESC![94;106m▀!ESC![94;46m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![36;46m▀!ESC![96;106m▀!ESC![36;106m▀▀!ESC![96;46m▀!ESC![36;44m▀!ESC![34;46m▀!ESC![36;104m▀!ESC![94;44m▀▀!ESC![34;44m▀▀▀▀▀▀▀▀!ESC![94;46m▀!ESC![94;104m▀▀▀!ESC![34;46m▀!ESC![34;44m▀▀▀▀!ESC![36;46m▀!ESC![36;104m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;40m▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀!ESC![36;44m▀!ESC![36;104m▀▀▀▀▀!ESC![94;104m▀!ESC![36;104m▀!ESC![34;104m▀▀▀▀▀▀▀▀▀!ESC![34;46m▀!ESC![34;44m▀!ESC![94;44m▀!ESC![94;46m▀!ESC![94;104m▀▀!ESC![36;104m▀!ESC![34;104m▀▀!ESC![36;104m▀▀!ESC![94;104m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀!ESC![34;40m▀▀▀!ESC![30;40m▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![94;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![36;44m▀!ESC![34;44m▀▀▀!ESC![36;44m▀!ESC![94;44m▀▀▀▀!ESC![36;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀!ESC![35;47m▀!ESC![90;47m▀!ESC![35;47m▀!ESC![34;44m▀▀▀!ESC![35;100m▀!ESC![90;47m▀!ESC![34;44m▀▀▀▀!ESC![34;45m▀!ESC![34;47m▀!ESC![90;47m▀!ESC![37;100m▀!ESC![90;47m▀!ESC![35;47m▀!ESC![34;100m▀!ESC![34;44m▀▀!ESC![34;47m▀!ESC![90;47m▀!ESC![37;100m▀!ESC![90;47m▀!ESC![35;47m▀!ESC![34;45m▀!ESC![90;100m▀!ESC![90;47m▀▀▀▀▀!ESC![35;100m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀!ESC![35;100m▀!ESC![95;105m▀!ESC![90;44m▀!ESC![37;105m▀!ESC![35;100m▀!ESC![34;44m▀▀!ESC![90;100m▀!ESC![37;47m▀!ESC![34;44m▀▀▀!ESC![34;45m▀!ESC![37;47m▀!ESC![90;45m▀!ESC![34;44m▀▀▀!ESC![90;44m▀!ESC![37;105m▀!ESC![35;45m▀!ESC![35;44m▀!ESC![37;105m▀!ESC![35;47m▀!ESC![34;100m▀▀!ESC![35;44m▀▀!ESC![34;44m▀▀!ESC![90;45m▀!ESC![37;47m▀!ESC![35;45m▀!ESC![34;44m▀!ESC![34;45m▀!ESC![35;47m▀!ESC![37;105m▀!ESC![37;45m▀!ESC![37;105m▀!ESC![35;47m▀!ESC![34;44m▀!ESC![90;45m▀!ESC![35;105m▀!ESC![34;44m▀▀!ESC![35;45m▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀!ESC![34;45m▀!ESC![37;100m▀!ESC![90;100m▀!ESC![34;100m▀!ESC![35;104m▀!ESC![37;104m▀!ESC![34;45m▀!ESC![34;44m▀!ESC![35;45m▀!ESC![37;100m▀!ESC![34;44m▀▀▀!ESC![35;44m▀!ESC![95;104m▀!ESC![35;45m▀!ESC![34;44m▀▀▀!ESC![34;45m▀!ESC![95;104m▀!ESC![35;44m▀!ESC![34;44m▀!ESC![34;45m▀!ESC![35;44m▀▀!ESC![95;44m▀!ESC![95;104m▀!ESC![35;45m▀!ESC![34;44m▀▀!ESC![35;45m▀!ESC![95;100m▀!ESC![34;44m▀▀!ESC![90;45m▀!ESC![95;105m▀!ESC![34;44m▀▀!ESC![34;45m▀!ESC![95;105m▀!ESC![35;45m▀!ESC![34;44m▀!ESC![95;45m▀!ESC![35;45m▀!ESC![34;45m▀!ESC![95;104m▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀!ESC![94;104m▀!ESC![94;44m▀!ESC![34;40m▀!ESC![34;44m▀!ESC![34;40m▀!ESC![94;44m▀!ESC![94;104m▀!ESC![34;44m▀!ESC![35;44m▀!ESC![94;104m▀!ESC![90;104m▀▀▀!ESC![34;44m▀▀!ESC![94;44m▀!ESC![94;104m▀!ESC![35;104m▀!ESC![94;104m▀!ESC![94;44m▀▀!ESC![34;44m▀▀!ESC![94;44m▀!ESC![94;104m▀!ESC![35;104m▀!ESC![94;104m▀!ESC![94;44m▀!ESC![34;44m▀▀▀▀!ESC![94;104m▀!ESC![34;44m▀▀▀!ESC![94;44m▀!ESC![94;45m▀!ESC![35;45m▀!ESC![90;45m▀!ESC![94;44m▀!ESC![34;44m▀▀▀!ESC![94;104m▀▀!ESC![34;44m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀!ESC![34;40m▀!ESC![30;44m▀▀▀!ESC![34;44m▀!ESC![30;44m▀!ESC![34;44m▀▀!ESC![30;44m▀!ESC![34;44m▀▀!ESC![30;44m▀▀!ESC![34;44m▀▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![30;44m▀▀▀▀!ESC![34;44m▀!ESC![34;40m▀!ESC![34;44m▀!ESC![34;104m▀!ESC![94;44m▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;44m▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀!ESC![30;44m▀!ESC![34;44m▀▀▀▀▀!ESC![34;104m▀!ESC![34;44m▀!ESC![34;45m▀!ESC![34;44m▀!ESC![35;45m▀!ESC![35;104m▀!ESC![34;44m▀▀!ESC![34;45m▀!ESC![35;45m▀!ESC![90;45m▀!ESC![34;45m▀!ESC![34;44m▀▀▀▀▀▀▀▀▀!ESC![34;40m▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀▀▀!ESC![30;40m▀▀▀▀▀!ESC![34;40m▀▀!ESC![34;44m▀!ESC![34;40m▀!ESC![94;44m▀!ESC![34;104m▀!ESC![94;44m▀!ESC![34;40m▀!ESC![34;44m▀!ESC![94;104m▀!ESC![34;44m▀▀!ESC![94;44m▀!ESC![34;104m▀▀!ESC![94;44m▀!ESC![34;40m▀!ESC![34;44m▀▀▀!ESC![34;40m▀▀▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![34;40m▀▀▀!ESC![30;40m▀!ESC![34;40m▀▀▀▀!ESC![30;40m▀!ESC![34;40m▀▀!ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo !ESC![30;40m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀!ESC![0m
    echo(
    echo(      !TC!!Text!!ESC![0m
    echo(
    echo(                                       !TC!ALOSTOY V1.0 INSTALLER!ESC![0m
    timeout /t 1 /NOBREAK >nul
)
goto Stop
:Colour
set "N=%~1"
set "OUT=%~2"
if "!N!"=="0" set "!OUT!=!C0!"
if "!N!"=="1" set "!OUT!=!C1!"
if "!N!"=="2" set "!OUT!=!C2!"
if "!N!"=="3" set "!OUT!=!C3!"
if "!N!"=="4" set "!OUT!=!C4!"
if "!N!"=="5" set "!OUT!=!C5!"
if "!N!"=="6" set "!OUT!=!C6!"
if "!N!"=="7" set "!OUT!=!C7!"
if "!N!"=="8" set "!OUT!=!C8!"
if "!N!"=="9" set "!OUT!=!C9!"
if "!N!"=="10" set "!OUT!=!C10!"
if "!N!"=="11" set "!OUT!=!C11!"
if "!N!"=="12" set "!OUT!=!C12!"
if "!N!"=="13" set "!OUT!=!C13!"
if "!N!"=="14" set "!OUT!=!C14!"
if "!N!"=="15" set "!OUT!=!C15!"
exit /b
:Stop
if !Automatic! gtr 0 (echo We will continue in 3 seconds... & timeout /t 3 /NOBREAK >nul) else (echo Push any key to show the appropriate menu. & pause >nul)
mode con: cols=120 lines=30
cls
endlocal
exit /b 0