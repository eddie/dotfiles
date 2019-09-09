export ZSH=~/.oh-my-zsh
bindkey -v
HISTFILESIZE=50000

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
alias pa="php artisan"
alias phpunit="./vendor/bin/phpunit"

DISABLE_AUTO_UPDATE="true"
ZSH_THEME="fishy"
export EDTIOR=vim

plugins=(git git-extras autojump)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh --no-use

alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'

if [ -f ~/.zshrc-local  ]; then
  source ~/.zshrc-local
fi

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export GPG_TTY=$(tty)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias java8='export JAVA_HOME=$(/usr/libexec/java_home -v1.8)'
export PATH="/usr/local/sbin:$PATH"
