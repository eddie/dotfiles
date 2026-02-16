Set-PSReadLineOption -EditMode Emacs        

function h { Get-History | Where-Object CommandLine -match ($args -join ' ') }

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function dot { Set-Location ~/dotfiles }

function dc { docker compose @args }
function dcd { docker compose down; docker compose up -d @args }
function dlf { docker compose logs --tail=1000 -f @args }
function dl { docker compose logs --tail=1000 -f @args }

# --- Git ---
function ggp { git push @args }
function ggl { git pull @args }
function gpa { git pull --all @args }
function gp { git add -p @args }
function glp { git log -p --stat @args }
function gl { git log -n 10 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit @args }
function gs { git status -sb @args }
function gss { git diff --staged @args }
function gd { git diff @args }
function gcm { git checkout main @args }
function gc { git commit -m @args }
function gti { git @args }  # typo alias