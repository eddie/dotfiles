# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="kardan"

# Example aliases
alias gs="git status"
alias g="git"
alias gap="git add -p"
alias cb="xsel --clipboard"
alias tmux="tmux -2"
alias todo="vim ~/docs/on-going"
alias ccat="pygmentize -g"
alias v="vim"
alias g="git status"
alias l="ls"
alias pg='grep -H -r --include="*.php"'
alias h='history | grep'
alias rake='noglob rake'
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

DISABLE_AUTO_UPDATE="true"
plugins=(git git-extras brew npm autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Python
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

if [ -f ~/.zsh-local  ]; then
  source ~/.zsh-local
fi

