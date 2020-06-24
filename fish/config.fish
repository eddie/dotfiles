abbr gs 'git status'
abbr ggp 'git push'
abbr ggl 'git pull'
abbr gcm 'git checkout master'
abbr dcl 'docker-compose logs --tail=1000 -f'
abbr dc 'docker-compose'
alias h="history | grep"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true
