<#
FOLDERBROWSE BUILD SCRIPT
    A simple but effective build script for folderbrowse.ps1
    to compile the powershell script into folderbrowse.exe as
    seen in the ALOSToy Installer. Mandatory element, place in
    the bin folder.
Made by Aarav Katariya with love and care...
#>
Write-Host "Compile in progress!" -ForegroundColor Yellow
# Install ps2exe module.
Install-Module -Name ps2exe -Scope AllUsers -Force
# Ensure we succeed before moving on.
if ($?) { Import-Module ps2exe -Force }
try {
    if (Test-Path -LiteralPath ) { ps2exe -InputFile "${PSScriptRoot}folderbrowse.ps1" -OutputFile "${PSScriptRoot}folderbrowse.exe" -x64 -STA -ConHost -UNICODEEncoding -IconFile "${PSScriptRoot}\folderbrowse.ico" -Title "Folder Browser" -Description "An effective folder picker." -Company "AaravLegend-Inc" -Product "Folder Browser" -Copyright "AaravLegend-Inc 2023-2026" -Trademark "AaravLegend-Inc" -Version "1.0.0.0" -RequireAdmin -SupportOS -LongPaths }
    # If we succeed.
    if ($?) {
        Write-Host "The compile succeeded!" -ForegroundColor Green
        Start-Sleep -Seconds 3
        Exit 0
    }
} catch {
    # If we fail.
    Write-Error "Sorry! The compile failed!`r`n`r`n$($_.Exception.Message)." -ErrorAction Continue
    Pause
    Exit 1
}