# Clone 

  git clone https://github.com/Cyclo/dotfiles ~/dotfiles
  cd ~/dotfiles && git submodule init


# ZSH and tmux

Install oh-my-zsh

  ```curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh```

Create symlinks:

  ```ln -s ~/dotfiles/tmux.conf ~/.tmux.conf```
  ```ln -s ~/dotfiles/zshrc ~/.zshrc```
  ```ln -s ~/dotfiles/tmux-powerlinerc ~/.tmux-powerlinerc```

Setup a patched font:

  mkdir ~/.fonts && ln -s ~/dotfiles/ubuntu-mono-powerline/* ~/.fonts
  cd ~/.fonts/ && git clone https://github.com/scotu/ubuntu-mono-powerline.git && cd ~
  fc-cache -vf

# Vim Installation and Setup

Create Symlinks:

	```ln -s ~/dotfiles/vim ~/.vim```
  ```ln -s ~/dotfiles/vim/vimrc ~/.vimrc```

Install Bundles:

	```vim +BundleInstall +qall```
