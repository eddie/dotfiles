#!/usr/bin/env bash
# Fedora workstation setup. Pick sections to run; no args lists them.
set -euo pipefail

SECTIONS=(base cli apps gnome dotfiles)

describe() {
  case $1 in
    base)     echo "hostname, sudo, dnf, upgrade, rpmfusion + third-party repos" ;;
    cli)      echo "CLI tools, neovim, fnm, podman, sensors" ;;
    apps)     echo "chrome, gimp, inkscape, minder, ffmpeg/multimedia, flatpaks" ;;
    gnome)    echo "gsettings (chassis-aware)" ;;
    dotfiles) echo "stow home + system, sshd, inhibitor (desktop), tmux plugins" ;;
    all)      echo "run every section in order" ;;
  esac
}

usage() {
  cat <<EOF
usage: $0 [--hostname NAME] <section>...

sections:
EOF
  for s in "${SECTIONS[@]}" all; do
    printf "  %-9s %s\n" "$s" "$(describe "$s")"
  done
}

log() { printf '==> %s\n' "$*"; }

HOSTNAME_ARG=""
ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --hostname) HOSTNAME_ARG=$2; shift 2 ;;
    -h|--help)  usage; exit 0 ;;
    -*)         echo "unknown flag: $1" >&2; usage >&2; exit 1 ;;
    *)          ARGS+=("$1"); shift ;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  usage
  exit 0
fi

if [[ " ${ARGS[*]} " == *" all "* ]]; then
  ARGS=("${SECTIONS[@]}")
fi

CHASSIS=$(hostnamectl chassis 2>/dev/null || echo unknown)
log "chassis: $CHASSIS"

repo_exists() { dnf repolist 2>/dev/null | grep -q "$1"; }

section_base() {
  if [[ -z $HOSTNAME_ARG ]]; then
    echo "base requires --hostname NAME" >&2
    exit 1
  fi
  log "hostname → $HOSTNAME_ARG"
  sudo hostnamectl set-hostname --static "$HOSTNAME_ARG"
  sudo hostnamectl set-hostname --pretty "$HOSTNAME_ARG"

  if [[ ! -f /etc/sudoers.d/timeout ]]; then
    echo 'Defaults timestamp_timeout=30' | sudo tee /etc/sudoers.d/timeout >/dev/null
    sudo chmod 440 /etc/sudoers.d/timeout
  fi

  if ! grep -q '^max_parallel_downloads=10' /etc/dnf/dnf.conf 2>/dev/null; then
    echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
  fi

  sudo dnf -y upgrade --refresh
  sudo systemctl disable NetworkManager-wait-online.service 2>/dev/null || true

  # RPM Fusion
  if ! repo_exists rpmfusion-free; then
    local fed; fed=$(rpm -E %fedora)
    sudo dnf install -y \
      "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fed}.noarch.rpm" \
      "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fed}.noarch.rpm"
  fi
  sudo dnf group upgrade -y core

  # Third-party repos
  if ! repo_exists 1password; then
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'cat > /etc/yum.repos.d/1password.repo <<EOF
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey="https://downloads.1password.com/linux/keys/1password.asc"
EOF'
  fi

  if ! repo_exists azure-cli; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm || true
    sudo tee /etc/yum.repos.d/azure-cli.repo >/dev/null <<'EOF'
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
  fi

  sudo dnf install -y dnf5-plugins

  if ! repo_exists gh-cli; then
    sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  fi

  if ! repo_exists tableplus; then
    sudo rpm -v --import https://yum.tableplus.com/apt.tableplus.com.gpg.key
    sudo dnf config-manager addrepo --from-repofile=https://yum.tableplus.com/rpm/x86_64/tableplus.repo
  fi

  # pgdev/ghostty lags Fedora; scottames/ghostty tracks current.
  repo_exists scottames-ghostty || sudo dnf copr enable -y scottames/ghostty
  repo_exists che-nerd-fonts    || sudo dnf copr enable -y che/nerd-fonts
}

section_cli() {
  sudo dnf install -y --skip-unavailable --skip-broken \
    stow neovim gnome-tweaks \
    'google-roboto*' ibm-plex-mono-fonts jetbrains-mono-fonts nerd-fonts \
    tldr wl-clipboard inxi fd-find ncdu duf diff-so-fancy bat \
    z evtest clang direnv gnome-firmware podman-compose python-neovim \
    python3-pip 'dnf-command(config-manager)' \
    gh lm_sensors s-tui

  npm list -g neovim &>/dev/null || sudo npm install -g neovim

  if ! command -v fnm &>/dev/null && [[ ! -x $HOME/.local/share/fnm/fnm ]]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- \
      --skip-shell --install-dir "$HOME/.local/share/fnm"
  fi

  systemctl --user enable --now podman.socket || true
  [[ -f /etc/sysconfig/lm_sensors ]] || sudo sensors-detect --auto || true
}

section_apps() {
  sudo dnf install -y \
    google-chrome-stable gimp inkscape minder \
    1password tableplus ghostty libheif-freeworld

  rpm -q ffmpeg &>/dev/null || sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
  sudo dnf group upgrade -y --with-optional Multimedia || true

  flatpak remote-list | grep -q flathub || \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  local apps=(
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
  local installed
  installed=$(flatpak list --app --columns=application 2>/dev/null)
  for app in "${apps[@]}"; do
    grep -qx "$app" <<<"$installed" || flatpak install -y flathub "$app"
  done
}

section_gnome() {
  # Appearance
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface accent-color 'teal'
  gsettings set org.gnome.desktop.interface font-hinting 'full'
  gsettings set org.gnome.desktop.interface font-antialiasing 'grayscale'

  # WM
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.mutter check-alive-timeout 10000
  gsettings set org.gnome.shell.app-switcher current-workspace-only true

  # Input
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'gb')]"

  # Privacy
  gsettings set org.gnome.desktop.privacy remember-recent-files false

  # Night light
  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3700

  # Keybindings: Alt-Tab = windows, Super-Tab = apps
  gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Alt><Super>Left']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Alt><Super>Right']"
  gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
  gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>s']"

  # Nautilus
  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
  gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'always'

  # Power: 10min idle, 60min AC suspend. On desktop, working-hours-inhibit.timer
  # blocks suspend during working hours so this only fires overnight.
  gsettings set org.gnome.desktop.session idle-delay 600
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'suspend'

  # Chassis-specific display
  if [[ $CHASSIS == laptop ]]; then
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.2
    gsettings set org.gnome.mutter experimental-features "[]"
  else
    gsettings set org.gnome.desktop.interface show-battery-percentage false
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.3
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
  fi
}

section_dotfiles() {
  if [[ ! -d $HOME/dotfiles/.git ]]; then
    gh auth status &>/dev/null || gh auth login
    gh repo clone eddie/dotfiles "$HOME/dotfiles"
  fi

  cd "$HOME/dotfiles"
  stow -R -t ~ home
  sudo stow -R -t / system

  sudo systemctl daemon-reload
  sudo systemctl enable --now sshd.service

  if [[ $CHASSIS == desktop ]]; then
    sudo systemctl enable --now working-hours-inhibit.timer
  fi

  local tpm=$HOME/.tmux/plugins/tpm
  [[ -d $tpm ]] || git clone https://github.com/tmux-plugins/tpm "$tpm"
  "$tpm/bin/install_plugins"
}

for s in "${ARGS[@]}"; do
  if ! declare -f "section_$s" >/dev/null; then
    echo "unknown section: $s" >&2
    usage >&2
    exit 1
  fi
  log "── $s ──"
  "section_$s"
done
