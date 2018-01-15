export ZSH=~/.oh-my-zsh

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
alias vim="nvim"
alias ag='ag --path-to-ignore ~/.agignore'
alias n="npm"
alias nr="npm run"
alias yr="yarn run"
alias r="ranger"

DISABLE_AUTO_UPDATE="true"
ZSH_THEME="avit"

plugins=(git git-extras autojump)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

# nvm
export NVM_DIR="/Users/eddie/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Python
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

if [ -f ~/.zsh-local  ]; then
  source ~/.zsh-local
fi


export PATH="$HOME/.yarn/bin:$PATH"
