# Clone 

  git clone https://github.com/eddie/dotfiles ~/dotfiles
  cd ~/dotfiles && git submodule init


# ZSH and tmux

## Install oh-my-zsh

  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

## Create symlinks:

  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

  ln -s ~/dotfiles/zshrc ~/.zshrc

# Vim Installation and Setup

## Create Symlinks:

    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/vim/vimrc ~/.vimrc

## Install Bundles:

    vim +BundleInstall +qall
