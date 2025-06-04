if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=2000

export ELECTRON_OZONE_PLATFORM_HINT=auto
