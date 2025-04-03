#!/bin/bash
# Usage: ./script.sh username@remote_host

if [ -z "$1" ]; then
  echo "Usage: $0 username@remote_host"
  exit 1
fi

REMOTE_HOST="$1"
TEMP_DIR=$(mktemp -d)

# List of dconf paths to sync
PATHS=(
  "/org/gnome/desktop/wm/keybindings/"
  "/org/gnome/Ptyxis/"
  "/org/gnome/desktop/interface/"
  "/org/gnome/shell/keybindings/"
  "/org/gnome/shell/extensions/"
)

echo "Syncing dconf settings from $REMOTE_HOST to local machine..."

# For each path, create a separate file
for path in "${PATHS[@]}"; do
  # Create a sanitized filename
  filename=$(echo "$path" | sed 's/^\///' | sed 's/\//-/g')
  echo "Syncing $path"
  
  # Export from remote to local file
  ssh "$REMOTE_HOST" "dconf dump $path" > "$TEMP_DIR/$filename.dconf"
  
  # Import from file to local dconf
  if [ -s "$TEMP_DIR/$filename.dconf" ]; then
    dconf load "$path" < "$TEMP_DIR/$filename.dconf"
    echo "✓ Successfully imported settings for $path"
  else
    echo "⚠ No settings found for $path"
  fi
done

# Clean up
rm -rf "$TEMP_DIR"
echo "Settings sync complete!"
