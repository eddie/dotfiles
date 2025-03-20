alias ggp="git push"
alias ggl="git pull"
alias gs="git status"
alias gd="git diff"
alias gcm='git checkout main'
alias c='git commit -m'
alias g="git status"
alias h="history | grep"
alias dc="docker-compose"
alias dc="docker-compose"
alias vim="nvim"
alias h='history | grep'
alias dlf='docker compose logs --tail=1000 -f'
alias dl='docker compose logs --tail=1000 -f'
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
alias docker="podman"
alias su="sail up -d"
alias sd="sail down"
alias suud="sail up -d && sail down"
alias samfs="sail artisan migrate:fresh --seed"
alias samf="sail artisan migrate:fresh"
alias m="make"
alias dc="docker compose"
alias dcd="docker compose down && docker compose up -d"
alias a="vim ~/.bash_aliases && source ~/.bash_aliases"
alias pp="poetry run python manage.py"
alias r="git diff --cached --name-only --diff-filter=ACMR | grep '\.py$' | xargs -r ruff check --fix"
alias pyc='find . -name "*.pyc" -delete && find . -name "__pycache__" -type d -exec rm -rf {} +  2>/dev/null || true'


django(){
 python manage.py "$@"
}

[ -f ~/.bash_alias_work ] && source ~/.bash_alias_work
