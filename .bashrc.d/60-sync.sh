
sync () {
    local source_dir="${1:-~/Downloads}"
    local dest_dir="${2:-/mnt/home/Downloads}"
    local max_size="${3:-50m}"
    
    rsync -av --one-way --max-size="$max_size" \
        --include="*.pdf" --include="*.txt" \
        --include="*.jpg" --include="*.jpeg" --include="*.png" \
        --include="*.gif" --include="*.bmp" --include="*.tiff" --include="*.webp" \
        --exclude="*" \
        "$source_dir/" "$dest_dir/"
    
    echo "Copied files from $source_dir to $dest_dir (max size: $max_size)"
}


sync_big() {
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
