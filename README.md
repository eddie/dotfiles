# Clone

    git clone https://github.com/eddie/dotfiles ~/dotfiles

# Install deps

Install stow, ag etc.

    sudo dnf install stow ag jq neovim

# Link config

    stow .

## Install VIM plugins:

    vim +PlugClean
    vim +PlugInstall
