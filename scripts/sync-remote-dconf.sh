#!/bin/bash
# Replace REMOTE_HOST with your remote machine's SSH address

# List of dconf paths to sync
PATHS=(
  "/org/gnome/desktop/wm/keybindings/"
  "/org/gnome/Ptyxis/"
  "/org/gnome/desktop/interface/"
  "/org/gnome/shell/keybindings/"
  "/org/gnome/shell/extensions/"
)

# Create the one-liner command
ONE_LINER=""
for path in "${PATHS[@]}"; do
  if [ -n "$ONE_LINER" ]; then
    ONE_LINER+="; "
  fi
  ONE_LINER+="echo 'Syncing $path' && dconf dump $path"
done

echo "# Run this command to export settings from remote and import to local:"
echo "ssh REMOTE_HOST '$ONE_LINER' | bash -c 'while IFS= read -r line; do if [[ \$line == Syncing* ]]; then echo \"\$line\"; path=\${line#Syncing }; else dconf load \$path <<< \"\$line\"; fi; done'"
