
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

git clone https://github.com/gmarik/vundle ~/.vim/vundle

vim +BundleInstall +qall && cd ~/.vim/bundle/vimproc.vim && make

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh


