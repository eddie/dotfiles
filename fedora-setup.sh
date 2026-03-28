#!/usr/bin/env bash
# fedora-setup.sh: Automated Fedora workstation setup.
# Usage: ./fedora-setup.sh [--hostname NAME] [section ...]
# Run with no args to execute all sections in order.
# Run with section names to execute only those: ./fedora-setup.sh cli flatpak
set -e

# --- Helpers ---
info()    { echo -e "==> $1"; }
success() { echo -e "  ✓ $1"; }
warn()    { echo -e "  ⚠ $1"; }

is_installed()      { rpm -q "$1" &>/dev/null; }
flatpak_installed() { flatpak list --app --columns=application 2>/dev/null | grep -q "^$1$"; }
repo_exists()       { dnf repolist 2>/dev/null | grep -q "$1"; }

ALL_SECTIONS=(tweaks rpmfusion repos cli desktop flatpak monitoring media dotfiles tpm gnome notes)

usage() {
  echo "Usage: $0 [--hostname NAME] [section ...]"
  echo ""
  echo "Sections: ${ALL_SECTIONS[*]}"
  echo ""
  echo "Run with no section args to execute all in order."
}

# --- Argument parsing ---
HOSTNAME_ARG=""
SECTIONS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --hostname) HOSTNAME_ARG="$2"; shift 2 ;;
    --list)     echo "${ALL_SECTIONS[*]}"; exit 0 ;;
    --help|-h)  usage; exit 0 ;;
    *)          SECTIONS+=("$1"); shift ;;
  esac
done

