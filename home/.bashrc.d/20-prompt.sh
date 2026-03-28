#!/bin/bash
#
# DESCRIPTION:
#
#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch of the current git/mercurial repository
#    * the return value of the previous command
#    * the fact you just came from Windows and are used to having newlines in
#      your prompts.
#    * tmux window title integration for better window naming
#
# USAGE:
#
#   1. Save this file as ~/.bash_prompt
#   2. Add the following line to the end of your ~/.bashrc or ~/.bash_profile:
#        . ~/.bash_prompt
#
# LINEAGE:
#
#   Based on work by woods
#
#   https://gist.github.com/31967

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Determine if we're in an SSH session
function is_ssh_session() {
  if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    return 0  # True, this is an SSH session
  else
    return 1  # False, not an SSH session
  fi
}

# Set the hostname display based on SSH status
function set_hostname_display() {
  if is_ssh_session; then
    # In SSH session - use a different color
    HOSTNAME_COLOR="${LIGHT_RED}"
    HOSTNAME_PREFIX="[SSH] "
  else
    # Local session - use the default green
    HOSTNAME_COLOR="${GREEN}"
    HOSTNAME_PREFIX=""
  fi
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  # Set the final branch string.
  BRANCH="${PURPLE}${branch}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

# Update terminal title for tmux integration
function update_terminal_title() {
  if [[ "$TERM" == screen* ]] || [[ "$TERM" == tmux* ]]; then
    # Get current directory basename
    local current_dir="${PWD##*/}"
    
    # Get git branch if available (clean format without parentheses)
    local git_branch=""
    if git rev-parse --git-dir >/dev/null 2>&1; then
      git_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
      if [[ -n "$git_branch" ]]; then
        git_branch=":$git_branch"
      fi
    fi
    
    # Get virtualenv if available
    local venv=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
      venv="[$(basename "$VIRTUAL_ENV")] "
    fi
    
    # Set terminal title: [venv] directory:branch
    printf "\033]2;%s%s%s\033\\" "$venv" "$current_dir" "$git_branch"
  fi
}

# Enhanced cd function that updates terminal title
cd() {
  builtin cd "$@"
  update_terminal_title
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?
  
  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv
  
  # Set the BRANCH variable.
  set_git_branch
  
  # Set the hostname display based on SSH status
  set_hostname_display
  
  # Update terminal title for tmux
  update_terminal_title
  
  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${HOSTNAME_PREFIX}${GREEN}\u@${HOSTNAME_COLOR}\h${COLOR_NONE}:${YELLOW}\w${COLOR_NONE}${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

eval "$(direnv hook bash)"
