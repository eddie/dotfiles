#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Use LocalAppData instead of Documents (avoids domain restrictions)
$profileDir = "$env:LOCALAPPDATA\Microsoft\PowerShell"
$profilePath = "$profileDir\Microsoft.PowerShell_profile.ps1"
$sourceProfile = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"

Write-Host "Profile location: $profilePath" -ForegroundColor Cyan
Write-Host "Source: $sourceProfile" -ForegroundColor Cyan

# Create directory
[System.IO.Directory]::CreateDirectory($profileDir) | Out-Null

# Remove existing file/link if present
if (Test-Path $profilePath) {
    Remove-Item $profilePath -Force
    Write-Host "Removed existing profile" -ForegroundColor Yellow
}

# Create symlink
New-Item -ItemType SymbolicLink -Path $profilePath -Target $sourceProfile -Force | Out-Null

Write-Host "✓ Symlink created: $profilePath -> $sourceProfile" -ForegroundColor Green
Write-Host "`nTo use, add this line to your `$PROFILE:" -ForegroundColor Yellow
Write-Host ". '$profilePath'" -ForegroundColor White

# Create the actual profile directory if it doesn't exist
$actualProfileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $actualProfileDir)) {
    [System.IO.Directory]::CreateDirectory($actualProfileDir) | Out-Null
}

# Open the profile for editing
Write-Host "`nOpening $PROFILE for editing..." -ForegroundColor Cyan
if (Get-Command code -ErrorAction SilentlyContinue) {
    code $PROFILE
}
else {
    notepad $PROFILE
}