if [[ ${#SECTIONS[@]} -eq 0 ]]; then
  SECTIONS=("${ALL_SECTIONS[@]}")
fi

# =============================================================================
# Sections
# =============================================================================

section_tweaks() {
  info "System tweaks"

  # Hostname
  if [[ -n "$HOSTNAME_ARG" ]]; then
    info "Setting hostname to $HOSTNAME_ARG"
    sudo hostnamectl set-hostname --static "$HOSTNAME_ARG"
    sudo hostnamectl set-hostname --pretty "$HOSTNAME_ARG"
  else
    read -rp "Enter hostname (leave empty to skip): " hn
    if [[ -n "$hn" ]]; then
      sudo hostnamectl set-hostname --static "$hn"
      sudo hostnamectl set-hostname --pretty "$hn"
    fi
  fi

  # Sudo timeout
  if [[ ! -f /etc/sudoers.d/timeout ]]; then
    info "Setting sudo timeout to 30 minutes"
    echo 'Defaults timestamp_timeout=30' | sudo tee /etc/sudoers.d/timeout > /dev/null
    sudo chmod 440 /etc/sudoers.d/timeout
  fi

  # DNF parallel downloads
  if ! grep -q "^max_parallel_downloads=10" /etc/dnf/dnf.conf 2>/dev/null; then
    info "Setting max_parallel_downloads=10"
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
  fi

  info "Running system upgrade"
  sudo dnf -y upgrade --refresh

  info "Disabling NetworkManager-wait-online.service"
  sudo systemctl disable NetworkManager-wait-online.service 2>/dev/null || true
}

section_rpmfusion() {
  info "RPM Fusion repositories"

  if ! repo_exists "rpmfusion-free"; then
    sudo dnf install -y \
      "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
      "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    success "RPM Fusion installed"
  else
    success "RPM Fusion already installed"
  fi

  # Enable AppStream metadata (RPM Fusion packages in GNOME Software)
  sudo dnf group upgrade -y core
}

section_repos() {
  info "Third-party repositories"

  # 1Password
  if ! repo_exists "1password"; then
    info "Adding 1Password repo"
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
  fi
  sudo dnf install -y 1password

  # VS Code
  if ! repo_exists "code"; then
    info "Adding VS Code repo"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
  fi
  sudo dnf install -y code

  # Google Cloud CLI
  if ! repo_exists "google-cloud-cli"; then
    info "Adding Google Cloud CLI repo"
    sudo tee /etc/yum.repos.d/google-cloud-sdk.repo > /dev/null << 'EOM'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
  fi
  sudo dnf install -y google-cloud-cli

  # Azure CLI
  if ! repo_exists "azure-cli"; then
    info "Adding Azure CLI repo"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm || true
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo > /dev/null
  fi
  sudo dnf install -y azure-cli

  # GitHub CLI
  if ! repo_exists "gh-cli"; then
    info "Adding GitHub CLI repo"
    sudo dnf install -y dnf5-plugins
    sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  fi
  sudo dnf install -y gh --repo gh-cli

  # TablePlus
  if ! repo_exists "tableplus"; then
    info "Adding TablePlus repo"
    sudo rpm -v --import https://yum.tableplus.com/apt.tableplus.com.gpg.key
    sudo dnf config-manager addrepo --from-repofile=https://yum.tableplus.com/rpm/x86_64/tableplus.repo
  fi
  sudo dnf install -y tableplus

  # Ghostty terminal (COPR)
  if ! repo_exists "pgdev-ghostty"; then
    info "Enabling Ghostty COPR"
    sudo dnf copr enable -y pgdev/ghostty
  fi
  sudo dnf install -y ghostty

  # Nerd Fonts (COPR)
  if ! repo_exists "che-nerd-fonts"; then
    info "Enabling Nerd Fonts COPR"
    sudo dnf copr enable -y che/nerd-fonts
  fi
  sudo dnf install -y nerd-fonts

  # Espanso (COPR — preferred over flatpak)
  if ! repo_exists "eclipseo-espanso"; then
    info "Enabling Espanso COPR"
    sudo dnf copr enable -y eclipseo/espanso
  fi
  sudo dnf install -y espanso-wayland
  sudo setcap "cap_dac_override+p" "$(which espanso-wayland)" 2>/dev/null || true
  espanso service register 
  espanso service start
}

section_cli() {
  info "Core CLI packages"

  sudo dnf install -y \
    stow tmuxp neovim gnome-tweaks \
    'mozilla-fira*' 'google-roboto*' ibm-plex-mono-fonts jetbrains-mono-fonts \
    tldr wl-clipboard inxi fd-find ncdu duf diff-so-fancy bat \
    z evtest clang direnv gnome-firmware podman-compose python-neovim \
    python3-pip dnf5-plugins

  sudo dnf install -y 'dnf-command(config-manager)'

  info "Installing neovim npm package"
  sudo npm install -g neovim

  info "Installing llm CLI"
  pip install llm
}

section_desktop() {
  info "Desktop packages"

  sudo dnf install -y google-chrome-stable gimp inkscape minder pomodoro

  info "Installing Pop Shell"
  sudo dnf install -y gnome-shell-extension-pop-shell

  info "Installing HEIF support (RPM Fusion)"
  sudo dnf install -y libheif-freeworld
}

section_flatpak() {
  info "Flatpak applications"

  # Ensure flathub is configured
  if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  fi

  local flatpaks=(
    md.obsidian.Obsidian
    com.plexamp.Plexamp
    com.valvesoftware.Steam
    org.prismlauncher.PrismLauncher
    com.github.tchx84.Flatseal
    com.spotify.Client
    us.zoom.Zoom
    io.missioncenter.MissionCenter
    com.slack.Slack
    com.mattjakeman.ExtensionManager
    it.mijorus.gearlever
    com.microsoft.AzureStorageExplorer
  )

  for app in "${flatpaks[@]}"; do
    if ! flatpak_installed "$app"; then
      info "Installing $app"
      flatpak install -y flathub "$app"
    else
      success "$app already installed"
    fi
  done
}

section_monitoring() {
  info "Monitoring tools"
  sudo dnf install -y lm_sensors s-tui
  sudo sensors-detect --auto || true
}

section_media() {
  info "Multimedia support (RPM Fusion)"

  sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
  sudo dnf group upgrade -y --with-optional Multimedia || true
}

section_dotfiles() {
  info "Dotfiles"

  if [[ -d "$HOME/dotfiles/.git" ]]; then
    success "Dotfiles already cloned"
  else
    if ! gh auth status &>/dev/null; then
      info "Authenticating with GitHub"
      gh auth login
    fi

    info "Cloning dotfiles"
    gh repo clone eddie/dotfiles "$HOME/dotfiles"
  fi

  info "Stowing home dotfiles"
  cd "$HOME/dotfiles" && stow -t ~ home

  info "Stowing system config"
  cd "$HOME/dotfiles" && sudo stow -t / system

  info "Enabling working-hours sleep inhibitor"
  sudo systemctl daemon-reload
  sudo systemctl enable --now working-hours-inhibit.timer
}

section_tpm() {
  info "Tmux Plugin Manager"

  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    success "TPM already installed"
  else
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "TPM installed"
  fi
}

section_gnome() {
  info "GNOME settings"

  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.shell.app-switcher current-workspace-only true
  dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

  success "GNOME settings applied"
}

section_notes() {
  echo ""
  echo "================================================================"
  echo "  Setup complete! Post-setup notes:"
  echo "================================================================"
  echo ""
  echo "  DCONF SYNC (keybindings & extensions from another machine):"
  echo "    ~/dotfiles/scripts/sync-remote-dconf.sh user@other-machine"
  echo "    Syncs: wm keybindings, interface, shell keybindings, extensions"
  echo ""
  echo "  TMUX:"
  echo "    Install plugins:    Ctrl+a, Shift+I"
  echo "    Update plugins:     Ctrl+a, Shift+U"
  echo "    Save session:       Ctrl+a, Ctrl+s"
  echo "    Restore session:    Ctrl+a, Ctrl+r"
  echo ""
  echo "  ESPANSO:"
  echo "    espanso service register"
  echo "    espanso start"
  echo ""
  echo "  GNOME EXTENSIONS (install via Extension Manager):"
  echo "    - Clipboard Indicator"
  echo "    - Media Labels & Controls (mprisLabel@moon-0xff)"
  echo "    - Useless Gaps"
  echo "    - Vitals (Vitals@CoreCoding.com)"
  echo "    - Just Perfection (just-perfection-desktop@just-perfection)"
  echo "    - GSConnect (gsconnect@andyholmes.github.io)"
  echo "    - Color Picker (color-picker@tuberry)"
  echo "    - focus-follows-workspace"
  echo ""
  echo "  NAS LOCAL FILES:"
  echo "    Once NAS is mounted, copy private/machine-specific files:"
  echo "    - WOL MAC addresses"
  echo "    - llm / doctl / gcloud configs"
  echo "    - Custom .desktop files"
  echo ""
  echo "  POST-SETUP CHECKLIST:"
  echo "    - Check custom keybindings (e.g. Obsidian Ctrl+Shift+P)"
  echo "    - Set Chrome flag: #ozone-platform-hint=wayland"
  echo ""
  echo "================================================================"
}

# =============================================================================
# Main
# =============================================================================

for section in "${SECTIONS[@]}"; do
  if declare -f "section_${section}" > /dev/null 2>&1; then
    info "--- $section ---"
    "section_${section}"
    echo ""
  else
    warn "Unknown section: $section"
    usage
    exit 1
  fi
done
