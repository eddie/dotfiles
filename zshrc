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
ZSH_THEME="robbyrussell"

plugins=(git git-extras autojump)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh


# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# PHP-VERSION
source $(brew --prefix php-version)/php-version.sh && php-version 7.1

if [ -f ~/.zsh-local  ]; then
  source ~/.zsh-local
fi

export PATH="$HOME/.yarn/bin:$PATH"
