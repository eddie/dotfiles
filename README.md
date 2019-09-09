# Clone 

    git clone https://github.com/eddie/dotfiles ~/dotfiles

## Create symlinks:

    ln -s ~/dotfiles/nvim vim ~/.config/nvim   # Neovim
    ln -s ~/dotfiles/agignore ~/.agignore      # Silversurfer ignore
    ln -s ~/dotfiles/gitconfig ~/.gitconfig 
    ln -s ~/dotfiles/zshrc ~/.zshrc
    ln -s ~/dotfiles/nvim ~/.

## Install VIM plugins:

    vim +PlugInstall

# Fish setup


    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

    ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
    ln -s ~/dotfiles/fish/fishfile ~/.config/fish/fishfile

