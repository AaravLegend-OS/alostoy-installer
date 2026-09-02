@rem ===================================================================
@rem                ALOSToy Installer By Aarav Katariya
@rem                      Program encoding: UTF-8
@rem                      Program language: EN-GB
@rem                      Is emergency update: False
@rem    Repo: https://www.github.com/AaravLegend-OS/alostoy-installer
@rem                       Newline sequence: CRLF
@rem           Program license: GPL v3 "or any later version"
@rem             Supports upgrade from GPLv3 to future: True
@rem              SPDX-License-Identifier: GPL-v3.0-or-later
@rem Please read GPLV3_ONLY_INFO.TXT for redistribution under GPLv3 only.
@rem                   An overview of the installer:
@rem This utility can save your life! It can create a bootable USB
@rem drive that is jam-packed with diagnostic, password removal, live
@rem antimalware, boot repair, partition, and imaging tools as well as
@rem Windows PE environments, Linux repair disks to fix both Windows
@rem and Linux and even forensic tools for deep investigation and
@rem bit-for-bit clones. ALOSToy comes in 3 editions: Standard,
@rem Standard+Extensions and Extended versions. Higher versions give
@rem you OS installers pre-loaded for you. (I know.)
@rem ===================================================================
@rem                     Pro delayed expansion tip:
@rem If you want to escape ! in delayed expansion, without disabling it,
@rem use ^^! so that it prints the exclamation mark without creating any
@rem setlocal layers. I know. ^^ is required becase one ^ will still
@rem expand !variables! to their contents so use two ^^ to properly
@rem print any ! you want to display. Eg:
@rem echo ^^!variable^^!
@rem echo This is a test of bypassing delayed expansion problems^^!
@rem Please note, this will not work in PowerShell unless you embed it
@rem in the program or use a separate script (Which lets you use !
@rem without the need of ^'s.)
@rem I hope that helps you get around delayed expansion quirks!
@rem ===================================================================
@rem ALSO, NEVER USE "::" FOR COMMENTS. IT IS A BROKEN LABEL THAT BATCH
@rem SURPRISINGLY ACCEPTS BUT CAN BREAK IN ACTUAL LABELS OR BLOCKS. USE
@rem REM TO MARK A COMMENT. IT IS FAR SAFER. YOU WILL FIND OUT WHEN YOU
@rem USE A "::" COMMENT INSIDE AN IF BLOCK!
@rem ===================================================================
@rem Please note that the ALOSToy Installer is licensed under GPL v3 but
@rem aria2c is licensed under GPL v2. No code from either program is
@rem combined, nor is it statically or dynamically linked to avoid a
@rem derivative work. Instead, the installer just calls the compiled exe
@rem to prevent license incompatibility between GPLv2.0 and GPLv3.0.
@rem This notice is only for aria2c.exe and only the exe is called AS A
@rem SEPARATE PROCESS.
@rem ===================================================================
@rem Ventoy is licensed under GNU GPLv3 or any later version. The code
@rem can be combined or linked statically or dynamically, but the author
@rem chose not to combine the code because it would create a combined/
@rem derivative work.
@rem ===================================================================
@rem =============================== folderbrowse usage ==================================
@rem Usage: folderbrowse.exe <WindowTitle> <timeout>
@rem EG: folderbrowse.exe "This is a test." 3
@rem The example above sets the window title to "This is a test." and waits 3 seconds
@rem before opening the actual folder browser user interface where you can pick a folder.
@rem If you do not specify a timeout duration, it defaults to 0 seconds. (No time delay.)
@rem Do you know how to add a dynamic light/dark mode changer in Windows Presentation
@rem Framework using PowerShell? I am interested to see your replication on Github.
@rem =====================================================================================
@rem Set the codepage to UTF-8 for international character support.
@chcp 65001 >nul
@rem We should only enable delayed expansion once.
@setlocal EnableExtensions EnableDelayedExpansion
@rem We will turn off command echoing and then later reset
@rem PATH and other system variables to their defaults.
@set "CmdEchoing=off"
@rem ========================================================================
@rem This does NOT print "off" or "on" literally. The echo command treats on
@rem or off like a command to toggle command echoing. It is as if you use
@rem "@echo off" or "@echo on"
@echo !CmdEchoing!
rem =========================================================================
rem Save the script name to relaunch and use. (Persists across arguments and relaunches.)
rem A for loop is more reliable because when arguments are parsed and shifted,
rem %~nx0 could become the next argument.
for /f "delims=" %%S in ('echo %~nx0') do set "Script=%%S"
for /f "delims=" %%F in ('echo %~f0') do set "FullScript=%%F"
rem Store the root directory for use (Contains trailing slash).
set "Root=%~dp0"
rem Define the author.
set "Author=Aarav Katariya"
rem Define the version. (Will always remain in 1.X.X.X format.)
set "Version=1.0.1.4"
for /f "skip=2 tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Control Panel\International" /v "LocaleName"') do (
    set "OSLanguage=%%B"
    set "lang=!OSLanguage:~0,2!"
    set "locale=!OSLanguage:~3,5!"
    set "OSLanguage="
)
rem The official way to check for admin in batch. Even Microsoft says this too.
net session >nul 2>&1
if !errorlevel! gtr 0 (
    call :WindowTitle "RELAUNCHING"
    rem Use conhost instead of cmd to force a relaunch in the Windows Console Host instead of Windows Terminal.
    powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Relaunching as an administrator.','ALOSToy Installer','OK','Warning') | Out-Null; Start-Process conhost.exe -Verb RunAs -ArgumentList 'cmd.exe /c cd /d "!Root!\" & call "!Script!" %*'" >nul 2>&1 && (endlocal & exit 0) || (
        call :WindowTitle "CANCELLED"
        start /b powershell -nop -nol -ExecutionPolicy Bypass -WindowStyle Hidden -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Necessary administrator permissions was denied or rejected. Exiting...','ALOSToy Installer','OK','Error') | Out-Null"
        endlocal
        exit 1
    )
) else if defined WT_SESSION (
    rem Or detect Windows Terminal in administrator session of
    rem WT and then force relaunch in the Windows Console Host.
    set "WT_SESSION="
    powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Relaunching in a Windows Console Host window.','ALOSToy Installer','OK','Warning') | Out-Null; Start-Process conhost.exe -Verb RunAs -ArgumentList 'cmd.exe /c cd /d "!Root!\" & call "!Script!" %*'" >nul 2>&1
    endlocal
    exit 15
)
rem Now enforce the CRLF line ending.
>nul findstr /v "$" "!Script!" && (
   call :WindowTitle "CRLF EMPTY LINE MISSING."
   cls
   echo The CRLF empty line is missing. Please re-add that empty line at the
   echo bottom of !Script!.
   echo Press any key to quit...
   pause >nul
   endlocal
   exit 2
)
rem =========================================================================
rem IMPORTANT VARIABLE. THIS VARIABLE HELPS DECIDE IF THIS PROGRAM CAN BE
rem LICENSED UNDER ANY LATER VERSION. IF THIS IS "False", YOU CAN USE AND
rem REDISTRIBUTE UNDER GPLV3 ONLY, BUT IF THIS IS "True", YOU CAN USE AND
rem REDISTRIBUTE UNDER GPLV3 "OR ANY LATER VERSION". PLEASE REVIEW THIS
rem CAREFULLY BEFORE CHANGING "Or-Any-Later-Version" BELOW. DO NOT REMOVE.
rem =========================================================================
rem THE VARIABLE BELOW DOES NOT AUTOMATICALLY MAKE THIS PROGRAM GPLV3 ONLY OR
rem GPLV3 "OR ANY LATER VERSION". INSTEAD, IT CHANGES BEHAVIOUR TO HELP YOU
rem REDISTRIBUTE UNDER V3 ONLY OR V3 "OR ANY LATER VERSION" THIS MEANS THE
rem VARIABLE BELOW DOES NOT ALLOW AUTOMATIC GPLV3 "OR ANY LATER VERSION"
rem DISTRIBUTION TO OCCUR. ONLY CHANGE IF YOU CHOOSE TO FORK THIS PROGRAM.
rem =========================================================================
set "Or-Any-Later-Version=True"
rem Check for powershell existence and find it in path.
rem Must happen before anything else occurs in the process.
if exist "!SystemRoot!\System32\WindowsPowershell\v1.0\powershell.exe" (
    for %%# in (powershell.exe) do @if "%%~$PATH:#"=="" (
        echo You must install powershell or include it in ^^!Path^^!.
        pause >nul
        endlocal
        exit 1
    )
)
set "D=!DATE!"
set "T=!TIME!"
rem Strip special characters out.
set "LogStamp=!D!-!T!"
set "LogStamp=!LogStamp:/=-!"
set "LogStamp=!LogStamp::=-!"
set "LogStamp=!LogStamp: =0!"
rem Define the main url. ALWAYS HTTPS, NEVER HTTP.
set "InstallerRepo=https://github.com/AaravLegend-OS/alostoy-installer"
set "Uri=!InstallerRepo!/raw/refs/heads/main/tools.esd"
rem Write a new timestamped log.
if not exist "!Root!logs" md "!Root!logs"
set "logfile=!Root!logs\ALOSTOY-INSTALLER_!LOGSTAMP!.LOG"
if /i "%~1"=="I_QEOff" (
    call :WindowTitle "STARTING {Part 1}..."
    rem Definitive start. Write the starting header to the logfile to begin new install.
    echo ========================================================================================================================>> "!logfile!"
    echo ================================ Starting ALOSToy Installer... ^(!D! !T!^) ================================>> "!logfile!"
    echo ========================================================================================================================>> "!logfile!"
)
rem Define primary and fallback font.
set "FirstFont=CaskaydiaCove NFM"
set "SecondFont=Courier New"
set "Missing=False"
rem Define the SHA algorithm.
set "Algorithm=SHA256"
cls
rem Define the number of columms and lines.
rem It will always be 120x30.
set "Columns=120"
set "Lines=30"
mode con: cols=!Columns! lines=!Lines!
rem Place the logfile argument first before you specify custom logfile.
rem This means even the "Starting ALOSToy Installer" header is in the
rem user defined logfile path.
for %%L in (%*) do (
    if /i "%%L"=="/LogFile" (
        if "%~2"=="" (
            echo Missing value for LogFile.
            endlocal
            exit 7
        ) else (
            set "logfile=%~2"
            echo Successfully set logfile path to !logfile!.
            set "CustomLogFilePath=True"
            set "ArgumentsPassed=True"
            timeout /t 1 /NOBREAK >nul
            shift
            shift
        )
    ) else if /i "%%L"=="-LogFile" (
        if "%~2"=="" (
            echo Missing value for LogFile.
            endlocal
            exit 7
        ) else (
            set "logfile=%~2"
            echo Successfully set logfile path to !logfile!.
            set "CustomLogFilePath=True"
            set "ArgumentsPassed=True"
            timeout /t 1 /NOBREAK >nul
            shift
            shift
        )
    ) else if "%%L"=="--Log-File" (
        if "%~2"=="" (
            echo Missing value for LogFile.
            endlocal
            exit 7
        ) else (
            set "logfile=%~2"
            echo Successfully set logfile path to !logfile!.
            set "CustomLogFilePath=True"
            set "ArgumentsPassed=True"
            timeout /t 1 /NOBREAK >nul
            shift
            shift
        )
    )
)
set "GPLNotice=1"
rem This special argument has to be parsed the manual and hard way
rem because the installer title and gpl notice shows up before the
rem argument parser.
for %%A in (%*) do (
    if /i "%%A"=="/HideGPLNotice" (
        set "GPLNotice=0"
        goto Start
    ) else if /i "%%A"=="-HideGPLNotice" (
        set "GPLNotice=0"
        goto Start
    ) else if "%%A"=="--Hide-GPL-Notice" (
        set "GPLNotice=0"
        goto Start
    )
)
:Start
call :InstallerTitle
rem Set a blank title.
title 
rem Initialise all the variables.
rem First, check the file name. If it is not the same, exit immediately.
if "!Script!" neq "ALOSTOY-INSTALLER.BAT" exit 1
rem Set the hashes as early as the start. Better than hardcoded values buried everywhere.
set "STHashA=580B1901D6307541DA38D38B2CB3E365EB81002B7DA220F678282983FBA059D6"
set "STHashB=F18B9F2E01BD8EA4FCAF4B3D22B12384FC8B371C3690814F87FA9A06341EDEE6"
set "STHashC=3E43F268EDAF230F738C4E92A36369F4E84D9E9E67E93B3B81CD895FB0F825A5"
set "STHashD=C76AF29900CFC1BBC509E16B90CB74F354DA69813DB02BFE5E629F40361AC49F"
set "STHashE=1944B43B92CD6B1FCBACED02DC9FD8259AC6492F2D13B66E36C414423231CBC2"
set "STHashF=2FF1C6D7AF7825F53ADAA70444BBE80675404A79402176A43A562826AC5737D4"
set "EXHashA=BF943BB1B47880675A76FADFE18D5CC920060B8D22A9A7D46A94CAF27160C7D4"
set "EXHashB=B06ADA3ADD1BD3079B3F410CB7470FDC29DFF9BC56D930A5239338355A6E9774"
set "EXHashC=935B46673D9406077FF1CF1C210C3BA30E000E653B680D5A465331CE2B366EE1"
set "EXHashD=89F04F63F8606F568B9022DB4489D08B67B1E5D2B29C947D15B63A0985AC99F7"
set "EXHashE=2B3670042B42760016ED006D4066E8700D43BCDF528780A6E47CCFE7F204EA3E"
set "EXHashF=D55CDAAE3DD35900EF69DE063AA02C10DCCB8ED172B55434FDBB4E2F0378129C"
set "EXHashG=0E417F999D42920282B9AD411E95372C692DC6FA21CDC15511F8F80EB04887CB"
set "EXHashH=486265B9BA383F2ADB8B5C5F26B76148CDCEBAB7965ACE3B083F52080F6899D7"
rem Store the tools hash and use it later. (Useful for hashing the tools.esd file and not trusting blindly.)
set "ToolsHash=CC6B492FDA5E3A4F2FA3B10B2B5F08A10122286D2DAEC9C7E5B3967101828CB8"
rem You can configure how new lines are represented in message boxes.
rem Use `r`n for Windows style Carriage Return Line Feed newlines or
rem use `n for Unix style Line Feed newlines. This program uses CRLF
rem line endings because this is written on a Windows system. Just
rem change the variable "NewLine" to decide your line endings in
rem message boxes. The ending will be validated after it is set.
set "NewLine=`r`n"
rem Initialise the rest.
set "InstallExtensions=False"
set "WarnAccepted=0"
set "ConfigChanged=False"
set "Selected=False"
set "BannerShown=False"
set "InternetArchiveBlocked=False"
set "GithubBlocked=False"
set "CustomLogFilePath=False"
set "ProductDefinedWithArg=False"
set "ShowBanner=Yes"
set "ArgumentIsSwitch=No"
set "BannerReShown=False"
set "AlwaysShowBanner=No"
set "NeverShowBanner=No"
set "Vtoy_DL_Mode=0"
set "NoticeAgreed=False"
set "AcceptEULA=0"
set "AcceptAVWarn=0"
set "Pages=10"
set "InstallGuidePages=10"
set "HelpFromMain=0"
set "RequiresExit=False"
set "Located=0"
set "ResetVars=0"
set "re1=0"
set "re2=0"
set "Updated=0"
set "RequiresUpdate=False"
set "ForceUpdate=0"
set "NoUpdate=0"
set "CaseSensitive=0"
set "AutoUpdate=0"
set "BrowsingHelp=False"
set "FormatAccepted=0"
set "RedoInstall=No"
set "ArgumentsPassed=False"
rem Validate the line ending choice.
if "!NewLine!"=="`r`n" (echo >nul) else if "!NewLine!"=="`n" (echo >nul) else (
    echo Your line endings are not valid.
    echo Please change your line ending of !NewLine! to either:
    echo `r`n
    echo `n
    pause
    endlocal
    exit 4
)
set "QuickEdit=On"
rem Arguments starting with "I_" are supposed to be internal use only.
if /i "%~1"=="I_QEOff" set "QuickEdit=Off"
if "!Or-Any-Later-Version!"=="False" (
    call :LicenseHasher
    rem Properly enforce the license rules.
    if "!Missing!"=="True" (
        echo The license documents are missing. We can no longer prove if
        echo !Script! is legitimately licensed or not. Go and
        echo redownload them from !InstallerRepo!.
        timeout /t 3 /NOBREAK >nul
        echo DO IT IMMEDIATELY^^!
        pause >nul
        endlocal
        exit 22
    )
    if !Valid_LicenseDocuments! lss 2 (
        echo The license documents are not valid. Either you saved a newer
        echo version, or you modified one or more license documents. This
        echo is not permitted under the GNU GPL v3.0 as stated by the Free
        echo Software Foundation. Please redownload the unmodified copies
        echo of COPYING.TXT and LICENSE.TXT from:
        echo !InstallerRepo!
        echo.
        echo Note: !Script! is licensed under GPLv3 ONLY.
        pause
        endlocal
        exit 22
    )
)
set "PathExt=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"
set "SysPath=!SystemRoot!\System32"
set "Path=!SystemRoot!\System32;!SystemRoot!;!SystemRoot!\System32\Wbem;!SystemRoot!\System32\WindowsPowerShell\v1.0\"
if exist "!SystemRoot!\Sysnative\reg.exe" (
    set "SysPath=!SystemRoot!\Sysnative"
    set "Path=!SystemRoot!\Sysnative;!SystemRoot!;!SystemRoot!\Sysnative\Wbem;!SystemRoot!\Sysnative\WindowsPowerShell\v1.0\;!Path!"
)
set "ComSpec=!SysPath!\cmd.exe"
set "PSModulePath=!ProgramFiles!\WindowsPowerShell\Modules;!SysPath!\WindowsPowerShell\v1.0\Modules"
set "Path=!Path!;!Root!;!Root!bin;!Root!Ventoy2Disk;!Root!Ventoy2Disk\altexe"
set "UserArguments=%*"
rem Right-click + Run As Administrator forcibly sets the working directory to !SystemRoot!\System32. Overcome that and handle it properly with the ability to run it from System32.
if /i "!CD!"=="!SYSTEMROOT!\System32" if "!FullScript!" neq "!SYSTEMROOT!\System32\!Script!" (
    call :WindowTitle "NO RUNNING FROM SYSTEM32."
    echo Do not directly run this as admin. Ensure that !Script! is actually in !SystemRoot!\System32 if you want to right click + Run As Administrator.
    echo Press any key to exit and next time, double click it normally.
    echo.
    echo !Script! will automatically relaunch as admin within the correct working directory.
    echo.
    echo Do not try turning off UAC though.
    pause >nul
    exit 10
)
rem ================================================
rem Check for the rest of the files and then SHA256
rem verify them all to confirm they were downloaded
rem          from the official repository.
rem ================================================
rem Initalise some temporary variables.
set "HASH1="
set "HASH2="
set "HASH3="
set "HASH4="
set "HASH5="
set "HASH6="
set "HASH7="
set "COUNTER=0"
set "Valid_SubFiles=0"
rem Actually start hashing all the files. 7 files to hash.
for /f "usebackq delims=" %%A in (`powershell -nop -nol -c "@('COPY_SCRIPT_TO_CLIPBOARD.BAT','MAKE_TOOLS_ESD.BAT','NEW_ALOSTOY-INSTALLER.ZIP.BAT','SHOW_COMMAND_LINE_HELP.BAT','SHOW_INSTALLATION_HELP.BAT','FORCE_UPDATE_AND_RUN.BAT','README.MD') | foreach { (Get-FileHash -LiteralPath $_ -Algorithm $env:Algorithm).Hash.ToUpper() }"`) do (
    rem Set the temporary hash variables sequentially.
    rem It is not possible to do it in parallel. (Batch limitation.)
    set /a "COUNTER+=1"
    if "!COUNTER!"=="1" set "HASH1=%%A"
    if "!COUNTER!"=="2" set "HASH2=%%A"
    if "!COUNTER!"=="3" set "HASH3=%%A"
    if "!COUNTER!"=="4" set "HASH4=%%A"
    if "!COUNTER!"=="5" set "HASH5=%%A"
    if "!COUNTER!"=="6" set "HASH6=%%A"
    if "!COUNTER!"=="7" set "HASH7=%%A"
)
rem Compare expected hash to actual hash. It might not seem necessary to
rem hash the subfiles that come with the zipfile but actually, it proves
rem that you got this program, ALOSTOY-INSTALLER.BAT, is from the author
rem (Aarav Katariya) and not a hacker or scammer.
if defined HASH1 if /i "!HASH1!"=="5CBAD9C202662DE56E042C79F45B95DA67293D55341369F841E9027E388C3F1B" (set /a "Valid_SubFiles+=1")
if defined HASH2 if /i "!HASH2!"=="EC6A2C047BA35ADFFD2D639C860B82B6F27B3C1E273141722D07A07FF130DA17" (set /a "Valid_SubFiles+=1")
if defined HASH3 if /i "!HASH3!"=="782944F445BCFB294C4027D86E969DEF80884A439669BDB49C5F59D7A31BBF5E" (set /a "Valid_SubFiles+=1")
if defined HASH4 if /i "!HASH4!"=="89489AC860E420AC64856F2C2960769C56E87C028A79BB01562DC1373E819BA8" (set /a "Valid_SubFiles+=1")
if defined HASH5 if /i "!HASH5!"=="5F7C42892C1E86C3A7123F8A5A933ED584A21A2DA89EF19C84D52B9985C08CBD" (set /a "Valid_SubFiles+=1")
if defined HASH6 if /i "!HASH6!"=="08708EB8284E17A9505008551A172F6841A70D58587DDC07351DE1C2B54668B9" (set /a "Valid_SubFiles+=1")
if defined HASH7 if /i "!HASH7!"=="EBE2ABDE48B2099ECEE76EAF981AD4D7840BFFA3E57E1DAA5859103C985AA4BB" (set /a "Valid_SubFiles+=1")
rem Enforce the subfile requirement immediately.
rem If we get to the fail, exit immediately. Assume untrusted source.
rem Remember. Zero-trust policy. I do not trust any entity personally.
if !Valid_SubFiles! lss 7 (
    echo The subfiles of !Script! are not valid^^!
    echo You are required to redownload them from:
    echo !InstallerRepo!.
    echo.
    echo Press any key to open the GitHub repository in your default browser...
    pause >nul
    start !InstallerRepo!
    endlocal
    exit 23
) else (
    rem But if we succeed, erase all the temporary variables and move on.
    set "HASH1="
    set "HASH2="
    set "HASH3="
    set "HASH4="
    set "HASH5="
    set "HASH6="
    set "HASH7="
    set "COUNTER="
    set "Valid_SubFiles="
)
rem Block ARM32 and x86 but permit x64 and ARM64.
rem ARM64 support is now official and out of beta!
for /f "tokens=3" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE ^| find "PROCESSOR_ARCHITECTURE"') do (
    if /i "%%A"=="AMD64" (
        set "Arch=X64"
    ) else if /i "%%A"=="ARM64" (
        echo You can only install ALOSToy on this machine.
        echo The final product will ONLY be bootable on an
        echo x64 machine.
        timeout /t 3 /NOBREAK >nul
        set "Arch=ARM64"
    ) else if /i "%%A"=="X86" (
        powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('X86 is not supported.','ALOSToy Installer','OK','Info') | Out-Null"
        endlocal
        rem 86 is a good exit code because it represents x86.
        exit 86
    ) else if /i "%%A"=="ARM32" (
        powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('ARM32 is not supported.','ALOSToy Installer','OK','Info') | Out-Null"
        endlocal
        rem 32 is a good exit code because it represents ARM32.
        exit 32
    ) else (
        echo I am not sure...
        endlocal
        exit 20
    )
)
powershell -nop -nol -ExecutionPolicy Bypass -c "if ($env:Version -match '^1\.[0-9]\.[0-9]\.[0-9]$') { Exit 0 } else { Exit 1 }" || (
    echo Version number is not valid.
    echo You specified !Version!.
    echo.
    echo Press any key now and change the "Version" variable to a format like 1.X.X.X.
    pause >nul
    endlocal
    exit 19
)
if /i "!CmdEchoing!"=="on" (echo on) else if /i "!CmdEchoing!"=="off" (echo off) else (endlocal & exit 1)
rem Instead of digging this later and failing on invalid argument, place it before any logic.
set re1=
set re2=
for %%# in (%*) do (
    if /i "%%#"=="re1" set re1=1
    if /i "%%#"=="re2" set re2=1
    if /i "%%#"=="/qedit" (
        set re1=1
        set re2=1
    ) else if /i "%%#"=="-qedit" (
        set re1=1
        set re2=1
    ) else if "%%#"=="--qedit" (
        set re1=1
        set re2=1
    )
)
rem You might want to restart in an x64 process if an x86 process started ALOSToy-Installer.bat on Windows 11 or Windows 10 x64.
if exist !SystemRoot!\Sysnative\cmd.exe if not defined re1 (
    echo !DATE! !TIME! x86 process caught running !FullScript!. Restarting in the x64 process...>> "!logfile!"
    start !SystemRoot!\Sysnative\cmd.exe /c ""!FullScript!" %* re1"
    cls
    exit 16
)
rem You might want to restart in an ARM32 process if it was initiated by x64 process on ARM64 Windows 10 or Windows 11 on ARM.
if exist !SystemRoot!\SysArm32\cmd.exe if "!PROCESSOR_ARCHITECTURE!"=="AMD64" if not defined re2 (
    echo !DATE! !TIME! x64 process caught running !FullScript!. Restarting in the ARM32 process...>> "!logfile!"
    start !SystemRoot!\SysArm32\cmd.exe /c ""!FullScript!" %* re2"
    cls
    exit 16
)
call :InstallerTitle
rem Disable Quick Edit only if neccesary.
if "!QuickEdit!"=="On" goto DisableQuickEdit
rem Ping websites.
cd /d "!Root!"
if "!Vtoy_DL_Mode!"=="0" (
    ping 1.1.1.1 -w 1000 >> "!logfile!" 2>&1
    if errorlevel 1 (echo Unfortunately, CloudFlare DNS is blocked.) else (echo !CmdEchoing!)
    ping 8.8.8.8 -w 1000 >> "!logfile!" 2>&1
    if errorlevel 1 (echo Unfortunately, Google Public DNS is blocked.) else (echo !CmdEchoing!)
    rem DNS access is not always required. If it is blocked, your connection may not be as secure.
)
curl.exe -o NUL https://github.com >> "!logfile!" 2>&1
if errorlevel 1 set "GithubBlocked=True"
if "!Vtoy_DL_Mode!"=="0" (
    curl.exe -o NUL https://archive.org >> "!logfile!" 2>&1
    if errorlevel 1 (set "InternetArchiveBlocked=True") else (echo !CmdEchoing!)
    if "!InternetArchiveBlocked!"=="False" if "!GithubBlocked!"=="False" (
        echo !CmdEchoing!
    ) else (
        curl.exe -o NUL https://google.com >> "!logfile!" 2>&1
        if errorlevel 1 (echo No internet or intranet found. Check connection or change to different network. Tip: You may be connected but behind a firewall. & echo !DATE! !TIME! A corporate firewall was found.>> "!logfile!") else (echo You have an internet connection but you are probably on a company or school network. Change to a network that does not filter or block any required sites.)
        echo Sadly. The 2 required sites needed to install ALOSToy are not accessible.
        echo Exiting...
        timeout /t 3 /NOBREAK >nul
        endlocal
        exit 1
    )
)
rem Define UAC key.
set "Target=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
echo !DATE! !TIME! Checking UAC status...>> "!logfile!"
for /f "tokens=3" %%A in ('reg query "!Target!" /v EnableLUA 2^>nul') do set "UACStatus=%%A"
rem Enforce global UAC requirement.
if /i "!UACStatus!" neq "0x1" (
    cls
    echo !DATE! !TIME! UAC is off. !Script! cannot continue for safety.
    start /b powershell -nop -nol -WindowStyle Hidden -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('User Account Control appears to be off for the whole system. Please turn it back on.','ALOSToy Installer','OK','Error') | Out-Null"
    rem Turn UAC back on for the user if off in interest of safety.
    reg add "!Target!" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
    endlocal
    exit 25
)
rem If we pass, check for the use of the built-in Administrator account.
powershell -nop -nol -c "if ([System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value -match '-500$') { Exit 0 } else { Exit 1 }"
rem If yes, run the extra check for Admin Approval Mode for the built in admin.
if !errorlevel! equ 0 (
    set "Administrator_UACStatus="
    rem Check if the built-in Administrator account has
    rem it's token limited to standard administrators.
    for /f "tokens=3" %%A in ('reg query "!Target!" /v FilterAdministratorToken 2^>nul') do set "Administrator_UACStatus=%%A"
    rem Enforce Administrator account UAC requirement.
    if /i "!Administrator_UACStatus!" neq "0x1" (
        cls
        echo !DATE! !TIME! Administrator token not filtered. !Script! cannot continue for safety.>> "!logfile!"
        start /b powershell -nop -nol -WindowStyle Hidden -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('The Administrator account appears to have its UAC off. This is the default setting. Please filter the administrator token.','ALOSToy Installer','OK','Error') | Out-Null"
        rem Turn UAC on for the administrator account in interest of safety.
        reg add "!Target!" /v FilterAdministratorToken /t REG_DWORD /d 1 /f >nul 2>&1
        endlocal
        exit 24
    )
)
rem All good. We can continue starting up.
set "Administrator_UACStatus="
set "CurrentSID="
set "UACStatus="
set "Target="
goto CLI_Arguments
:CLI_Arguments
rem ALL ARGUMENTS ARE CASE-INSENSITIVE.
rem GNU --long-options ARE CASE-SENSITIVE.
call :WindowTitle "PARSING ARGUMENTS..."
if "%~1"=="" goto StepTwo
set "ArgName=%~1"
set "ArgPrefix="
rem It is important to normalise the arguments so that we can compare them in PowerShell.
if "!ArgName:~0,2!"=="--" (
    set "ArgPrefix=--"
    set "ArgName=!ArgName:~2!"
    set "CaseSensitive=1"
) else if "!ArgName:~0,1!"=="/" (
    set "ArgPrefix=/"
    set "ArgName=!ArgName:~1!"
) else if "!ArgName:~0,1!"=="-" (
    set "ArgPrefix=-"
    set "ArgName=!ArgName:~1!"
)
if defined ArgPrefix (
    if not defined PfxStyle (
        set "PfxStyle=!ArgPrefix!"
    ) else if "!ArgPrefix!" neq "!PfxStyle!" (
        cls
        echo I am sorry. You mixed prefixes. This is not compatible with your current session.
        echo For this command-line "!PfxStyle!" must be used.
        echo Remember. You pick between /, - or -- and only use that.
        endlocal
        exit 5
    )
)
set "ArgKind="
rem Parse arguments cleanly in PowerShell. It works for me and is more efficient but is like 1 second slower on my system than in pure cmd.
rem It makes sense because batch cannot do or, and, is, like, in or match checks.
rem Using variable case-sensitivity for arguments.
rem A much better argparser. Love it.
for /f "delims=" %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "function Match([string]$Left, [string]$Right) { if ($env:CaseSensitive -match '^(1|true|yes|on)$') { return $Left -ceq $Right } else { return $Left -ieq $Right } }; if ((Match $env:ArgName '?') -or (Match $env:ArgName 'Help') -or (Match $env:ArgName 'H')) { Write-Output 'Help' } elseif ((Match $env:ArgName 'NoBanner') -or (Match $env:ArgName 'No-Banner')) { Write-Output 'NoBanner' } elseif ((Match $env:ArgName 'ForceBanner') -or (Match $env:ArgName 'Force-Banner')) { Write-Output 'ForceBanner' } elseif ((Match $env:ArgName 'LogFile') -or (Match $env:ArgName 'Log-File')) { Write-Output 'LogFile' } elseif (Match $env:ArgName 'Product') { Write-Output 'Product' } elseif ((Match $env:ArgName 'VentoyVersion') -or (Match $env:ArgName 'Ventoy-Version')) { Write-Output 'VentoyVersion' } elseif ((Match $env:ArgName 'DownloadVentoyVersion') -or (Match $env:ArgName 'Download-Ventoy-Version')) { Write-Output 'DownloadVentoyVersion' } elseif ((Match $env:ArgName 're1') -or (Match $env:ArgName 're2') -or (Match $env:ArgName 'qedit')) { Write-Output 'Arch_Relaunch' } elseif ((Match $env:ArgName 'NoUpdate') -or (Match $env:ArgName 'No-Update')) { Write-Output 'Do_Not_Update' } elseif ((Match $env:ArgName 'ForceUpdate') -or (Match $env:ArgName 'Force-Update')) { Write-Output 'Always_Update' } elseif (Match $env:ArgName 'Updated') { Write-Output 'Successful_Update' } elseif ((Match $env:ArgName 'AutoUpdate') -or (Match $env:ArgName 'Auto-Update')) { Write-Output 'Auto_Update_Prg' } elseif ((Match $env:ArgName 'HideGPLNotice') -or (Match $env:ArgName 'Hide-GPL-Notice')) { Write-Output 'Inhibit_GPL_Notice' } elseif (Match $env:ArgName 'I_QEOff') { Write-Output 'I_QEOff' } else { Write-Output 'Other' }"') do set "ArgKind=%%A"
rem Help arguments. Open the Command-Line Help Guide...
if /i "!ArgKind!"=="Help" (
    call :WindowTitle "Starting Help Guide..."
    echo Launching Help Guide...
    powershell -nop -nol -c "$data = curl https://api.github.com/repos/ventoy/ventoy/git/refs/tag -UseBasicParsing | ConvertFrom-Json; $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './ventoyversion.txt'" >nul 2>&1
    set /p EgVer= <./ventoyversion.txt
    set "EgVer=!EgVer:~-6!"
    del ventoyversion.txt /f /q >nul
    if "%~2"=="" goto Help
    set "HelpArg=%~2"
    set "HelpPrefix="
    set "TargetLabel=Help"
    set "SwitchArg=%~2"
    set "PageArg=%~3"
    set "StartPage="
    if "!HelpArg:~0,2!"=="--" (
        set "HelpPrefix=--"
        set "HelpArg=!HelpArg:~2!"
    ) else if "!HelpArg:~0,1!"=="/" (
        set "HelpPrefix=/"
        set "HelpArg=!HelpArg:~1!"
    ) else if "!HelpArg:~0,1!"=="-" (
        set "HelpPrefix=-"
        set "HelpArg=!HelpArg:~1!"
    )
    rem We should also validate prefixes on help arguments too.
    if defined HelpPrefix (
        if not defined PfxStyle (
            set "PfxStyle=!HelpPrefix!"
        ) else if "!HelpPrefix!" neq "!PfxStyle!" (
            cls
            echo I am sorry. You mixed prefixes. This is not compatible with your current session.
            echo For this command-line "!PfxStyle!" must be used.
            echo Remember. You pick between /, - or -- and only use that.
            endlocal
            exit 5
        )
    )
    if /i "!HelpArg!"=="InstallGuide" (
        rem Main routine to jump to the install guide.
        rem If you use / or - for your prefix.
        set "TargetLabel=InstallGuide"
        set "SwitchArg=%~3"
        set "PageArg=%~4"
    ) else if "!HelpArg!"=="Install-Guide" (
        rem Alternate routine to jump to the install guide.
        rem If you use -- for your prefix.
        set "TargetLabel=InstallGuide"
        set "SwitchArg=%~3"
        set "PageArg=%~4"
    )
    if "!SwitchArg!"=="" goto !TargetLabel!
    set "SwitchPrefix="
    if "!SwitchArg:~0,2!"=="--" (
        set "SwitchPrefix=--"
        set "SwitchArg=!SwitchArg:~2!"
    ) else if "!SwitchArg:~0,1!"=="/" (
        set "SwitchPrefix=/"
        set "SwitchArg=!SwitchArg:~1!"
    ) else if "!SwitchArg:~0,1!"=="-" (
        set "SwitchPrefix=-"
        set "SwitchArg=!SwitchArg:~1!"
    )
    rem We should also validate prefixes on help arguments too.
    if defined SwitchPrefix (
        if not defined PfxStyle (
            set "PfxStyle=!SwitchPrefix!"
        ) else if "!SwitchPrefix!" neq "!PfxStyle!" (
            cls
            echo I am sorry. You mixed prefixes. This is not compatible with your current session.
            echo For this command-line "!PfxStyle!" must be used.
            echo Remember. You pick between /, - or -- and only use that.
            endlocal
            exit 5
        )
    )
    if not defined PfxStyle (
        if /i "!SwitchArg!"=="StartingHelpPage" (set "StartPage=!PageArg!")
        if "!SwitchArg!"=="Starting-Help-Page" (set "StartPage=!PageArg!")
    ) else if "!PfxStyle!"=="/" (
        if /i "!SwitchArg!"=="StartingHelpPage" set "StartPage=!PageArg!"
    ) else if "!PfxStyle!"=="-" (
        if /i "!SwitchArg!"=="StartingHelpPage" set "StartPage=!PageArg!"
    ) else if "!PfxStyle!"=="--" (
        if "!SwitchArg!"=="Starting-Help-Page" set "StartPage=!PageArg!"
    )
    if not defined StartPage goto !TargetLabel!
    if "!TargetLabel!"=="Help" (
        if !StartPage! leq !Pages! (
            goto Help
        ) else (
            call :WindowTitle "Invalid range."
            cls
            echo Not a valid page number.
            echo !StartPage! is outside the range of 1-!Pages!.
            pause
            endlocal
            exit 21
        )
    ) else if "!TargetLabel!"=="InstallGuide" (
        if !StartPage! leq !InstallGuidePages! (
            goto InstallGuide
        ) else (
            call :WindowTitle "Invalid range."
            cls
            echo Not a valid page number.
            echo !StartPage! is outside the range of 1-!InstallGuidePages!.
            pause
            endlocal
            exit 21
        )
    ) else (
        endlocal
        exit 1
    )
)
rem If you pass both "NoBanner" and "ForceBanner", "ForceBanner" takes precedence over "NoBanner".
rem Eg: ALOSTOY-INSTALLER.BAT /ForceBanner /NoBanner or ALOSTOY-INSTALLER.BAT -ForceBanner -NoBanner or ALOSTOY-INSTALLER.BAT --Force-Banner --No-Banner (and vice-versa).
rem When you pass both arguments, the ForceBanner argument will be used and NoBanner will not get used.
if /i "!ArgKind!"=="NoBanner" (
    set "ShowBanner=No"
    set "ArgumentsPassed=True"
    set "ArgumentIsSwitch=Yes"
    set "NeverShowBanner=Yes"
    shift
    goto CLI_Arguments
)
if /i "!ArgKind!"=="ForceBanner" (
    if "!ShowBanner!"=="No" set "ShowBanner=Yes"
    set "AlwaysShowBanner=Yes"
    set "ArgumentsPassed=True"
    set "ArgumentIsSwitch=Yes"
    shift
    goto CLI_Arguments
)
rem Product argument. Lets you define which product to install.
rem HOWEVER, IT DOES NOT PERFORM A FULLY AUTOMATED/SILENT SETUP.
rem IT DOES SKIP SOME STEPS LIKE THE EULA, THE ANTIMALWARE WARNING,
rem THE PRESS ANY KEY TO SHOW MENU, THE PRODUCT SELECTION AND IT'S
rem LICENSE AGREEMENT, DRIVE CONFIRMATION (YOU MUST PICK DRIVE MANUALLY),
rem VENTOY INSTALLATION (PASS < /- >VentoyInstallType / --Ventoy-Install-Type
rem ARGUMENT), FORMAT CONFIRMATION AND THE END CHOICES, SO THE PROGRAM EXITS.
rem ANY ERROR MAKES THE INSTALLER EXIT.
if /i "!ArgKind!"=="Product" (
    if "%~2"=="" (
        echo Missing value for Product.
        endlocal
        exit 7
    )
    set "product=%~2"
    call :ValidateEdition "!product!"
    if "!errorlevel!"=="0" (
        set "product=Standard"
        echo Successfully set product to ALOSToy Standard.
    ) else if "!errorlevel!"=="1" (
        set "product=Extended"
        echo Successfully set product to ALOSToy Extended.
    ) else if "!errorlevel!"=="2" (
        set "InstallExtensions=True"
        set "product=Standard+Extensions"
        echo Successfully set product to ALOSToy Standard With Extensions.
    ) else if "!errorlevel!"=="3" (
        echo Invalid product: !product!.
        endlocal
        exit 3
    ) else (
        endlocal
        exit 4
    )
    if "%~3" neq "" (
        set "SubSwitchArg=%~3"
        set "SubSwitchPrefix="
        set "SubSwitchIsVtoySwitch="
        if "!SubSwitchArg:~0,2!"=="--" (
            set "SubSwitchPrefix=--"
            set "SubSwitchArg=!SubSwitchArg:~2!"
        ) else if "!SubSwitchArg:~0,1!"=="/" (
            set "SubSwitchPrefix=/"
            set "SubSwitchArg=!SubSwitchArg:~1!"
        ) else if "!SubSwitchArg:~0,1!"=="-" (
            set "SubSwitchPrefix=-"
            set "SubSwitchArg=!SubSwitchArg:~1!"
        )
        if defined SubSwitchPrefix (if /i "!SubSwitchPrefix!"=="--" (if "!SubSwitchArg!"=="Ventoy-Install-Type" set "SubSwitchIsVtoySwitch=1") else (if /i "!SubSwitchArg!"=="VentoyInstallType" set "SubSwitchIsVtoySwitch=1"))
        if not defined SubSwitchIsVtoySwitch (
            echo This optional switch does not exist: %~3
            endlocal
            exit 6
        )
        if defined SubSwitchPrefix (
            if not defined PfxStyle (
                set "PfxStyle=!SubSwitchPrefix!"
            ) else if "!SubSwitchPrefix!" neq "!PfxStyle!" (
                cls
                echo I am sorry. You mixed prefixes. This is not compatible with your current session.
                echo For this command-line "!PfxStyle!" must be used.
                echo Remember. You pick between /, - or -- and only use that.
                endlocal
                exit 5
            )
        )
        if "%~4"=="" (
            echo You provided a null value for Ventoy Install Type^^!
            endlocal
            exit 7
        )
        if /i "%~4"=="Install" (
            set "Vtoy_Install_Type=Install"
            echo Successfully set the install type to "Install".
        ) else if /i "%~4"=="Update" (
            set "Vtoy_Install_Type=Update"
            echo Successfully set the install type to "Update".
        ) else (
            echo Not a valid value for Ventoy Install Type. ^(%~4^)
            endlocal
            exit 7
        )
        set "ProductDefinedWithArg=True"
        set "ArgumentsPassed=True"
        set "AcceptEULA=1"
        set "AcceptAVWarn=1"
        shift
        shift
        shift
        shift
        goto CLI_Arguments
    )
    set "ProductDefinedWithArg=True"
    set "AcceptEULA=1"
    set "AcceptAVWarn=1"
    shift
    shift
    goto CLI_Arguments
)
rem Ventoy Version argument. Decide what version of Ventoy you want to download and install.
if /i "!ArgKind!"=="VentoyVersion" (
    if "%~2"=="" (
        echo Missing value for VentoyVersion.
        endlocal
        exit 7
    )
    set "Selected_Venver=%~2"
    rem Validate the format and block depreciated Ventoy versions.
    for /f "delims=" %%V in ('powershell -nop -nol -c "if ($env:Selected_Venver -match '^1\.\d\.\d{2}$' -and -not ($env:Selected_Venver -in @('1.1.13','1.1.03','1.0.92','1.0.83','1.0.68','1.0.60','1.0.59'))) { Write-Output 'Valid' } else { Write-Output 'Invalid' }"') do (
        if /i "%%V"=="Invalid" (
            for %%N in (1.1.13 1.1.03 1.0.92 1.0.83 1.0.68 1.0.60 1.0.59) do (
                if "%%N"=="!Selected_Venver!" (
                    echo I see you tried to download a deprecated Ventoy Version.
                    echo Try something else.
                    pause
                    endlocal
                    exit 9
                )
            )
            echo Invalid format for Ventoy version.
            echo The syntax is 1.X.XX. ^(Must be a number, not a string.^)
            pause
            endlocal
            exit 9
        ) else if "%%V"=="Valid" (
            echo Successfully set Ventoy version to !Selected_Venver!.
            set "ArgumentsPassed=True"
            timeout /t 1 /NOBREAK >nul
            shift
            shift
            goto CLI_Arguments
        ) else (
            echo I am not sure...
            endlocal
            exit 9
        )
    )
)
rem Ventoy Download Mode. Enable Ventoy Download Mode, decide where to download Ventoy and exit.
if /i "!ArgKind!"=="DownloadVentoyVersion" (
    if not defined ArgPrefix (
        echo Oh no. You did not realise that prefix consistency extends to argument:
        echo !ArgKind!.
        echo You need to use the same consistency as the rest of the command-line.
        endlocal
        exit 5
    )
    if defined PfxStyle if "!ArgPrefix!" neq "!PfxStyle!" (
        cls
        echo I am sorry. You mixed prefixes. This is not compatible with your current session.
        echo For this command-line "!PfxStyle!" must be used.
        echo Remember. You pick between /, - or -- and only use that.
        endlocal
        exit 5
    ) else (
        set "PfxStyle=!ArgPrefix!"
    )
    if "%~2"=="" (
        echo Missing value for DownloadVentoyVersion.
        endlocal
        exit 7
    )
    set "Selected_Venver=%~2"
    set "SaveArg=%~3"
    if /i "!PfxStyle!"=="/" (
        if /i "%~3"=="/SaveLocation" (set "SaveArg=SaveLocation") else set "SaveArg=Other"
    ) else if /i "!PfxStyle!"=="-" (
        if /i "%~3"=="-SaveLocation" (set "SaveArg=SaveLocation") else set "SaveArg=Other"
    ) else if /i "!PfxStyle!"=="--" (
        if "%~3"=="--Save-Location" (set "SaveArg=SaveLocation") else set "SaveArg=Other"
    )
    if /i "!SaveArg!"=="SaveLocation" (
        if "%~4"=="" (
            echo Missing value for SaveLocation.
            echo Either put in a valid location or "Prompt" in. ^(Note: It is case-insensitive.^)
            endlocal
            exit 7
        ) else if /i "%~4"=="re1" (
            echo re1 is not a valid value for SaveLocation.
            echo Either put in a valid location or "Prompt" in. ^(Note: It is case-insensitive.^)
            timeout /t 10 /NOBREAK >nul
            endlocal
            exit 7
        ) else if /i "%~4"=="re2" (
            echo re2 is not a valid value for SaveLocation.
            echo Either put in a valid location or "Prompt" in. ^(Note: It is case-insensitive.^)
            timeout /t 10 /NOBREAK >nul
            endlocal
            exit 7
        ) else (
            set "save=%~4"
            if /i "!save!" neq "!save: =!" (
                echo Use "Prompt" to set a location that contains spaces.
                pause
                endlocal
                exit 7
            )
            echo Successfully set save location to !save!.
            shift
            shift
            shift
            shift
        )
    ) else (
        echo Missing parameter: SaveLocation.
        endlocal
        exit 6
    )
    set "Vtoy_DL_Mode=1"
    rem Validate the format and block depreciated Ventoy versions.
    for /f "delims=" %%V in ('powershell -nop -nol -c "if ($env:Selected_Venver -match '^1\.\d\.\d{2}$' -and -not ($env:Selected_Venver -in @('1.1.13','1.1.03','1.0.92','1.0.83','1.0.68','1.0.60','1.0.59'))) { Write-Output 'Valid' } else { if ($env:Selected_Venver -ieq 'Latest') { Write-Output 'Valid' } else { Write-Output 'Invalid' } }"') do (
        if /i "%%V"=="Invalid" (
            for %%N in (1.1.13 1.1.03 1.0.92 1.0.83 1.0.68 1.0.60 1.0.59) do (
                if "%%N"=="!Selected_Venver!" (
                    echo I see you tried to download a deprecated Ventoy Version.
                    echo Try something else.
                    pause
                    endlocal
                    exit 9
                )
            )
            echo Invalid format for Ventoy version.
            echo The syntax is 1.X.XX. ^(Must be a number, not a string.^)
            pause
            endlocal
            exit 9
        ) else if "%%V"=="Valid" (
            set "Updated=1"
            echo Successfully set Ventoy version to !Selected_Venver!.
            timeout /t 1 /NOBREAK >nul
            goto CLI_Arguments
        ) else (
            echo I am not sure...
            endlocal
            exit 9
        )
    )
)
rem Architecture relaunch. Do not document or use. Only to be executed from:
rem x86 process on Windows 11 or Windows 10 x64. (Restart in x64.)
rem x64 process on Windows 11 on ARM or Windows 10 ARM64. (Restart in ARM32.)
if /i "!ArgKind!"=="Arch_Relaunch" (
    if /i "!ArgName!"=="re1" (set re1=1 & shift)
    if /i "!ArgName!"=="re2" (set re2=1 & shift)
    if /i "!ArgName!"=="qedit" (
        set re1=1
        set re2=1
        shift
    )
    goto CLI_Arguments
)
rem Update control.
if /i "!ArgKind!"=="Do_Not_Update" (
    set "NoUpdate=1"
    set "ArgumentsPassed=True"
    shift
    goto CLI_Arguments
)
if /i "!ArgKind!"=="Always_Update" (
    set "ForceUpdate=1"
    set "ArgumentsPassed=True"
    shift
    goto CLI_Arguments
)
rem Update success relaunch. Do not document or use unless !Script! is updated.
if /i "!ArgKind!"=="Successful_Update" (
    set "Updated=1"
    set "ForceUpdate=0"
    set "NoUpdate=0"
    set "AutoUpdate=0"
    shift
    goto CLI_Arguments
)
rem Auto update program
if /i "!ArgKind!"=="Auto_Update_Prg" (
    set "AutoUpdate=1"
    set "ArgumentsPassed=True"
    shift
    goto CLI_Arguments
)
rem Quick Edit disable. Do not document or use unless !Script! disables quick edit.
if /i "!ArgKind!"=="I_QEOff" (
    set "QuickEdit=Off"
    shift
    goto CLI_Arguments
)
rem Hide GPL Notice. Do not document. Can be used.
if /i "!ArgKind!"=="Inhibit_GPL_Notice" (
    set "ArgumentsPassed=True"
    shift
    goto CLI_Arguments
)
:InvalidArgument
rem Handle invalid argument.
cls
call :WindowTitle "INVALID COMMAND LINE"
echo Command line is invalid:
echo Full command line: %*
echo Argument parsed: %1
echo Type one of these to get help:
echo.
echo    For Windows users, use these 3:
echo,
echo         !Script! /?
echo         !Script! /H
echo         !Script! /Help
echo.
echo    For UNIX/PowerShell users, use these 3:
echo.
echo         !Script! -?
echo         !Script! -H
echo         !Script! -Help
echo.
echo    For GNU users, use these 3:
echo.
echo         !Script! --?
echo         !Script! --H
echo         !Script! --Help
echo.
echo Keep in mind it is case-insensitive by default but case-sensitive for --long-options. Also, you can pass another argument for the help parameters:
echo    "/StartingHelpPage" if Windows user.
echo    "-StartingHelpPage" if UNIX/PowerShell user.
echo    "--Starting-Help-Page" if GNU user.
if "!re1!"=="1" (timeout /t 10 /NOBREAK >nul) else if "!re2!"=="1" (timeout /t 10 /NOBREAK >nul)
echo Please push any key now to see more...
pause >nul
cls
echo You can also read the installation guide as well.
echo Run either the following:
echo     !Script! /? /InstallGuide
echo     !Script! -? -InstallGuide
echo     !Script! --? --Install-Guide
echo   To launch the installation guide.
echo   For both guides, you can use either:
echo       /StartingHelpPage
echo       -StartingHelpPage
echo       --Starting-Help-Page
echo.
echo.
echo Note that for the command line help guide, you can specify from 1-!Pages!.
echo Also, for the installation guide, you can specify from 1-!InstallGuidePages!.
echo.
if !Pages! equ !InstallGuidePages! (
    echo Both the help guides are the same amount of pages so the range is the same.
    echo It does not really matter anyway but if the range changes, you will not see
    echo this notice.
) else (
    echo The ranges of both are different.
    echo Please adhere to those because it would be very important
    echo to not get an error.
)
endlocal
exit 6
rem This is what I mean by.
:ValidateEdition
rem Validate the product.
if /i "!product!"=="Standard" (exit /b 0) else if /i "!product!"=="Extended" (exit /b 1) else if /i "!product!"=="Standard+Extensions" (exit /b 2) else (exit /b 3)
goto :eof
:StepTwo
cls
call :WindowTitle "STARTING {Part 2}..."
if "!ForceUpdate!"=="1" if "!NoUpdate!"=="1" (
    echo I did mean to say you cannot put both update flags together.
    echo Quit now and relaunch with either one, not both.
    pause >nul
    exit 1
)
if "!NoUpdate!"=="1" if "!ForceUpdate!"=="1" (
    echo I did mean to say you cannot put both update flags together.
    echo Quit now and relaunch with either one, not both.
    pause >nul
    exit 1
)
cls
call :InstallerTitle
echo Working Directory: !CD!
if /i "!AlwaysShowBanner!"=="Yes" set "ShowBanner=Yes"
rem Show the Ventoy Download Mode message if selected.
if "!Vtoy_DL_Mode!"=="1" (echo Starting Ventoy Download Mode...)
rem Get windows build. (Eg: 26200)
for /f "tokens=2 delims=[]" %%G in ('ver') do for /f "tokens=2,3,4 delims=. " %%H in ("%%G") do set "winbuild=%%J"
rem Get full windows build. (Eg: 26200.8973)
for /f "tokens=2 delims=[]" %%G in ('ver') do for /f "tokens=3,4 delims=." %%H in ("%%G") do set "full_winbuild=%%H.%%I"
rem This program uses features needed in build >17763. Like PowerShell DISM module.
if !winbuild! lss 17763 (
    call :WindowTitle "UNSUPPORTED OS VERSION FOUND!!!"
    echo Unsupported OS version...
    echo Press any key to quit...
    pause >nul
    exit !winbuild!
)
rem Make Product and ForceUpdate/AutoUpdate mutually exclusive.
rem Either one or the other, not both.
if "!ProductDefinedWithArg!"=="True" (
    if "!ForceUpdate!"=="1" (
        cls
        echo !Author! is telling you that the ForceUpdate
        echo parameter is not compatible with !ArgPrefix!Product.
        echo Remove the !ArgPrefix!Product argument to use the
        echo ForceUpdate parameter.
        pause
        endlocal
        exit 26
    )
    if "!AutoUpdate!"=="1" (
        cls
        echo !Author! is telling you that the AutoUpdate
        echo parameter is not compatible with !ArgPrefix!Product.
        echo Remove the !ArgPrefix!Product argument to use the
        echo AutoUpdate parameter.
        pause
        endlocal
        exit 26
    )
)
if "!Vtoy_DL_Mode!"=="0" (if "!Updated!"=="0" (goto Updater) else if "!Updated!"=="1" (goto Continue) else (endlocal & exit 13)) else (goto Continue)
:Updater
rem Update bootstrapper for ALOSToy Installer.
powershell -nop -nol -c "$data = curl https://api.github.com/repos/AaravLegend-OS/alostoy-installer/git/refs/tag -UseBasicParsing | ConvertFrom-Json; if ($?) { $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './ALOSToy-Installer_Version.txt'; Exit 0 } else { Exit 1 }" >nul 2>&1
if !errorlevel! equ 0 (
    rem Only proceed to update requirement checking if this succeeds.
    set /p Newest= <./ALOSToy-Installer_Version.txt
    del ALOSToy-Installer_Version.txt /f /q
    if "!ForceUpdate!"=="1" set "RequiresUpdate=True"
    if "!Version!" neq "!Newest!" set "RequiresUpdate=True"
    if "!Updated!"=="1" set "RequiresUpdate=False"
    if "!NoUpdate!"=="1" set "RequiresUpdate=False"
    if /i "!RequiresUpdate!"=="True" (
        cd /d "!Root!"
        rem If AutoUpdate is set to 1, automatically update without prompt.
        if "!AutoUpdate!"=="1" goto ApplyUpdate
        rem Else if the "Product" argument is passed, automatically update without prompt.
        if "!ProductDefinedWithArg!"=="True" goto ApplyUpdate
        rem Else if the "ForceUpdate" argument is passed, automatically update without prompt.
        if "!ForceUpdate!"=="1" goto ApplyUpdate
        rem Else, prompt the user.
        for /f "delims= " %%# in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"A new version of the installer has been found.!NewLine!!NewLine!Current version: ${env:Version}!NewLine!Newest version: ${env:Newest}!NewLine!!NewLine!Do you want to update now or not?\",'ALOSToy Installer','YesNoCancel','Question')"') do (
            if "%%#"=="Yes" (
                 rem If the user says yes, begin the update process.
                 goto ApplyUpdate
            ) else if "%%#"=="No" (
                set "Updated=1"
                goto Continue
            ) else if "%%#"=="Cancel" (
                endlocal
                exit 18
            )
        )
    ) else (
        if "!NoUpdate!"=="1" (
            echo Updates disabled for current session.
            echo !DATE! !TIME! User passed the "NoUpdate" parameter. Skipping updates...>> "!logfile!"
        )
        goto Continue
    )
) else (
    rem Handle update check errors.
    echo Unable to check for updates. We will continue to
    echo use version !Version!. Sorry for the inconvenience.
    rem Then continue like nothing happened.
    goto Continue
)
:Continue
rem Set the optimal font. Users will be happy.
call :PowerShell_Helper "SetFont"
if "!errorlevel!"=="1" echo Unable to set optimal font, experience may not be great.
set "D="
set "T="
where curl >nul 2>&1
if "!errorlevel!"=="1" (
    echo You must install curl. It should be installed in !SystemRoot!\System32 as cUrl.exe.
    pause >nul
    start https://curl.se
    endlocal
    exit 1
) else if "!errorlevel!"=="2" (
    echo Error occurred with running where curl.
    pause >nul
    endlocal
    exit 2
) else (
    echo !DATE! !TIME! Curl has been found.>> "!logfile!"
)
rem Check their region. If the computer region is set to United Kingdom, run an extra check.
for /f "usebackq delims=" %%R in (`powershell -nop -nol -ExecutionPolicy Bypass -c "$ErrorActionPreference = 'Stop'; try { if ((Get-WinHomeLocation).GeoId -eq 242) { Write-Output 'UK' } else { Write-Output 'NOT_UK' } } catch { Write-Output 'FAIL' }"`) do set "REGION=%%R"
rem Do the logic.
if /i "!REGION!"=="UK" (
    echo !DATE! !TIME! UK user.>> "!logfile!"
    goto RD_DateCheck
) else if "!REGION!"=="FAIL" (
    echo Cannot determine region.
    exit 12
) else (
    echo !DATE! !TIME! Normal user.>> "!logfile!"
    goto EULA
)
:RD_DateCheck
rem [EXTRA CHECK] Get their date. Split it into YYYY MM DD HH MIN SS.
for /f "usebackq delims=" %%I in (`powershell -nop -nol -c "Get-Date -Format 'yyyy MM dd HH mm ss'"`) do (
    for /f "tokens=1-6" %%A in ("%%I") do (
        set "YYYY=%%A"
        set "MM=%%B"
        set "DD=%%C"
        set "HH=%%D"
        set "MIN=%%E"
        set "SS=%%F"
    )
)
rem Two if checks.
if "!MM!" neq "11" goto EULA
if "!DD!" neq "11" goto EULA
rem This region only runs on Veterans/Remembrance Day. (11th November)
rem Calculate the time.
set /a H = 1!HH! - 100
set /a M = 1!MIN! - 100
set /a TOTAL_MIN = H * 60 + M
rem 10:58AM
set /a START = 10 * 60 + 58
rem 11:02AM
set /a END = 11 * 60 + 2
rem Final two checks. At some point, you need to be aware of history.
if !TOTAL_MIN! GEQ !START! if !TOTAL_MIN! LEQ !END! (
    rem If that is the case, exit and remind the user to silence themself for 2 minutes.
    call :WindowTitle "PAY YOUR RESPECTS TO THE DEAD AND WOUNDED OF WWI"
    echo.
    echo ------------------------------------------------------------
    echo At the going down of the sun and in the morning,
    echo we will remember them.
    echo.
    echo We shall remember them.
    echo.
    echo Lest we forget.
    echo.
    echo Their name liveth for everyone.
    echo ------------------------------------------------------------
    echo.
    powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('You should be observing silence for all the people that died in World War One. Remember this: 22 million people died and 40 million were wounded. Read the message in the console and try again at 11:02am.','ALOSToy Installer','OK','Error') | Out-Null"
    endlocal
    exit 11
)
:EULA
rem Show the End-User License Agreement.
if "!AcceptEULA!"=="0" (
    set "agree="
    call :WindowTitle "End-User License Agreement"
    cls
    echo ====================================================
    echo              ALOSToy Installer v!Version!
    echo ====================================================
    echo Author: !Author!
    echo.
    echo END USER LICENSE AGREEMENT
    echo.
    echo By using this software, you agree to the following:
    rem Optimise the code by printing the unique terms
    rem instead of copying the whole EULA twice.
    if "!Vtoy_DL_Mode!"=="1" (
        echo - Ventoy is provided "as-is" with no warranty.
        echo - Ventoy Download Mode will grab a specific version for you.
        echo - You must not misuse the software or it's owner to deploy malware.
        echo - You must use Ventoy properly.
    ) else if "!Vtoy_DL_Mode!"=="0" (
        echo - This tool is provided "as-is" with no warranty.
        echo - You are responsible for any changes made to your system.
        echo - Redistribution or modification is allowed only with credit.
    ) else (
        endlocal
        exit 3
    )
    echo - Under GPLv3, you are required to provide source code if modified,
    echo - license under the GPLv3 license and pass freedoms to others.
    if "!Or-Any-Later-Version!"=="False" (
        echo - You are not permitted to distribute this under any other license
        echo - other than the GNU General Public License v3.0. Combination with
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo - You are permitted to distribute this under any later version of
        echo - the GNU General Public License v3 or just GPLv3. Combination with
    )
    echo - GNU General Public License v1 or v2 code is legally prohibited.
    echo - The author is not liable for any damage or data loss.
    echo - !Author! does not condone any damage whatsoever.
    echo - USE AT YOUR OWN RISK.
    echo.
    echo You must agree to use this software by law. If you do not agree, you may not continue to use this software.
    echo.
    set /p "agree=[CASE-SENSITIVE] Do you agree to the End User License Agreement? (Yes or No) >> "
    if "!agree!"=="Yes" (
        cls
        echo !DATE! !TIME! The End-User License Agreement has been agreed to.>> "!logfile!"
        if "!Vtoy_DL_Mode!"=="1" start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('You can combine code with other GPLv3 programs but if you do with GPLv2 or any later version programs, you must upgrade the modified code to GPLv3.','ALOSToy Installer','OK','Info') | Out-Null"
        if "!Vtoy_DL_Mode!"=="0" (if "!AcceptAVWarn!"=="0" (goto AVWarn) else if "!AcceptAVWarn!"=="1" (goto DLBin) else (endlocal & exit 1)) else if "!Vtoy_DL_Mode!"=="1" (goto DLBin) else (endlocal & exit 1)
    ) else if "!agree!"=="No" (
        cls
        echo !DATE! !TIME! The End-User License Agreement has been denied to.>> "!logfile!"
        powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Since you declined the EULA, this program will now exit.','ALOSToy Installer','OK','Error') | Out-Null"
        exit 3
    ) else (
        goto EULA
    )
)
echo !DATE! !TIME! Pre-accepted EULA.>> "!logfile!"
if "!Vtoy_DL_Mode!"=="0" (if "!AcceptAVWarn!"=="0" (goto AVWarn) else if "!AcceptAVWarn!"=="1" (goto DLBin) else (endlocal & exit 1)) else if "!Vtoy_DL_Mode!"=="1" (goto DLBin) else (endlocal & exit 1)
:AVWarn
call :WindowTitle "Will you trust this installer?"
for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('If your antivirus flags the installation files, disable it temporarily and re-enable it after installation. ALOSToy is free of malware and has been proven to stay clean. Do you trust this notice and installer?','ALOSToy Installer','YesNo','Warning')"') do (
    if "%%A"=="Yes" (
        echo !DATE! !TIME! Antimalware warning has been accepted.>> "!logfile!"
        goto DLBin
    ) else if "%%A"=="No" (
        call :WindowTitle "GO FIND SOMETHING ELSE OR COME BACK LATER IF YOU TRUST LATER"
        powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Then quit this program and go find something else. Eg: Easy2Boot (modern alternative) or Medicat USB (2021 alternative). However, if you trust this program later on, come back and run it.','ALOSToy Installer','OK','Error') | Out-Null"
        exit 14
    ) else (
        goto AVWarn
    )
)
:DLBin
cls
call :WindowTitle "Get binaries."
cd /d "!Root!"
set "present=0"
for %%A in (
    "!Root!\bin\aria2c_X64.exe"
    "!Root!\bin\aria2c_ARM64.exe"
    "!Root!\bin\batbox.exe"
    "!Root!\bin\Box.bat"
    "!Root!\bin\Button.bat"
    "!Root!\bin\folderbrowse.exe"
    "!Root!\bin\folderbrowse.exe.config"
    "!Root!\bin\GetInput.exe"
    "!Root!\bin\Getlen.bat"
    "!Root!\bin\QuickSFV.exe"
    "!Root!\bin\QuickSFV.ini"
    "!Root!\bin\7-Zip\X64\7z.dll"
    "!Root!\bin\7-Zip\X64\7z.exe"
    "!Root!\bin\7-Zip\ARM64\7z.dll"
    "!Root!\bin\7-Zip\ARM64\7z.exe"
    "!Root!\bin\hash_database\ALOSToy_v1.0_Extended.md5"
    "!Root!\bin\hash_database\ALOSToy_v1.0_Standard.md5"
    "!Root!\bin\hash_database\ALOSToy_v1.0_Standard_With_Extensions.md5"
) do if exist "%%~A" set /a "present+=1"
if !present! equ 18 (
    call :PowerShell_Helper "Hash_BinFiles" && (if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)) || (
        set "errorcode=Bin files do not match their hashes."
        set "RequiresExit=True"
        goto Error
    )
)
if exist "!Root!tools.esd" (
    call :Hashing "!Root!tools.esd" "!ToolsHash!" && (
        set "OK=0"
        call :WindowTitle "Missing binaries."
        echo !DATE! !TIME! Begin extracting binaries.>> "!logfile!"
        echo Extracting necessary files.
        if not exist "!Root!bin" md "!Root!bin" >nul 2>&1
        dism /apply-image /imagefile:"!Root!tools.esd" /index:1 /applydir:"!Root!\bin" /quiet /logfile:"!Root!\dism.log"
        del /f /q "!Root!tools.esd" >nul 2>&1
        call :PowerShell_Helper "Hash_BinFiles" && (if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)) || (
            set "errorcode=Bin files do not match their hashes."
            set "RequiresExit=True"
            goto Error
        )
    ) || (
        echo The hash does not match...
        choice /c yn /m "Do you want to retry? Sometimes, a download can fail and produce a different hash." /cs
        if "!errorlevel!"=="1" (
            if exist "!Root!tools.esd" del "!Root!tools.esd" /f /q >nul
            goto DLBin
        ) else if "!errorlevel!"=="2" (
            set "errorcode=Failed to download files."
            set "RequiresExit=True"
            goto Error
        )
    )
) else (
    call :WindowTitle "Missing binaries. Downloading..."
    echo Getting necessary files.
    echo !DATE! !TIME! Begin download of files.>> "!logfile!"
    curl "!Uri!" -o tools.esd -L >> "!logfile!" 2>&1 && (
        call :Hashing "!Root!tools.esd" "!ToolsHash!" && (
            set "OK=0"
            call :WindowTitle "Missing binaries."
            echo !DATE! !TIME! Begin extracting binaries.>> "!logfile!"
            echo Extracting necessary files.
            if not exist "!Root!bin" md "!Root!bin" >nul 2>&1
            dism /apply-image /imagefile:"!Root!tools.esd" /index:1 /applydir:"!Root!\bin" /quiet /logfile:"!Root!\dism.log"
            del /f /q "!Root!tools.esd" >nul 2>&1
            call :PowerShell_Helper "Hash_BinFiles" && (if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)) || (
                set "errorcode=Bin files do not match their hashes."
                set "RequiresExit=True"
                goto Error
            )
        ) || (
            echo The hash does not match...
            choice /c yn /m "Do you want to retry? Sometimes, a download can fail and produce a different hash." /cs
            if "!errorlevel!"=="1" (
                if exist "!Root!tools.esd" del "!Root!tools.esd" /f /q >nul
                goto DLBin
            ) else if "!errorlevel!"=="2" (
                set "errorcode=Failed to download files."
                set "RequiresExit=True"
                goto Error
            )
        )
        echo !DATE! !TIME! Begin extracting binaries.>> "!logfile!"
        echo Extracting necessary files.
        if not exist "!Root!bin" md "!Root!bin" >nul 2>&1
        dism /apply-image /imagefile:"!Root!tools.esd" /index:1 /applydir:"!Root!\bin" /quiet /logfile:"!Root!dism.log"
        del /f /q "!Root!tools.esd" >nul 2>&1
        call :PowerShell_Helper "Hash_BinFiles" && (if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)) || (
            set "errorcode=Bin files do not match their hashes."
            set "RequiresExit=True"
            goto Error
        )
    ) || (
        echo Fail
        timeout /t 3 /NOBREAK >nul
        choice /c yn /m "Do you want to try again?" /cs
        if "!errorlevel!"=="1" (
            if exist "!Root!tools.esd" del "!Root!tools.esd" /f /q >nul
            goto DLBin
        )
        if "!errorlevel!"=="2" (
            set "errorcode=Failed to download files."
            set "RequiresExit=True"
            goto Error
        )
    )
)
call :PowerShell_Helper "Hash_BinFiles" && (if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)) || (
    set "errorcode=Bin files do not match their hashes."
    set "RequiresExit=True"
    goto Error
)
:Hash_BinFiles
# A sub-wrapper to hash every single individual file using a hashtable of files and hashes.
# Example: @{"File.txt" = "0123456789ABCDEFFEDCBA98765432100123456789ABCDEFFEDCBA9876543210"}
<#
DISCLAIMER:
    The only file that cannot be SHA256 verified is QuickSFV.ini. That is
    because this configuration file can be changed by the user when QuickSFV
    runs. Every time you exit, the file gets modified to save the window size
    or other settings. Because of this, QuickSFV.ini is the only file that you
    can modify without the ALOSToy Installer throwing an error. You can resize
    the window at your own desire. Thank you. By Aarav Katariya, the author.
#>
Clear-Host
# Set our window title based on the header.
$Host.UI.RawUI.WindowTitle = "$env:BaseHeader <-----> HASHING FILES..."
Write-Host "Hashing Files..." -ForegroundColor Yellow
$Root = $env:Root
# Make a big hashtable.
[hashtable]$Hashes = @{
    "${Root}bin\aria2c_X64.exe" = "BE2099C214F63A3CB4954B09A0BECD6E2E34660B886D4C898D260FEBFE9D70C2"
    "${Root}bin\aria2c_ARM64.exe" = "33C775256F64123515F32A8252200EF2AB5AD72963981C694DFF5E61D650F6BE"
    "${Root}bin\batbox.exe" = "9553BC17FA0FD08E026C1865812B3388E3D5495A5394BBF671E5A8F21C79989A"
    "${Root}bin\Box.bat" = "F164716E7B1F98F68F6CE3239345C30B3410ED9812F30B37BB7630F28047EBD9"
    "${Root}bin\Button.bat" = "03A86F9FCDCCBAA499EA4435434A45178E367639D8FB755C5211F304C70744B5"
    "${Root}bin\folderbrowse.exe" = "348430F39C1CE0C0C1FFF7E7B80C796F533F85F2DE40EA00C97759C66FC2AA70"
    "${Root}bin\folderbrowse.exe.config" = "A122790E20A37DD3A16D42F4F089275558E94310BCB6DB11F71769B7C722AB39"
    "${Root}bin\GetInput.exe" = "3F5C64717A0092AE214154A730E96E2E56921BE2E3F1121A3E98B1BA84627665"
    "${Root}bin\Getlen.bat" = "83CE5342710A2F2E385A363402661E3426728DD6BCFE9D87E22F2FB858B07BDE"
    "${Root}bin\QuickSFV.exe" = "410D63C8CE116D613E775631C089DCDBB7893EF2120313289C29C381B7B0924E"
    "${Root}bin\7-Zip\X64\7z.dll" = "69FD4DF057985C40E510E2FAC182881C7F85E90AA13EC703F763A8FDB2CE61F8"
    "${Root}bin\7-Zip\X64\7z.exe" = "83967F1B02B43C4EFEDA302795722C809E0E81B8307DE73558D10484D5676A7D"
    "${Root}bin\7-Zip\ARM64\7z.dll" = "7346EAEA5F333B1D65B6B4EEDF6797C416BBC91C75E46159DF38AA28E153F7C5"
    "${Root}bin\7-Zip\ARM64\7z.exe" = "46009C25732880C9D49032EC20DA46DFDC669FB60257F50308A0026B4FAC3AEF"
    "${Root}bin\hash_database\ALOSToy_v1.0_Extended.md5" = "40205C4E65566EAD90619D2BEDF8EBFB84245E170B1B94A7F978949233FF43E7"
    "${Root}bin\hash_database\ALOSToy_v1.0_Standard.md5" = "1F8F64018D03FFB0BACA7ADB814E44E52E424C6686C36CA09FBCF3A29E78D6C0"
    "${Root}bin\hash_database\ALOSToy_v1.0_Standard_With_Extensions.md5" = "3BAC3FF2F85D262A104B1BF45CE0C76176804E383527C3233E5FAEDA5CAF7252"
}
# Run SHA256 checks.
foreach ($Entry in $Hashes.GetEnumerator()) {
    if (-not (Test-Path $Entry.Key -PathType Leaf)) {
        # Stop installation if there is a missing file.
        Write-Host "[ERROR] Missing: $($Entry.Key)." -ForegroundColor Red
        # Write to log.
        Write-Output "[ERROR] Missing: $($Entry.Key). $(Get-Date)" >> $env:logfile
        # Beep an error code. Grab their attention.
        [Console]::Beep(800, 500)
        [Console]::Beep(1000, 1000)
        [Console]::Beep(1200, 1500)
        Exit 1
    }
    # Calculate the SHA256 hash of every file.
    $Actual = (Get-FileHash $Entry.Key -Algorithm $env:Algorithm).Hash.ToUpper()
    if ($Actual -cne $Entry.Value) {
        # Stop installation if there is a tampered file.
        Write-Host "[ERROR] $($Entry.Key)'s hash does not match! We got: $($Entry.Value)." -ForegroundColor Red
        # Write to log.
        Write-Output "[ERROR] $($Entry.Key)'s hash does not match! We got: $($Entry.Value). $(Get-Date)" >> $env:logfile
        # Beep an error code. Grab their attention.
        [Console]::Beep(500, 1000)
        [Console]::Beep(750, 1250)
        [Console]::Beep(1000, 1500)
        Exit 1
    } else {
        # Exisiting, original file can continue. Then move onto the next file.
        Write-Host "[SUCCESS] $($Entry.Key) is valid." -ForegroundColor Green
        # Write to log.
        Write-Output "[SUCCESS] $($Entry.Key) is valid. $(Get-Date)" >> $env:logfile
    }
}
# If all files are existent and not tampered with, we can exit with code 0 and go into the main menu.
Exit 0
:Post_Hash_BinFiles
:Main
set "RedoInstall=No"
cls
echo !CmdEchoing!
mode con: cols=!Columns! lines=!Lines!
set "label="
set "drivepath="
set "Selected=False"
set "Page="
set "InstallGuidePage="
if "!ShowBanner!"=="Yes" if "!BannerShown!"=="False" (
    call :WindowTitle "WELCOME TO THE ALOSTOY INSTALLER."
    rem The batch file that is called shows a banner of the product. It can show the logo using a special ESC character
    rem for ANSI and can show the complement text in all colours. It will cycle through 16 colours specifically.
    call :Banner_Art /PreInstall
    set "BannerShown=True"
    cls
    if "!AlwaysShowBanner!"=="Yes" set "BannerShown=False"
)
if not defined database_std set "database_std=!Root!bin\hash_database\ALOSToy_v1.0_Standard.md5"
if not defined database_stdext set "database_stdext=!Root!bin\hash_database\ALOSToy_v1.0_Standard_With_Extensions.md5"
if not defined database_ext set "database_ext=!Root!bin\hash_database\ALOSToy_v1.0_Extended.md5"
if "!ProductDefinedWithArg!"=="True" (
    if /i "!product!"=="Standard" goto Standard_Briefing
    if /i "!product!"=="Extended" goto Extended_Briefing
    if /i "!product!"=="Standard+Extensions"  (
        set "InstallExtensions=True"
        goto Standard_Briefing
    )
)
set "product="
if exist "!Root!bin\ventoyversion.txt" del "!Root!bin\ventoyversion.txt" /f /q >nul
if "!ResetVars!"=="1" (
    rem Reset the variables that were modified. This will return
    rem the installer into a clean state before any installation
    rem of ALOSToy Standard or Extended had occurred.
    set "product="
    set "label="
    set "drivepath="
    set "drive="
    set "firstarg="
    set "secondarg="
    set "thirdarg=/FS:NTFS"
    set "NoFormat=0"
    set "confirm="
    set "Msg="
    set "wins=0"
    set "stdext_wins=0"
    set "OK=0"
    set "files=0"
    set "good=0"
    set "Located=0"
    set "dir="
    set "block="
    set "Part="
    set "Parts="
    set "stdext_parts="
    set "Archive_Part="
    set "Required="
    set "File="
    set "CorrectHash="
    set "PreserveBad=0"
    set "Hash="
    set "save="
    set "VENVER="
    set "vencurver="
    set "localver="
    set "Expected_Ventoy_Hash="
    set "Actual_Ventoy_Hash="
    set "WinInstall="
    set "size="
    set "Edition="
    set "errorcode="
    set "WarnAccepted=0"
    set "ConfigChanged=False"
    set "NoticeAgreed=False"
    set "MessageSuccess="
    set "MessageFailure="
    set "FormatAccepted=0"
    set "ResetVars=0"
    cls
)
call :WindowTitle "PLEASE WAIT FOR THE BUTTONS TO INITIALISE"
call :PowerShell_Helper "Installer-Choices" || exit 1
call Button 1 3 F2 "Install ALOSToy Standard" 30 3 F2 "Install ALOSToy Extended" 59 3 F5 "Install Extensions + ALOSToy Standard (Currently !InstallExtensions!)" 2 7 F3 "Verify Your Installation" 74 7 F4 "Quit Program" 31 7 F6 "Delete Leftover Verification Databases" 91 7 F1 "Look Into The Installer"  X _Var_Box _Var_Hover
echo.
echo.
echo.
call :PowerShell_Helper "Size-Requirements" || exit 1
call :PowerShell_Helper "ALOSToy-Info" || exit 1
call :WindowTitle "MAKE A CHOICE."
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (
    goto Standard_Briefing
) else if "!errorlevel!"=="2" (
    goto Extended_Briefing
) else if "!errorlevel!"=="3" (
    if "!InstallExtensions!"=="False" (
        set "InstallExtensions=True"
        goto Main
    ) else (
        set "InstallExtensions=False"
        goto Main
    )
) else if "!errorlevel!"=="4" (
    cls
    goto Verify_Files
) else if "!errorlevel!"=="5" (
    cls
    echo Quitting...
    endlocal
    timeout /t 1 /NOBREAK >nul
    exit 0
) else if "!errorlevel!"=="6" (
    cls
    goto Del_Verification_DBs
) else if "!errorlevel!"=="7" (
    cls
    call :WindowTitle "SEEING INSIDE..."
    echo This is your time to look into the installer. !Script! will open in notepad and you can read or edit this installer.
    echo If you find flaws, report them to me please on Github via the issues.
    start /max /wait notepad.exe "!Root!!Script!"
    echo.
    echo Finished looking inside. Returning to main menu...
    timeout /t 1 /NOBREAK >nul
    goto Main
) else if "!errorlevel!"=="18" (
    call :WindowTitle "RELAUNCHING"
    cls
    echo Restarting...
    powershell -nop -nol -c "Start-Process -FilePath conhost.exe -Verb RunAs -ArgumentList 'cmd.exe /c cd /d "!Root!\" & call "!Script!" %*'" >nul 2>&1 && (
        endlocal
        exit 0
    ) || (
        call :WindowTitle "NEVERMIND"
        pause
        goto Main
    )
) else if "!errorlevel!"=="68" (
    cls
    call :WindowTitle "INITIATE REDOWNLOAD?"
    for /f "delims=" %%# in ('powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"Do you want to redownload the files in:!NewLine!!NewLine!!Root!bin?\",'ALOSToy Installer','YesNo','Question')"') do (
        if "%%#"=="Yes" (
            echo Removing bin files...
            rd "!Root!bin" /s /q
            echo Done.
            for /f "delims=" %%Z in ('powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Do you want to restart the ALOSToy welcome banner as well?','ALOSToy Installer','YesNo','Question')"') do (if "%%Z"=="Yes" set "BannerShown=False")
            goto DLBin
        ) else if "%%#"=="No" (
            goto Main
        )
    )
) else if "!errorlevel!"=="71" (
    cls
    echo Opening the github repository...
    start !InstallerRepo!
    goto Main
) else if "!errorlevel!"=="72" (
    set "HelpFromMain=1"
    goto Help
) else if "!errorlevel!"=="73" (
    set "HelpFromMain=1"
    goto InstallGuide
) else if "!errorlevel!"=="85" (
     powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!Script! will now update to the newest version or restore a good version of V!Version!...','ALOSToy Installer','OK','Info') | Out-Null"
     goto ApplyUpdate
) else if "!errorlevel!"=="100" (
    cls
    call :WindowTitle "INITIATE REDOWNLOAD?"
    for /f "delims=" %%# in ('powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"Do you want to redownload the files in:!NewLine!!NewLine!!Root!bin?\",'ALOSToy Installer','YesNo','Question')"') do (
        if "%%#"=="Yes" (
            echo Removing bin files...
            rd "!Root!bin" /s /q
            echo Done.
            for /f "delims=" %%Z in ('powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Do you want to restart the ALOSToy welcome banner as well?','ALOSToy Installer','YesNo','Question')"') do (if "%%Z"=="Yes" set "BannerShown=False")
            goto DLBin
        ) else if "%%#"=="No" (
            goto Main
        )
    )
) else if "!errorlevel!"=="103" (
    cls
    echo Opening the github repository...
    start !InstallerRepo!
    goto Main
) else if "!errorlevel!"=="104" (
    set "HelpFromMain=1"
    goto Help
) else if "!errorlevel!"=="105" (
    set "HelpFromMain=1"
    goto InstallGuide
) else if "!errorlevel!"=="114" (
    call :WindowTitle "RELAUNCHING"
    cls
    echo Restarting...
    powershell -nop -nol -c "Start-Process -FilePath conhost.exe -Verb RunAs -ArgumentList 'cmd.exe /c cd /d "!Root!\" & call "!Script!" %*'" >nul 2>&1 && (
        endlocal
        exit 0
    ) || (
        call :WindowTitle "NEVERMIND"
        pause
        goto Main
    )
) else if "!errorlevel!"=="117" (
     powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!Script! will now update to the newest version or restore a good version of V!Version!...','ALOSToy Installer','OK','Info')"
     goto ApplyUpdate
) else if "!errorlevel!"=="194" (
    cls
    echo Opening the github repository...
    start !InstallerRepo!
    goto Main
) else (
    echo This is not a valid choice.
    echo Return Code: !errorlevel!
    pause
    goto Main
)
:Standard_Briefing
cls
echo !CmdEchoing!
set "product=Standard"
set "label=ALOSToy_v1.0_STD_Rev_B"
call :WindowTitle "INSTALL ALOSTOY STANDARD"
echo Chosen product: ALOSToy !product!.>> "!logfile!"
if "!AcceptEULA!"=="0" (
    call :PowerShell_Helper "License-Terms_STD" /Maximised
    pause
    call powershell.exe -nop -nol -ExecutionPolicy Bypass -WindowStyle Normal -c "Write-Output 'User agreed to license terms.' | Out-File $env:logfile -Encoding UTF8 -Append -NoClobber -Force"
)
goto Vtoy_dl
:Extended_Briefing
cls
echo !CmdEchoing!
set "product=Extended"
set "label=ALOSToy_v1.0_EXT_Rev_B"
call :WindowTitle "INSTALL ALOSTOY EXTENDED"
if "!InstallExtensions!"=="True" (
    set "InstallExtensions=False"
    goto Extended_Briefing
)
echo Chosen product: ALOSToy !product!.>> "!logfile!"
if "!AcceptEULA!"=="0" (
    call :PowerShell_Helper "License-Terms_EXT" /Maximised
    pause
    call powershell.exe -nop -nol -ExecutionPolicy Bypass -WindowStyle Normal -c "Write-Output 'User agreed to license terms.' | Out-File $env:logfile -Encoding UTF8 -Append -NoClobber -Force"
)
goto Vtoy_dl
:Vtoy_dl
cls
rem Remove existing hash variables if defined.
if defined Actual_Ventoy_Hash set "Actual_Ventoy_Hash="
if defined Expected_Ventoy_Hash set "Expected_Ventoy_Hash="
rem Then continue.
call :WindowTitle "Collecting Ventoy..."
echo !CmdEchoing!
rem Do not trust the existing ventoy download. Delete and redownload to force SHA256 verification.
if "!Vtoy_DL_Mode!"=="0" if exist "!Root!Ventoy2Disk" rd "!Root!Ventoy2Disk" /s /q
if "!Vtoy_DL_Mode!"=="1" (
    if defined save if /i "!save!"=="Prompt" (
        for /f "delims=" %%P in ('folderbrowse.exe "Pick a location to save Ventoy." 0') do set "save=%%P"
        if /i "!save!"=="None" (
            endlocal
            exit /b 1
            goto :eof
        )
    )
    if /i "!Selected_Venver!" neq "Latest" (
        cd /d "!Root!"
        call :WindowTitle "Collecting Ventoy V!Selected_Venver!..."
        echo Collecting Ventoy V!Selected_Venver!...
        if exist "!Root!Ventoy2Disk" rd "!Root!Ventoy2Disk" /s /q >nul 2>&1
        curl https://github.com/ventoy/Ventoy/releases/download/v!Selected_Venver!/ventoy-!Selected_Venver!-windows.zip -o ./ventoy.zip -L >> "!logfile!" 2>&1 && (
            echo Successful.
            call :HashVentoyZip !Selected_Venver! && (
                "!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!save!\" "ventoy.zip" >> "!logfile!"
                if !errorlevel! gtr 1 (
                    set "errorcode=Unable to extract archive. Maybe requested version does not exist? ^(!errorlevel!^)"
                    goto Error
                ) else (
                    echo Downloaded Ventoy !Selected_Venver! successfully.
                    goto Ventoy_Is_Downloaded
                )
            ) || (
                set "errorcode=Bad ventoy version. Expected !Expected_Ventoy_Hash!. Got !Actual_Ventoy_Hash!. Expected !Expected_Ventoy_Hash!. Got !Actual_Ventoy_Hash!."
                goto Error
            )
        ) || (
            echo Failed.
            pause >nul
            endlocal
            exit 1
        )
    ) else (
        call :WindowTitle "Getting the latest Ventoy..."
        echo Getting the latest Ventoy...
        echo !DATE! !TIME! Collect the latest Ventoy Version.>> "!logfile!"
        powershell -nop -nol -c "$data = curl https://api.github.com/repos/ventoy/ventoy/git/refs/tag -UseBasicParsing | ConvertFrom-Json; $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './ventoyversion.txt'"
        set /p VENVER= <./ventoyversion.txt
        set vencurver=!VENVER:~-6!
        call :WindowTitle "Latest version is !vencurver!."
        echo Latest version is !vencurver!.
        curl https://github.com/ventoy/Ventoy/releases/download/v!vencurver!/ventoy-!vencurver!-windows.zip -o ./ventoy.zip -L >> "!logfile!" 2>&1 && (
            call :HashVentoyZip !vencurver! && (
                "!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!save!\" "!Root!ventoy.zip" >> "!logfile!"
                cls
                echo !CmdEchoing!
                echo Downloaded newest version.
                goto Ventoy_Is_Downloaded
            ) || (
                set "errorcode=Bad ventoy version. Expected !Expected_Ventoy_Hash!. Got !Actual_Ventoy_Hash!."
                goto Error
            )
        )
    )
) else if "!Vtoy_DL_Mode!"=="0" if defined Selected_Venver (
    cd /d "!Root!"
    call :WindowTitle "Collecting Ventoy V!Selected_Venver!..."
    echo Collecting Ventoy V!Selected_Venver!...
    if exist "!Root!Ventoy2Disk" rd "!Root!Ventoy2Disk" /s /q >nul 2>&1
    curl https://github.com/ventoy/Ventoy/releases/download/v!Selected_Venver!/ventoy-!Selected_Venver!-windows.zip -o ./ventoy.zip -L >> "!logfile!" 2>&1 && (
        echo Successful.
        call :HashVentoyZip !Selected_Venver! && (
            "!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!Root!\" "!Root!ventoy.zip" >> "!logfile!"
            if !errorlevel! gtr 1 (
                set "errorcode=Unable to extract archive. Maybe requested version does not exist?"
                goto Error
            ) else (
                echo Downloaded Ventoy !Selected_Venver! successfully.
                ren ventoy-!Selected_Venver! Ventoy2Disk
                goto Ventoy_Is_Downloaded
            )
        ) || (
            set "errorcode=Bad ventoy version. Expected !Expected_Ventoy_Hash!. Got !Actual_Ventoy_Hash!."
            goto Error
        )
    ) || (
        echo Failed.
        pause >nul
        endlocal
        exit 1
    )
)
call :WindowTitle "Getting the latest Ventoy..."
echo Getting the latest Ventoy...
echo !DATE! !TIME! Collect the latest Ventoy Version.>> "!logfile!"
powershell -nop -nol -c "$data = curl https://api.github.com/repos/ventoy/ventoy/git/refs/tag -UseBasicParsing | ConvertFrom-Json; $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './ventoyversion.txt'"
set /p VENVER= <./ventoyversion.txt
set vencurver=!VENVER:~-6!
cd /d "!Root!"
if exist "!cd!\Ventoy2Disk\" (goto Check_Ventoy_Version) else (goto Download_Ventoy)
:Check_Ventoy_Version
set /p localver= <.\Ventoy2Disk\ventoy\version
if "!localver!"=="!vencurver!" (goto Latest_Version_Installed) else (goto Download_Ventoy)
:Download_Ventoy
echo !DATE! !TIME! New ventoy version to download.>> "!logfile!"
if exist !Root!Ventoy2Disk rd "!Root!Ventoy2Disk" /s /q
curl https://github.com/ventoy/Ventoy/releases/download/v!vencurver!/ventoy-!vencurver!-windows.zip -o ./ventoy.zip -L >> "!logfile!" 2>&1
call :HashVentoyZip !vencurver! && (
    "!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!Root!" "!Root!ventoy.zip" >> "!logfile!" 2>&1
    cls 
    echo !CmdEchoing!
    goto Ventoy_Is_Downloaded
) || (
    set "errorcode=Bad ventoy version. Expected !Expected_Ventoy_Hash!. Got !Actual_Ventoy_Hash!."
    goto Error
)
:Latest_Version_Installed
rem No need to update.
:Ventoy_Is_Downloaded
for %%A in (ventoy.zip .wget-hsts ventoyversion.txt) do if exist "%%A" del "%%A" /f /q >nul 2>&1
if "!Vtoy_DL_Mode!"=="0" (
    cd /d "!Root!"
    ren ventoy-!vencurver! Ventoy2Disk
    goto ChooseDrive
) else (
    call :WindowTitle "DOWNLOADED !SELECTED_VENVER! SUCCESSFULLY."
    echo Ventoy version !Selected_Venver! downloaded to !save!.
    timeout /t 3 /NOBREAK >nul
    endlocal
    exit 0
)
:ChooseDrive
cls
echo !CmdEchoing!
cd "!Root!bin"
call :WindowTitle "Choose a drive."
echo We need to know where ventoy will be installed to. Pick carefully.
if "!ConfigChanged!"=="False" (for /f "delims=" %%A in ('folderbrowse.exe "We need to know which drive you are installing ALOSToy on." 5') do set "drive=%%A") else if "!ConfigChanged!"=="True" (for /f "delims=" %%A in ('folderbrowse.exe "We need to know which drive you are installing ALOSToy on."') do set "drive=%%A")
if /i "!drive!"=="None" (
    if /i "!ProductDefinedWithArg!"=="True" (
        echo Exiting...
        timeout /t 1 /NOBREAK >nul
        endlocal
        exit 1
    ) else (
        echo Returning to main menu...
        if "!ConfigChanged!"=="True" set "ResetVars=1"
        timeout /t 1 /NOBREAK >nul
        goto Main
    )
)
set drivepath=!drive:~0,1!
set "drive="
rem Don't hardcode the system drive. Expand !SYSTEMDRIVE! and compare the selected drive. !SYSTEMDRIVE! could be something else like X:\ or A:\ or even B:\.
rem It is never good to assume that !SYSTEMDRIVE! is always C:\!
set "WindowsDrive=!SYSTEMDRIVE:~0,1!"
powershell -nop -nol -c "if (($env:drivepath -match '^[A-Z]$') -and ($env:drivepath -ceq $env:drivepath.ToUpper())) { exit 0 } else { exit 1 }"
if !errorlevel! gtr 0 (
    set "drivepath="
    goto ChooseDrive
)
if "!drivepath!"=="\" echo You cannot select this PC or the root of the current drive or cancel. Try again. && pause >nul && goto ChooseDrive
rem Our expansion allows blocking of the system drive even if it isn't C:\. I am so much better.
goto WindowsDriveCheck
:WindowsDriveCheck
set "ScriptDrive=%~d0"
if /i "!drivepath!"=="!WindowsDrive!" (
    call :WindowTitle "PICK SOMETHING ELSE OTHER THAN YOUR SYSTEMDRIVE."
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('It turns out you tried to select the !WindowsDrive! drive. We cannot let you do this because otherwise you would end up wrecking your operating system. We will ask you again.','ALOSToy Installer','OKCancel','Error')"') do (
        if /i "%%A"=="OK" (
            goto ChooseDrive
        ) else if /i "%%A"=="Cancel" (
            set "errorcode=Attempted selection of system drive."
            goto Error
        ) else (
            goto WindowsDriveCheck
        )
    )
) else if /i "!drivepath!:"=="!ScriptDrive!" (
    call :WindowTitle "PICK SOMETHING ELSE OTHER THAN THE SCRIPT DRIVE."
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"It turns out you tried to select the !ScriptDrive! drive. We cannot let you do this because otherwise you would end up destroying the script and files.!NewLine!!NewLine!This can impair your ability to continue installing.!NewLine!!NewLine!We will ask you again.\",'ALOSToy Installer','OKCancel','Error')"') do (
        if /i "%%A"=="OK" (
            goto ChooseDrive
        ) else if /i "%%A"=="Cancel" (
            set "errorcode=Attempted selection of script drive."
            goto Error
        ) else (
            goto WindowsDriveCheck
        )
    )
) else (
    cd "!Root!"
    goto ConfirmDrive
)
:ConfirmDrive
cls
call :WindowTitle "Confirm the drive you selected is !drivepath!."
if "!ProductDefinedWithArg!"=="False" (
    echo !CmdEchoing!
    echo Make sure that !drivepath! is correct. AaravLegend-OS is not responsible for firing a nuke on an innocent drive.
    echo.
    echo If the drive letter is correct, push ENTER.
    set /p "drivepath=If that is not the case, type the letter in now. Just the letter without the colon or trailing slash. For example, E >> " && (goto ConfirmDrive)
    rem Same example here.
    powershell -nop -nol -c "if (($env:drivepath -match '^[A-Z]$') -and ($env:drivepath -ceq $env:drivepath.ToUpper())) { exit 0 } else { exit 1 }"
    if !errorlevel! gtr 0 (
        set "drivepath="
        goto ConfirmDrive
    )
)
if /i "!drivepath!"=="!WindowsDrive!" (
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('It turns out you tried to select the !WindowsDrive! drive. We cannot let you do this because otherwise you would end up wrecking your operating system. We will ask you again.','ALOSToy Installer','OKCancel','Error')"') do (
        if /i "%%A"=="OK" (
            set "drivepath="
            goto ConfirmDrive
        ) else if /i "%%A"=="Cancel" (
            set "errorcode=Attempted selection of system drive."
            goto Error
        ) else (
            goto ConfirmDrive
        )
    )
) else if /i "!drivepath!:"=="!ScriptDrive!" (
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"It turns out you tried to select the !ScriptDrive! drive. We cannot let you do this because otherwise you would end up destroying the script and files.!NewLine!!NewLine!This can impair your ability to continue installing.!NewLine!!NewLine!We will ask you again.\",'ALOSToy Installer','OKCancel','Error')"') do (
        if /i "%%A"=="OK" (
            goto ConfirmDrive
        ) else if /i "%%A"=="Cancel" (
            set "errorcode=Attempted selection of script drive."
            goto Error
        ) else (
            goto ConfirmDrive
        )
    )
)
if not defined drivepath goto ConfirmDrive
echo Drive validation in progress...
rem Using call :PowerShell_Helper <PS_Label> will not work in a for /f loop.
for /f "delims=" %%W in ('powershell -nop -nol -c "chcp 65001 > $null; $i18n = New-Object System.Text.UTF8Encoding; [Console]::InputEncoding = $i18n; [Console]::OutputEncoding = $i18n; $OutputEncoding = $i18n; $section = [io.file]::ReadAllText($env:FullScript) -split '(?ms)^:Find_WinInstall\r?\n(.*?)\r?\n:Post_Find_WinInstall'; & ([scriptblock]::Create($section[1]))"') do set "WinInstall=%%W"
goto Post_Find_WinInstall
:Find_WinInstall
if ([string]::IsNullOrWhiteSpace($env:drivepath)) {
    Write-Output 'NOTFOUND'
    return
}
$root = "${env:drivepath}:\"
$kernel = Join-Path -Path $root -ChildPath 'Windows\System32\ntoskrnl.exe'
try {
    if (-not (Test-Path -LiteralPath $kernel -PathType Leaf)) {
        Write-Output 'NOTFOUND'
        return
    }
    Import-Module Dism -ErrorAction Stop
    $Info = Get-WindowsEdition -Path $root -ErrorAction Stop
    $Packages = @(Get-WindowsPackage -Path $root -ErrorAction Stop)
    [PSCustomObject]@{
        STATUS = 'FOUND'
        Edition = $Info.Edition
        PackageCount = $Packages.Count
    } | Select-Object -ExpandProperty STATUS
} catch {
    Write-Output 'ERROR'
}
:Post_Find_WinInstall
if /i "!WinInstall!"=="FOUND" (
    for /f "delims= " %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('I detected a Windows installation on Drive !drivepath!. Do you want to continue? If you do, you can lose that installation and all its files.','ALOSToy Installer','YesNoCancel','Warning')"') do (
        if /i "%%Q"=="Yes" (
            echo !CmdEchoing!
        ) else if /i "%%Q"=="No" (
            set "drivepath="
            goto ChooseDrive
        ) else if /i "%%Q"=="Cancel" (
            if /i "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
        ) else (
           endlocal
           exit 1
        )
    )
) else if /i "!WinInstall!"=="NOTFOUND" (
    echo !CmdEchoing!
) else if /i "!WinInstall!"=="ERROR" (
    set "errorcode=Unable to find a Windows Installation. Aborting for safety..."
    goto Error
) else (
    set "errorcode=An invalid value was supplied."
    goto Error
)
echo Validating size...
set size=0
call :PowerShell_Helper "SizeValidation"
goto Post_SizeValidation
:SizeValidation
$size = (Get-Volume -DriveLetter $env:drivepath).Size
if ($env:product -ieq "Standard") {
    if ($env:InstallExtensions -ieq "True") {
        if ($size -lt 123071926272) {
            Exit 1
        } else {
            Exit 0
        }
    }
    elseif ($env:InstallExtensions -ieq "False") {
        if ($size -lt 53333282816) {
            Exit 1
        } else {
            Exit 0
        }
    } else {
        Exit 2
    }
}
elseif ($env:product -ieq "Extended") {
    if ($size -lt 190845530112) {
        Exit 1
    } else {
        Exit 0
    }
}
Exit 0
:Post_SizeValidation
if !errorlevel! lss 1 (
    goto GPTChoice
) else (
    echo You cannot continue as your drive is too small.
    pause
    if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (goto ChooseDrive)
)
:GPTChoice
rem DO NOT CONFUSE GPT WITH CHATGPT. GPT AND CHATGPT ARE TWO DIFFERENT THINGS.
call :WindowTitle "Do you want GPT? (Not ChatGPT.)"
cls
echo !CmdEchoing!
set "choice="
echo Do you intend to only use ALOSToy on modern UEFI systems?
call Button 5 3 F2 "Yes. I only use Ventoy on modern UEFI systems." 65 3 F4 "No. I use Ventoy on old BIOS systems as well."  X _Var_Box _Var_Hover
echo.
echo.
echo.
echo Do not confuse this with ChatGPT^^! GPT and ChatGPT are two different things^^!
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (
    set "firstarg=/GPT"
) else if "!errorlevel!"=="2" (
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('MBR only supports disks up to 2TB. Do you want to continue?','ALOSToy Installer','YesNoCancel','Question')"') do (
        if "%%A"=="Yes" (
            set "firstarg="
        ) else if "%%A"=="No" (
            goto GPTChoice
        ) else if "%%A"=="Cancel" (
            cls
            if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
        ) else (
            set "errorcode=Invalid choice."
            goto Error
        )
    )
) else (
    echo.
    echo.
    echo.
    echo Invalid choice.
    goto GPTChoice
)
goto SecureBootChoice
:SecureBootChoice
call :WindowTitle "Do you want Secure Boot?"
cls
echo !CmdEchoing!
set "choice="
echo Do you want to support Secure Boot?
call Button 25 3 F2 "Yes. It is essential for security." 75 3 F4 "No. I do not care."  X _Var_Box _Var_Hover
echo.
echo.
echo.
echo Secure Boot is only supported on UEFI systems but you can still use the USB
echo with BIOS computers but you will not be able to use Secure Boot. This does
echo NOT stop you from booting the final ALOSToy USB.
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (
    set "secondarg="
) else if "!errorlevel!"=="2" (
    for /f "delims= " %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Secure Boot Support is good for your computer. Do you want to continue without it? Pro tip: You do not explicitly need GPT for Secure Boot.','ALOSToy Installer','YesNoCancel','Question')"') do (
        if "%%A"=="Yes" (
            set "secondarg=/NOSB"
        ) else if "%%A"=="No" (
            goto SecureBootChoice
        ) else if "%%A"=="Cancel" (
            cls
            if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
        ) else (
            set "errorcode=Invalid choice."
            goto Error
        )
    )
) else (
    echo Invalid choice.
    goto SecureBootChoice
)
goto VentoyMenu
:VentoyMenu
call :WindowTitle "LETS INSTALL OR UPDATE VENTOY"
cls
echo !CmdEchoing!
if "!ProductDefinedWithArg!"=="True" (if /i "!Vtoy_Install_Type!"=="Install" (goto InstallVtoy) else if /i "!Vtoy_Install_Type!"=="Update" (goto UpdateVtoy) else (goto Main))
cd /d "!Root!"
if /i "!NoticeAgreed!"=="False" if /i "!ConfigChanged!"=="False" (
    for /f "delims=" %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('You are now entering the install screen. 4 buttons are going to appear. Pay attention to the buttons that will appear.','ALOSToy Installer','OKCancel','Info')"') do if /i "%%Q"=="OK" (cls) else (if /i "%%Q"=="Cancel" (if /i "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)) else (goto VentoyMenu)
    )
)
if /i "!ConfigChanged!"=="True" (
    echo ^| =========================== ^|
    echo ^|  Configuration Successful.  ^|
    echo ^| =========================== ^|
    set "ConfigChanged=False"
)
set "NoticeAgreed=True"
set "confirm="
set "thirdarg=/FS:NTFS"
call :PowerShell_Helper "Ventoy-Choices"
call Button 15 12 F4 "Change Configuration" 45 12 F6 "Install Ventoy Onto !drivepath!" 75 12 F3 "Update Ventoy On !drivepath!" 40 18 F2 "Ventoy Is Already Installed On !drivepath!" X _Var_Box _Var_Hover
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (
    set "ConfigChanged=True"
    goto ChooseDrive
) else if "!errorlevel!"=="2" (
    goto InstallVtoy
) else if "!errorlevel!"=="3" (
    goto UpdateVtoy
) else if "!errorlevel!"=="4" (
    cls
    rem You still have to get consent from the user. Cannot be force formatting their drive without their consent. (To comply with Computer Misuse Laws like the Computer Misuse Act 1990:S3 in the UK for example.)
    for /f "delims= " %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"You said ventoy is installed on !drivepath!. do you want to format that drive to make room? It is your choice. If it is fresh and not NTFS, go ahead if you want or else no need if you are not OK?!NewLine!!NewLine!Keep in mind, your GPT and Secure Boot settings cannot be applied so ensure your settings are applied beforehand in Ventoy.\",'ALOSToy Installer','YesNoCancel','Question')"') do (
        if /i "%%Q"=="Yes" (
            set "NoFormat=0"
            goto CheckVentoyB
        ) else if /i "%%Q"=="No" (
            set "NoFormat=1"
            goto CheckVentoyB
        ) else if /i "%%Q"=="Cancel" (
            if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (goto Main)
        ) else (
            set "errorcode=Invalid choice."
            goto Error
        )
    )
) else (
    echo.
    echo.
    echo.
    echo This is not a valid choice.
    pause
    goto VentoyMenu
)
:InstallVtoy
cls
echo !CmdEchoing!
set "MessageSuccess=Ventoy Install Successful."
set "MessageFailure=Ventoy Install Failed."
call :WindowTitle "Installing Ventoy Onto !drivepath!..."
set "NoFormat=0"
if "!ProductDefinedWithArg!"=="False" (
    for /f "delims=" %%A in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('FINAL CHANCE. Do you want to install Ventoy to !drivepath!? All data will be lost. If you click Yes, you will be asked to confirm.','ALOSToy Installer','YesNoCancel','Warn')"') do (
        if "%%A"=="Yes" (
            set /p "confirm=Confirm that you want to format by typing exactly "Yes. I hereby agree to format this drive which will erase ALL data on !drivepath!. I have understood that the contents of !drivepath! will be lost forever. I also acknowledge that data on other partitions of the disk associated with the !drivepath! drive will be lost." >> "
            if "!confirm!" neq "Yes. I hereby agree to format this drive which will erase ALL data on !drivepath!. I have understood that the contents of !drivepath! will be lost forever. I also acknowledge that data on other partitions of the disk associated with the !drivepath! drive will be lost." (
                set "confirm="
                goto VentoyMenu
            )
        ) else if "%%A"=="No" (
            cls
            set "confirm="
            goto VentoyMenu
        ) else if "%%A"=="Cancel" (
            if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
        ) else (
            set "errorcode=Invalid choice."
            goto Error
        )
    )
)
cls
set "FormatAccepted=1"
echo Hold On. We Will Install Ventoy.
echo.
echo I am just going to let you know that ventoy sometimes messes up drives. They can fail to remount or even install entirely making the cli return exit code 1. If that is the case, you must install Ventoy manually.
echo This is a ventoy bug and we at AaravLegend-OS cannot fix this.
echo.
echo Just kidding... Ventoy will reject fake drives in the CLI often. You must use the GUI for fake drives and ensure you repartition fake drives properly.
echo When I went to Chennai, India in April 2025, I met someone I knew (I am not telling you who they are) at GRT Grand Hotel. They gave me a fake 1TB usb drive. I found out only 64GB was real when I validated it.
echo.
echo The ventoy command line result file will be checked. If 0 exists, it worked but if 1 exists, it failed.
echo Close the file explorer when done.
echo !DATE! !TIME! Begin Ventoy Install Log:>> "!logfile!"
Ventoy2Disk_!Arch!.exe VTOYCLI /I /Drive:!drivepath! /NOUSBCheck !firstarg! !secondarg! !thirdarg!
rem Capture the ventoy log into the main logfile.
type "!Root!Ventoy2Disk\cli_log.txt" >> "!logfile!"
echo !DATE! !TIME! End Ventoy Install Log:>> "!logfile!"
cls
echo !CmdEchoing!
goto CheckVentoyA
:UpdateVtoy
cls
echo !CmdEchoing!
set "MessageSuccess=Ventoy Update Successful."
set "MessageFailure=Ventoy Update Failed."
call :WindowTitle "Updating Ventoy On !drivepath!..."
set "NoFormat=1"
echo Hold On. We Will Update Ventoy.
echo.
echo I am just going to let you know that ventoy sometimes messes up drives. They can fail to remount or install entirely making the cli return exit code 1. If that is the case, you must update Ventoy manually.
echo This is a ventoy bug and we at AaravLegend-OS cannot fix this.
echo.
echo Just kidding... Ventoy will reject fake drives in the CLI often. You must use the GUI for fake drives and ensure you repartition fake drives properly.
echo When I went to Chennai, India in April 2025, I met someone I knew (I am not telling you who they are) at GRT Grand Hotel. They gave me a fake 1TB usb drive. I found out only 64GB was real when I validated it.
echo.
echo The ventoy command line result file will be checked. If 0 exists, it worked but if 1 exists, it failed.
echo Close the file explorer when done.
echo !DATE! !TIME! Begin Ventoy Install Log:>> "!logfile!"
Ventoy2Disk_!Arch!.exe VTOYCLI /U /Drive:!drivepath! /NOUSBCheck !firstarg! !secondarg!
rem Capture the ventoy log into the main logfile.
type "!Root!Ventoy2Disk\cli_log.txt" >> "!logfile!"
echo !DATE! !TIME! End Ventoy Install Log:>> "!logfile!"
cls
echo !CmdEchoing!
goto CheckVentoyA
:CheckVentoyA
rem Ventoy generates a cli_done.txt in the same folder as the Ventoy2Disk.exe file.
rem It is important to read the file as 0 means success and 1 means failure.
for /f "delims= " %%A in ('type "!Root!Ventoy2Disk\cli_done.txt"') do (
    echo !DATE! !TIME! Ventoy Operation Succeeded: %%A>> "!logfile!"
    if "%%A"=="0" (
        call :WindowTitle "!MessageSuccess!"
        powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!MessageSuccess! We can continue.','ALOSToy Installer','OK','Info') | Out-Null"
        goto CheckVentoyB
    ) else if "%%A"=="1" (
        call :WindowTitle "!MessageFailure!"
        if "!ProductDefinedWithArg!"=="False" (
            for /f "delims= " %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!MessageFailure! You can always try again. Do you want to try manually?','ALOSToy Installer','YesNoCancel','Error')"') do (
                if "%%Q"=="Yes" (
                    call :WindowTitle "INSTALL VENTOY MANUALLY THEN."
                    echo INSTALL VENTOY MANUALLY THEN.
                    if /i "!firstarg!"=="/GPT" (echo In the GUI, change the partition scheme to GPT if it is not GPT ^(Option --^> Partition Style --^> GPT^).) else (echo In the GUI, change the partition scheme to MBR if it is not MBR ^(Option --^> Partition Style --^> MBR^).)
                    if /i "!secondarg!" neq "/NOSB" (echo In the GUI, uncheck "Secure Boot Support" if it is checked. ^(Option --^> Secure Boot Support^).) else (echo In the GUI, check "Secure Boot Support" if it is unchecked ^(Option --^> Secure Boot Support^).)
                    echo Open the dropdown menu for the drive to select. It is on the Main Menu and select !drivepath!:.
                    echo Finally click install and confirm this is the correct drive. ^(Double check this drive is !drivepath!.^)
                    echo When it is complete, close Ventoy2Disk and then we will continue.
                    start /wait "" "Ventoy2Disk.exe"
                    for /f "delims= " %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Did it work? Please tell the truth.','ALOSToy Installer','YesNoCancel','Question')"') do (
                        if "%%Q"=="Yes" (
                            goto CheckVentoyB
                        ) else if "%%Q"=="No" (
                            goto ChooseDrive
                        ) else if "%%Q"=="Cancel" (
                            set "ResetVars=1"
                            goto Main
                        )
                    )
                ) else if "%%Q"=="No" (
                    goto VentoyMenu
                ) else if "%%Q"=="Cancel" (
                    set "ResetVars=1"
                    goto Main
                )
            )
        ) else (
            powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!MessageFailure! You must restart the installation with a different drive. Command line operation failed.','ALOSToy Installer','OK','Error') | Out-Null"
            set "errorcode=The installation of Ventoy failed due to a bad USB drive or configuration."
            goto Error
        )
    ) else (
        echo The data is invalid in the cli_done.txt file.
        endlocal
        exit 1
    )
)
:CheckVentoyB
cls
call :WindowTitle "CONFIRM THE DRIVE HAS NOT CHANGED."
if "!ProductDefinedWithArg!"=="True" (
    set "WarnAccepted=True"
    choice /c YN /n /m "Did the drive letter change?" /t 10 /d N
    if "!errorlevel!"=="1" (set /p "drivepath=Insert the drive letter here ^(Currently !drivepath!^). >> ")
    call :WindowTitle "FORMATTING IN PROGRESS..."
    echo Formatting !drivepath!:\...
    format !drivepath!: /fs:ntfs /q /v:!label! /a:4096 /x /y >> "!logfile!" && (
        echo Success.
        set "confirm="
        set "Msg="
        goto CheckFiles
    ) || (
        echo Fail.
        timeout /t 3 /NOBREAK >nul
        set "errorcode=Unable to format !drivepath!."
        goto Error
    )
)
if "!NoFormat!"=="0" if "!WarnAccepted!"=="0" (
    for /f "delims=" %%Q in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('I want to make sure that your drive letter has not changed. If it changed, type the new drive letter now.','ALOSToy Installer','OKCancel','Warning')"') do (
        if /i "%%Q"=="OK" (
            cls
            echo !CmdEchoing!
            set "WarnAccepted=1"
        ) else if /i "%%Q"=="Cancel" (
            if "!ProductDefinedWithArg!"=="False" (
                set "ResetVars=1"
                goto Main
            ) else (
                endlocal
                exit 1
            )
        ) else (
            goto CheckVentoyB
        )
    )
)
if "!NoFormat!"=="0" (
    set "Msg=Insert the drive letter here ^(Currently !drivepath!^), then if you skipped Ventoy install, confirm that this is the drive to reformat by pressing ENTER or else, press ENTER to format."
) else (
    set "Msg=Insert the drive letter here ^(Currently !drivepath!^).
)
set /p "drivepath=!Msg! >> " && (
    rem Double validate when changing and confirming. Requires UPPERCASE drive letter to pass. Not
    rem lowercase, PascalCase, camelCase, snake_case, kebab-case or any other case, just UPPERCASE.
    powershell -nop -nol -c "if (($env:drivepath -match '^[A-Z]$') -and ($env:drivepath -ceq $env:drivepath.ToUpper())) { exit 0 } else { exit 1 }"
    if "!errorlevel!"=="1" (
        echo Invalid drive.
        timeout /t 3 /NOBREAK >nul
        set "drivepath="
    )
    goto CheckVentoyB
) || (
    rem Requires code repetition.
    powershell -nop -nol -c "if (($env:drivepath -match '^[A-Z]$') -and ($env:drivepath -ceq $env:drivepath.ToUpper())) { exit 0 } else { exit 1 }"
    if "!errorlevel!"=="1" (
        echo Invalid drive.
        timeout /t 3 /NOBREAK >nul
        set "drivepath="
        goto CheckVentoyB
    )
)
if "!NoFormat!"=="0" (
    if /i "!drivepath!"=="!WindowsDrive!" goto CheckVentoyB
    if not defined confirm set /p "confirm=Confirm that you want to format by typing exactly "Yes. I hereby agree to format this drive which will erase ALL data on !drivepath!. I have understood that the contents of !drivepath! will be lost forever." >> "
    if "!confirm!"=="Yes. I hereby agree to format this drive which will erase ALL data on !drivepath!. I have understood that the contents of !drivepath! will be lost forever." (set "RunFormat=1") else if "!FormatAccepted!"=="1" (set "RunFormat=1")
    if "!RunFormat!"=="1" (
        call :WindowTitle "FORMATTING IN PROGRESS..."
        echo Formatting !drivepath!:\...
        format !drivepath!: /fs:ntfs /q /v:!label! /a:4096 /x /y >> "!logfile!" && (
            echo Success.
            set "confirm="
            set "Msg="
            goto CheckFiles
        ) || (
            echo Fail.
            timeout /t 3 /NOBREAK >nul
            set "errorcode=Unable to format !drivepath!."
            goto Error
        )
    ) else if "!confirm!"=="Yes. I hereby agree to format this drive which will erase ALL data on !drivepath!. I have understood that the contents of !drivepath! will be lost forever. I also acknowledge that data on other partitions of the disk associated with the !drivepath! drive will be lost." (set "RunFormat=1") else if "!FormatAccepted!"=="1" (set "RunFormat=1")
    if "!RunFormat!"=="1" (
        call :WindowTitle "FORMATTING IN PROGRESS..."
        echo Formatting !drivepath!:\...
        format !drivepath!: /fs:ntfs /q /v:!label! /a:4096 /x /y >> "!logfile!" && (
            echo Success.
            set "confirm="
            set "Msg="
            goto CheckFiles
        ) || (
            echo Fail.
            timeout /t 3 /NOBREAK >nul
            set "errorcode=Unable to format !drivepath!."
            goto Error
        )
    ) else (
        set "confirm="
        goto CheckVentoyB
    )
)
:CheckFiles
label !drivepath!: !label! >nul 2>&1
call :WindowTitle "HASHING FILES..."
if not exist !Root!\files md files
cls
echo !CmdEchoing!
label !drivepath!: !label! >nul 2>&1
rem SHA256 verification. Stop MITM attacks or modifications.
echo Ensuring that no one has tampered with source files.
if /i "!product!"=="Standard" (
    set "OK=0"
    set "files=0"
    set "good=0"
    if exist !Root!\files\ALOSToy_v1.0_STD_Part_1.7z ( 
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_STD_Part_1.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SAHash=%%H"
        if /i "!SAHash!"=="!STHashA!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_STD_Part_1.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_STD_Part_2.7z ( 
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_STD_Part_2.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SBHash=%%H"
        if /i "!SBHash!"=="!STHashB!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_STD_Part_2.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_STD_Part_3.7z ( 
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_STD_Part_3.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SCHash=%%H"
        if /i "!SCHash!"=="!STHashC!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_STD_Part_3.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_STD_Part_4.7z ( 
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_STD_Part_4.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SDHash=%%H"
        if /i "!SDHash!"=="!STHashD!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_STD_Part_4.7z" /f /q)
    )
    if /i "!InstallExtensions!"=="True" (
        if exist !Root!\files\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z (
            set /a "files+=1"
            for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SEHash=%%H"
            if /i "!SEHash!"=="!STHashE!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z" /f /q)
        )
        if exist !Root!\files\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z (
            set /a "files+=1"
            for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "SFHash=%%H"
            if /i "!SFHash!"=="!STHashF!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z" /f /q)
        )
        if !files! lss 6 (
            goto Files
        ) else (
            if !good! lss 6 set "errorcode=BAD HASHES" && goto Error
            goto Extract
        )
    ) else (
        if !files! lss 4 (
            goto Files
        ) else (
            if !good! lss 4 set "errorcode=BAD HASHES" && goto Error
            goto Extract
        )
    )
) else if /i "!product!"=="Extended" (
    set "OK=0"
    set "files=0"
    set "good=0"
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_1.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_1.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EAHash=%%H"
        if /i "!EAHash!"=="!EXHashA!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_1.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_2.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_2.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EBHash=%%H"
        if /i "!EBHash!"=="!EXHashB!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_2.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_3.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_3.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "ECHash=%%H"
        if /i "!ECHash!"=="!EXHashC!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_3.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_4.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_4.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EDHash=%%H"
        if /i "!EDHash!"=="!EXHashD!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_4.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_5.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_5.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EEHash=%%H"
        if /i "!EEHash!"=="!EXHashE!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_5.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_6.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_6.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EFHash=%%H"
        if /i "!EFHash!"=="!EXHashF!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_6.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_7.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_7.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EGHash=%%H"
        if /i "!EGHash!"=="!EXHashG!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_7.7z" /f /q)
    )
    if exist !Root!\files\ALOSToy_v1.0_EXT_Part_8.7z (
        set /a "files+=1"
        for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!Root!files\ALOSToy_v1.0_EXT_Part_8.7z' -Algorithm !Algorithm!).Hash.ToUpper()"') do set "EHHash=%%H"
        if /i "!EHHash!"=="!EXHashH!" (echo Good && set /a "good+=1") else (echo Bad && del "!Root!files\ALOSToy_v1.0_EXT_Part_8.7z" /f /q)
    )
    if !files! lss 8 (
        goto Files
    ) else (
        if !good! lss 8 set "errorcode=BAD HASHES" && goto Error
        goto Extract
    )
) else (
    exit 1
    goto :eof
)
:Hashing
set "File=%~1"
set "CorrectHash=%~2"
if /i "%~3"=="PreserveBad" (set "PreserveBad=1") else (set "PreserveBad=0")
if exist "!File!" (
    echo Verifying !File! ^| It should be !CorrectHash!
    if "!PreserveBad!"=="1" echo !File! will be preserved on mismatch.
    for /f "delims=" %%H in ('powershell -nop -nol -ExecutionPolicy Bypass -c "(Get-FileHash '!File!' -Algorithm !Algorithm!).Hash.ToUpper()"') do (
        set "Hash=%%H"
        if /i "!Hash!"=="!CorrectHash!" (
            echo !File! is OK.
            set /a "OK+=1"
            timeout /t 1 /NOBREAK >nul
            set "PreserveBad=0"
           exit /b 0
        ) else (
            echo !File! is not OK.
            echo The hash is !Hash!.
            if "!PreserveBad!"=="0" del "!File!" /f /q
            timeout /t 1 /NOBREAK >nul
            set "PreserveBad=0"
            exit /b 1
        )
    )
) else (
    echo The file !File! does not exist.
    timeout /t 1 /NOBREAK >nul
    set "PreserveBad=0"
    exit /b 1
)
:Files
cls
echo !CmdEchoing!
call :WindowTitle "THERE ARE MISSING FILES"
label !drivepath!: !label! >nul 2>&1
echo Tell me this. Do you have the main files? If you do, click Locate Files else click Download Files.
call Button 20 12 F2 "Download Files" 90 12 F4 "Locate Files" X _Var_Box _Var_Hover
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (goto Files_DL) else if "!errorlevel!"=="2" (goto Files_LCT) else (goto Files)
:Files_DL
cls
echo !CmdEchoing!
start /b powershell -nop -nologo -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('The logfile: !Root!aria2c_download.log will take up several gigabytes of your %~d0 drive space.','ALOSToy Installer','OK','Warn')"
if /i "!product!"=="Standard" (
    echo Downloading standard version... This will take a long time...
    for /l %%X in (1,1,4) do (
        if not exist "!Root!\files\ALOSToy_v1.0_STD_Part_%%X.7z" (
            aria2c_!Arch!.exe -d"!Root!files" -o ALOSToy_v1.0_STD_Part_%%X.7z  --max-connection-per-server=16 --split=16 --file-allocation=none --log="aria2c_download.log" --continue=true "https://archive.org/download/alostoy-v1.0-standard/ALOSToy_v1.0_STD_Part_%%X.7z" >> "!logfile!" 2>&1
            if "%%X"=="1" call :Hashing "!Root!files\ALOSToy_v1.0_STD_Part_1.7z" "!STHashA!"
            if "%%X"=="2" call :Hashing "!Root!files\ALOSToy_v1.0_STD_Part_2.7z" "!STHashB!"
            if "%%X"=="3" call :Hashing "!Root!files\ALOSToy_v1.0_STD_Part_3.7z" "!STHashC!"
            if "%%X"=="4" call :Hashing "!Root!files\ALOSToy_v1.0_STD_Part_4.7z" "!STHashD!"
        )
    )
    if "!InstallExtensions!"=="True" (
        echo Downloading extensions... This will take a long time...
        for /l %%J in (1,1,2) do (
            if not exist "!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_%%J.7z" (
                aria2c_!Arch!.exe -d"!Root!files" -o Extensions_For_ALOSToy_v1.0_STD_Part_%%J.7z --max-connection-per-server=16 --split=16 --file-allocation=none --log="aria2c_download.log" --continue=true "https://archive.org/download/alostoy-v1.0-extensions/Extensions_For_ALOSToy_v1.0_STD_Part_%%J.7z" >> "!logfile!" 2>&1
                if "%%J"=="1" call :Hashing "!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z" "!STHashE!"
                if "%%J"=="2" call :Hashing "!Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z" "!STHashF!"
            )
        )
    )
    if /i "!InstallExtensions!"=="True" (
        if !OK! lss 6 (
            set "errorcode=Potential interception and modification mid-download."
            goto Error
        ) else (
            call :WindowTitle "EVERYTHING IS GOOD."
            goto Extract
        )
    ) else (
        if !OK! lss 4 (
            set "errorcode=Potential interception and modification mid-download."
            goto Error
        ) else (
            call :WindowTitle "EVERYTHING IS GOOD."
            goto Extract
        )
    )
) else if /i "!product!"=="Extended" (
    echo Downloading extended version... This will take a long time...
    for /l %%X in (1,1,8) do (
        if not exist "!Root!\files\ALOSToy_v1.0_EXT_Part_%%X.7z" (
            aria2c_!Arch!.exe -d"!Root!files" -o ALOSToy_v1.0_EXT_Part_%%X.7z --max-connection-per-server=16 --split=16 --file-allocation=none --log="aria2c_download.log" --continue=true "https://archive.org/download/alostoy-v1.0-extended/ALOSToy_v1.0_EXT_Part_%%X.7z" >> "!logfile!" 2>&1
            if "%%X"=="1" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_1.7z" "!EXHashA!"
            if "%%X"=="2" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_2.7z" "!EXHashB!"
            if "%%X"=="3" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_3.7z" "!EXHashC!"
            if "%%X"=="4" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_4.7z" "!EXHashD!"
            if "%%X"=="5" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_5.7z" "!EXHashE!"
            if "%%X"=="6" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_6.7z" "!EXHashF!"
            if "%%X"=="7" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_7.7z" "!EXHashG!"
            if "%%X"=="8" call :Hashing "!Root!files\ALOSToy_v1.0_EXT_Part_8.7z" "!EXHashH!"
        )
    )
    if !OK! lss 8 (
        set "errorcode=Potential interception and modification mid-download."
        goto Error
    ) else (
        call :WindowTitle "EVERYTHING IS GOOD."
        goto Extract
    )
) else (
    endlocal
    exit 1
)
:Files_LCT
cls
echo We need to know which directory you placed the ALOSToy !product! files.
if /i "!InstallExtensions!"=="True" echo Because extensions are also being installed, you must also have the extensions in the same folder.
cd "!Root!bin"
for /f "delims=" %%D in ('folderbrowse.exe "Please browse to the folder where the ALOSToy !product! files are." 3') do set "dir=%%D"
if /i "!dir!"=="None" (
    echo You have not selected a directory.
    echo Press any key now and select the directory where you kept the files.
    pause >nul
    goto Files_LCT
)
call :WindowTitle "HASHING LOCAL FILES"
if /i "!product!"=="Standard" (
    set "OK=0"
    set "Required=4"
    call :Hashing "!dir!\ALOSToy_v1.0_STD_Part_1.7z" "!STHashA!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_STD_Part_2.7z" "!STHashB!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_STD_Part_3.7z" "!STHashC!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_STD_Part_4.7z" "!STHashD!" PreserveBad
    if "!InstallExtensions!"=="True" (
        set /a "Required+=2"
        call :Hashing "!dir!\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z" "!STHashE!" PreserveBad
        call :Hashing "!dir!\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z" "!STHashF!" PreserveBad
    )
    if !OK! equ !Required! (
        set "Located=1"
        goto Extract
    ) else (
        for /f "delims=" %%E in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Either one or more hashes do not match or some files are missing. Do you want to download missing assets?','ALOSToy Installer','YesNoCancel','Error')"') do (
            if "%%E"=="Yes" (
                goto Files_DL
            ) else if "%%E"=="No" (
                set "errorcode=Local files are tampered with."
                goto Error
            ) else if "%%E"=="Cancel" (
                if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
            )
        )
    )
) else if /i "!product!"=="Extended" (
    set "OK=0"
    set "Required=8"
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_1.7z" "!EXHashA!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_2.7z" "!EXHashB!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_3.7z" "!EXHashC!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_4.7z" "!EXHashD!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_5.7z" "!EXHashE!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_6.7z" "!EXHashF!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_7.7z" "!EXHashG!" PreserveBad
    call :Hashing "!dir!\ALOSToy_v1.0_EXT_Part_8.7z" "!EXHashH!" PreserveBad
    if !OK! equ !Required! (
        set "Located=1"
        goto Extract
    ) else (
        for /f "delims=" %%E in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Either one or more hashes do not match or some files are missing. Do you want to download missing assets?','ALOSToy Installer','YesNoCancel','Error')"') do (
            if "%%E"=="Yes" (
                goto Files_DL
            ) else if "%%E"=="No" (
                set "errorcode=Local files are tampered with."
                goto Error
            ) else if "%%E"=="Cancel" (
                if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (set "ResetVars=1" & goto Main)
            )
        )
    )
) else (
    if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1) else (goto Main)
)
:Extract
mode con: cols=130 lines=!Lines!
cls
set "wins=0"
set stdext_wins=0
echo !CmdEchoing!
cd "!Root!"
if /i "!product!"=="Standard" (
    rem Use a for loop over ALOSToy_v1.0_STD*.7z to allow showing the progress from 1-4.
    for /l %%Y in (1,1,4) do (
        cls
        set "Archive_Part=%%Y"
        if "!InstallExtensions!"=="True" (set "Parts=6") else (set "Parts=4")
        call :WindowTitle "Installing ALOSToy !product!"
        echo =======================================
        echo Copying files for ALOSToy Standard to
        echo Drive !drivepath!
        echo =======================================
        echo Extracting Part !Archive_Part! of !Parts!...
        echo =======================================
        if defined dir ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!dir!\ALOSToy_v1.0_STD_Part_%%Y.7z" >> "!logfile!") else ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!Root!\files\ALOSToy_v1.0_STD_Part_%%Y.7z" >> "!logfile!")
        if !errorlevel! leq 1 (
            set /a "wins+=1"
        ) else (
            if !errorlevel! equ 2 (
                echo FATAL ERROR!!!!!! Something went wrong critically.
            ) else if !errorlevel! equ 7 (
                echo COMMAND LINE ERROR! There was an issue with the syntax.
            ) else if !errorlevel! equ 8 (
                echo MEMORY ERROR! Not enough memory to continue.
            ) else if !errorlevel! equ 255 (
                echo PROCESS STOPPED! The user canceled the operation.
            ) else if !errorlevel! equ 9009 (
                echo COMMAND NOT RECOGNISED!!!!
            ) else (
                echo We have returned with !errorlevel!.
            )
        )
    )
    if !wins! geq 4 (
        if /i "!InstallExtensions!"=="True" goto Extract_Extensions
        goto End
    )
) else if "!product!"=="Extended" (
    rem Use a for loop over ALOSToy_v1.0_EXT*.7z to allow showing the progress from 1-8.
    for /l %%Y in (1,1,8) do (
        cls
        set "Archive_Part=%%Y"
        set "Parts=8"
        call :WindowTitle "Installing ALOSToy !product!"
        echo =======================================
        echo Copying files for ALOSToy Extended to
        echo Drive !drivepath!
        echo =======================================
        echo Extracting Part !Archive_Part! of !Parts!...
        echo =======================================
        if defined dir ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!dir!\ALOSToy_v1.0_EXT_Part_%%Y.7z" >> "!logfile!") else ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!Root!\files\ALOSToy_v1.0_EXT_Part_%%Y.7z" >> "!logfile!")
        if !errorlevel! leq 1 (
            set /a "wins+=1"
        ) else (
            if !errorlevel! equ 2 (
                echo FATAL ERROR!!!!!! Something went wrong critically.
            ) else if !errorlevel! equ 7 (
                echo COMMAND LINE ERROR! There was an issue with the syntax.
            ) else if !errorlevel! equ 8 (
                echo MEMORY ERROR! Not enough memory to continue.
            ) else if !errorlevel! equ 255 (
                echo PROCESS STOPPED! The user canceled the operation.
            ) else if !errorlevel! equ 9009 (
                echo COMMAND NOT RECOGNISED!!!!
            ) else (
                echo We have returned with !errorlevel!.
            )
        )
    )
    if !wins! geq 8 goto End
) else (
    echo Product is undefined.
    timeout /t 3 /NOBREAK >nul
    set "errorcode=Product is undefined."
    goto Error
)
timeout /t 3 /NOBREAK >nul
set "errorcode=Failed extraction of archives."
goto Error
:Extract_Extensions
mode con: cols=130 lines=!Lines!
cls
echo !CmdEchoing!
set "stdext_parts=0"
if defined dir (
    if exist !dir!\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z set /a "stdext_parts+=1"
    if exist !dir!\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z set /a "stdext_parts+=1"
    if !stdext_parts! lss 2 (
        echo You do not have enough parts to install extensions. Please locate them.
        for /f "delims=" %%B in ('folderbrowse.exe "Please select the directory with the missing extension files. Both Part 1 and 2 must be present." 3') do set "dir=%%B"
        if /i "!dir!"=="None" goto Extract_Extensions
    )
) else (
    if exist !Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_1.7z set /a "stdext_parts+=1"
    if exist !Root!files\Extensions_For_ALOSToy_v1.0_STD_Part_2.7z set /a "stdext_parts+=1"
    if !stdext_parts! lss 2 (
        echo You do not have enough parts to install extensions. Please locate them.
        for /f "delims=" %%B in ('folderbrowse.exe "Please select the directory with the missing extension files. Both Part 1 and 2 must be present." 3') do set "dir=%%B"
        if /i "!dir!"=="None" goto Extract_Extensions
    )
)
cls
echo !CmdEchoing!
rem Use a for loop over Extensions_For_ALOSToy_v1.0_STD*.7z to allow showing the progress from 1-2.
rem But add 1 and 2 by 4 to show a continuation from 5-6.
for /l %%Y in (1,1,2) do (
    cls
    set "Parts=6"
    echo !CmdEchoing!
    set "Archive_Part=%%Y"
    set /a "Archive_Part+=4"
    call :WindowTitle "INSTALLING THE EXTENSIONS"
    echo =======================================
    echo Copying files for ALOSToy Standard to
    echo Drive !drivepath!
    echo =======================================
    echo Extracting Part !Archive_Part! of !Parts!...
    echo =======================================
    if defined dir ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!dir!\Extensions_For_ALOSToy_v1.0_STD_Part_%%Y.7z" >> "!logfile!") else ("!Root!bin\7-Zip\!Arch!\7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!drivepath!:\" "!Root!\files\Extensions_For_ALOSToy_v1.0_STD_Part_%%Y.7z" >> "!logfile!")
    if !errorlevel! leq 1 (
        echo Success.
        set /a stdext_wins+=1
    ) else (
        if !errorlevel! equ 2 (
            echo FATAL ERROR!!!!!! Something went wrong critically.
        ) else if !errorlevel! equ 7 (
            echo COMMAND LINE ERROR! There was an issue with the syntax.
        ) else if !errorlevel! equ 8 (
            echo MEMORY ERROR! Not enough memory to continue.
        ) else if !errorlevel! equ 255 (
            echo PROCESS STOPPED! The user canceled the operation.
        ) else if !errorlevel! equ 9009 (
            echo COMMAND NOT RECOGNISED!!!!
        ) else (
            echo We have returned with !errorlevel!.
        )
    )
)
if !stdext_wins! lss 2 (
    set "errorcode=Failed extraction of archives."
    goto Error
) else (
    goto End
)
:End
mode con: cols=!Columns! lines=!Lines!
cls
set "Archive_Part="
set "Part="
set "Parts="
call :WindowTitle "ALOSToy !product! Installed"
label !drivepath!: !label! >nul 2>&1
echo ALOSToy v1.0 !product! installed to !drivepath!:\>> "!logfile!"
echo ALOSToy v1.0 !product! has been successfully installed.
rem !Root! has trailing slash at the end. Writing !Root!\ would be unnecessary because it would just add another unnecessary trailing slash.
if /i "!product!"=="Standard" (
    if /i "!InstallExtensions!"=="True" (
        copy "!database_stdext!" "!drivepath!:\ALOSToy_v1.0_Standard_With_Extensions.md5" /Y >nul 2>&1
        cd /d "!drivepath!:\"
        start QuickSFV.exe ALOSToy_v1.0_Standard_With_Extensions.md5
        cd "!Root!"
    ) else (
        cd /d "!drivepath!:\"
        copy "!database_std!" "!drivepath!:\ALOSToy_v1.0_Standard.md5" /Y >nul 2>&1
        start QuickSFV.exe ALOSToy_v1.0_Standard.md5
        cd "!Root!"
    )
) else if /i "!product!"=="Extended" (
    cd /d "!drivepath!:\"
    copy "!database_ext!" "!drivepath!:\ALOSToy_v1.0_Extended.md5" /Y >nul 2>&1
    start QuickSFV.exe ALOSToy_v1.0_Extended.md5
    cd "!Root!"
) else (
    echo No product.
    endlocal
    exit 2
)
echo !CmdEchoing!
if exist "!Root!Ventoy2Disk" rd "!Root!Ventoy2Disk" /s /q
if "!Located!"=="0" (for /f "delims=" %%D in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Do you want to remove the ALOSToy archives? The choice is yours.','ALOSToy Installer','YesNo','Question')"') do (if "%%D"=="Yes" (if exist "!Root!files" rd "!Root!files" /s /q) else if "%%D"=="No" (echo !CmdEchoing!)))
goto EndChoices
:EndChoices
if "!ShowBanner!"=="Yes" if "!BannerReShown!"=="False" (
    call :WindowTitle "THANK YOU FOR INSTALLING ALOSTOY !PRODUCT!."
    call :Banner_Art /PostInstall
    set "BannerReShown=True"
    if "!AlwaysShowBanner!"=="Yes" set "BannerReShown=False"
)
label !drivepath!: !label! >nul 2>&1
cls
if exist "!drivepath!:\ventoyversion.txt" del "!drivepath!:\ventoyversion.txt" /f /q
rem Now show the choices or a success message and exit depending on if the product was defined with an argument.
if /i "!ProductDefinedWithArg!"=="True" (
    call :ExitMessages "Normal"
    endlocal
    rem Exit the script with code 0. Do it twice and goto eof to ensure fully closed.
    exit 0
    exit 0
    goto :eof
) else (
    label !drivepath!: !label! >nul 2>&1
    call :PowerShell_Helper "FinishUp-Choices"
    call Button 5 5 F4 "Quit The Installer" 30 5 F1 "Reboot To Firmware Setup" 60 5 F2 "Return to Main Menu (As In Do Another Installation)"  X _Var_Box _Var_Hover
    echo.
    echo.
    echo.
    call :PowerShell_Helper "FinishUp-Warning"
    GetInput /M !_Var_Box! /H !_Var_Hover! 
    if "!errorlevel!"=="1" (
        cls
        echo !CmdEchoing!
        echo Exiting...
        label !drivepath!: !label! >nul 2>&1
        call :ExitMessages
        endlocal
        rem Exit the script with code 0. Do it twice and goto eof to ensure fully closed.
        exit 0
        exit 0
        goto :eof
    ) else if "!errorlevel!"=="2" (
        cls
        echo !CmdEchoing!
        echo Rebooting to firmware setup...
        taskkill /f /im explorer.exe >nul 2>&1
        label !drivepath!: !label! >nul 2>&1
        call :ExitMessages
        shutdown /r /fw /t 3
        endlocal
        rem Exit the script with code 0. Do it twice and goto eof to ensure fully closed.
        exit 0
        exit 0
        goto :eof
    ) else if "!errorlevel!"=="3" (
        cls
        echo !CmdEchoing!
        set "RedoInstall=Yes"
        set "ResetVars=1"
        call :ExitMessages "Normal"
        call :WindowTitle "BACK FOR ANOTHER INSTALLATION."
        echo Returning to main menu...
        cd /d "!Root!"
        if "!NeverShowBanner!"=="Yes" (
            set "BannerReShown=True"
            set "BannerShown=False"
        ) else if "!AlwaysShowBanner!"=="Yes" (
            set "BannerReShown=False"
            set "BannerShown=False"
        ) else (
            set "BannerReShown=False"
            set "BannerShown=False"
        )
        goto Main
    ) else (
        echo Do not press keys. Click buttons instead.
        echo Return Code: !errorlevel!
        pause
        label !drivepath!: !label! >nul 2>&1
        cls
        goto EndChoices
    )
)
:Verify_Files
call :WindowTitle "VERIFY INSTALLATION"
cls
echo !CmdEchoing!
if "!Selected!" neq "True" for /f "delims=" %%D in ('folderbrowse.exe "Select the drive where ALOSToy was installed to."') do set "drivepath=%%D"
if /i "!drivepath!"=="None" (
    goto Main
) else if /i "!drivepath:~0,2!"=="!SYSTEMDRIVE!" (
    echo It is definitely not your !SYSTEMDRIVE! drive.
    echo.
    echo Press any key to reselect a drive...
    pause >nul
    set "drivepath="
    goto Verify_Files
)
set "Selected=True"
echo Please decide which installation you have. (Drive Selected: !drivepath!)
call Button 10 6 F4 "ALOSToy Standard" 35 6 F2 "ALOSToy Extended" 60 6 F6 "ALOSToy Standard With Extensions" 100 6 F1 "Auto-Detect" X _Var_Box _Var_Hover
echo.
echo.
echo.
echo Click one of the 4 buttons to select your edition or press any key to return to main menu.
GetInput /M !_Var_Box! /H !_Var_Hover! 
if "!errorlevel!"=="1" (
    cls
    echo !CmdEchoing!
    cd "!Root!bin"
    if not exist "!drivepath!ALOSToy_v1.0_Standard.md5" copy "!database_std!" "!drivepath!ALOSToy_v1.0_Standard.md5" /Y >nul 2>&1
    cd /d "!drivepath!"
    start QuickSFV.exe ALOSToy_v1.0_Standard.md5
    cd "!Root!"
     set "Selected=False"
    goto Main
) else if "!errorlevel!"=="2" (
    cls
    echo !CmdEchoing!
    cd "!Root!bin"
    if not exist "!drivepath!ALOSToy_v1.0_Extended.md5" copy "!database_ext!" "!drivepath!ALOSToy_v1.0_Extended.md5" /Y >nul 2>&1
    cd /d "!drivepath!"
    start QuickSFV.exe ALOSToy_v1.0_Extended.md5
    cd "!Root!"
    set "Selected=False"
    goto Main
) else if "!errorlevel!"=="3" (
    cls
    echo !CmdEchoing!
    cd "!Root!bin"
    if not exist "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" copy "!database_stdext!" "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" /Y >nul 2>&1
    cd /d "!drivepath!"
    start QuickSFV.exe ALOSToy_v1.0_Standard_With_Extensions.md5
    cd "!Root!"
    set "Selected=False"
    goto Main
) else if "!errorlevel!"=="4" (
    rem You can auto-detect the edition if the ALOSToy_Edition.txt file is there.
    cls
    echo !CmdEchoing!
    cd "!Root!bin"
    set /p Edition= <!drivepath!System\ALOSToy_Edition.txt
    echo Detected ALOSToy edition is !Edition!.
    if /i "!Edition!"=="Standard" (
        if not exist "!drivepath!ALOSToy_v1.0_Standard.md5" copy "!database_std!" "!drivepath!ALOSToy_v1.0_Standard.md5" /Y >nul 2>&1
        cd /d "!drivepath!"
        start QuickSFV.exe ALOSToy_v1.0_Standard.md5
    ) else if /i "!Edition!"=="Standard With Extensions" (
        if not exist "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" copy "!database_stdext!" "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" /Y >nul 2>&1
        cd /d "!drivepath!"
        start QuickSFV.exe ALOSToy_v1.0_Standard_With_Extensions.md5
    ) else if /i "!Edition!"=="Extended" (
        if not exist "!drivepath!ALOSToy_v1.0_Extended.md5" copy "!database_ext!" "!drivepath!ALOSToy_v1.0_Extended.md5" /Y >nul 2>&1
        cd /d "!drivepath!"
        start QuickSFV.exe ALOSToy_v1.0_Extended.md5
    ) else (
        start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('No ALOSToy edition detected.','ALOSToy Installer','OK','Error') | Out-Null"
        goto Verify_Files
    )
    cd "!Root!"
    set "Selected=False"
    set "Edition="
    goto Main
) else (
    echo Returning to main menu.
    set "Selected=False"
    set "drivepath="
    timeout /t 1 /NOBREAK >nul
    goto Main
)
:Del_Verification_DBs
call :WindowTitle "DELETE LEFTOVER VERIFICATION DATABASES"
cls
cd "!Root!bin"
if "!Selected!" neq "True" for /f "delims=" %%D in ('folderbrowse.exe "Select the drive you have previously verified ALOSToy on. If you think there are leftover md5 files on there, locate it now."') do set "drivepath=%%D"
if /i "!drivepath!"=="None" (
    goto Main
) else if /i "!drivepath:~0,2!"=="!SYSTEMDRIVE!" (
    echo It is definitely not your !SYSTEMDRIVE! drive.
    echo.
    echo Press any key to reselect a drive...
    pause >nul
    set "drivepath="
    goto Del_Verification_DBs
)
set "Selected=True"
echo Please select which ones to cleanup now. (Drive Selected: !drivepath!)
call Button 5 6 F4 "ALOSToy Standard" 30 6 F2 "ALOSToy Extended" 55 6 F6 "ALOSToy Standard With Extensions" 95 6 F1 "Auto-Detect" X _Var_Box _Var_Hover
echo.
echo.
echo.
echo Or you can press any key to return to the main menu.
GetInput /M !_Var_Box! /H !_Var_Hover! 
rem !drivepath! will have a trailing slash in it. !drivepath! would expand to something like D:\ but !drivepath!\ would expand to something like D:\\.
if "!errorlevel!"=="1" (
    cls
    echo Deleting !drivepath!ALOSToy_v1.0_Standard.md5 database...
    if exist "!drivepath!ALOSToy_v1.0_Standard.md5" del "!drivepath!ALOSToy_v1.0_Standard.md5" /f /q >nul
) else if "!errorlevel!"=="2" (
    cls
    echo Deleting !drivepath!ALOSToy_v1.0_Extended.md5 database...
    if exist "!drivepath!ALOSToy_v1.0_Extended.md5" del "!drivepath!ALOSToy_v1.0_Extended.md5" /f /q >nul
) else if "!errorlevel!"=="3" (
    cls
    echo Deleting !drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5 database...
    if exist "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" del "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" /f /q >nul
) else if "!errorlevel!"=="4" (
    rem You can auto-detect the edition if the ALOSToy_Edition.txt file is there.
    cls
    set /p Edition= <!drivepath!System\ALOSToy_Edition.txt
    if /i "!Edition!"=="Standard" (
        if exist "!drivepath!ALOSToy_v1.0_Standard.md5" (
            echo Deleting !drivepath!ALOSToy_v1.0_Standard.md5 database...
            del "!drivepath!ALOSToy_v1.0_Standard.md5" /f /q >nul
        )
    ) else if /i "!Edition!"=="Standard With Extensions" (
        if exist "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" (
            echo Deleting !drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5 database...
            del "!drivepath!ALOSToy_v1.0_Standard_With_Extensions.md5" /f /q >nul
        )
    ) else if /i "!Edition!"=="Extended" (
        if exist "!drivepath!ALOSToy_v1.0_Extended.md5" (
            echo Deleting !drivepath!ALOSToy_v1.0_Extended.md5 database...
            del "!drivepath!ALOSToy_v1.0_Extended.md5" /f /q >nul
        )
    ) else (
        start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('No ALOSToy edition detected.','ALOSToy Installer','OK','Error') | Out-Null"
        goto Del_Verification_DBs
    )
) else (
    echo.
    echo Returning to main menu...
    set "Selected=False"
    set "drivepath="
    timeout /t 1 /NOBREAK >nul
    goto Main
)
if exist "!drivepath!ventoyversion.txt" del "!drivepath!ventoyversion.txt" /f /q
echo Cleanup complete.
echo Press any key to return to the main menu...
set "Selected=False"
set "drivepath="
pause >nul
goto Main
:Error
cls
echo !CmdEchoing!
call :WindowTitle "AN ERROR HAS OCCURRED. CHECK THE ERROR CODE."
if not defined errorcode exit /b 1
if "!ProductDefinedWithArg!"=="True" set "RequiresExit=True"
echo Sorry !USERNAME!^^! We encountered errors and we could not install ALOSToy !product!. We apologise for the errors but the installation did not succeed.
echo Error code: !errorcode!
echo Logfile (send to !Author! for help or look at it yourself): !logfile!
timeout /t 3 /NOBREAK >nul
if /i "!ProductDefinedWithArg!"=="False" if /i "!RequiresExit!"=="False" (
    for /f "delims= " %%E in ('powershell -nop -nol -ExecutionPolicy Bypass -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('You can always retry the installation though. Do you want to retry?','ALOSToy Installer','YesNo','Question')"') do (
        if /i "%%E"=="Yes" (
            echo We will restart the installation from the beginning.
            timeout /t 1 /NOBREAK >nul
            set "RequiresExit=False"
            set "ResetVars=1"
            if "!Vtoy_DL_Mode!"=="0" (goto Main) else if "!Vtoy_DL_Mode!"=="1" (goto Vtoy_dl)
        ) else if /i "%%E"=="No" (
            echo Ok then.
        ) else (
            echo Not a valid choice for the question.
            pause
            goto Error
        )
    )
)
echo Press any key to quit...
pause >nul
endlocal
exit 1
:Help
set "BrowsingHelp=True"
if "!StartPage!"=="1" (goto Help1) else if "!StartPage!"=="2" (goto Help2) else if "!StartPage!"=="3" (goto Help3) else if "!StartPage!"=="4" (goto Help4) else if "!StartPage!"=="5" (goto Help5) else if "!StartPage!"=="6" (goto Help6) else if "!StartPage!"=="7" (goto Help7) else if "!StartPage!"=="8" (goto Help8) else if "!StartPage!"=="9" (goto Help9) else if "!StartPage!"=="10" (goto Help10) else if "!StartPage!"=="" (set "StartPage=1" & goto Help1) else (endlocal & exit 8)
:Help1
call :HelpTitle 1
echo.
echo    /NoBanner
echo    -NoBanner
echo    --No-Banner
echo        Do not show my amazing banner when starting and ending an installation.
echo.
echo    /ForceBanner
echo    -ForceBanner
echo    --Force-Banner
echo        Always show my amazing banner when starting and ending an installation.
echo.
echo    /LogFile  ^<path^>
echo    -LogFile  ^<path^>
echo    --LogFile ^<path^>
echo        Changes the logfile path to the specified file path.
echo.
echo    /SaveLocation    ^<SaveLocation ^| Prompt^>
echo    -SaveLocation    ^<SaveLocation ^| Prompt^>
echo    --Save-Location  ^<SaveLocation ^| Prompt^>
echo        Specifies the location to save.
echo        Or you can input "Prompt" to interactively select the save location.
echo        You must use this argument with /DownloadVentoyVersion, -DownloadVentoyVersion or --Download-Ventoy-Version.
echo        This is not compatible on it's own without that parent argument mentioned above.
echo.
choice /c FE /n /m "Turn the page forward or exit? [F or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help2
) else if "!errorlevel!"=="2" (
    goto HelpExit
) else (
    goto Help1
)
:Help2
call :HelpTitle 2
echo.
echo    /Product  ^<edition^>
echo    -Product  ^<edition^>
echo    --Product ^<edition^>
echo        Selects the ALOSToy edition. Valid values are:
echo            Standard
echo            Extended
echo            Standard+Extensions (Standard With Extensions)
echo        You can also pass: /VentoyInstallType, -VentoyInstallType or --Ventoy-Install-Type.
echo.
echo    /VentoyVersion   ^<version^>
echo    -VentoyVersion   ^<version^>
echo    --Ventoy-Version ^<version^>
echo        Force the installer to download a specific version of Ventoy instead of the latest.
echo        Version syntax for Ventoy is 1.X.XX.
echo.
echo    /DownloadVentoyVersion    ^<version ^| Latest^>
echo    -DownloadVentoyVersion    ^<version ^| Latest^>
echo    --Download-Ventoy-Version ^<version ^| Latest^>
echo        Same idea as the VentoyVersion argument but ONLY download that version and exit afterward.
echo        Version syntax for Ventoy is 1.X.XX.
echo        Or you can input "Latest" to grab the latest version.
echo        You must use this with the SaveLocation parameter (/SaveLocation, -SaveLocation or --Save-Location).
echo.
choice /c FBE /n /m "Turn back a page, turn forward a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help3
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help1
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help2
)
:Help3
call :HelpTitle 3
echo     /NoUpdate
echo     -NoUpdate
echo     --No-Update
echo         Tells the installer not to update.
echo          It does not matter if there is a new update, it will not when specified.
echo          Useful for keeping the same version for longer.
echo.
echo      /ForceUpdate
echo      -ForceUpdate
echo      --Force-Update
echo         Tells the installer to forcibly update even if no new version.
echo         It does not matter if there is not a new update, it will update to the newest or current version.
echo         No questions asked. Useful for reverting unwanted local changes.
echo.
echo     /AutoUpdate
echo     -AutoUpdate
echo     --Auto-Update
echo         Enables automatic update. If an update is found, it applies the new update
echo         without prompting you. This can save some headache of clicking the button
echo         to choose if you want to apply new updates. Useful if you want the latest
echo         version without be nagged for clicks.
echo.
echo   All of these options can be used with any other argument or switch.
choice /c FBE /n /m "Turn back a page, turn forward a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help4
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help2
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help3
)
:Help4
call :HelpTitle 4
echo.
echo   Examples:
echo       !Script! /NoBanner /LogFile C:\Logs\%~n0.log /Product Standard
echo       !Script! /Product Extended /VentoyVersion 1.1.00
echo       !Script! /Product Standard+Extensions /ForceBanner /VentoyVersion 1.1.00
echo       !Script! /DownloadVentoyVersion 1.1.00 /SaveLocation D:\Data\Ventoy\versions
echo       !Script! /DownloadVentoyVersion Latest /SaveLocation Prompt
echo.
echo       !Script! -NoBanner -LogFile C:\Logs\%~n0.log -Product Standard
echo       !Script! -Product Extended -VentoyVersion 1.1.00
echo       !Script! -Product Standard+Extensions -ForceBanner -VentoyVersion 1.1.00
echo       !Script! -DownloadVentoyVersion 1.1.00 -SaveLocation D:\Data\Ventoy\versions
echo       !Script! -DownloadVentoyVersion Latest -SaveLocation Prompt
echo.
echo       !Script! --No-Banner --LogFile C:\Logs\%~n0.log --Product Standard
echo       !Script! --Product Extended --Ventoy-Version 1.1.00
echo       !Script! --Product Standard+Extensions -ForceBanner --Ventoy-Version 1.1.00
echo       !Script! --Download-Ventoy-Version 1.1.00 --Save-Location D:\Data\Ventoy\versions
echo       !Script! --Download-Ventoy-Version Latest --Save-Location Prompt
echo.
echo You are not able to input spaces into the SaveLocation or
echo the LogFile arguments. I know. Cmd.exe parses %%* weirdly
echo and there is nothing I can do about it^^!
echo.
choice /c FBE /n /m "Turn back a page, turn forward a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help5
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help3
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help4
)
:Help5
call :HelpTitle 5
echo HELP SWITCHES:
echo    /Help, -Help, --Help, /H, -H, --H, /?, -?, --?
echo    Displays the help menu and usage instructions.
echo    Call this to get help and I will help you understand the command line.
echo    You can also use:
echo.
echo ALOSTOY LOGO BANNER ART:
echo.
echo    /NoBanner, -NoBanner, --No-Banner
echo    This can inhibit showing my banner at pre-install and post-install.
echo    It will skip the lovely banner that I spent a long time making. :(
echo.
echo    /ForceBanner, -ForceBanner, --Force-Banner
echo    Always force my banner to show no matter what.
echo    Takes priority over /NoBanner if both are provided.
echo    My branding will always show no matter what. :)
echo.
echo LOGFILE:
echo.
echo    /LogFile, -LogFile, --LogFile ^<path^>
echo    Specifies a custom log file path.
echo    If a path is provided, it can start else, it ignores your argument.
echo.
choice /c FBE /n /m "Turn back a page, turn forward a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help6
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help4
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help5
)
:Help6
call :HelpTitle 6
echo PRODUCT SELECTION:
echo.
echo    /Product, -Product, --Product ^<value^>
echo    Choose a product to install.
echo    Valid values are:
echo        Standard
echo        Extended
echo        Standard+Extensions (Standard With Extensions)
echo    IF THIS PARAMETER IS USED, THE INSTALLER WILL EXIT AFTER INSTALL OR ON ERROR^^!
echo    With this, you can pre-select an edition and automate some installation steps.
echo    Valid values for the Ventoy Install Type argument are "Install" or "Update"^^!
echo.
echo VENTOY VERSION:
echo.
echo    /VentoyVersion, -VentoyVersion, --Ventoy-Version ^<version^>
echo    Sets the Ventoy version to use.
echo    Must match format: 1.X.XX (only numbers can be used).
echo    Example: !EgVer!
echo    There are a few versions that are deprecated by Ventoy so you can't use those.
echo    Type correctly or else you can get an error. (I love regex... (^^1\.\d\.\d{2}$))
echo.
choice /c FBE /n /m "Turn back a page, turn forward a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help7
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help5
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help6
)
:Help7
call :HelpTitle 7
echo VENTOY DOWNLOAD MODE:
echo.
echo    /DownloadVentoyVersion, -DownloadVentoyVersion, --Download-Ventoy-Version ^<version^>
echo    Downloads a specific Ventoy version and exits afterward.
echo    Requires an additional parameter:
echo        /SaveLocation, -SaveLocation, --Save-Location ^<path ^| Prompt^>
echo        Defines where the downloaded file will be saved.
echo        You can interactively select a location by supplying "Prompt".
echo        Do not miss out this parameter. It will exit otherwise.
echo        Must match format: 1.X.XX (only numbers can be used).
echo        There are a few versions that are deprecated by Ventoy so you cannot use those.
echo.
echo NOTICE THAT: Parameters are case-insensitive and if you type something invalid in, it will exit.
echo    You can combine lots of parameters together in harmony.
echo    YOU can choose your prefix for arguments^^! Either /, - or --^^!
echo    NEVER USE AN INVALID SYNTAX. I will exit if you do^^!
echo    If you were born by GNU operating systems, you know all the arguments in here
echo    are case-sensitive JUST FOR YOU. Obviously, I care about your expectations.
echo.
echo If you start in Ventoy Download Mode, you WILL get a different EULA.
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help8
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help6
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help7
)
:Help8
call :HelpTitle 8
echo INSTALLER UPDATES CONTROL (I KNOW. WOW.):
echo.
echo     /NoUpdate, -NoUpdate, --No-Update
echo         You can force !Script! not to update itself even if there is new version.
echo         This lets you admire your current version and maybe say your last words
echo         before you decide to update (It will not update with this flag).
echo         Useful when you desperately want to hang on to that version (!Version!)
echo         or if you believe that this is reliable for you. :)
echo         It works totally fine on human beings that just want to use the current
echo         version already. Your current version (!Version!) stays as it is. Be happy. :)
echo.
echo     /ForceUpdate, -ForceUpdate, --Force-Update
echo         You could use this flag to forcibly update from !Version! to whatever future
echo         version exists. Like you may not know but I do. It happens even when !Script!
echo         is the latest version I have to offer. Useful when you desperately need to restore a good
echo         copy of !Script! that definitely did not go through local editing and breaking.
echo.
echo     /AutoUpdate, -AutoUpdate, --Auto-Update
echo         You can use this flag to automatically update the program if a new version
echo         is found. It is like how in some batch utilities automatically apply the newest
echo         update without asking the user. We normally ask you if you want to update.
echo         If you already pre-consent, use this flag to automatically apply the newest version.
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help9
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help7
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help8
)
:Help9
call :HelpTitle 9
echo.
choice /c SV /n /m "Press S to show the standard EULA or V to show the Ventoy Download Mode EULA. (You have 5 seconds.)" /t 5 /d S
if "!errorlevel!"=="1" (
    echo.
    echo ====================================================
    echo              ALOSToy Installer v!Version!
    echo ====================================================
    echo Author: !Author!
    echo.
    echo END USER LICENSE AGREEMENT
    echo.
    echo By using this software, you agree to the following:
    echo - This tool is provided "as-is" with no warranty.
    echo - You are responsible for any changes made to your system.
    echo - Redistribution or modification is allowed only with credit.
    echo - The author is not liable for any damage or data loss.
    echo - Under GPLv3, you are required to provide source code if modified,
    echo - license under the GPLv3 license and pass freedoms to others.
    if "!Or-Any-Later-Version!"=="False" (
        echo - You are not permitted to distribute this under any other license
        echo - other than the GNU General Public License v3.0. Combination with
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo - You are permitted to distribute this under any later version of
        echo - the GNU General Public License v3 or just GPLv3. Combination with
    )
    echo - GNU General Public License v1 or v2 code is legally prohibited.
    echo - The author is not liable for any damage or data loss.
    echo - !Author! does not condone any damage whatsoever.
    echo - USE AT YOUR OWN RISK.
) else if "!errorlevel!"=="2" (
    echo ====================================================
    echo            ALOSToy Installer v!Version!
    echo ====================================================
    echo Author: !Author!
    echo.
    echo END USER LICENSE AGREEMENT
    echo.
    echo By using this software, you agree to the following:
    echo - Ventoy and this tool are provided "as-is" with no warranty.
    echo - Ventoy Download Mode will grab a specific version for you.
    echo - You must not misuse the software or it's owner to deploy malware.
    echo - You must use Ventoy properly.
    echo - Under GPLv3, you are required to provide source code if modified,
    echo - license under the GPLv3 license and pass freedoms to others.
    if "!Or-Any-Later-Version!"=="False" (
        echo - You are not permitted to distribute this under any other license
        echo - other than the GNU General Public License v3.0. Combination with
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo - You are permitted to distribute this under any later version of
        echo - the GNU General Public License v3 or just GPLv3. Combination with
    )
    echo - GNU General Public License v1 or v2 code is legally prohibited.
    echo - The author is not liable for any damage or data loss.
    echo - !Author! does not condone any damage whatsoever.
    echo - USE AT YOUR OWN RISK.
) else (
    goto Help9
)
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto Help10
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help8
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help9
)
:Help10
call :HelpTitle 10
echo.
echo I embedded PowerShell in my batch script. It is perfect. Here is how I do it:
echo I have a subroutine at the bottom of my script called PowerShell_Helper.
echo What it does is call PowerShell with the specified block to call.
echo PowerShell will read all text in a specified section and execute that code. Eg:
echo ========================================================================================================================
echo echo PowerShell will read all text in :RunPS to :Post_RunPS.
echo call :PowerShell_Helper "RunPS"
echo :RunPS
echo # This is inside PowerShell!
echo Write-Host "Hello from PowerShell."
echo Write-Host "I am so happy about embedding PS in batch."
echo $number1 = 37
echo $number2 = 78
echo Write-Host "The addition of $number1 + $number2 = $($number1 + $number2)."
echo Exit 0
echo :Post_RunPS
echo echo PowerShell ends and returns to batch.
echo ========================================================================================================================
echo This is the perfect example of embedding pure PowerShell code in the same batch script.
echo Just make sure you jump to the :Post_ block afterward otherwise (if it is necessary), you may run into errors.
echo To retrive the command to do it yourself, press C on your keyboard. (Replace "YourPSBlock" with your actual block name
echo once copied to clipboard.)
echo.
choice /c CBE /n /m "Copy command to clipboard, turn back a page or exit? (Note: You have reached the end of the guide.) [C, B or E]"
if "!errorlevel!"=="1" (
    cls
    start /b powershell -nop -nol -c "Set-Clipboard ([string]::Concat('powershell -nop -nol -c ',[char]34,'chcp 65001 > $null; $i18n = New-Object System.Text.UTF8Encoding; [Console]::InputEncoding = $i18n; [Console]::OutputEncoding = $i18n; $OutputEncoding = $i18n; $section = [io.file]::ReadAllText(''%%~f0'') -split ''(?ms)^:YourPSBlock\r?\n(.*?)\r?\n:Post_YourPSBlock''; & ([scriptblock]::Create($section[1]))',[char]34)); if ($?) { Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Command has been copied to clipboard.','ALOSToy Installer','OK','Info') | Out-Null; Exit 0 } else { Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Command could not be copied to clipboard','ALOSToy Installer','OK','Error') | Out-Null; Exit 1 }" >nul 2>&1
    goto Help10
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto Help9
) else if "!errorlevel!"=="3" (
    goto HelpExit
) else (
    goto Help10
)
:HelpExit
cls
set "BrowsingHelp=False"
call :WindowTitle "GOOD LUCK WITH THE ARGUMENTS."
if "!ArgPrefix!"=="--" (powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.Messagebox]::Show(\"If you prefer to use ${env:ArgPrefix}, then all arguments are case-sensitive. Type it exactly as I show you.!NewLine!!NewLine!You must use the same prefix for all arguments.!NewLine!!NewLine!Choose a prefix and use that only. ^(Only per session.^)!NewLine!!NewLine!Like !ArgPrefix! for example.!NewLine!!NewLine!Using / or - makes them case-insensitive.\",'ALOSToy Installer','OK','Info') | Out-Null; [System.Windows.Messagebox]::Show(\"You probably came from GNU linux and programs. Most likely, --long-options are familiar with you. All arguments ARE case-sensitive for you. Every single one. I know your habits for case-sensitivity. Use Train-Case.!NewLine!!NewLine!Like --Ventoy-Version for example.\",'ALOSToy Installer','OK','Info') | Out-Null") else (powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.Messagebox]::Show(\"If you prefer to use ${env:ArgPrefix}, then all arguments are case-insensitive. You do not have to worry about casing.!NewLine!!NewLine!You must use the same prefix for all arguments.!NewLine!!NewLine!Choose a prefix and use that only. ^(Only per session.^)!NewLine!!NewLine!Like !ArgPrefix! for example.!NewLine!!NewLine!Using -- makes them case-sensitive.\",'ALOSToy Installer','OK','Info') | Out-Null")
title 
if "!HelpFromMain!"=="1" (
    set "HelpFromMain=0"
    goto Main
) else if "!HelpFromMain!"=="0" (
    endlocal
    exit 0
)
:InstallHelpTitle
set "InstallGuidePage=%~1"
if defined PartMsg set "PartMsg="
cls
echo             ^˄^˄^˄^˄^˄^˄ ^|=============================================================================^| ^˄^˄^˄^˄^˄^˄
echo             ^<^<^<^<^<^< ^| ALOSToy Installation Help Guide (100%% Guaranteed To Make Your Life Better)  ^| ^>^>^>^>^>^>
echo             ^˅^˅^˅^˅^˅^˅ ^|=============================================================================^| ^˅^˅^˅^˅^˅^˅
echo [Page !InstallGuidePage! of !InstallGuidePages!]
echo.
call :WindowTitle "ALOSTOY INSTALLATION GUIDE"
goto :eof
:InstallGuide
set "BrowsingHelp=True"
if "!StartPage!"=="1" (goto InstallGuide1) else if "!StartPage!"=="2" (goto InstallGuide2) else if "!StartPage!"=="3" (goto InstallGuide3) else if "!StartPage!"=="4" (goto InstallGuide4) else if "!StartPage!"=="5" (goto InstallGuide5) else if "!StartPage!"=="6" (goto InstallGuide6) else if "!StartPage!"=="7" (goto InstallGuide7) else if "!StartPage!"=="8" (goto InstallGuide8) else if "!StartPage!"=="9" (goto InstallGuide9) else if "!StartPage!"=="10" (goto InstallGuide10) else if "!StartPage!"=="" (set "StartPage=1" & goto InstallGuide1) else (endlocal & exit 8)
:InstallGuide1
call :InstallHelpTitle 1
echo Welcome to the ALOSToy Installer^^!
echo.
echo This is the correct utility to install ALOSToy, a powerful
echo bootable USB drive that can save a computer and is more
echo modern than any other massive Ventoy USB. A brief overview:
echo.
echo This utility can save your life^^! It can create a bootable USB
echo drive that is jam-packed with diagnostic, password removal, live
echo antimalware, boot repair, partition, and imaging tools as well as
echo Windows PE environments, Linux repair disks to fix both Windows
echo and Linux and even forensic tools for deep investigation and
echo bit-for-bit clones. ALOSToy comes in 3 editions: Standard,
echo Standard+Extensions and Extended versions. Higher versions give
echo you OS installers pre-loaded for you. (I know.)
echo.
echo In theory, you can create the ultimate, bootable USB drive that will
echo grant your access to the massive variety of diagnostic and disaster
echo recovery tools.
echo.
echo Turn over to see the steps and troubleshooting. It will help you
echo install ALOSToy Standard or Extended onto a USB drive, HDD or SSD.
echo.
choice /c FE /n /m "Turn forward a page or exit? [F or E]"
if "!errorlevel!"=="1" (
     call :PageFlip
     goto InstallGuide2
) else if "!errorlevel!"=="2" (
    goto InstallGuideExit
) else (
    goto InstallGuide1
)
:InstallGuide2
call :InstallHelpTitle 2
echo PREPARE YOUR DRIVE AND RUN THE INSTALLER:
echo.
echo Prepare a USB drive. It needs to be at least 64GiB, 128GiB or 192GiB.
echo The size requirements for the Standard version is 64GiB without extensions
echo and 128GiB with the OS installer extensions. If you try to install with a
echo smaller size, we will stop you. The size requirements for the Extended version
echo is 192GiB. If you try to install with a smaller size, we will stop you. Try to
echo get a USB 3.2 Gen2 drive and plug it into the fastest port. Prefer USB 3.2 ports.
echo.
echo The next thing you want to do is double-click !Script!. It is very
echo important that you do not click "Run As Administrator" as that will set the working
echo directory to !SystemRoot!\System32 which can cause lots of missing file errors or
echo even inability to modify files. However, !Script! handles this edge case.
echo.
echo STARTUP ROUTINE:
echo.
echo !Script! will relaunch it self as administrator. Just click Yes to
echo the User Account Control prompt to continue. Then the installer
echo will run all it's checks like DNS, site connections, dependency
echo checks, update checks, and show the End User License Agreement.
echo.
echo Turn over to see the next part. (GO ON.)
echo.
choice /c FUBE /n /m "Turn forward a page, look for USB 3.2 Gen2 drives, turn back a page or exit? [F, U, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide3
) else if "!errorlevel!"=="2" (
    cls
    powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('My USB drive is the Samsung PSSD T9 1TB model. You do not have to get exactly that.','ALOSToy Installer','OK','Info') | Out-Null; [System.Windows.MessageBox]::Show('BE CAREFUL OF FAKE DRIVES. MANY NO-NAME BRANDS SELL LIKE \"1TB SSD\" FOR ABNORMALLY CHEAP. THESE DRIVES ACTUALLY USE GLORIFIED MICROSD CARDS WITH A FIRMWARE PROGRAMMED TO LIE TO ALL OPERATING SYSTEMS. MANY MICROSD CARDS THAT TECHNICIANS POPPED OUT OF FAKE DRIVES ARE INDEED JUST 64GIB OR LESS SO DATA CAN BE QUIETLY OVERWRITTEN ONCE ENOUGH FILES ARE WRITTEN.','ALOSToy Installer','OK','Warning') | Out-Null; [System.Windows.MessageBox]::Show('WE STRONGLY RECOMMEND VALIDATING THE USB DRIVE WITH VALIDRIVE, A POWERFUL FAKE DRIVE DETECTOR.','ALOSToy Installer','OK','Warning') | Out-Null"
    start https://bit.ly/3R9w9ZD
    start https://www.grc.com/validrive.htm
    goto InstallGuide2
) else if "!errorlevel!"=="3" (
    call :PageFlipBack
    goto :InstallGuide1
) else if "!errorlevel!"=="4" (
    goto InstallGuideExit
) else (
    goto InstallGuide2
)
:InstallGuide3
call :InstallHelpTitle 3
echo The End User License Agreement will show and you must agree to it by law.
echo Disagreeing exits !Script!. Here is the full EULA text:
choice /c SV /n /m "Press S to show the standard EULA or V to show the Ventoy Download Mode EULA. (You have 5 seconds.)" /t 5 /d S
if "!errorlevel!"=="1" (
    echo ====================================================
    echo              ALOSToy Installer v!Version!
    echo ====================================================
    echo Author: !Author!
    echo.
    echo END USER LICENSE AGREEMENT
    echo.
    echo By using this software, you agree to the following:
    echo - This tool is provided "as-is" with no warranty.
    echo - You are responsible for any changes made to your system.
    echo - Redistribution or modification is allowed only with credit.
    echo - Under GPLv3, you are required to provide source code if modified,
    echo - license under the GPLv3 license and pass freedoms to others.
    if "!Or-Any-Later-Version!"=="False" (
        echo - You are not permitted to distribute this under any other license
        echo - other than the GNU General Public License v3.0. Combination with
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo - You are permitted to distribute this under any later version of
        echo - the GNU General Public License v3 or just GPLv3. Combination with
    )
    echo - GNU General Public License v1 or v2 code is legally prohibited.
    echo - The author is not liable for any damage or data loss.
    echo - !Author! does not condone any damage whatsoever.
    echo - USE AT YOUR OWN RISK.
) else if "!errorlevel!"=="2" (
    echo ====================================================
    echo            ALOSToy Installer v!Version!
    echo ====================================================
    echo Author: !Author!
    echo.
    echo END USER LICENSE AGREEMENT
    echo.
    echo By using this software, you agree to the following:
    echo - Ventoy and this tool are provided "as-is" with no warranty.
    echo - Ventoy Download Mode will grab a specific version for you.
    echo - You must not misuse the software or it's owner to deploy malware.
    echo - You must use Ventoy properly.
    echo - Under GPLv3, you are required to provide source code if modified,
    echo - license under the GPLv3 license and pass freedoms to others.
    if "!Or-Any-Later-Version!"=="False" (
        echo - You are not permitted to distribute this under any other license
        echo - other than the GNU General Public License v3.0. Combination with
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo - You are permitted to distribute this under any later version of
        echo - the GNU General Public License v3 or just GPLv3. Combination with
    )
    echo - GNU General Public License v1 or v2 code is legally prohibited.
    echo - The author is not liable for any damage or data loss.
    echo - !Author! does not condone any damage whatsoever.
    echo - USE AT YOUR OWN RISK.
) else (
    goto InstallGuide4
)
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide4
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto :InstallGuide2
) else if "!errorlevel!"=="3" (
    goto InstallGuideExit
) else (
    goto InstallGuide3
)
:InstallGuide4
call :InstallHelpTitle 4
echo THE MAIN MENU AND OPTIONS:
echo.
echo You will see a main menu. 7 options will show. Those are:
echo 1 - Install ALOSToy Standard
echo 2 - Install ALOSToy Extended
echo 3 - Install Extensions + ALOSToy Standard (Currently ^<True or False^>)
echo 4 - Verify Your Installation
echo 5 - Delete Leftover Verification Databases
echo 6 - Quit Program
echo 7 - Look Into The Installer
echo.
echo You need to use your mouse to click on a button. Pressing invalid inputs
echo will be caught and the menu has to reload. I am watching your inputs...
echo There are some keyboard buttons that you can press to show more options.
echo.
echo Press V on this choice menu (not the main menu) to find them or press I to open
echo an image link of the main menu. Standard buttons (F, B and E still work).
echo.
echo Other than that, you would click on a button on the main menu. Then turn
echo over to the next page.
echo.
choice /c FIBEV /n /m "Turn Forward a page, open the Image link, turn Back a page, Exit or View more shortcuts? [F, I, B, E or V]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide5
) else if "!errorlevel!"=="2" (
    cls
    for /f "delims= " %%I in ('powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('The image is hosted on Google Drive.','ALOSToy Installer','OKCancel','Info')"') do (if /i "%%I"=="OK" start https://bit.ly/4bPND4x)
    goto InstallGuide4
) else if "!errorlevel!"=="3" (
    call :PageFlipBack
    goto :InstallGuide3
) else if "!errorlevel!"=="4" (
    goto InstallGuideExit
) else if "!errorlevel!"=="5" (
    cls
    powershell -nop -nologo -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"Extra main menu keyboard shortcuts:!NewLine!!NewLine!D: Redownload bin files.!NewLine!G: Open the Github repository.!NewLine!H: Show command line help.!NewLine!I: Show installation help.!NewLine!R: Restart the program.!NewLine!U: Force update the program to new or current version.\",'ALOSToy Installer','OK','Info') | Out-Null; [System.Windows.MessageBox]::Show('All keyboard shortcuts work whether you input UPPERCASE or lowercase.','ALOSToy Installer','OK','Info') | Out-Null"
    goto InstallGuide4
) else (
    goto InstallGuide4
)
:InstallGuide5
call :InstallHelpTitle 5
echo VENTOY DOWNLOAD AND USB SELECTION:
echo.
echo Once you have clicked on a button, you will see the edition's
echo license terms. Press any key to continue and we will download
echo the latest Ventoy version or, a user-selected Ventoy version.
echo.
echo When Ventoy has downloaded to Ventoy2Disk in the program root,
echo (the path will be different depending on the program location),
echo you will need to select your USB drive in the folder browser. Keep
echo in mind that it has to be a drive root, not a directory. If a dir is
echo selected, we will reduce it down to one drive letter.
echo.
echo Afterwards, confirm you want to use this drive because it will get
echo erased later on. You can type in a drive letter on the confirmation
echo prompt and press ENTER to change the drive letter or you press ENTER
echo.
echo DO NOT TRY TO CHOOSE THE SYSTEM DRIVE (!SYSTEMDRIVE!\) OR PROGRAM DRIVE (%~D0\) AS YOU
echo WILL BE BLOCKED FROM PROCEEDING IF THAT IS THE CASE, YOU CAN RETRY WITH
echo A DIFFERENT DRIVE LETTER. THIS IS TO PROTECT YOUR SYSTEM AND OTHER FILES.
echo.
echo The drive gets validated and size checked. If the drive is below the minimum size, you are blocked from continuing.
echo Turn over to see GPT, Secure Boot and Ventoy install options.
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide6
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto :InstallGuide4
) else if "!errorlevel!"=="3" (
    goto InstallGuideExit
) else (
    goto InstallGuide5
)
:InstallGuide6
call :InstallHelpTitle 6
echo GPT AND SECURE BOOT PREFERENCES:
echo.
echo Now you will see a button menu saying "Do you want GPT?"
echo GPT or GUID Partition Table is a modern partiton scheme that
echo is primarily used on modern computers to boot your operating
echo system like Windows and Linux. You can either click Yes or No
echo to decide. If you select "Yes", your drive will use the modern
echo GPT partition scheme which supports massive disks. If you select
echo "No", your drive will use the MBR partition scheme which is an
echo older partition scheme used on legacy computers and only supports
echo disks up to 2TB. MBR should not be used unless you intent to boot
echo ALOSToy on both modern and legacy computers. Click "Yes" or "No".
echo I recommend clicking "Yes" unless you have a purpose with old pc's.
echo.
echo Next, you will see another button menu saying "Do you want Secure Boot?"
echo Secure Boot is a security feature on modern systems ONLY that prevents
echo malicious software from starting up during the boot process ensuring that
echo only signed OSes, drivers, loaders and firmware may proceed into the boot
echo chain and process. Ventoy does support Secure Boot since v1.0.76. I would
echo click "Yes" unless you have a purpose for not using Secure Boot of if your
echo computer does not support Secure Boot in which you should trash your PC.
echo.
echo To see the Ventoy installation part, turn over to the next page.
echo.
choice /c FBSE /n /m "Turn forward a page, turn back a page, read the secure boot documentation or exit? [F, B, S or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide7
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto :InstallGuide5
) else if "!errorlevel!"=="3" (
    start https://www.ventoy.net/en/doc_secure.html
    goto InstallGuide6
) else if "!errorlevel!"=="4" (
    goto InstallGuideExit
) else (
    goto InstallGuide6
)
:InstallGuide7
call :InstallHelpTitle 7
echo VENTOY INSTALLATION ONTO YOUR USB:
echo.
echo You will now enter the Ventoy installation screen where you can:
echo Install Ventoy Onto ^<drivepath^>
echo Update Ventoy On ^<drivepath^>
echo Change Configuration
echo Declare That Ventoy Is Already Installed On ^<drivepath^>
echo.
echo If this is a fresh USB, click on the Install Ventoy option, accept the
echo warning and then type out a long confirmation sentence to prove that you
echo do want to format and erase the drive. Remember, this will wipe all data
echo stored on the target drive, so pick wisely.
echo.
echo When confirmed, Ventoy will erase the drive and all data will be lost.
echo It's bootloader will be installed onto your target drive and you should
echo see the data partition (where ALOSToy files are stored) and the 32MiB EFI
echo partition (where the boot files are stored). You can also update Ventoy on a
echo drive to the newest version if Ventoy is installed but an older version. It
echo is possible to Change Configuration as well if you want to change either
echo Drive, GPT and Secure Boot settings.
echo.
echo Turn over to see more.
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
set "PartMsg=The data partition labelled \"Ventoy\" is the partition where all the ALOSToy or your own bootable files will be stored on."
if "!errorlevel!"=="1" (
    cls
    start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!PartMsg!','ALOSToy Installer','OK','Info') | Out-Null"
    call :PageFlip
    goto InstallGuide8
) else if "!errorlevel!"=="2" (
    cls
    start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!PartMsg!','ALOSToy Installer','OK','Info') | Out-Null"
    call :PageFlipBack
    goto :InstallGuide6
) else if "!errorlevel!"=="3" (
    cls
    start /b powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('!PartMsg!','ALOSToy Installer','OK','Info') | Out-Null"
    goto InstallGuideExit
) else (
    goto InstallGuide7
)
:InstallGuide8
call :InstallHelpTitle 8
echo DOWNLOADING OR LOCATING AND THEN EXTRACTING THE MAIN FILES:
echo.
echo If you already have the main parts named ALOSToy_v1.0_STD_Part_1-4.7z and
echo Extensions_For_ALOSToy_v1.0_STD_Part_1-2.7z or ALOSToy_v1.0_EXT_Part_1-8.7z,
echo they will all be SHA256 verified to stop invalid main files. Is that great?
echo.
echo If they do not exist or are bad, you will be given the choice to download
echo them or locate the files manually. If this is your first time running this,
echo select "Download Files". If you already have the files somewhere, select
echo "Locate Files" and browse to the directory manually. When the files have
echo downloaded or you have located them, !Script! will extract them
echo to the target drive. You will have to wait some time before you can use the
echo ALOSToy USB drive.
echo.
echo However, if the files are automatically found in the files directory of the
echo root directory, the installer will automatically !Algorithm! verify them to prove
echo that the main parts of Standard, Standard+Extensions or Extended is legitimate
echo from !Author! and not a hacker. If all of them pass, we will extract all the main
echo compressed archive parts to the target drive. Regardless of where they are found.
echo Extraction takes time depending on your USB drive and/or USB port. Wait for it.
echo.
echo Turn over to see more.
echo. 
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide9
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto :InstallGuide7
) else if "!errorlevel!"=="3" (
    goto InstallGuideExit
) else (
    goto InstallGuide8
)
:InstallGuide9
call :InstallHelpTitle 9
echo POST INSTALLATION STEPS (AFTER ALOSTOY IS INSTALLED):
echo.
echo When !Script! has extracted all of the main files,
echo we will copy a local hash database and run QuickSFV to compare
echo the hashes of the extracted files against the database ensuring
echo your files are valid and not malformed after extraction.
echo.
echo You will soon see a end choices menu. 3 buttons will appear saying:
echo.
echo "Quit The Installer" (Exits !Script!.)
echo "Reboot To Firmware Setup" (Exits and reboots to BIOS setup.)
echo "Return To Main Menu (As In To Do Another Installation)" (Sends you back to main menu.)
echo.
echo You can click either one of those to proceed. We recommend clicking
echo "Quit The Installer" so that you can exit !Script! and
echo see your ALOSToy USB drive.
echo.
echo You can now boot up your ALOSToy USB and see all the tools on there.
echo If you want to see some extra functions, turn over to the last page
echo or you can exit the guide.
echo.
choice /c FBE /n /m "Turn forward a page, turn back a page or exit? [F, B or E]"
if "!errorlevel!"=="1" (
    call :PageFlip
    goto InstallGuide10
) else if "!errorlevel!"=="2" (
    call :PageFlipBack
    goto :InstallGuide8
) else if "!errorlevel!"=="3" (
    goto InstallGuideExit
) else (
    goto InstallGuide9
)
:InstallGuide10
call :InstallHelpTitle 10
echo EXTRA FUNCTIONS OF ALOSTOY ON THE MAIN MENU:
echo.
echo 	VERIFY YOUR INSTALLATION:
echo.
echo 	Click on the "Verify Your Installation" button and then select the drive
echo 	that you want to verify your ALOSToy installation. When a menu pops up,
echo 	select the edition that you have. We will then hash all files and return
echo 	to the main menu.
echo.
echo 	DELETE LEFTOVER VERIFICATION DATABASES:
echo.
echo 	Click on the "Delete Leftover Verification Databases" button and then
echo 	select the drive that you want to erase the leftover database used to
echo 	verify the installation. We will erase the edition's hash database and
echo 	return to the main menu.
echo.
echo 	TOGGLE EXTENSIONS FOR ALOSTOY STANDARD:
echo.
echo 	Click on the "Install Extensions + ALOSToy Standard (Currently !InstallExtensions!)"
echo 	button and then it will return to the main menu saying Currently True.
echo 	Then proceed on clicking "Install ALOSToy Standard" to continue. Click
echo 	it again to disable the extension installation.
echo.
choice /c BE /n /m "Turn back a page or exit? (Note: You have reached the end of the guide.) [B or E]"
if "!errorlevel!"=="1" (
    call :PageFlipBack
    goto :InstallGuide9
) else if "!errorlevel!"=="2" (
    goto InstallGuideExit
) else (
    goto InstallGuide10
)
:InstallGuideExit
cls
set "BrowsingHelp=False"
set "StartPage="
call :WindowTitle "GOOD LUCK WITH YOUR INSTALLATION OF ALOSTOY"
powershell -nop -nol -c "Add-Type -AssemblyName PresentationFramework; [System.Windows.Messagebox]::Show('Now that you have read the guide, you should be able to confidently install ALOSToy Standard or Extended. I hope this helped you learn something.','ALOSToy Installer','OK','Info') | Out-Null"
if "!HelpFromMain!"=="1" (
    set "HelpFromMain=0"
    goto Main
) else (
    title 
    endlocal
    exit 0
)
:PageFlip
cls
echo Going to next page...
timeout /t 1 /NOBREAK >nul
goto :eof
:PageFlipBack
cls
echo Returning to previous page...
timeout /t 1 /NOBREAK >nul
goto :eof
:WindowTitle
rem Helper function to set the window title that tracks Product, Boolean of InstallExtensions,
rem Version and Ventoy Download Mode with a general Window Title that stays consistent and shows
rem information about activity. Can now also track the help page as well. ArgumentsPassed is back
rem but does not show. Now includes Archive_Part because of the need to see the full messages.
set "Input=%~1"
if "!BrowsingHelp!"=="True" (
    if defined Page (set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [START PAGE: !STARTPAGE!] [PAGE !PAGE!]")
    if defined InstallGuidePage (set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [START PAGE: !STARTPAGE!] [PAGE !INSTALLGUIDEPAGE!]")
) else if defined drivepath (
    if defined product (
        if "!InstallExtensions!"=="False" (
            set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [PRODUCT: !PRODUCT!] [DRIVE: !DRIVEPATH!]"
        ) else if "!InstallExtensions!"=="True" (
            set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [PRODUCT: !PRODUCT!+Extensions] [DRIVE: !DRIVEPATH!]"
        )
    ) else if "!Vtoy_DL_Mode!"=="1" (
        set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [VTOY DL MODE]"
    ) else (
        set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [DRIVE: !DRIVEPATH!]"
    )
) else (
    if defined product (
        if "!InstallExtensions!"=="False" (
            set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [PRODUCT: !PRODUCT!]"
        ) else if "!InstallExtensions!"=="True" (
            set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [PRODUCT: !PRODUCT!+Extensions]"
        )
    ) else if "!Vtoy_DL_Mode!"=="1" (
        set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!] [VTOY DL MODE]"
    ) else (
        set "BaseHeader=[ALOSTOY INSTALLER V!VERSION!] [!LANG!-!LOCALE!]"
    )
)
if defined Archive_Part if defined Parts (set "BaseHeader=!BaseHeader! [ARCHIVE PART: !ARCHIVE_PART! OF !PARTS!]")
title !BaseHeader! ^<-----^> !Input!
set "Input="
goto :eof
:HelpTitle
set "Page=%~1"
cls
echo         ^˄^˄^˄^˄^˄^˄ ^|=======================================================================================^| ^˄^˄^˄^˄^˄^˄
echo         ^<^<^<^<^<^< ^| ALOSToy Installer Command-Line Help Guide (100%% Guaranteed To Make Your Life Better)  ^| ^>^>^>^>^>^>
echo         ^˅^˅^˅^˅^˅^˅ ^|=======================================================================================^| ^˅^˅^˅^˅^˅^˅
echo [Page !Page! of !Pages!]
if !Page! lss 4 (call :WindowTitle "BASIC COMMAND-LINE HELP GUIDE") else if !Page! equ 4 (call :WindowTitle "COMMAND-LINE EXAMPLES") else if !Page! gtr 4 (if !Page! lss 9 (call :WindowTitle "ADVANCED COMMAND-LINE HELP GUIDE") else if !Page! equ 9 (call :WindowTitle "AUTHOR INFO AND EULA") else if !Page! equ 10 (call :WindowTitle "ABOUT THE EMBEDDED POWERSHELL"))
goto :eof
:PowerShell_Helper
rem A PowerShell helper to read all the text in a specific section.
rem Eg:
rem :RunPS
rem # This is inside PowerShell!
rem Write-Host "Hello from PowerShell."
rem Write-Host "I am so happy about embedding PS in batch."
rem Write-Host "This will make so much sense."
rem Exit 0
rem :Post_RunPS
rem echo PowerShell ends and returns to batch.
set "block=%~1"
rem Change the iex $section[1] to a compiled scriptblock. Far safer.
if /i "%~2"=="/Maximised" (powershell -nop -nol -WindowStyle Maximized -c "$section = [io.file]::ReadAllText($env:FullScript) -split '(?ms)^:!block!\r?\n(.*?)\r?\n:Post_!block!'; & ([scriptblock]::Create($section[1]))") else (powershell -nop -nol -c "chcp 65001 > $null; $i18n = New-Object System.Text.UTF8Encoding; [Console]::InputEncoding = $i18n; [Console]::OutputEncoding = $i18n; $OutputEncoding = $i18n; $section = [io.file]::ReadAllText($env:FullScript) -split '(?ms)^:!block!\r?\n(.*?)\r?\n:Post_!block!'; & ([scriptblock]::Create($section[1]))")
exit /b !errorlevel!
:ExitMessages
if "%~1"=="" (set "WS=Hidden") else (set "WS=%~1")
powershell -nop -nol -ExecutionPolicy Bypass -WindowStyle !WS! -c "Add-Type -AssemblyName PresentationFramework; if ($env:ProductDefinedWithArg -ieq 'True') { [System.Windows.MessageBox]::Show('Your bootable ALOSToy !product! drive has been successfully created. Enjoy.','ALOSToy Installer','OK','Info') }; [System.Windows.MessageBox]::Show('Share this installer with your friends or other people as well. Help them save their pc''s too.','ALOSToy Installer','OK','Info') | Out-Null; [System.Windows.MessageBox]::Show('If you have any other custom Windows PE''s you want to carry, copy them to !drivepath!:\WinPE or any ALOSToy drive with the /WinPE folder.','ALOSToy Installer','OK','Info') | Out-Null; [System.Windows.MessageBox]::Show(\"If you have any of your own Windows Installation Media, copy them to:!NewLine!!drivepath!:\OSimages\Windows or any other drive with /OSImages/Windows.!NewLine!!NewLine!If you have any of your own Linux Installation Media, copy them to:!NewLine!!drivepath!:\OSimages\Linux or any other drive with /OSimages/Linux.\",'ALOSToy Installer','OK','Info') | Out-Null; if ($env:RedoInstall -ieq 'No') { [System.Windows.MessageBox]::Show('!Author! thanks you for installing ALOSToy !product!. Click OK to exit.','ALOSToy Installer','OK','Info') | Out-Null }"
set "WS="
set "PSCmdTemp="
goto :eof
:ApplyUpdate
cls
set "Timestamp=!DATE!-!TIME!"
set "Timestamp=!Timestamp:/=-!"
set "Timestamp=!Timestamp::=-!"
set "Timestamp=!Timestamp: =0!"
echo Backing up current version of !Version! to "!Script!_V!VERSION!_!Timestamp!.BAK"...
copy "!Script!" "!Script!_V!VERSION!_!Timestamp!.BAK" /y >nul && (
    set "Timestamp="
    echo Successful backup. Now Updating ALOSToy Installer...
    echo !DATE! !TIME! Found ALOSToy Installer Version !Newest!. Downloading right now to "!Root!"...>> "!logfile!"
    curl !InstallerRepo!/releases/download/!Newest!/ALOSTOY-INSTALLER.ZIP -O -L >> "!logfile!" 2>&1
    curl !InstallerRepo!/raw/refs/heads/main/HASH.TXT -O -L >> "!logfile!" 2>&1
    rem VERY IMPORTANT TO HASH THE DOWNLOADED ZIP FILE BEFORE IT IS EXTRACTED.
    rem PROVES AUTHENTICITY OVER MALICE.
    set /p NewVersion_Hash= <./HASH.TXT
    call :Hashing "ALOSTOY-INSTALLER.ZIP" "!NewVersion_Hash!"
    if !errorlevel! gtr 0 (
        echo Failed to update. Hash does not mismatch.
        if "!ProductDefinedWithArg!"=="False" (echo We will continue anyway.) else if "!ProductDefinedWithArg!"=="True" (echo We will exit in this case.)
        timeout /t 3 /NOBREAK >nul
        if "!ProductDefinedWithArg!"=="False" (goto Continue) else if "!ProductDefinedWithArg!"=="True" (endlocal & exit 1)
    )
    rem Find user's 7-Zip installation. Alternatively, summon PowerShell for extraction of updated ALOSTOY-INSTALLER.ZIP.
    for /f "skip=2 tokens=2*" %%Y in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip /v InstallLocation') do (
        set "SZ=%%Z"
        if exist "!SZ!7z.exe" ("!SZ!7z.exe" x -y -r -aoa -bso1 -bse1 -bsp1 -o"!Root!" "!Root!ALOSTOY-INSTALLER.ZIP" >> "!logfile!") else (echo Use powershell instead. & powershell -nop -nol -ExecutionPolicy Bypass -c "Expand-Archive -LiteralPath '!Root!ALOSTOY-INSTALLER.ZIP' -DestinationPath '!Root!' -Force; if ($?) { Exit 0 } else { Exit 1 }")
        if !errorlevel! equ 0 (
            del ALOSTOY-INSTALLER.ZIP /f /q
            del hash.txt /f /q
            cls
            set "SZ="
            echo The update has succeeded. !Script! is restarting...
            powershell -nop -nol -c "Start-Process cmd.exe -Verb RunAs -ArgumentList '/c cd /d "!Root!\" & call "!Script!" %* !ArgPrefix!Updated'" >nul 2>&1
            title 
            endlocal
            exit 0
        ) else (
            echo Update failed. Exiting...
            timeout /t 3 /NOBREAK >nul
            endlocal
            exit 17
        )
    )
) || (
    echo The backup could not be created^^!
    echo We will continue to use V!VERSION! anyway.
    echo Check if the backup logic is working.
    cls
    goto Continue
)
:DisableQuickEdit
rem We use an I_QEOff flag to not infinitely relaunch.
powershell -nop -nol -c "$QEOff = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0); $QEOff.DefinePInvokeMethod('GetStdHandle', 'kernel32.dll', 22, 1, [IntPtr], @([Int32]), 1, 3).SetImplementationFlags(128); $QEOff.DefinePInvokeMethod('SetConsoleMode', 'kernel32.dll', 22, 1, [Boolean], @([IntPtr], [Int32]), 1, 3).SetImplementationFlags(128); $Object = $QEOff.CreateType(); $Quick_Edit_Lock = $Object::SetConsoleMode($Object::GetStdHandle(-10), 0x00A0); & cmd.exe '/c' 'cd /d !Root! & call !Script! I_QEOff !UserArguments!'" & endlocal & exit 0
rem =================================================================================================================
rem   We prefer 0x00A0 instead of 0x0080 because it also enables the insert mode while disabling quick edit because
rem  setting ENABLE_EXTENDED_FLAGS (0x0080) turns off both Quick Edit and Insert Mode to properly initalise. 0x00A0
rem                          turns both off but then enables insert mode immediately after.
rem =================================================================================================================
rem ================================================================================================
rem     AN EXHAUSTIVE LIST OF SetConsoleMode FLAGS. BOTH STD_INPUT_HANDLE AND STD_OUTPUT_HANDLE.
rem   CAUTION: UNLESS YOU ARE A TECHNICIAL USER, YOU CAN KEEP SCROLLING BUT IF YOU ARE AN ADVANCED
rem                             USER, PLEASE TAKE SOME TIME TO READ THIS.
rem ================================================================================================
rem                                  Flags For Input Handle (-10)
rem ================================================================================================
rem 0x0001 ENABLE_PROCESSED_INPUT - Let the system process Ctrl C properly.
rem 0x0002 ENABLE_LINE_INPUT - Only carriage return can return reads.
rem 0x0004 ENABLE_ECHO_INPUT - Write typed characters to screen buffer.
rem 0x0008 ENABLE_WINDOW_INPUT - Send window resizing to screen buffer.
rem 0x0010 ENABLE_MOUSE_INPUT - Send mouse events to screen buffer.
rem 0x0020 ENABLE_INSERT_MODE - Enable insert mode to not overwrite text. (Needs 0x0080!)
rem 0x0040 ENABLE_QUICK_EDIT_MODE - Enable quick edit to pause execution by click. (Needs 0x0080!)
rem 0x0080 ENABLE_EXTENDED_FLAGS - Enable extended flags. (Turns off 0x20 and 0x40 by default.)
rem                      This is a master switch for ENABLE_INSERT_MODE and ENABLE_QUICK_EDIT_MODE.
rem 0x0200 ENABLE_VIRTUAL_TERMINAL_INPUT - Take input and convert it to Virtual Terminal sequences.
rem Some Example Combinations For Input:
rem 0x000F = 0x0001+0x0002+0x0004+0x0008 - Normal input mode.
rem 0x001F = 0x000F+0x0010 - Normal + mouse input mode.
rem 0x00C0 = 0x0080+0x0040 - Enable Extended Flags and Quick Edit only.
rem 0x00A0 = 0x0080+0x0020 - Enable Extended Flags and Insert mode only.
rem 0x00E0 = 0x0080+0x0040+0x0020 - Enable All Extended Flags. (Insert and Quick Edit mode.)
rem 0x020F = 0x000F+0x0200 - Normal + virtual terminal input mode.
rem 0x021F = 0x001F+0x0200 - Normal + mouse + virtual terminal input mode.
rem ================================================================================================
rem                                  Flags For Output Handle (-11)
rem ================================================================================================
rem 0x0001 ENABLE_PROCESSED_OUTPUT - Read and parse any and all ASCII control sequences.
rem 0x0002 ENABLE_WRAP_AT_EOL_OUTPUT - Wrap the cursor at the end of a line.
rem 0x0004 ENABLE_VIRTUAL_TERMINAL_PROCESSING - Read and parse Virtual Terminal 100 sequences.
rem 0x0008 DISABLE_NEWLINE_AUTO_RETURN - Delay scrolling at the end of a line.
rem 0x0010 ENABLE_LVB_GRID_WORLDWIDE - Enable LVB flags on any codepage for worldwide support.
rem Some Example Combinations For Output:
rem 0x0003 = 0x0001+0x0002 - Normal output mode.
rem 0x0007 = 0x0001+0x0002+0x0004 - Process Virutal Terminal. This is common!
rem 0x000F = 0x0001+0x0002+0x0004+0x0008 - Use Virutal Terminal without automatic return.
rem 0x0013 = 0x0003+0x0010 - Normal output mode with worldwide LVB.
rem 0x0017 = 0x0007+0x0010 - Use Virutal Terminal with worldwide LVB.
rem ================================================================================================
:Banner_Art
if /i "%~1"=="/PreInstall" (set "Text=        WELCOME TO THE INSTALLER. THANK YOU FOR CHOOSING TO INSTALL ALOSTOY V1.0.") else if /i "%~1"=="/PostInstall" (set "Text=    THANK YOU FOR INSTALLING ALOSTOY V1.0. YOU NOW HAVE THE BEST BOOTABLE USB DRIVE.") else (exit 2)
for /f %%A in ('"prompt $E & for %%B in (1) do rem"') do set "ESC=%%A"
mode con: cols=100 lines=40
set "C0=!ESC![38;2;255;0;76m"
set "C1=!ESC![38;2;0;255;247m"
set "C2=!ESC![38;2;255;183;0m"
set "C3=!ESC![38;2;111;255;0m"
set "C4=!ESC![38;2;255;64;191m"
set "C5=!ESC![38;2;64;128;255m"
set "C6=!ESC![38;2;255;92;0m"
set "C7=!ESC![38;2;0;255;140m"
set "C8=!ESC![38;2;208;0;255m"
set "C9=!ESC![38;2;255;255;64m"
set "C10=!ESC![38;2;0;191;255m"
set "C11=!ESC![38;2;255;0;153m"
set "C12=!ESC![38;2;50;255;50m"
set "C13=!ESC![38;2;255;128;64m"
set "C14=!ESC![38;2;0;255;255m"
set "C15=!ESC![38;2;255;255;255m"
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
    echo(                                    !TC!ALOSTOY INSTALLER !VERSION!!ESC![0m
    timeout /t 1 /NOBREAK >nul
)
if /i "!ProductDefinedWithArg!"=="True" (
    echo We will continue in 3 seconds...
    timeout /t 3 /NOBREAK >nul
) else (
    echo Push any key to show the main menu.
    pause >nul
)
mode con: cols=!Columns! lines=!Lines!
cls
set "Text="
set "TC="
set "N="
set "OUT="
exit /b 0
goto :eof
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
:HashVentoyZip
rem =============================================
rem SHA256 verify the downloaded ventoy zipfile.
rem =============================================
set "Vtoy_Ver=%~1"
curl https://github.com/ventoy/Ventoy/releases/download/v!Vtoy_Ver!/sha256.txt -O -L >> "!logfile!" 2>&1
rem Change to root.
cd /d "!Root!"
rem =============================================================
rem Ventoy sha256.txt file orders the sha256 hashes by linux
rem archive first, ventoy livecd and windows zip. To select the
rem windows zip, we use "skip=2 tokens=1,2" in for /f loop to
rem bypass the linux and livecd checksums and instead, parse the
rem windows archive checksum.
rem The hashes are ordered line by line on their own lines.
rem =============================================================
rem ==============================================================================================
rem Here is an example of it's contents from version 1.1.17:
rem 7fb4ed08cef6a6b4d39dd19260d8c80291a78dfdf9af7d461571e23cbbc43805  ventoy-1.1.17-linux.tar.gz
rem a8c66e94e04ee8c7ec4a8474ea576f4fbf26641e344ad223d711752628d0a814  ventoy-1.1.17-livecd.iso
rem d250e97a7595fdac4f97debc630d7a8da942319274a76cb32384596b659dbaeb  ventoy-1.1.17-windows.zip
rem ==============================================================================================
for /f "skip=2 tokens=1,2" %%A in ('type "!Root!sha256.txt"') do if /i "%%B"=="ventoy-!Vtoy_Ver!-windows.zip" (set "Expected_Ventoy_Hash=%%A") else (echo Unknown. %%B %%A ventoy-!Vtoy_Ver!-windows.zip & pause & exit 1)
echo Verifying ventoy.zip ^| It should be !Expected_Ventoy_Hash!...
for /f "delims=" %%V in ('powershell -nop -nol -c "(Get-FileHash '!Root!ventoy.zip' -Algorithm $env:Algorithm).Hash.ToUpper()"') do set "Actual_Ventoy_Hash=%%V"
if /i "!Actual_Ventoy_Hash!"=="!Expected_Ventoy_Hash!" (
    rem If we succeed, we can continue to the drive selection or
    rem exit depending on if we are in Ventoy Download Mode or not.
    echo ventoy.zip is OK.
    del sha256.txt /f /q >nul
    set "Actual_Ventoy_Hash="
    set "Expected_Ventoy_Hash="
    exit /b 0
) else (
    rem But if we fail, we cannot proceed and must throw an error.
    echo ventoy.zip is not OK.
    echo The hash is !Actual_Ventoy_Hash!.
    timeout /t 3 /NOBREAK >nul
    exit /b 1
)
:InstallerTitle
cls
echo ========================================================================================================================
echo ================================ Starting ALOSToy Installer... (!D! !T!) ================================
echo ========================================================================================================================
if "!Or-Any-Later-Version!"=="True" if exist "!Root!LICENSE.TXT" (set "EXISTS=1" & set "FILE=!Root!LICENSE.TXT") else (set "EXISTS=0")
if "!Or-Any-Later-Version!"=="False" if exist "!Root!GPLV3_ONLY_INFO.TXT" (set "EXISTS=1" & set "FILE=!Root!GPLV3_ONLY_INFO.TXT") else (set "EXISTS=0")
if "!GPLNotice!"=="1" if "!EXISTS!"=="1" (
    type "!FILE!"
    echo To see the full GNU GPL License, open the COPYING.TXT file.
    if "!ArgumentsPassed!"=="True" echo Arguments passed: %*
    if "!Or-Any-Later-Version!"=="True" (echo GPLv3 or any later version.) else if "!Or-Any-Later-Version!"=="False" (echo GPLv3 ONLY.)
    echo ========================================================================================================================
) else (
    cls
    echo The license file are non-existent. This means you may not have any
    echo GNU GPL rights to use unless you redownload the license files to
    echo !Root!.
    echo.
    echo You are required to redownload the licenses from:
    echo !InstallerRepo!
    echo.
    echo Press any key to download the license files...
    if "!Or-Any-Later-Version!"=="False" (
        echo Note: !Script!'s code is GPL v3 ONLY. You may NOT redistribute
        echo under any later or previous version, only the GNU GPL v3 license.
    ) else if "!Or-Any-Later-Version!"=="True" (
        echo Note: !Script!'s code is GPL v3 or any later version.
        echo You may redistribute under GPLv3 or any future version of your choice.
    )
    pause >nul
    if "!Or-Any-Later-Version!"=="False" (
        for %%A in (COPYING.TXT LICENSE.TXT) do curl "!InstallerRepo!/raw/refs/heads/main/backup_license/%%A" -O -L >> "!logfile!" 2>&1
        call :LicenseHasher AfterRedownload || (
            endlocal
            exit 23
        )
    ) else if "!Or-Any-Later-Version!"=="True" (
        cls
        echo You do not have to actually redownload the license files
        echo because you chose to redistribute under any later version.
    )
)
set "EXISTS="
set "FILE="
goto :eof
:LicenseHasher
rem Maintain the integrity of the license files. The GNU GPL licenses forbid
rem editing the documents. "Everyone is permitted to copy and distribute
rem verbatim copies of this license document but changing it is not allowed."
rem DO NOT ASK ME TO REMOVE THIS IN ISSUES OR COMMENTS! I WILL NOT RESPOND!
set "ARE=0"
if /i "%~1"=="AfterRedownload" set "ARE=1"
set "Valid_LicenseDocuments=0"
for /f "tokens=1,2 usebackq" %%H in (`powershell -nop -nol -c "if ((Test-Path -LiteralPath \"$env:Root\LICENSE.TXT\") -and (Test-Path -LiteralPath \"$env:Root\COPYING.TXT\")) { $LICENSE = (Get-FileHash -Path \"$env:Root\LICENSE.TXT\" -Algorithm $env:Algorithm).Hash.ToUpper(); $COPYING = (Get-FileHash -Path \"$env:Root\COPYING.TXT\" -Algorithm $env:Algorithm).Hash.ToUpper(); '{0} {1}' -f $LICENSE,$COPYING; Exit 0 } else { Exit 1 }"`) do (
    if !errorlevel! equ 1 set "Missing=True"
    rem LICENSE.TXT
    if /i "%%H"=="7F545FE11D2817185E365A03E5DD7FAD1C9F858702FA09E361D5ABF5A8FFF4E6" set /a "Valid_LicenseDocuments+=1"
    rem COPYING.TXT
    if /i "%%I"=="3972DC9744F6499F0F9B2DBF76696F2AE7AD8AF9B23DDE66D6AF86C9DFB36986" set /a "Valid_LicenseDocuments+=1"
)
if "!ARE!"=="0" (
    exit /b 0
    goto :eof
) else if !Valid_LicenseDocuments! lss 2 (
    echo The licenses are still bad. This program will quit.
    timeout /t 3 /NOBREAK >nul
    exit 1
) else (
    exit / 0
    goto :eof
)
:SetFont
$ConsoleFont = @"
using System;
using System.Runtime.InteropServices;
// Define a class called ConsoleFont.
public static class ConsoleFont
{
    // Create constants.
    private const int STD_OUTPUT_HANDLE = -11;
    private const uint DEFAULT_CHARSET = 1;
    private const int FF_MODERN = 48;
    // Import DLLs.
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    // Function for SetCurrentConsoleFontEx API.
    private static extern bool SetCurrentConsoleFontEx(
        IntPtr consoleOutput,
        bool maximumWindow,
        ref CONSOLE_FONT_INFO_EX consoleCurrentFontEx);
    [DllImport("user32.dll")]
    private static extern IntPtr GetDC(IntPtr hWnd);
    [DllImport("user32.dll")]
    private static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);
    [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
    private static extern int EnumFontFamiliesEx(
        IntPtr hdc,
        ref LOGFONT lpLogfont,
        EnumFontFamExProc lpEnumFontFamExProc,
        IntPtr lParam,
        uint dwFlags);
    private delegate int EnumFontFamExProc(
        ref ENUMLOGFONTEX lpelfe,
        IntPtr lpntme,
        uint FontType,
        IntPtr lParam);
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct LOGFONT
    {
        public int lfHeight;
        public int lfWidth;
        public int lfEscapement;
        public int lfOrientation;
        public int lfWeight;
        public byte lfItalic;
        public byte lfUnderline;
        public byte lfStrikeOut;
        public byte lfCharSet;
        public byte lfOutPrecision;
        public byte lfClipPrecision;
        public byte lfQuality;
        public byte lfPitchAndFamily;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string lfFaceName;
    }
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct ENUMLOGFONTEX
    {
        public LOGFONT elfLogFont;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 64)]
        public string elfFullName;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string elfStyle;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string elfScript;
    }
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct CONSOLE_FONT_INFO_EX
    {
        public uint cbSize;
        public uint nFont;
        public short dwFontSizeX;
        public short dwFontSizeY;
        public int FontFamily;
        public int FontWeight;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string FaceName;
    }
    // Function to check if font exists.
    public static bool FontExists(string fontName)
    {
        IntPtr hdc = GetDC(IntPtr.Zero);
        if (hdc == IntPtr.Zero)
            return false;
        try
        {
            bool found = false;
            LOGFONT lf = new LOGFONT();
            lf.lfCharSet = (byte)DEFAULT_CHARSET;
            lf.lfFaceName = fontName;
            EnumFontFamExProc proc = delegate(ref ENUMLOGFONTEX lpelfe, IntPtr lpntme, uint FontType, IntPtr lParam)
            {
                found = true;
                return 0;
            };
            EnumFontFamiliesEx(hdc, ref lf, proc, IntPtr.Zero, 0);
            return found;
        }
        finally
        {
            ReleaseDC(IntPtr.Zero, hdc);
        }
    }
    // Function to get the preferred font based on previous functions.
    public static string GetPreferredFont()
    {
        if (FontExists("$env:FirstFont"))
            return "$env:FirstFont"; // This is the optimal font that the ALOSToy Installer was built for.
        return "$env:SecondFont"; // This is the font to use for those on normal Windows installations. The default font is Consolas but we are not using that because setting that would cause the API to set the Terminal font (A raster font).
    }
    // Function to set the preferred font based on previous functions.
    public static bool SetPreferredFont(short size)
    {
        string font = GetPreferredFont();
        IntPtr hnd = GetStdHandle(STD_OUTPUT_HANDLE);
        if (hnd == IntPtr.Zero || hnd == new IntPtr(-1))
            return false;
        CONSOLE_FONT_INFO_EX info = new CONSOLE_FONT_INFO_EX();
        info.cbSize = (uint)Marshal.SizeOf(info);
        info.FaceName = font;
        info.dwFontSizeX = 0;
        info.dwFontSizeY = size;
        info.FontFamily = FF_MODERN;
        info.FontWeight = 400;
        return SetCurrentConsoleFontEx(hnd, false, ref info); // Actually call the API to set the font.
    }
}
// The end of the font setter.
// Made by Aarav Katariya with love and care...
"@
Add-Type -TypeDefinition $ConsoleFont
if ([ConsoleFont]::SetPreferredFont(16)) { Exit 0 } else { Exit 1 }
:Post_SetFont
rem ======================================================================
rem All of these giant blocks like "ALOSToy-Info, Size-Requirements", etc
rem have a purpose. It is to display the messages in a few different
rem languages. Everything below is all PowerShell.
rem ======================================================================
:ALOSToy-Info
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
ALOSToy is a new version of any ventoy toolkit that helps you diagnose PC's. ${env:Author} built ALOSToy as the only developer. It is a different Ventoy toolkit that is meant to modernise that 5.6 year old tool. ALOSToy is the world's first ventoy toolkit to feature an installer for AaravLegend-OS and ChromeOS that is patched with Brunch to boot on all computers.
========================================================================================================================
Running On Windows Build ${env:full_winbuild}. If you want to open the installation help, press "i" or "I" on your keyboard.
We strongly recommend you read the installation guide so that you know how to use this tool.
========================================================================================================================
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
ALOSToy est une nouvelle version de la boîte à outils Ventoy qui vous aide à diagnostiquer les PC. ${env:Author} est le seul développeur à avoir créé ALOSToy. Il s'agit d'une boîte à outils Ventoy différente, destinée à moderniser cet outil vieux de 5,6 ans. ALOSToy est la première boîte à outils Ventoy au monde à proposer un programme d'installation pour AaravLegend-OS et ChromeOS, patché avec Brunch pour démarrer sur tous les ordinateurs.
========================================================================================================================
Exécution sous Windows, version ${env:full_winbuild}. Si vous souhaitez afficher l'aide à l'installation, appuyez sur la touche « i » ou « I » de votre clavier.
Nous vous recommandons vivement de lire le guide d'installation afin de savoir comment utiliser cet outil.
========================================================================================================================
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
ALOSToy ist eine neue Version eines beliebigen Ventoy-Toolkits, das Ihnen bei der Diagnose von PCs hilft. ${env:Author} hat ALOSToy als einziger Entwickler erstellt. Es handelt sich um ein eigenständiges Ventoy-Toolkit, das das 5,6 Jahre alte Tool modernisieren soll. ALOSToy ist das weltweit erste Ventoy-Toolkit, das einen Installer für AaravLegend-OS und ChromeOS enthält, der mit Brunch gepatcht ist, um auf allen Computern zu booten.
========================================================================================================================
Läuft unter Windows-Build ${env:full_winbuild}. Wenn Sie die Installationshilfe öffnen möchten, drücken Sie „i“ oder „I“ auf Ihrer Tastatur.
Wir empfehlen Ihnen dringend, die Installationsanleitung zu lesen, damit Sie wissen, wie Sie dieses Tool verwenden.
========================================================================================================================
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
ALOSToy es una nueva versión de cualquier kit de herramientas de Ventoy que te ayuda a diagnosticar ordenadores. ${env:Author} es el único desarrollador de ALOSToy. Se trata de un kit de herramientas de Ventoy diferente, diseñado para modernizar esa herramienta que ya tiene 5,6 años. ALOSToy es el primer kit de herramientas de Ventoy del mundo que incluye un instalador para AaravLegend-OS y ChromeOS, parcheado con Brunch para que se inicie en todos los ordenadores.
========================================================================================================================
Se está ejecutando en la compilación de Windows ${env:full_winbuild}. Si quieres abrir la ayuda de instalación, pulsa «i» o «I» en el teclado.
Te recomendamos encarecidamente que leas la guía de instalación para saber cómo utilizar esta herramienta.
========================================================================================================================
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
ALOSToy è una nuova versione del toolkit Ventoy che consente di eseguire la diagnostica dei PC. ${env:Author} è l’unico sviluppatore di ALOSToy. Si tratta di un toolkit Ventoy diverso, pensato per modernizzare quello ormai vecchio di 5,6 anni. ALOSToy è il primo toolkit Ventoy al mondo a includere un programma di installazione per AaravLegend-OS e ChromeOS, patchato con Brunch per consentire l’avvio su tutti i computer.
========================================================================================================================
In esecuzione su Windows Build ${env:full_winbuild}. Se desideri aprire la guida all’installazione, premi il tasto “i” o “I” sulla tastiera.
Ti consigliamo vivamente di leggere la guida all’installazione per imparare a utilizzare questo strumento.
========================================================================================================================
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToyは、PCの診断に役立つVentoyツールキットの新バージョンです。 ${env:Author} が唯一の開発者としてALOSToyを構築しました。これは、5.6年前にリリースされた既存のツールを現代化することを目的とした、従来のVentoyツールキットとは異なるものです。ALOSToyは、あらゆるコンピュータで起動できるようBrunchでパッチが適用されたAaravLegend-OSおよびChromeOS用のインストーラーを搭載した、世界初のVentoyツールキットです。
========================================================================================================================
Windows ビルド ${env:full_winbuild} 上で実行中です。インストールヘルプを開きたい場合は、キーボードの「i」または「I」キーを押してください。
このツールの使い方を理解するため、インストールガイドを必ずお読みになることを強くお勧めします。
========================================================================================================================
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
ALOSToy는 PC 진단에 도움을 주는 Ventoy 툴킷의 새로운 버전입니다. ${env:Author} 가 유일한 개발자로서 ALOSToy를 제작했습니다. 이 툴킷은 출시된 지 5.6년이 지난 기존 Ventoy 툴킷을 현대화하기 위해 개발된 새로운 버전입니다. ALOSToy는 모든 컴퓨터에서 부팅될 수 있도록 Brunch 패치가 적용된 AaravLegend-OS 및 ChromeOS용 설치 프로그램을 탑재한 세계 최초의 Ventoy 툴킷입니다.
========================================================================================================================
Windows 빌드 ${env:full_winbuild} 에서 실행 중입니다. 설치 안내를 보려면 키보드의 “i” 또는 “I” 키를 누르십시오.
이 도구의 사용 방법을 숙지하기 위해 설치 가이드를 꼭 읽어보실 것을 강력히 권장합니다.
========================================================================================================================
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_ALOSToy-Info
:FinishUp-Choices
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
Now that ALOSToy is finished installing, do you want to exit, reboot your computer to it's firmware to disable Secure Boot or perform another installation?
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Maintenant que l'installation d'ALOSToy est terminée, souhaitez-vous quitter, redémarrer votre ordinateur en mode firmware pour désactiver le Secure Boot ou effectuer une autre installation?
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Nachdem die Installation von ALOSToy nun abgeschlossen ist, möchten Sie das Programm beenden, Ihren Computer neu starten, um Secure Boot über die Firmware zu deaktivieren, oder eine weitere Installation durchführen?
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Ahora que se ha completado la instalación de ALOSToy, ¿deseas salir, reiniciar el ordenador en modo firmware para desactivar el arranque seguro o realizar otra instalación?
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Ora che l'installazione di ALOSToy è terminata, desideri uscire, riavviare il computer in modalità firmware per disabilitare Secure Boot oppure eseguire un'altra installazione?
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToyのインストールが完了しました。終了しますか、Secure Bootを無効にするためにコンピュータをファームウェアモードで再起動しますか、それとも別のインストールを実行しますか？
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
ALOSToy 설치가 완료되었습니다. 이제 종료하시겠습니까, 아니면 컴퓨터를 펌웨어 모드로 재부팅하여 보안 부팅을 비활성화하시겠습니까, 아니면 다른 설치를 진행하시겠습니까?
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_FinishUp-Choices
:FinishUp-Warning
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
If you reboot your computer to bios setup, you need to know where the secure boot setting is. It could be in the security tab or even trusted computing or windows os configuration, etc. Make sure you look up your motherboard or computer's bios manual to find out where it is!
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Si vous redémarrez votre ordinateur pour accéder à la configuration du BIOS, vous devez savoir où se trouve le paramètre de démarrage sécurisé. Il peut se trouver dans l'onglet « Sécurité » ou même dans « Informatique de confiance » ou « Configuration du système d'exploitation Windows », etc. Assurez-vous de consulter le manuel du BIOS de votre carte mère ou de votre ordinateur pour savoir où il se trouve!
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Wenn Sie Ihren Computer neu starten, um das BIOS-Setup aufzurufen, müssen Sie wissen, wo sich die Secure-Boot-Einstellung befindet. Diese könnte sich in der Registerkarte „Sicherheit“ oder sogar unter „Trusted Computing“ oder „Windows-Betriebssystemkonfiguration“ usw. befinden. Schlagen Sie unbedingt im Handbuch Ihres Motherboards oder Computers nach, um herauszufinden, wo sich diese Einstellung befindet!
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Si reinicia el ordenador para acceder a la configuración del BIOS, debe saber dónde se encuentra la configuración de arranque seguro. Puede estar en la pestaña de seguridad o incluso en la configuración de confianza del sistema operativo Windows, etc. ¡Asegúrese de consultar el manual de la placa base o del BIOS del ordenador para averiguar dónde se encuentra!
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Se riavvii il computer per accedere alla configuración del BIOS, devi sapere dove si trova l'impostazione de avvio sicuro. Potrebbe trovarsi nella scheda Sicurezza o anche in Trusted Computing o Configurazione del sistema operativo Windows, ecc. Assicurati di consultare il manuale della scheda madre o del BIOS del computer per scoprire dove si trova!
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
コンピュータを再起動してBIOS設定画面に入った場合、セキュアブート設定の場所を把握しておく必要があります。セキュリティタブや、信頼できるコンピューティング設定、Windows OS構成などにある可能性があります。必ずマザーボードまたはコンピュータのBIOSマニュアルを参照し、設定場所を確認してください！
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
컴퓨터를 BIOS 설정으로 재부팅할 경우, 보안 부팅 설정 위치가 어디인지 알아야 합니다. 보안 탭이나 신뢰할 수 있는 컴퓨팅, Windows OS 구성 등 다양한 위치에 있을 수 있습니다. 반드시 메인보드나 컴퓨터의 BIOS 설명서를 참고하여 해당 설정이 어디에 있는지 확인하세요!
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_FinishUp-Warning
:Installer-Choices
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
What will you like to do? 7 buttons will show up. Click on the one you want to do.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Que souhaitez-vous faire ? 7 boutons apparaîtront. Cliquez sur celui qui vous intéresse.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Was möchten Sie tun? Es werden 7 Schaltflächen angezeigt. Klicken Sie auf diejenige, die Sie ausführen möchten.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
¿Qué te gustaría hacer? Aparecerán 7 botones. Haz clic en el que quieras hacer.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Cosa ti piacerebbe fare? Appariranno 7 pulsanti. Clicca su quello che desideri fare.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
何をしたいですか？7つのボタンが表示されます。やりたいものを選択してください。
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
어떤 것을 하고 싶으신가요? 7개의 버튼이 표시됩니다. 원하는 버튼을 클릭하세요.
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_Installer-Choices
:License-Terms_EXT
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
ALOSToy V1.0 Extended - License agreement Copyright (C) 2026 AaravLegend-Inc

Did you pay for this? If so, you were SCAMMED and may have malware instead!

This toolkit is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This toolkit has been created in the hope that it will be useful, but WITHOUT ANY WARRANTY, not even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. For more information, see the GNU General Public License.
You should have received a copy of the GNU General Public License along with this toolkit. If not, see https://www.gnu.org/licenses/.

SECTION 1 - DEFINITIONS
"Toolkit" refers to ALOSToy v1.0 Extended, including its source files, isos, documentation and any related files. "You" refers to the licensee or user of the toolkit. "Modified version" refers to any derivative work based on the toolkit.

SECTION 2 - AVAILABILITY OF SOURCE CODE
The complete source code of ALOSToy v1.0 Extended must be made available to anyone to whom the object code is created. This ensures transparency, allows others to study, and modify the code. There are also freely available extensions that include installation media for reinstalling a popular OS. These can be found here.

SECTION 3 - MODIFICATION CONDITIONS
You are allowed to modify the source code and create derivative works under the following conditions:
You may base projects using this.
This toolset may be forked to get a glimpse at Ventoy's advanced customisation.
You must not misrepresent the origin of the software.
Derivative works must also be licensed under the GNU GPL.
You may reverse engineer this toolkit and make your own.
If you want to find the source product for ALOSToy Extended, please visit https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
You may copy and distribute verbatim copies of the Toolkit source files as you receive them, in any medium, if you:
Conspicuously and appropriately publish on each copy an appropriate copyright notice.
Keep intact all notices that this License applies to the code.
Give all recipients a copy of this License along with the toolkit.

SECTION 5 - NO WARRANTY
THE TOOLKIT GIVES NO WARRANTY, TO THE EXTENT PERMITTED BY APPLICABLE LAW. THE TOOLKIT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

SECTION 6 - LIMITATION OF LIABILITY
IN NO EVENT, UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING, SHALL ANY COPYRIGHT HOLDER BE LIABLE TO YOU FOR ANY DAMAGES, INCLUDING GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE TOOLKIT.

This license is based on the GNU General Public License v3. See https://www.gnu.org/licenses/gpl-3.0.html for complete terms.

SECTION 7 – Extended Toolkit Info
Because this is the extended version of ALOSToy v1.0, you get a ton of additional features including:
Preloaded standard ALOSToy extensions.
Full iso’s for reinstalling Windows or Linux
Additional tools for extra diagnostics and other things.
And additional drivers for more devices especially laptop trackpads that need it’s own drivers to work.

This is the end of the license terms. Enjoy ALOSToy v1.0 Extended.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
ALOSToy V1.0 Extended - Contrat de licence Copyright (C) 2026 AaravLegend-Inc

Avez-vous payé pour cela ? Si oui, vous avez été victime d'une ARNAQUE et vous avez peut-être reçu un logiciel malveillant à la place!

Ce kit d'outils est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation, soit la version 3 de la licence, soit (à votre choix) toute version ultérieure.
Cette boîte à outils a été créée dans l'espoir qu'elle sera utile, mais SANS AUCUNE GARANTIE, pas même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER. Pour plus d'informations, consultez la licence publique générale GNU.
Vous devriez avoir reçu une copie de la licence publique générale GNU avec cette boîte à outils. Si ce n'est pas le cas, consultez https://www.gnu.org/licenses/.

SECTION 1 - DÉFINITIONS
Le terme « boîte à outils » désigne ALOSToy v1.0 Extended, y compris ses fichiers source, ses images ISO, sa documentation et tous les fichiers associés. Le terme « vous » désigne le titulaire de la licence ou l'utilisateur de la boîte à outils. Le terme « version modifiée » désigne toute œuvre dérivée basée sur la boîte à outils.

SECTION 2 - DISPONIBILITÉ DU CODE SOURCE
Le code source complet d'ALOSToy v1.0 Extended doit être mis à la disposition de toute personne pour laquelle le code objet est créé. Cela garantit la transparence et permet à d'autres personnes d'étudier et de modifier le code. Il existe également des extensions disponibles gratuitement qui comprennent des supports d'installation pour réinstaller un système d'exploitation populaire. Vous les trouverez ici.

SECTION 3 - CONDITIONS DE MODIFICATION
Vous êtes autorisé à modifier le code source et à créer des œuvres dérivées dans les conditions suivantes :
Vous pouvez baser vos projets sur celui-ci.
Cet ensemble d'outils peut être dérivé pour avoir un aperçu de la personnalisation avancée de Ventoy.
Vous ne devez pas déformer l'origine du logiciel.
Les œuvres dérivées doivent également être sous licence GNU GPL.
Vous pouvez procéder à une ingénierie inverse de cette boîte à outils et créer la vôtre.
Si vous souhaitez trouver le produit source d'ALOSToy Extended, veuillez consulter le site https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
Vous pouvez copier et distribuer des copies conformes des fichiers source de la boîte à outils tels que vous les avez reçus, sur tout support, à condition de :
Publiez de manière visible et appropriée sur chaque copie une mention de copyright appropriée.
Conservez intactes toutes les mentions indiquant que cette licence s'applique au code.
Donnez à tous les destinataires une copie de cette licence avec la boîte à outils.

SECTION 5 - ABSENCE DE GARANTIE
LA BOÎTE À OUTILS NE DONNE AUCUNE GARANTIE, DANS LA MESURE PERMISE PAR LA LOI APPLICABLE. LA BOÎTE À OUTILS EST FOURNIE « TELLE QUELLE », SANS GARANTIE D'AUCUNE SORTE, EXPRESSE OU IMPLICITE, Y COMPRIS, MAIS SANS S'Y LIMITER, LES GARANTIES IMPLICITES DE QUALITÉ MARCHANDE ET D'ADÉQUATION À UN USAGE PARTICULIER.

SECTION 6 - LIMITATION DE RESPONSABILITÉ
EN AUCUN CAS, SAUF SI LA LOI APPLICABLE L'EXIGE OU SI CELA A ÉTÉ CONVENU PAR ÉCRIT, LES TITULAIRES DE DROITS D'AUTEUR NE POURRONT ÊTRE TENUS RESPONSABLES ENVERS VOUS DE TOUT DOMMAGE, Y COMPRIS LES DOMMAGES GÉNÉRAUX, SPÉCIAUX, ACCESSOIRES OU CONSÉCUTIFS À L' , RÉSULTANT DE L'UTILISATION OU DE L'INCAPACITÉ À UTILISER LA BOÎTE À OUTILS.

Cette licence est basée sur la licence publique générale GNU v3. Voir https://www.gnu.org/licenses/gpl-3.0.html pour les conditions complètes.

SECTION 7 – Informations sur la boîte à outils étendue
Comme il s'agit de la version étendue d'ALOSToy v1.0, vous bénéficiez d'une multitude de fonctionnalités supplémentaires, notamment :
Extensions ALOSToy standard préchargées.
Images ISO complètes pour réinstaller Windows ou Linux
Des outils supplémentaires pour des diagnostics supplémentaires et d'autres choses.
Et des pilotes supplémentaires pour davantage de périphériques, en particulier les pavés tactiles d'ordinateurs portables qui nécessitent leurs propres pilotes pour fonctionner.

Ceci conclut les conditions de licence. Profitez pleinement d'ALOSToy v1.0 Extended.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
ALOSToy V1.0 Extended – Lizenzvereinbarung Copyright (C) 2026 AaravLegend-Inc

Haben Sie dafür bezahlt? Wenn ja, wurden Sie BETROGEN und haben möglicherweise stattdessen Malware!

Dieses Toolkit ist freie Software: Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, entweder in der Version 3 der Lizenz oder (nach Ihrer Wahl) in einer späteren Version weitergeben und/oder modifizieren.
Dieses Toolkit wurde in der Hoffnung erstellt, dass es nützlich ist, jedoch OHNE JEGLICHE GARANTIE, auch ohne die implizite Garantie der MARKTGÄNGIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK. Weitere Informationen finden Sie in der GNU General Public License.
Sie sollten zusammen mit diesem Toolkit eine Kopie der GNU General Public License erhalten haben. Falls nicht, finden Sie diese unter https://www.gnu.org/licenses/.

ABSCHNITT 1 – DEFINITIONEN
„Toolkit” bezieht sich auf ALOSToy v1.0 Extended, einschließlich seiner Quelldateien, ISOs, Dokumentation und aller zugehörigen Dateien. „Sie” bezieht sich auf den Lizenznehmer oder Nutzer des Toolkits. „Modifizierte Version” bezieht sich auf alle abgeleiteten Werke, die auf dem Toolkit basieren.

ABSCHNITT 2 – VERFÜGBARKEIT DES QUELLCODES
Der vollständige Quellcode von ALOSToy v1.0 Extended muss allen Personen zur Verfügung gestellt werden, für die der Objektcode erstellt wird. Dies gewährleistet Transparenz und ermöglicht es anderen, den Code zu studieren und zu modifizieren. Es gibt auch frei verfügbare Erweiterungen, die Installationsmedien für die Neuinstallation eines gängigen Betriebssystems enthalten. Diese finden Sie hier.

ABSCHNITT 3 – ÄNDERUNGSBEDINGUNGEN
Sie dürfen den Quellcode unter den folgenden Bedingungen ändern und abgeleitete Werke erstellen:
Sie können Projekte auf dieser Grundlage erstellen.
Dieses Toolset kann geforkt werden, um einen Einblick in die erweiterten Anpassungsmöglichkeiten von Ventoy zu erhalten.
Sie dürfen die Herkunft der Software nicht falsch darstellen.
Abgeleitete Werke müssen ebenfalls unter der GNU GPL lizenziert werden.
Sie dürfen dieses Toolkit zurückentwickeln und Ihr eigenes erstellen.
Wenn Sie das Quellprodukt für ALOSToy Extended suchen, besuchen Sie bitte https://www.ventoy.net.

ABSCHNITT 4 – WEITERVERBREITUNG
Sie dürfen unveränderte Kopien der Toolkit-Quelldateien, wie Sie sie erhalten haben, auf jedem Medium kopieren und verbreiten, wenn Sie:
auf jeder Kopie deutlich sichtbar und in angemessener Weise einen entsprechenden Copyright-Vermerk anbringen.
alle Hinweise, dass diese Lizenz für den Code gilt, unverändert beibehalten.
Sie allen Empfängern zusammen mit dem Toolkit eine Kopie dieser Lizenz aushändigen.

ABSCHNITT 5 – KEINE GEWÄHRLEISTUNG
DAS TOOLKIT GIBT KEINE GEWÄHRLEISTUNG, SOWEIT DIES NACH GELTENDEM RECHT ZULÄSSIG IST. DAS TOOLKIT WIRD „WIE BESEHEN“ OHNE JEGLICHE AUSDRÜCKLICHE ODER STILLSCHWEIGENDE GEWÄHRLEISTUNG, EINSCHLIESSLICH, ABER NICHT BESCHRÄNKT AUF DIE STILLSCHWEIGENDE GEWÄHRLEISTUNG DER MARKTGÄNGIGKEIT UND EIGNUNG FÜR EINEN BESTIMMTEN ZWECK, BEREITGESTELLT.

ABSCHNITT 6 – HAFTUNGSBESCHRÄNKUNG
IN KEINEM FALL, SOFERN NICHT GESETZLICH VORGESCHRIEBEN ODER SCHRIFTLICH VEREINBART, HAFTET EIN URHEBERRECHTSINHABER IHNEN GEGENÜBER FÜR SCHÄDEN, EINSCHLIESSLICH ALLGEMEINER, BESONDERER, ZUFÄLLIGER ODER FOLGESCHÄDEN , DIE SICH AUS DER NUTZUNG ODER DER UNMÖGLICHKEIT DER NUTZUNG DES TOOLKITS ERGEBEN.

Diese Lizenz basiert auf der GNU General Public License v3. Die vollständigen Bedingungen finden Sie unter https://www.gnu.org/licenses/gpl-3.0.html.

ABSCHNITT 7 – Informationen zum erweiterten Toolkit
Da es sich um die erweiterte Version von ALOSToy v1.0 handelt, erhalten Sie eine Vielzahl zusätzlicher Funktionen, darunter:
Vorinstallierte Standard-Erweiterungen für ALOSToy.
Vollständige ISOs zur Neuinstallation von Windows oder Linux
Zusätzliche Tools für weitere Diagnosen und andere Zwecke.
Und zusätzliche Treiber für weitere Geräte, insbesondere Laptop-Trackpads, die eigene Treiber benötigen, um zu funktionieren.

Dies ist das Ende der Lizenzbedingungen. Viel Spaß mit ALOSToy v1.0 Extended.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
ALOSToy V1.0 Extended - Acuerdo de licencia Copyright (C) 2026 AaravLegend-Inc

¿Ha pagado por esto? Si es así, ¡le han ESTAFADO y es posible que tenga malware en su lugar!

Este kit de herramientas es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia Pública General GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia o (a su elección) cualquier versión posterior.
Este kit de herramientas se ha creado con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA, ni siquiera la garantía implícita de COMERCIABILIDAD o IDONEIDAD PARA UN FIN DETERMINADO. Para obtener más información, consulta la Licencia Pública General GNU.
Debería haber recibido una copia de la Licencia Pública General GNU junto con este kit de herramientas. Si no es así, consulte https://www.gnu.org/licenses/.

SECCIÓN 1 - DEFINICIONES
«Kit de herramientas» se refiere a ALOSToy v1.0 Extended, incluidos sus archivos fuente, isos, documentación y cualquier archivo relacionado. «Usted» se refiere al licenciatario o usuario del kit de herramientas. «Versión modificada» se refiere a cualquier trabajo derivado basado en el kit de herramientas.

SECCIÓN 2 - DISPONIBILIDAD DEL CÓDIGO FUENTE
El código fuente completo de ALOSToy v1.0 Extended debe estar disponible para cualquier persona a la que se le haya creado el código objeto. Esto garantiza la transparencia y permite que otros estudien y modifiquen el código. También hay extensiones disponibles gratuitamente que incluyen medios de instalación para reinstalar un sistema operativo popular. Se pueden encontrar aquí.

SECCIÓN 3 - CONDICIONES DE MODIFICACIÓN
Se permite modificar el código fuente y crear obras derivadas bajo las siguientes condiciones:
Puede basar proyectos en su uso.
Este conjunto de herramientas puede bifurcarse para echar un vistazo a la personalización avanzada de Ventoy.
No debe tergiversar el origen del software.
Las obras derivadas también deben tener licencia GNU GPL.
Puede realizar ingeniería inversa en este conjunto de herramientas y crear el suyo propio.
Si desea encontrar el producto original de ALOSToy Extended, visite https://www.ventoy.net.

SECCIÓN 4: REDISTRIBUCIÓN
Puede copiar y distribuir copias literales de los archivos fuente del kit de herramientas tal y como los recibe, en cualquier medio, si:
Publica de forma visible y adecuada en cada copia un aviso de derechos de autor apropiado.
Mantiene intactos todos los avisos de que esta licencia se aplica al código.
Entregue a todos los destinatarios una copia de esta licencia junto con el kit de herramientas.

SECCIÓN 5 - SIN GARANTÍA
EL KIT DE HERRAMIENTAS NO OFRECE NINGUNA GARANTÍA, EN LA MEDIDA EN QUE LO PERMITA LA LEY APLICABLE. EL KIT DE HERRAMIENTAS SE PROPORCIONA «TAL CUAL», SIN GARANTÍA DE NINGÚN TIPO, YA SEA EXPRESA O IMPLÍCITA, INCLUIDAS, ENTRE OTRAS, LAS GARANTÍAS IMPLÍCITAS DE COMERCIABILIDAD E IDONEIDAD PARA UN FIN DETERMINADO.

SECCIÓN 6: LIMITACIÓN DE RESPONSABILIDAD
EN NINGÚN CASO, A MENOS QUE LO EXIJA LA LEY APLICABLE O SE ACUERDE POR ESCRITO, LOS TITULARES DE LOS DERECHOS DE AUTOR SERÁN RESPONSABLES ANTE USTED POR NINGÚN DAÑO, INCLUIDOS LOS DAÑOS GENERALES, ESPECIALES, INCIDENTALES O CONSECUENCIALES ES DERIVADOS DEL USO O DE LA IMPOSIBILIDAD DE USAR EL KIT DE HERRAMIENTAS.

Esta licencia se basa en la Licencia Pública General GNU v3. Consulte https://www.gnu.org/licenses/gpl-3.0.html para conocer los términos completos.

SECCIÓN 7: Información sobre el kit de herramientas ampliado
Dado que se trata de la versión ampliada de ALOSToy v1.0, obtendrá un montón de funciones adicionales, entre las que se incluyen:
Extensiones estándar de ALOSToy precargadas.
Imágenes ISO completas para reinstalar Windows o Linux.
Herramientas adicionales para diagnósticos extra y otras cosas.
Y controladores adicionales para más dispositivos, especialmente trackpads de portátiles que necesitan sus propios controladores para funcionar.

Aquí finalizan los términos de la licencia. Disfruta de ALOSToy v1.0 Extended.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
ALOSToy V1.0 Extended - Contratto di licenza Copyright (C) 2026 AaravLegend-Inc

Hai pagato per questo? Se sì, sei stato TRUFFATO e potresti avere un malware!

Questo toolkit è un software gratuito: puoi ridistribuirlo e/o modificarlo secondo i termini della GNU General Public License pubblicata dalla Free Software Foundation, sia nella versione 3 della Licenza, sia (a tua discrezione) in qualsiasi versione successiva.
Questo toolkit è stato creato nella speranza che possa essere utile, ma SENZA ALCUNA GARANZIA, nemmeno la garanzia implicita di COMMERCIABILITÀ o IDONEITÀ PER UN PARTICOLARE SCOPO. Per ulteriori informazioni, consulta la GNU General Public License.
Dovresti aver ricevuto una copia della GNU General Public License insieme a questo toolkit. In caso contrario, consulta https://www.gnu.org/licenses/.

SEZIONE 1 - DEFINIZIONI
Per "Toolkit" si intende ALOSToy v1.0 Extended, inclusi i file sorgente, le immagini ISO, la documentazione e qualsiasi file correlato. Per "Utente" si intende il licenziatario o l'utente del toolkit. Per "Versione modificata" si intende qualsiasi opera derivata basata sul toolkit.

SEZIONE 2 - DISPONIBILITÀ DEL CODICE SORGENTE
Il codice sorgente completo di ALOSToy v1.0 Extended deve essere reso disponibile a chiunque abbia creato il codice oggetto. Ciò garantisce la trasparenza e consente ad altri di studiare e modificare il codice. Sono inoltre disponibili estensioni gratuite che includono supporti di installazione per reinstallare un sistema operativo diffuso. Queste sono disponibili qui.

SEZIONE 3 - CONDIZIONI DI MODIFICA
È consentito modificare il codice sorgente e creare opere derivate alle seguenti condizioni:
È possibile basare progetti utilizzando questo.
Questo set di strumenti può essere biforcato per avere un assaggio della personalizzazione avanzata di Ventoy.
Non è consentito travisare l'origine del software.
Anche le opere derivate devono essere concesse in licenza ai sensi della GNU GPL.
È possibile decodificare questo toolkit e crearne uno proprio.
Se desiderate trovare il prodotto sorgente per ALOSToy Extended, visitate il sito https://www.ventoy.net.

SEZIONE 4 - RIDISTRIBUZIONE
È possibile copiare e distribuire copie fedeli dei file sorgente del Toolkit così come ricevuti, su qualsiasi supporto, a condizione che:
Pubblicare in modo visibile e appropriato su ciascuna copia un'adeguata nota sul copyright.
Mantenere intatti tutti gli avvisi che indicano che la presente Licenza si applica al codice.
Fornire a tutti i destinatari una copia della presente Licenza insieme al toolkit.

SEZIONE 5 - ESCLUSIONE DI GARANZIA
IL TOOLKIT NON FORNISCE ALCUNA GARANZIA, NEI LIMITI CONSENTITI DALLA LEGGE APPLICABILE. IL TOOLKIT VIENE FORNITO "COSÌ COM'È" SENZA ALCUN TIPO DI GARANZIA, ESPLICITA O IMPLICITA, INCLUSE, A TITOLO ESEMPLIFICATIVO MA NON ESAUSTIVO, LE GARANZIE IMPLICITE DI COMMERCIABILITÀ E IDONEITÀ PER UN PARTICOLARE SCOPO.

SEZIONE 6 - LIMITAZIONE DI RESPONSABILITÀ
IN NESSUN CASO, SALVO QUANTO PREVISTO DALLA LEGGE APPLICABILE O CONCORDATO PER ISCRITTO, I TITOLARI DEL DIRITTO D'AUTORE SARANNO RESPONSABILI NEI CONFRONTI DELL'UTENTE PER EVENTUALI DANNI, INCLUSE LE PERDITE GENERALI, SPECIALI, INCIDENTALI O CONSEGUENTI I DERIVANTI DALL'UTILIZZO O DALL'IMPOSSIBILITÀ DI UTILIZZARE IL TOOLKIT.

La presente licenza si basa sulla GNU General Public License v3. Per i termini completi, consultare https://www.gnu.org/licenses/gpl-3.0.html.

SEZIONE 7 - Informazioni sul toolkit esteso
Poiché questa è la versione estesa di ALOSToy v1.0, avrai a disposizione tantissime funzionalità aggiuntive, tra cui:
Estensioni ALOSToy standard precaricate.
ISO complete per reinstallare Windows o Linux
Strumenti aggiuntivi per diagnostica extra e altro.
E driver aggiuntivi per più dispositivi, in particolare trackpad di laptop che necessitano di driver propri per funzionare.

Questo è tutto per quanto riguarda i termini della licenza. Buon divertimento con ALOSToy v1.0 Extended.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToy V1.0 Extended - ライセンス契約著作権 (C) 2026 AaravLegend-Inc

これは購入したものですか？もしそうなら、あなたは詐欺に遭い、マルウェアを入手した可能性があります！

本ツールキットはフリーソフトウェアです：フリーソフトウェア財団が公開したGNU一般公衆利用許諾契約書（バージョン3または（任意で）それ以降のバージョン）の条件に基づき、再配布および／または改変が可能です。
このツールキットは有用であることを願って作成されましたが、いかなる保証もありません。商品性や特定目的への適合性に関する黙示の保証すら含まれません。詳細はGNU一般公衆利用許諾契約書を参照してください。
本ツールキットにはGNU一般公衆利用許諾契約書の写しが同封されているはずです。同封されていない場合は、https://www.gnu.org/licenses/ をご覧ください。

第1条 - 定義
「ツールキット」とは、ALOSToy v1.0 Extended（ソースファイル、ISOイメージ、ドキュメント、および関連ファイルを含む）を指します。「あなた」とは、ツールキットのライセンシーまたはユーザーを指します。「改変版」とは、ツールキットに基づくあらゆる派生作品を指し ます。

セクション2 - ソースコードの提供
ALOSToy v1.0 Extendedの完全なソースコードは、オブジェクトコードが生成されたすべての者に提供されなければなりません。これにより透明性が確保され、他者がコードを研究・修正することが可能となります。また、人気OSの再インストール用インストールメディアを含む拡張機能も無料で利用可能です。これらはここで入手できます。

セクション3 - 改変条件
以下の条件下でソースコードの改変および派生作品の作成が許可されます：
本ツールセットを基にしたプロジェクトを作成できます。
本ツールセットは、Ventoyの高度なカスタマイズを垣間見るためにフォークすることができます。
ソフトウェアの出所を偽って表示してはなりません。
派生作品もGNU GPLの下でライセンスされなければなりません。
本ツールキットをリバースエンジニアリングし、独自のものを作成することは可能です。
ALOSToy Extended のソース製品をお探しの方は、https://www.ventoy.net をご覧ください。

第4条 - 再配布
以下の条件を満たす場合、ツールキットのソースファイルを、受け取ったままの状態で、あらゆる媒体に複製・再配布することができます。
各コピーに、適切かつ目立つ形で適切な著作権表示を掲載すること。
本ライセンスがコードに適用される旨の通知をすべてそのまま保持すること。
ツールキットと共に本ライセンスの写しを全ての受領者に提供すること。

第5条 - 保証の否認
適用される法律で認められる範囲において、本ツールキットは一切の保証を行いません。 本ツールキットは「現状有姿」で提供され、商品性および特定目的への適合性に関する黙示の保証を含むがこれに限定されない、明示または黙示のいかなる保証も一切行われない。

第6条 - 責任の制限
適用される法律で要求される場合、または書面で合意された場合を除き、いかなる著作権者も、ツールキットの使用または使用不能に起因する、一般的、特別、付随的、または 結果的損害を含む、いかなる損害についても、お客様に対して責任を負わないものとします。

本ライセンスはGNU General Public License v3に基づいています。完全な条項についてはhttps://www.gnu.org/licenses/gpl-3.0.htmlを参照してください。

セクション7 – 拡張ツールキット情報
これはALOSToy v1.0の拡張版であるため、以下のような多数の追加機能を利用できます:
標準ALOSToy拡張機能のプリロード。
WindowsまたはLinuxの再インストール用完全ISOイメージ
追加診断ツールおよびその他の機能
特に専用ドライバーが必要なノートPCトラックパッドなど、より多くのデバイスに対応する追加ドライバー。

以上がライセンス条項の終わりです。ALOSToy v1.0 Extendedをお楽しみください。
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
ALOSToy V1.0 Extended - 라이선스 계약서 저작권 (C) 2026 AaravLegend-Inc

이걸 구매하셨나요? 그렇다면 사기 당한 것이며 악성 코드를 설치했을 수 있습니다!

이 툴킷은 자유 소프트웨어입니다: 귀하는 자유 소프트웨어 재단이 발표한 GNU 일반 공중 사용 허가서(GNU General Public License)의 조건에 따라, 라이선스 버전 3 또는 (선택에 따라) 그 이후 버전을 사용하여 이를 재배포 및/또는 수정할 수 있습니다.
이 툴킷은 유용할 것이라는 희망으로 제작되었으나, 상품성 또는 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하여 어떠한 보증도 제공하지 않습니다. 자세한 내용은 GNU 일반 공중 사용 허가서를 참조하십시오.
본 툴킷과 함께 GNU 일반 공중 사용 허가서 사본을 받으셨을 것입니다. 그렇지 않은 경우 https://www.gnu.org/licenses/를 참조하십시오.

제1조 - 정의
"툴킷"은 소스 파일, ISO, 문서 및 관련 파일을 포함한 ALOSToy v1.0 Extended를 의미합니다. "귀하"는 툴킷의 라이선스 보유자 또는 사용자를 의미합니다. "수정 버전"은 툴킷을 기반으로 한 모든 파생 작업을 의미합니다.

제2조 - 소스 코드 제공
ALOSToy v1.0 Extended의 완전한 소스 코드는 객체 코드가 생성된 모든 사람에게 제공되어야 합니다. 이는 투명성을 보장하고, 다른 사람들이 코드를 연구하고 수정할 수 있도록 합니다. 또한 인기 있는 OS를 재설치하기 위한 설치 미디어를 포함하는 무료로 이용 가능한  확장 기능도 있습니다. 여기에서 확인할 수 있습니다.

제3조 - 수정 조건
다음 조건 하에 소스 코드를 수정하고 파생 저작물을 생성할 수 있습니다:
이를 기반으로 프로젝트를 진행할 수 있습니다.
이 툴셋은 Ventoy의 고급 사용자 지정 기능을 살펴보기 위해 포크될 수 있습니다.
소프트웨어의 출처를 허위로 표시해서는 안 됩니다.
파생 작품 역시 GNU GPL 라이선스 하에 배포되어야 합니다.
본 툴킷을 리버스 엔지니어링하여 자체 버전을 제작할 수 있습니다.
ALOSToy Extended의 원본 제품을 찾으려면 https://www.ventoy.net을 방문하십시오.

섹션 4 - 재배포
다음과 같은 경우, 수신한 툴킷 소스 파일의 원본을 그대로 복사하여 모든 매체로 배포할 수 있습니다.
각 사본에 적절한 저작권 고지를 눈에 띄고 적절하게 게시해야 합니다.
본 라이선스가 해당 코드에 적용됨을 알리는 모든 고지를 그대로 유지해야 합니다.
모든 수령인에게 툴킷과 함께 본 라이선스의 사본을 제공해야 합니다.

제5조 - 보증의 부인
해당 법률이 허용하는 범위 내에서, 툴킷은 어떠한 보증도 제공하지 않습니다. 본 툴킷은 "있는 그대로" 제공되며, 상품성 및 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하되 이에 국한되지 않는, 어떠한 종류의 명시적 또는 묵시적 보증도 제공되지 않습니다.

제6조 - 책임의 제한
적용 가능한 법률에 의해 요구되거나 서면으로 합의된 경우를 제외하고, 어떠한 저작권자도 본 툴킷의 사용 또는 사용 불능으로 인해 발생하는 일반적, 특별, 부수적 또는 결과적 손해 배상 등 어떠한 손해에 대해서도 귀하에게 책임을 지지 않습니다.

본 라이선스는 GNU 일반 공중 사용 허가서 v3을 기반으로 합니다. 전체 약관은 https://www.gnu.org/licenses/gpl-3.0.html에서 확인하실 수 있습니다.

섹션 7 – 확장 툴킷 정보
본 버전은 ALOSToy v1.0의 확장판이므로 다음과 같은 다양한 추가 기능을 제공합니다:
사전 로드된 표준 ALOSToy 확장 기능.
Windows 또는 Linux 재설치를 위한 전체 ISO 이미지
추가 진단 및 기타 작업을 위한 도구.
그리고 별도의 드라이버가 필요한 노트북 트랙패드 등 더 많은 장치를 위한 추가 드라이버.

라이선스 약관은 여기까지입니다. ALOSToy v1.0 확장판을 즐기십시오.
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No license text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_License-Terms_EXT
:License-Terms_STD
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
ALOSToy V1.0 Standard - License agreement Copyright (C) 2026 AaravLegend-Inc

Did you pay for this? If so, you were SCAMMED and may have malware instead!

This toolkit is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This toolkit has been created in the hope that it will be useful, but WITHOUT ANY WARRANTY, not even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. For more information, see the GNU General Public License.
You should have received a copy of the GNU General Public License along with this toolkit. If not, see https://www.gnu.org/licenses/.

SECTION 1 - DEFINITIONS
"Toolkit" refers to ALOSToy v1.0 Standard, including its source files, isos, documentation and any related files. "You" refers to the licensee or user of the toolkit. "Modified version" refers to any derivative work based on the toolkit.

SECTION 2 - AVAILABILITY OF SOURCE CODE
The complete source code of ALOSToy v1.0 Standard must be made available to anyone to whom the object code is created. This ensures transparency, allows others to study, and modify the code. There are also freely available extensions that include installation media for reinstalling a popular OS. These can be found here.

SECTION 3 - MODIFICATION CONDITIONS
You are allowed to modify the source code and create derivative works under the following conditions:
You may base projects using this.
This toolset may be copied and forked to get a glimpse at Ventoy's advanced customisation.
You must not misrepresent the origin of the software.
Derivative works must also be licensed under the GNU GPL.
You may reverse engineer this software.
If you want to find the source product for ALOSToy Standard, please visit https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
You may copy and distribute verbatim copies of the Toolkit source files as you receive them, in any medium, if you:
Conspicuously and appropriately publish on each copy an appropriate copyright notice.
Keep intact all notices that this License applies to the code.
Give all recipients a copy of this License along with the toolkit.

SECTION 5 - NO WARRANTY
THE TOOLKIT GIVES NO WARRANTY, TO THE EXTENT PERMITTED BY APPLICABLE LAW. THE TOOLKIT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

SECTION 6 - LIMITATION OF LIABILITY
IN NO EVENT, UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING, SHALL ANY COPYRIGHT HOLDER BE LIABLE TO YOU FOR ANY DAMAGES, INCLUDING GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE TOOLKIT.

This license is based on the GNU General Public License v3. See https://www.gnu.org/licenses/gpl-3.0.html for complete terms.
This is the end of the license terms. Enjoy ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
ALOSToy V1.0 Standard - Contrat de licence Copyright (C) 2026 AaravLegend-Inc

Avez-vous payé pour cela ? Si oui, vous avez été victime d'une ARNAQUE et vous avez peut-être reçu un logiciel malveillant à la place!

Ce kit d'outils est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation, soit la version 3 de la licence, soit (à votre choix) toute version ultérieure.
Cette boîte à outils a été créée dans l'espoir qu'elle sera utile, mais SANS AUCUNE GARANTIE, pas même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER. Pour plus d'informations, consultez la licence publique générale GNU.
Vous devriez avoir reçu une copie de la licence publique générale GNU avec cette boîte à outils. Si ce n'est pas le cas, consultez https://www.gnu.org/licenses/.

SECTION 1 - DÉFINITIONS
Le terme « boîte à outils » désigne ALOSToy v1.0 Standard, y compris ses fichiers source, ses images ISO, sa documentation et tous les fichiers associés. Le terme « vous » désigne le titulaire de la licence ou l'utilisateur de la boîte à outils. Le terme « version modifiée » désigne toute œuvre dérivée basée sur la boîte à outils.

SECTION 2 - DISPONIBILITÉ DU CODE SOURCE
Le code source complet d'ALOSToy v1.0 Standard doit être mis à la disposition de toute personne pour laquelle le code objet est créé. Cela garantit la transparence et permet à d'autres personnes d'étudier et de modifier le code. Il existe également des extensions disponibles gratuitement qui comprennent des supports d'installation pour réinstaller un système d'exploitation populaire. Vous les trouverez ici.

SECTION 3 - CONDITIONS DE MODIFICATION
Vous êtes autorisé à modifier le code source et à créer des œuvres dérivées dans les conditions suivantes :
Vous pouvez baser vos projets sur celui-ci.
Cet ensemble d'outils peut être copié et dupliqué pour avoir un aperçu de la personnalisation avancée de Ventoy.
Vous ne devez pas déformer l'origine du logiciel.
Les œuvres dérivées doivent également être sous licence GNU GPL.
Vous pouvez procéder à une ingénierie inverse de ce logiciel.
Si vous souhaitez trouver le produit source pour ALOSToy Standard, veuillez consulter le site https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
Vous pouvez copier et distribuer des copies conformes des fichiers source du Toolkit tels que vous les avez reçus, sur tout support, à condition de :
Publiez de manière visible et appropriée sur chaque copie une mention de copyright appropriée.
Conservez intactes toutes les mentions indiquant que cette licence s'applique au code.
Donnez à tous les destinataires une copie de cette licence avec la boîte à outils.

SECTION 5 - ABSENCE DE GARANTIE
LA BOÎTE À OUTILS NE DONNE AUCUNE GARANTIE, DANS LA MESURE PERMISE PAR LA LOI APPLICABLE. LA BOÎTE À OUTILS EST FOURNIE « TELLE QUELLE », SANS GARANTIE D'AUCUNE SORTE, EXPRESSE OU IMPLICITE, Y COMPRIS, MAIS SANS S'Y LIMITER, LES GARANTIES IMPLICITES DE QUALITÉ MARCHANDE ET D'ADÉQUATION À UN USAGE PARTICULIER.

SECTION 6 - LIMITATION DE RESPONSABILITÉ
EN AUCUN CAS, SAUF SI LA LOI APPLICABLE L'EXIGE OU SI CELA A ÉTÉ CONVENU PAR ÉCRIT, LES TITULAIRES DE DROITS D'AUTEUR NE POURRONT ÊTRE TENUS RESPONSABLES ENVERS VOUS DE TOUT DOMMAGE, Y COMPRIS LES DOMMAGES GÉNÉRAUX, SPÉCIAUX, ACCESSOIRES OU CONSÉCUTIFS À L' , RÉSULTANT DE L'UTILISATION OU DE L'INCAPACITÉ À UTILISER LA BOÎTE À OUTILS.

Cette licence est basée sur la licence publique générale GNU v3. Voir https://www.gnu.org/licenses/gpl-3.0.html pour les conditions complètes.
Ceci est la fin des conditions de licence. Profitez bien d'ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
ALOSToy V1.0 Standard – Lizenzvereinbarung Copyright (C) 2026 AaravLegend-Inc

Haben Sie dafür bezahlt? Wenn ja, wurden Sie BETROGEN und haben möglicherweise stattdessen Malware erhalten!
Dieses Toolkit ist freie Software: Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, entweder in der Version 3 der Lizenz oder (nach Ihrer Wahl) in einer späteren Version weitergeben und/oder modifizieren.
Dieses Toolkit wurde in der Hoffnung erstellt, dass es nützlich ist, jedoch OHNE JEGLICHE GARANTIE, auch ohne die implizite Garantie der MARKTGÄNGIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK. Weitere Informationen finden Sie in der GNU General Public License.
Sie sollten zusammen mit diesem Toolkit eine Kopie der GNU General Public License erhalten haben. Falls nicht, finden Sie diese unter https://www.gnu.org/licenses/.

ABSCHNITT 1 – DEFINITIONEN
„Toolkit” bezieht sich auf ALOSToy v1.0 Standard, einschließlich seiner Quelldateien, ISOs, Dokumentation und aller zugehörigen Dateien. „Sie” bezieht sich auf den Lizenznehmer oder Nutzer des Toolkits. „Modifizierte Version” bezieht sich auf alle abgeleiteten Werke, die auf dem Toolkit basieren.

ABSCHNITT 2 – VERFÜGBARKEIT DES QUELLCODES
Der vollständige Quellcode von ALOSToy v1.0 Standard muss allen Personen zur Verfügung gestellt werden, für die der Objektcode erstellt wird. Dies gewährleistet Transparenz und ermöglicht es anderen, den Code zu studieren und zu modifizieren. Es gibt auch frei verfügbare Erweiterungen, die Installationsmedien für die Neuinstallation eines gängigen Betriebssystems enthalten. Diese finden Sie hier.

ABSCHNITT 3 – ÄNDERUNGSBEDINGUNGEN
Sie dürfen den Quellcode unter den folgenden Bedingungen ändern und abgeleitete Werke erstellen:
Sie können Projekte auf dieser Grundlage erstellen.
Dieses Toolset darf kopiert und geforkt werden, um einen Einblick in die erweiterten Anpassungsmöglichkeiten von Ventoy zu erhalten.
Sie dürfen die Herkunft der Software nicht falsch darstellen.
Abgeleitete Werke müssen ebenfalls unter der GNU GPL lizenziert werden.
Sie dürfen diese Software zurückentwickeln.
Wenn Sie das Quellprodukt für ALOSToy Standard suchen, besuchen Sie bitte https://www.ventoy.net.

ABSCHNITT 4 – WEITERVERBREITUNG
Sie dürfen unveränderte Kopien der Toolkit-Quelldateien, wie Sie sie erhalten haben, auf jedem Medium kopieren und verbreiten, wenn Sie:
auf jeder Kopie deutlich sichtbar und in angemessener Weise einen entsprechenden Copyright-Vermerk anbringen.
alle Hinweise, dass diese Lizenz für den Code gilt, unverändert beibehalten.
Sie allen Empfängern zusammen mit dem Toolkit eine Kopie dieser Lizenz aushändigen.

ABSCHNITT 5 – KEINE GEWÄHRLEISTUNG
DAS TOOLKIT GIBT KEINE GEWÄHRLEISTUNG, SOWEIT DIES NACH GELTENDEM RECHT ZULÄSSIG IST. DAS TOOLKIT WIRD „WIE BESEHEN“ OHNE JEGLICHE AUSDRÜCKLICHE ODER STILLSCHWEIGENDE GEWÄHRLEISTUNG, EINSCHLIESSLICH, ABER NICHT BESCHRÄNKT AUF DIE STILLSCHWEIGENDE GEWÄHRLEISTUNG DER MARKTGÄNGIGKEIT UND EIGNUNG FÜR EINEN BESTIMMTEN ZWECK, BEREITGESTELLT.

ABSCHNITT 6 – HAFTUNGSBESCHRÄNKUNG
IN KEINEM FALL, SOFERN NICHT GESETZLICH VORGESCHRIEBEN ODER SCHRIFTLICH VEREINBART, HAFTET EIN URHEBERRECHTSINHABER IHNEN GEGENÜBER FÜR SCHÄDEN, EINSCHLIESSLICH ALLGEMEINER, BESONDERER, ZUFÄLLIGER ODER FOLGESCHÄDEN , DIE SICH AUS DER NUTZUNG ODER DER UNMÖGLICHKEIT DER NUTZUNG DES TOOLKITS ERGEBEN.

Diese Lizenz basiert auf der GNU General Public License v3. Die vollständigen Bedingungen finden Sie unter https://www.gnu.org/licenses/gpl-3.0.html.
Dies ist das Ende der Lizenzbedingungen. Viel Spaß mit ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
ALOSToy V1.0 Estándar - Acuerdo de licencia Copyright (C) 2026 AaravLegend-Inc

¿Ha pagado por esto? Si es así, ¡le han ESTAFADO y es posible que tenga malware en su lugar!
Este kit de herramientas es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia Pública General GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia o (a su elección) cualquier versión posterior.
Este kit de herramientas se ha creado con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA, ni siquiera la garantía implícita de COMERCIABILIDAD o IDONEIDAD PARA UN FIN DETERMINADO. Para obtener más información, consulte la Licencia Pública General GNU.
Debería haber recibido una copia de la Licencia Pública General GNU junto con este kit de herramientas. Si no es así, consulte https://www.gnu.org/licenses/.

SECCIÓN 1 - DEFINICIONES
«Kit de herramientas» se refiere a ALOSToy v1.0 Standard, incluidos sus archivos fuente, isos, documentación y cualquier archivo relacionado. «Usted» se refiere al licenciatario o usuario del kit de herramientas. «Versión modificada» se refiere a cualquier trabajo derivado basado en el kit de herramientas.

SECCIÓN 2 - DISPONIBILIDAD DEL CÓDIGO FUENTE
El código fuente completo de ALOSToy v1.0 Standard debe estar a disposición de cualquier persona para la que se cree el código objeto. Esto garantiza la transparencia y permite que otros estudien y modifiquen el código. También hay extensiones disponibles gratuitamente que incluyen medios de instalación para reinstalar un sistema operativo popular. Se pueden encontrar aquí.

SECCIÓN 3 - CONDICIONES DE MODIFICACIÓN
Se permite modificar el código fuente y crear obras derivadas bajo las siguientes condiciones:
Puede basar proyectos en su uso.
Este conjunto de herramientas se puede copiar y bifurcar para echar un vistazo a la personalización avanzada de Ventoy.
No debe tergiversar el origen del software.
Las obras derivadas también deben tener licencia GNU GPL.
Puede realizar ingeniería inversa en este software.
Si desea encontrar el producto original de ALOSToy Standard, visite https://www.ventoy.net.

SECCIÓN 4: REDISTRIBUCIÓN
Puede copiar y distribuir copias literales de los archivos fuente del kit de herramientas tal y como los recibe, en cualquier medio, si:
Publica de forma visible y adecuada en cada copia un aviso de derechos de autor apropiado.
Mantiene intactos todos los avisos de que esta licencia se aplica al código.
Entregue a todos los destinatarios una copia de esta licencia junto con el kit de herramientas.

SECCIÓN 5 - SIN GARANTÍA
EL KIT DE HERRAMIENTAS NO OFRECE NINGUNA GARANTÍA, EN LA MEDIDA EN QUE LO PERMITA LA LEY APLICABLE. EL KIT DE HERRAMIENTAS SE PROPORCIONA «TAL CUAL», SIN GARANTÍA DE NINGÚN TIPO, YA SEA EXPRESA O IMPLÍCITA, INCLUIDAS, ENTRE OTRAS, LAS GARANTÍAS IMPLÍCITAS DE COMERCIABILIDAD E IDONEIDAD PARA UN FIN DETERMINADO.

SECCIÓN 6: LIMITACIÓN DE RESPONSABILIDAD
EN NINGÚN CASO, A MENOS QUE LO EXIJA LA LEY APLICABLE O SE ACUERDE POR ESCRITO, LOS TITULARES DE LOS DERECHOS DE AUTOR SERÁN RESPONSABLES ANTE USTED POR NINGÚN DAÑO, INCLUIDOS LOS DAÑOS GENERALES, ESPECIALES, INCIDENTALES O CONSECUENCIALES ES QUE SURJAN DEL USO O LA IMPOSIBILIDAD DE USAR EL KIT DE HERRAMIENTAS.

Esta licencia se basa en la Licencia Pública General GNU v3. Consulte https://www.gnu.org/licenses/gpl-3.0.html para conocer los términos completos.
Aquí finalizan los términos de la licencia. Disfrute de ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
ALOSToy V1.0 Standard - Contratto di licenza Copyright (C) 2026 AaravLegend-Inc

Hai pagato per questo? Se sì, sei stato TRUFFATO e potresti avere un malware!

Questo toolkit è un software gratuito: puoi ridistribuirlo e/o modificarlo secondo i termini della GNU General Public License pubblicata dalla Free Software Foundation, sia nella versione 3 della Licenza, sia (a tua discrezione) in qualsiasi versione successiva.
Questo toolkit è stato creato nella speranza che possa essere utile, ma SENZA ALCUNA GARANZIA, nemmeno la garanzia implicita di COMMERCIABILITÀ o IDONEITÀ PER UN PARTICOLARE SCOPO. Per ulteriori informazioni, consulta la GNU General Public License.
Dovresti aver ricevuto una copia della GNU General Public License insieme a questo toolkit. In caso contrario, consulta https://www.gnu.org/licenses/.

SEZIONE 1 - DEFINIZIONI
Per "Toolkit" si intende ALOSToy v1.0 Standard, inclusi i file sorgente, le immagini ISO, la documentazione e qualsiasi file correlato. Per "Utente" si intende il licenziatario o l'utente del toolkit. Per "Versione modificata" si intende qualsiasi opera derivata basata sul toolkit.

SEZIONE 2 - DISPONIBILITÀ DEL CODICE SORGENTE
Il codice sorgente completo di ALOSToy v1.0 Standard deve essere reso disponibile a chiunque abbia creato il codice oggetto. Ciò garantisce la trasparenza e consente ad altri di studiare e modificare il codice. Sono inoltre disponibili estensioni gratuite che includono supporti di installazione per reinstallare un sistema operativo diffuso. Queste sono disponibili qui.

SEZIONE 3 - CONDIZIONI DI MODIFICA
È consentito modificare il codice sorgente e creare opere derivate alle seguenti condizioni:
È possibile basare progetti utilizzando questo.
Questo set di strumenti può essere copiato e biforcato per avere un assaggio della personalizzazione avanzata di Ventoy.
Non è consentito travisare l'origine del software.
Anche le opere derivate devono essere concesse in licenza ai sensi della GNU GPL.
È possibile decodificare questo software.
Se desiderate trovare il prodotto sorgente per ALOSToy Standard, visitate il sito https://www.ventoy.net.

SEZIONE 4 - RIDISTRIBUZIONE
È possibile copiare e distribuire copie fedeli dei file sorgente del Toolkit così come ricevuti, su qualsiasi supporto, a condizione che:
Pubblicare in modo visibile e appropriato su ciascuna copia un'adeguata nota sul copyright.
Mantenere intatti tutti gli avvisi che indicano che la presente Licenza si applica al codice.
Fornire a tutti i destinatari una copia della presente Licenza insieme al toolkit.

SEZIONE 5 - ESCLUSIONE DI GARANZIA
IL TOOLKIT NON FORNISCE ALCUNA GARANZIA, NEI LIMITI CONSENTITI DALLA LEGGE APPLICABILE. IL TOOLKIT VIENE FORNITO "COSÌ COM'È" SENZA ALCUN TIPO DI GARANZIA, ESPLICITA O IMPLICITA, INCLUSE, A TITOLO ESEMPLIFICATIVO MA NON ESAUSTIVO, LE GARANZIE IMPLICITE DI COMMERCIABILITÀ E IDONEITÀ PER UN PARTICOLARE SCOPO.

SEZIONE 6 - LIMITAZIONE DI RESPONSABILITÀ
IN NESSUN CASO, SALVO QUANTO PREVISTO DALLA LEGGE APPLICABILE O CONCORDATO PER ISCRITTO, I TITOLARI DEL DIRITTO D'AUTORE SARANNO RESPONSABILI NEI CONFRONTI DELL'UTENTE PER EVENTUALI DANNI, INCLUSE LE PERDITE GENERALI, SPECIALI, INCIDENTALI O CONSEGUENTI I DERIVANTI DALL'UTILIZZO O DALL'IMPOSSIBILITÀ DI UTILIZZARE IL TOOLKIT.

La presente licenza è basata sulla GNU General Public License v3. Per i termini completi, consultare https://www.gnu.org/licenses/gpl-3.0.html.
Questo è il termine dei termini di licenza. Buon divertimento con ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToy V1.0 Standard - ライセンス契約著作権 (C) 2026 AaravLegend-Inc

これは購入したものですか？もしそうなら、あなたは詐欺に遭い、マルウェアを入手した可能性があります！

このツールキットはフリーソフトウェアです：フリーソフトウェア財団が公開したGNU一般公衆利用許諾契約書（バージョン3または（任意で）それ以降のバージョン）の条件に基づき、再配布および／または改変が可能です。
このツールキットは有用であることを願って作成されましたが、いかなる保証もありません。商品性や特定目的への適合性に関する黙示の保証すら含まれません。詳細はGNU一般公衆利用許諾契約書を参照してください。
本ツールキットにはGNU一般公衆利用許諾契約書の写しが同封されているはずです。同封されていない場合は、https://www.gnu.org/licenses/ をご覧ください。

第1条 - 定義
「ツールキット」とは、ALOSToy v1.0 Standard（ソースファイル、ISOイメージ、ドキュメント、および関連ファイルを含む）を指します。「あなた」とは、ツールキットのライセンシーまたはユーザーを指します。「改変版」とは、ツールキットに基づくあらゆる派生作品を指します。
セクション2 - ソースコードの提供

ALOSToy v1.0 Standardの完全なソースコードは、オブジェクトコードが生成されたすべての者に提供されなければなりません。これ により透明性が確保され、他者がコードを研究・修正することが可能となります。また、人気OSの再インストール用インストールメディアを含む拡張機能も無料で利用可能です。これらはここで入手できます。
セクション3 - 改変条件

以下の条件下でソースコードの改変および派生作品の作成が許可されます：
本ツールセットを基にしたプロジェクトを作成できます。
本ツールセットは、Ventoyの高度なカスタマイズを把握するために複製・フォークできます。
ソフトウェアの出所を偽って表示してはなりません。
派生作品もGNU GPLの下でライセンスされなければなりません。
本ソフトウェアのリバースエンジニアリングは許可されます。
ALOSToy Standard のソース製品をお探しの方は、https://www.ventoy.net をご覧ください。

第4条 - 再配布
以下の条件を満たす場合、ツールキットのソースファイルを、受け取ったままの状態で、あらゆる媒体に複製・再配布することができます。
各コピーに、適切かつ目立つ形で適切な著作権表示を掲載すること。
本ライセンスがコードに適用される旨の通知をすべてそのまま保持すること。
ツールキットと共に本ライセンスの写しを全ての受領者に提供すること。

第5条 - 保証の否認
適用される法律で認められる範囲において、本ツールキットは一切の保証を行いません。 本ツールキットは「現状有姿」で提供され 、商品性および特定目的への適合性に関する黙示の保証を含むがこれに限定されない、明示または黙示のいかなる保証も一切行われない。

第6条 - 責任の制限
適用される法律で要求される場合、または書面で合意された場合を除き、いかなる著作権者も、ツールキットの使用または使用不能に起因する、一般的、特別、付随的、または 結果的損害を含む、いかなる損害についても、お客様に対して責任を負わないものとしま す。

本ライセンスはGNU General Public License v3に基づいています。完全な条項についてはhttps://www.gnu.org/licenses/gpl-3.0.htmlを参照してください。
以上がライセンス条項の終わりです。ALOSToy v1.0 Standardをお楽しみください。
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
ALOSToy V1.0 Standard - 라이선스 계약서 저작권 (C) 2026 AaravLegend-Inc

이걸 구매하셨나요? 그렇다면 사기 당한 것이며 악성 코드를 설치했을 수 있습니다!

이 툴킷은 자유 소프트웨어입니다: 귀하는 자유 소프트웨어 재단이 발표한 GNU 일반 공중 사용 허가서(GNU General Public License)의 조건에 따라, 라이선스 버전 3 또는 (귀하의 선택에 따라) 그 이후 버전을 사용하여 이를 재배포 및/또는 수정할 수 있습 니다.
이 툴킷은 유용할 것이라는 희망으로 제작되었으나, 상품성 또는 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하여 어떠 한 보증도 제공하지 않습니다. 자세한 내용은 GNU 일반 공중 사용 허가서를 참조하십시오.
본 툴킷과 함께 GNU 일반 공중 사용 허가서 사본을 받으셨을 것입니다. 그렇지 않은 경우 https://www.gnu.org/licenses/를 참조하십시오.

제1조 - 정의
"툴킷"은 소스 파일, ISO, 문서 및 관련 파일을 포함한 ALOSToy v1.0 Standard를 의미합니다. "귀하"는 툴킷의 라이선스 보유자 또는 사용자를 의미합니다. "수정 버전"은 툴킷을 기반으로 한 모든 파생 작업을 의미합니다.

제2조 - 소스 코드의 제공
ALOSToy v1.0 Standard의 완전한 소스 코드는 객체 코드가 생성된 모든 사람에게 제공되어야 합니다. 이는 투명성을 보장하고,  다른 사람들이 코드를 연구하고 수정할 수 있도록 합니다. 또한 널리 사용되는 운영 체제를 재설치하기 위한 설치 미디어를 포함한 무료로 이용 가능한 확장 기능도 있습니다. 여기에서 확인할 수 있습니다.

제3조 - 수정 조건
다음 조건 하에 소스 코드를 수정하고 파생 저작물을 생성할 수 있습니다:
이를 기반으로 프로젝트를 진행할 수 있습니다.
이 툴셋은 Ventoy의 고급 사용자 지정 기능을 살펴보기 위해 복사 및 포크할 수 있습니다.
소프트웨어의 출처를 허위로 표시해서는 안 됩니다.
파생 작품 역시 GNU GPL 라이선스 하에 배포되어야 합니다.
본 소프트웨어를 리버스 엔지니어링할 수 있습니다.
ALOSToy Standard의 소스 제품을 찾으려면 https://www.ventoy.net을 방문하십시오.

섹션 4 - 재배포
다음과 같은 경우, 수신한 툴킷 소스 파일의 원본 사본을 모든 매체로 복사 및 배포할 수 있습니다.
각 사본에 적절한 저작권 고지를 눈에 띄고 적절하게 게시해야 합니다.
본 라이선스가 해당 코드에 적용됨을 알리는 모든 고지를 그대로 유지합니다.
모든 수령인에게 툴킷과 함께 본 라이선스의 사본을 제공해야 합니다.

제5조 - 보증의 부인
해당 법률이 허용하는 범위 내에서, 툴킷은 어떠한 보증도 제공하지 않습니다. 본 툴킷은 "있는 그대로" 제공되며, 상품성 및 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하되 이에 국한되지 않는, 어떠한 종류의 명시적 또는 묵시적 보증도 제공되지 않습니다.

제6조 - 책임의 제한
적용 가능한 법률에 의해 요구되거나 서면으로 합의된 경우를 제외하고, 어떠한 저작권자도 본 툴킷의 사용 또는 사용 불능으로 인해 발생하는 일반적, 특별, 부수적 또는 결과적 손해 배상 등 어떠한 손해에 대해서도 귀하에게 책임을 지지 않습니다.

본 라이선스는 GNU 일반 공중 사용 허가서 v3을 기반으로 합니다. 전체 약관은 https://www.gnu.org/licenses/gpl-3.0.html에서 확인하실 수 있습니다.
라이선스 조항은 여기까지입니다. ALOSToy v1.0 Standard를 즐기십시오.
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No license text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_License-Terms_STD
:Size-Requirements
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
========================================================================================================================
The size requirements for ALOSToy Standard are: 64GB without extensions and 128GB with extensions. If you try to install Extensions with a 64GB drive, we will stop you.
The size requirements for ALOSToy Extended are: Any USB drive that has over 128GB in storage. If you try to install the extended version with a 64GB or 128GB drive, we will stop you.
========================================================================================================================
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
========================================================================================================================
Les exigences en matière de taille pour ALOSToy Standard sont les suivantes : 64 Go sans extensions et 128 Go avec extensions. Si vous essayez d'installer des extensions avec un disque de 64 Go, nous vous en empêcherons.
Les exigences en matière de taille pour ALOSToy Extended sont les suivantes : tout disque USB disposant d'une capacité de stockage supérieure à 128 Go. Si vous essayez d'installer la version étendue avec un disque de 64 Go ou 128 Go, nous vous en empêcherons.
========================================================================================================================
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
========================================================================================================================
Die Größenanforderungen für ALOSToy Standard sind: 64 GB ohne Erweiterungen und 128 GB mit Erweiterungen. Wenn Sie versuchen, Erweiterungen mit einem 64-GB-Laufwerk zu installieren, werden wir Sie daran hindern.
Die Größenanforderungen für ALOSToy Extended sont: Jedes USB-Laufwerk mit einer Speicherkapazität von mehr als 128 GB. Wenn Sie versuchen, die erweiterte Version mit einem 64-GB- oder 128-GB-Laufwerk zu installieren, werden wir Sie daran hindern.
========================================================================================================================
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
========================================================================================================================
Los requisitos de tamaño para ALOSToy Standard son: 64 GB sin extensiones y 128 GB con extensiones. Si intenta instalar extensiones con una unidad de 64 GB, se lo impediremos.
Los requisitos de tamaño para ALOSToy Extended sont: cualquier unidad USB que tenga más de 128 GB de almacenamiento. Si intenta instalar la versión extendida con una unidad de 64 GB o 128 GB, se lo impediremos.
========================================================================================================================
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
========================================================================================================================
I requisiti di spazio per ALOSToy Standard sono: 64 GB senza estensioni e 128 GB con estensioni. Se provi a installare le estensioni con un'unità da 64 GB, ti impediremo di farlo.
I requisiti di spazio per ALOSToy Extended sono: qualsiasi unità USB con oltre 128 GB di spazio di archiviazione. Se provi a installare la versión estesa con un'unità da 64 GB o 128 GB, ti impediremo di farlo.
========================================================================================================================
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
========================================================================================================================
ALOSToy Standardの容量要件は、拡張機能なしの場合64GB、拡張機能ありの場合128GBです。64GBのドライブで拡張機能をインストールしようとすると、インストールを停止します。
ALOSToy Extendedの容量要件は、ストレージ容量が128GBを超えるUSBドライブです。64GBまたは128GBのドライブで拡張版をインストールしようとすると、インストールを停止します。
========================================================================================================================
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
========================================================================================================================
ALOSToy Standard의 용량 요구 사항은 다음과 같습니다: 확장 기능 없이 64GB, 확장 기능 포함 시 128GB입니다. 64GB 드라이브로 확장 기능을 설치하려고 하면 설치가 차단됩니다.
ALOSToy Extended의 용량 요구 사항은 다음과 같습니다: 저장 용량이 128GB를 초과하는 모든 USB 드라이브입니다. 64GB 또는 128GB 드라이브로 확장 버전을 설치하려고 하면 설치가 차단됩니다.
========================================================================================================================
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_Size-Requirements
:Ventoy-Choices
$Language = $env:lang
if ($Language -eq "en") {
    # English body.
    $text = @"
4 buttons which go by: Change Configuration, Install Ventoy Onto ${env:drivepath}, Update Ventoy On ${env:drivepath}, and Ventoy Is Already Installed On $env:drivepath will now show up. Click on one of them.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Quatre boutons intitulés: Modifier la configuration, Installer Ventoy sur ${env:drivepath}, Mettre à jour Ventoy sur ${env:drivepath} et Ventoy est déjà installé sur $env:drivepath s'affichent désormais. Cliquez sur l'un d'entre eux.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Es werden nun vier Schaltflächen angezeigt: „Konfiguration ändern“, „Ventoy auf $env:drivepath installieren“, „Ventoy auf $env:drivepath aktualisieren“ und „Ventoy ist bereits auf $env:drivepath installiert“. Klicken Sie auf eine davon.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Ahora aparecerán cuatro botones: Cambiar configuración, Instalar Ventoy en ${env:drivepath}, Actualizar Ventoy en $env:drivepath y Ventoy ya está instalado en ${env:drivepath}. Haz clic en uno de ellos.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Verranno visualizzati 4 pulsanti denominati: Modifica configurazione, Installa Ventoy su ${env:drivepath}, Aggiorna Ventoy su $env:drivepath e Ventoy è già installato su ${env:drivepath}. Clicca su uno di essi.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
「設定の変更」、「 ${env:drivepath} にVentoyをインストール」、「 ${env:drivepath} 上のVentoyを更新」、「 ${env:drivepath} にVentoyがすでにインストールされています」という4つのボタンが表示されます。いずれかをクリックしてください。
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
이제 ‘구성 변경’, ‘${env:drivepath} 에 Ventoy 설치’, ‘${env:drivepath} 에서 Ventoy 업데이트’, ‘${env:drivepath} 에 Ventoy가 이미 설치되어 있음’이라는 4개의 버튼이 표시됩니다. 그중 하나를 클릭하세요.
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0
:Post_Ventoy-Choices
rem End of installer, please leave an empty line and do not change the line endings.
rem Changing line endings from CRLF to LF will fail the empty line check.
rem Total line count: 5644. Made by Aarav Katariya with love and care...
