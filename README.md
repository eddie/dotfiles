# Clone

    git clone https://github.com/eddie/dotfiles ~/dotfiles
    cd ~/dotfiles

# Install deps

    sudo dnf install stow ag jq neovim

# Link config

User dotfiles (symlinks into `~`):

    stow -t ~ home

System config (symlinks into `/`):

    sudo stow -t / system

To remove symlinks (e.g. before restowing after a restructure):

    stow -D -t ~ home
    sudo stow -D -t / system

Then enable the systemd units:

    sudo systemctl daemon-reload
    sudo systemctl enable --now working-hours-inhibit.timer

## What's in `system/`

- `etc/ssh/sshd_config.d/90-local-sshinhibit.conf` — inhibit suspend during active SSH sessions
- `etc/systemd/system/working-hours-inhibit.service` — block sleep during working hours (11h window)
- `etc/systemd/system/working-hours-inhibit.timer` — triggers the inhibitor daily at 08:00

## Install VIM plugins

    vim +PlugClean
    vim +PlugInstall
