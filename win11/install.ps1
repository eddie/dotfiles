# Run as Admin (needed for symlinks on some Windows configs)
$profileDir = Split-Path $PROFILE -Parent

# Create the PowerShell directory if it doesn't exist
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# Remove existing profile if present
if (Test-Path $PROFILE) {
    Remove-Item $PROFILE -Force
}

# Create symlink
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$PSScriptRoot\win11\Microsoft.PowerShell_profile.ps1"

Write-Host "Profile linked: $PROFILE -> dotfiles" -ForegroundColor Green