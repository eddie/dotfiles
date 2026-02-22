# PowerShell sync functions for Windows using robocopy

function Sync-Screenshots {
    param(
        [string]$SourceDir = "$env:USERPROFILE\Pictures\Screenshots",
        [string]$DestDir = "Z:\screenshots"
    )

    Write-Host "Syncing screenshots from $SourceDir to $DestDir" -ForegroundColor Cyan

    # robocopy with file type filters and max size 10MB
    # /MIR = mirror, /MAX:10485760 = 10MB max, /R:1 = 1 retry, /W:1 = 1 sec wait
    robocopy "$SourceDir" "$DestDir" *.png *.jpg *.jpeg /MAX:10485760 /R:1 /W:1 /NP /NDL

    Write-Host "Screenshot sync complete!" -ForegroundColor Green
}

function Sync-Downloads {
    param(
        [string]$SourceDir = "$env:USERPROFILE\Downloads",
        [string]$DestDir = "Z:\Downloads",
        [int]$MaxSizeMB = 50
    )

    $maxBytes = $MaxSizeMB * 1024 * 1024

    Write-Host "Syncing downloads from $SourceDir to $DestDir (max ${MaxSizeMB}MB)" -ForegroundColor Cyan

    # robocopy with exclusions
    # /E = copy subdirectories including empty ones, /MAX = max file size
    # /XF = exclude files, /XD = exclude directories
    robocopy "$SourceDir" "$DestDir" /E /MAX:$maxBytes /R:1 /W:1 /NP `
        /XF *.iso *.ISO *.img *.dmg *.vmdk *.vdi *.qcow2 *.ova `
            *.tar.gz *.tar.xz *.tar.bz2 *.zip *.7z *.rar `
            *.deb *.rpm *.AppImage *.flatpak *.snap *.log `
        /XD node_modules .git .svn target build dist .venv venv env __pycache__

    Write-Host "Download sync complete!" -ForegroundColor Green
}
