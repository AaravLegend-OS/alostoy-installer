<#
FOLDERBROWSE BUILD SCRIPT
    A simple but effective build script for folderbrowse.ps1
    to compile the powershell script into folderbrowse.exe as
    seen in the ALOSToy Installer.
    You are not required to download folderbrowse.ps1 and
    folderbrowse.ico beforehand. Just download this build script
    and when you run it, the required files are automatically
    downloaded for you!
Made by Aarav Katariya with love and care...
#>
#Requires -PSEdition Desktop
#Requires -Version 5.1
# Define a parameter.
param([switch]$KeepSourceFiles)
# Check for admin.
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# If not, relaunch as admin.
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Start-Process -FilePath powershell.exe -ArgumentList "-Nop -Nol -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; Exit 2 }
Clear-Host
Write-Host "Compile in progress!" -ForegroundColor Yellow
# Install ps2exe module.
Install-Module -Name ps2exe -Scope AllUsers -Force
# Import module.
Import-Module ps2exe -Force
$items = @('folderbrowse.ps1','folderbrowse.ico')
foreach ($item in $items) { if (-not (Test-Path -LiteralPath "${PSScriptRoot}\$item")) { Invoke-RestMethod -Uri https://github.com/AaravLegend-OS/alostoy-installer/raw/refs/heads/main/$item -OutFile "${PSScriptRoot}\$item" } }
$Hash1 = (Get-FileHash -Path "${PSScriptRoot}\folderbrowse.ps1" -Algorithm SHA256).Hash.ToUpper()
$Hash2 = (Get-FileHash -Path "${PSScriptRoot}\folderbrowse.ico" -Algorithm SHA256).Hash.ToUpper()
if (($Hash1 -ieq "80DF1986879AA5A25E4E9C869F7433AED92EE6FA9B2A7D1FE8169AAAE843A6A6") -and ($Hash2 -ieq "2758105BEB56CCF0C2FF065D58B2BED5A177323EE66CE66446FB36D4F12C303D")) { Write-Host 'Hashes are good!' -ForegroundColor Green } else {
    Write-Error 'Hashes are bad!' -ErrorAction Continue
    Pause
    Exit 1
}
try {
    if ((Test-Path -LiteralPath "${PSScriptRoot}\folderbrowse.ps1") -and (Test-Path -LiteralPath "${PSScriptRoot}\folderbrowse.ico")) { ps2exe -InputFile "${PSScriptRoot}\folderbrowse.ps1" -OutputFile "${PSScriptRoot}\folderbrowse.exe" -x64 -STA -IconFile "${PSScriptRoot}\folderbrowse.ico" -Title "Folder Browser" -Description "An effective folder picker." -Company "AaravLegend-Inc" -Product "Folder Browser" -Copyright "AaravLegend-Inc 2023-2026" -Trademark "AaravLegend-Inc" -Version "1.0.0.0" -RequireAdmin -SupportOS -LongPaths | Out-Null }
    # If we succeed.
    if ($?) {
        Write-Host "The compile succeeded!" -ForegroundColor Green
        if (-not ($KeepSourceFiles)) { foreach ($item in $items) { Remove-Item -LiteralPath "${PSScriptRoot}\$item" -Force -ErrorAction Continue } }
        if (-not (Test-Path -LiteralPath "${PSScriptRoot}\bin")) { New-Item -Path "${PSScriptRoot}\bin" -ItemType Directory -Force }
        foreach ($file in @('folderbrowse.exe','folderbrowse.exe.config')) { Move-Item -LiteralPath "${PSScriptRoot}\$file" -Destination "${PSScriptRoot}\bin" -Force; Set-Clipboard -Value $((Get-FileHash -LiteralPath "${PSScriptRoot}\bin\$file" -Algorithm SHA256).Hash.ToUpper()); Start-Sleep -Milliseconds 1500 }
        Exit 0
    } else {
        throw "Bad."
    }
} catch {
    # If we fail.
    Write-Error "Sorry! The compile failed!`r`n`r`n$($_.Exception.Message)." -ErrorAction Continue
    Pause
    Exit 1
}
