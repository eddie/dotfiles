ln -s ~/dotfiles/nvim vim ~/.config/nvim   # Neovim
ln -s ~/dotfiles/agignore ~/.agignore      # Silversurfer ignore
ln -s ~/dotfiles/gitconfig ~/.gitconfig 
ln -s ~/dotfiles/nvim ~/.

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -s ~/dotfiles/fish/fishfile ~/.config/fish/fishfile

chsh -s /usr/bin/fish

fish -c fisher


