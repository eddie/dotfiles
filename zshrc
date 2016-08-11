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
alias vim="vim -X"
alias v="vim"
alias g="git status"
alias l="ls"
alias pg='grep -H -r --include="*.php"'
alias h='history | grep'
alias rake='noglob rake'
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras brew npm autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)" # or equivalent

export TERM="screen-256color"
gi() { gem install $@; rbenv rehash; rehash }

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"


source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  
