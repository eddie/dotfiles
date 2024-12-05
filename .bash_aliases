
alias ggp="git push"
alias ggl="git pull"
alias gs="git status"
alias gcm='git checkout main'
alias c='git commit -m'
alias g="git status"
alias h="history | grep"
alias dc="docker-compose"
alias p="./vendor/bin/phpunit"
alias dc="docker-compose"
alias vim="nvim"
alias h='history | grep'
alias dlf='docker-compose logs --tail=1000 -f'
alias t='tree -a -L 4'
alias glp="git log --pretty=format:'%C(auto)%h %<(20)%an %cd %s' --date=relative"
alias gti="git"
alias l="ls -al"
alias v="vim"
alias ag='ag --path-to-ignore ~/.agignore'
alias lc="llm -m claude"
alias la="llm -m gpt-4o"
alias ro="source ~/.bash_aliases"
alias ..="cd .."
alias ...="cd ../.."
alias dot="cd ~/dotfiles"
alias open="xdg-open"
alias a="./artisan"
alias sa="sail artisan"
alias samfs="sail artisan migrate:fresh --seed"
alias samf="sail artisan migrate:fresh"

django(){
 python manage.py "$@"
}


[ -f ~/.bash_alias_work ] && source ~/.bash_alias_work
