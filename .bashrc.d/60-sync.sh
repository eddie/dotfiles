sync_simple() {
    local source_dir="${1:-$HOME/Downloads}"
    local dest_dir="${2:-/mnt/home/Downloads}"
    local max_size="${3:-100m}"
    
    /usr/bin/rsync -av --max-size="$max_size" \
        --exclude="*.iso" \
        --exclude="*.ISO" \
        --exclude="*.img" \
        --exclude="*.dmg" \
        --exclude="*.vmdk" \
        --exclude="*.vdi" \
        --exclude="*.qcow2" \
        --exclude="*.ova" \
        --exclude="*.tar.gz" \
        --exclude="*.tar.xz" \
        --exclude="*.tar.bz2" \
        --exclude="*.zip" \
        --exclude="*.7z" \
        --exclude="*.rar" \
        --exclude="*.deb" \
        --exclude="*.rpm" \
        --exclude="*.AppImage" \
        --exclude="*.flatpak" \
        --exclude="*.snap" \
        --exclude="node_modules/" \
        --exclude=".git/" \
        --exclude="*.log" \
        "$source_dir/" "$dest_dir/"
    
    echo "Synced files from $source_dir to $dest_dir (max size: $max_size)"
}

sync_screenshots() {
    local source_dir="${1:-$HOME/Pictures/Screenshots}"
    local dest_dir="${2:-/mnt/home/screenshots}"

    rsync -av --max-size="10m" \
        --backup --backup-dir="$dest_dir/backups/$(date +%Y%m%d_%H%M%S)"\
        --include="*.png" --include="*.jpg" --include="*.jpeg" \
        --exclude="*" \
        "$source_dir/" "$dest_dir/"

    echo "Copied screenshots from $source_dir to $dest_dir (max size: 10m)"
}

sync_downloads() {
    local source_dir="${1:-$HOME/Downloads}"
    local dest_dir="${2:-/mnt/home/Downloads}"
    local max_size="${3:-50M}"
    local log_file="/tmp/copy_downloads_$(date +%s).log"
    
    # Create log file
    > "$log_file"
    
    # First find large files and log them
    echo "Finding large files (>${max_size})..."
    find "$source_dir" -type f -size +${max_size} -exec ls -lh {} \; | \
        tee >(awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print substr($0,9), "- too large"}' >> "$log_file")
    
    # Find ISO-like files and log them
    echo "Finding ISO-like files..."
    find "$source_dir" -type f \( -name "*.iso" -o -name "*.ISO" -o -name "*.img" \) -exec ls -lh {} \; | \
        tee >(awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print substr($0,9), "- excluded format"}' >> "$log_file")
    
    # Common directories with many nested files to exclude
    local excluded_dirs="node_modules .git .svn target build dist .venv venv env"
    local exclude_params=""
    
    # Build rsync exclude parameters for directories
    for dir in $excluded_dirs; do
        exclude_params="$exclude_params --exclude=$dir/"
        
        # Log directories found
        find "$source_dir" -type d -name "$dir" 2>/dev/null | while read -r found_dir; do
            echo "$found_dir (directory with potentially many files - excluded)" >> "$log_file"
        done
    done
    
    # Perform rsync with exclusions
    echo "Copying files..."
    rsync -av \
        --max-size="${max_size}" \
        --exclude="*.iso" --exclude="*.ISO" --exclude="*.img" \
        $exclude_params \
        "$source_dir/" "$dest_dir/"
    
    # Show skipped files summary
    if [ -s "$log_file" ]; then
        echo -e "\nSkipped these files/directories:"
        cat "$log_file"
        echo "Total skipped: $(wc -l < "$log_file") items"
    else
        echo -e "\nNo files were skipped."
    fi
    
    echo -e "\nCopied files from $source_dir to $dest_dir (max size: $max_size)"
    echo "Excluded directories: $excluded_dirs"
}
dconf_sync() {
    local dconf_path=""
    local remote_host=""
    
    # Parse arguments more intelligently
    if [[ $# -eq 1 ]]; then
        if [[ "$1" =~ ^/ ]]; then
            # First arg is a path, use default host
            dconf_path="$1"
            remote_host="howl"  # Set your default here
        else
            # First arg is likely a host, use default path
            remote_host="$1"
            dconf_path="/org/gnome/"
        fi
    elif [[ $# -eq 2 ]]; then
        if [[ "$1" =~ ^/ ]]; then
            # path host
            dconf_path="$1"
            remote_host="$2"
        else
            # host path
            remote_host="$1"
            dconf_path="$2"
        fi
    else
        dconf_path="${1:-/org/gnome/}"
        remote_host="${2:-howl}"
    fi
    
    # Basic validation
    if [[ ! "$dconf_path" =~ ^/ ]]; then
        echo "Error: dconf path must start with '/'" >&2
        echo "Usage: dconf_sync [host] [path] or dconf_sync [path] [host]" >&2
        return 1
    fi
    
    if [[ -z "$remote_host" ]]; then
        echo "Error: remote host not specified" >&2
        return 1
    fi
    
    echo "Syncing dconf path: $dconf_path from $remote_host"
    
    # Test SSH connection first
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$remote_host" exit 2>/dev/null; then
        echo "Error: Cannot connect to $remote_host" >&2
        return 1
    fi
    
    # Check if dconf path exists on remote
    if ! ssh "$remote_host" "dconf list $dconf_path" &>/dev/null; then
        echo "Warning: dconf path $dconf_path may not exist on $remote_host"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
    fi
    
    # Perform the sync
    if ssh "$remote_host" "dconf dump $dconf_path" | dconf load "$dconf_path"; then
        echo "✓ Successfully synced dconf settings"
    else
        echo "✗ Failed to sync dconf settings" >&2
        return 1
    fi
}
