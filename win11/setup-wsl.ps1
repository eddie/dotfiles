#Requires -RunAsAdministrator
# setup-wsl.ps1: Ensure Fedora WSL, install stow+git in Fedora, clone eddie/dotfiles, stow.
# Run first; bootstrap-fedora.sh is optional after.

$ErrorActionPreference = "Stop"

# Detect Fedora distro name (e.g. Fedora, FedoraLinux-42)
function Get-FedoraDistroName {
    $env:WSL_UTF8 = 1
    $lines = wsl --list --quiet 2>$null
    if ($lines) {
        foreach ($line in $lines) {
            $name = ($line -replace '^\s*\*\s*', '').Trim()
            if ($name -match 'Fedora') { return $name }
        }
    }
    return "Fedora"
}

# Ensure WSL is installed
if (!(Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "Installing WSL..." -ForegroundColor Cyan
    wsl --install
    Write-Host "WSL installed. You may need to reboot. Re-run this script after reboot." -ForegroundColor Yellow
    exit 0
}

# Ensure Fedora is installed and set as default
$distro = Get-FedoraDistroName
$installed = wsl --list --quiet 2>$null | ForEach-Object { $_.Trim() }
$fedoraInstalled = $installed | Where-Object { $_ -match "Fedora" } | Select-Object -First 1
if ($fedoraInstalled) { $distro = ($fedoraInstalled -replace '^\s*\*\s*', '').Trim() }

if (!$fedoraInstalled) {
    Write-Host "Installing Fedora WSL ($distro)..." -ForegroundColor Cyan
    wsl --install --no-distribution
    wsl --install $distro 2>$null
    if ($LASTEXITCODE -ne 0) {
        # Try generic name
        wsl --install Fedora 2>$null
        $distro = (wsl --list --quiet | Where-Object { $_ -match "Fedora" } | Select-Object -First 1).Trim()
    }
    if (!$distro) { $distro = "Fedora" }
}

# Set default distro (idempotent)
Write-Host "Setting default WSL distro to $distro" -ForegroundColor Cyan
wsl --set-default $distro 2>$null

Write-Host "Using WSL distro: $distro" -ForegroundColor Green

# Bootstrap inside Fedora: dnf install stow git, clone, stow
$bootstrapScript = @'
set -e
echo "==> Installing stow and git..."
sudo dnf install -y stow git

echo "==> Cloning dotfiles..."
if command -v gh &>/dev/null && gh auth status &>/dev/null; then
  gh repo clone eddie/dotfiles ~/dotfiles -- --depth 1
else
  git clone --depth 1 https://github.com/eddie/dotfiles ~/dotfiles
fi

echo "==> Stowing dotfiles..."
cd ~/dotfiles && stow .

if [ -f ~/dotfiles/scripts/bootstrap-fedora.sh ]; then
  echo "==> Running bootstrap-fedora.sh (optional)..."
  ~/dotfiles/scripts/bootstrap-fedora.sh
else
  echo "==> Done. Run gh auth login then ~/dotfiles/scripts/bootstrap-fedora.sh when ready."
fi
'@

Write-Host "Running bootstrap inside Fedora..." -ForegroundColor Cyan
$bootstrapScript | wsl -d $distro bash -s
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Done. Open Windows Terminal and start a Fedora tab, or run: wsl -d $distro" -ForegroundColor Green
