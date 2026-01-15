if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# append to the history file, don't overwrite it
shopt -s histappend

# enable recursive globbing (e.g. **/*.py)
shopt -s globstar 

# enable changing to a directory by typing its name
shopt -s autocd

# correct minor spelling errors in cd commands
shopt -s cdspell

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=2000
export HISTCONTROL=ignoredups:erasedups

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"


export ELECTRON_OZONE_PLATFORM_HINT=auto
