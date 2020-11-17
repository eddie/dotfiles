# Clone

    git clone https://github.com/eddie/dotfiles ~/dotfiles

# Install deps

Install stow, fisher, ag etc.

# Link config

    stow base
    stow fish
    stow nvim

# Change default shell

    # MacOS
    echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
    chsh -s /usr/local/bin/fish
    fish -c fisher

## Install VIM plugins:

    vim +PlugClean
    vim +PlugInstall
