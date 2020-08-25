abbr gs 'git status'
abbr ggp 'git push'
abbr ggl 'git pull'
abbr gcm 'git checkout master'
abbr dcl 'docker-compose logs --tail=1000 -f'
abbr dc 'docker-compose'
alias h="history | grep"

function fuck -d "Correct your previous console command"
  set -l fucked_up_command $history[1]
  env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
    eval $unfucked_command
    builtin history delete --exact --case-sensitive -- $fucked_up_command
    builtin history merge ^ /dev/null
  end
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true


thefuck --alias | source
