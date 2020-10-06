abbr gs 'git status'
abbr ggp 'git push'
abbr ggl 'git pull'
abbr gcm 'git checkout master'
abbr dlf 'docker-compose logs --tail=1000 -f'
abbr dc 'docker-compose'
abbr dup 'docker-compose up -d'
abbr dps 'docker-compose ps'
abbr dce 'docker-compose exec'
abbr dcr 'docker-compose restart'
abbr t 'tree -a -L 4'

alias h="history | grep"
alias vim='nvim'

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true
