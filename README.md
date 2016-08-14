# Clone 

  git clone https://github.com/eddie/dotfiles ~/dotfiles
  cd ~/dotfiles && git submodule init

## Install Dependencies

    # vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Ohmyzsh
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

## Create symlinks:

    ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
    ln -s ~/dotfiles/zshrc ~/.zshrc
    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/vim/vimrc ~/.vimrc

## Install VIM plugins:

    vim +PlugInstall

