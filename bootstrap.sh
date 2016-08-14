ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

vim +PlugInstall



