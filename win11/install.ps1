# Run as Admin (needed for symlinks on some Windows configs)
$profileDir = Split-Path $PROFILE -Parent

# Create the PowerShell directory if it doesn't exist
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# Create wrapper profile that sources the dotfiles version
$dotfilesProfile = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
$wrapperContent = @"
# Auto-generated wrapper - sources the real profile from dotfiles
. "$dotfilesProfile"
"@

Set-Content -Path $PROFILE -Value $wrapperContent -Force

Write-Host "Profile installed: $PROFILE -> $dotfilesProfile" -ForegroundColor Green