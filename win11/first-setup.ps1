# ============================================
# Windows 11 Setup Script (Idempotent)
# ============================================

#Requires -RunAsAdministrator

# =====================
# HELPER FUNCTIONS
# =====================

function Check-Reg {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Label
    )
    try {
        $val = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop
        [PSCustomObject]@{ Setting = $Label; Value = $val; Status = "Set" }
    }
    catch {
        [PSCustomObject]@{ Setting = $Label; Value = "N/A"; Status = "Not Configured" }
    }
}

function Set-Reg {
    param (
        [string]$Path,
        [string]$Name,
        [int]$Value
    )
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    $current = $null
    try { $current = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop } catch {}
    if ($current -ne $Value) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord
        Write-Host "  SET: $Name = $Value" -ForegroundColor Yellow
    }
    else {
        Write-Host "  OK:  $Name = $Value (already set)" -ForegroundColor DarkGray
    }
}

function Install-WingetPackage {
    param (
        [string]$Id,
        [string]$Label,
        [string]$Source = "winget"
    )
    $installed = winget list --id $Id --source $Source 2>&1 | Select-String $Id
    if ($installed) {
        Write-Host "  OK:  $Label (already installed)" -ForegroundColor DarkGray
    }
    else {
        Write-Host "  INSTALLING: $Label..." -ForegroundColor Yellow
        winget install --id $Id --source $Source --accept-package-agreements --accept-source-agreements --silent
    }
}

function Disable-ServiceIfRunning {
    param ([string]$Name)
    $svc = Get-Service -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $svc) {
        Write-Host "  SKIP: $Name (service not found)" -ForegroundColor DarkGray
        return
    }
    if ($svc.StartType -ne 'Disabled') {
        Set-Service -Name $Name -StartupType Disabled
        Write-Host "  SET: $Name startup -> Disabled" -ForegroundColor Yellow
    }
    else {
        Write-Host "  OK:  $Name (already disabled)" -ForegroundColor DarkGray
    }
    if ($svc.Status -eq 'Running') {
        Stop-Service -Name $Name -Force
        Write-Host "  SET: $Name stopped" -ForegroundColor Yellow
    }
}

# =====================
# STATUS CHECK — BEFORE
# =====================

$checks = @(
    @{Path = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"; Name = "TurnOffWindowsCopilot"; Label = "Copilot (User)" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"; Name = "TurnOffWindowsCopilot"; Label = "Copilot (Machine)" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"; Name = "AllowNewsAndInterests"; Label = "Widgets Disabled" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name = "DisableWindowsConsumerFeatures"; Label = "Consumer Experiences" }
    @{Path = "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"; Name = "DisableAIDataAnalysis"; Label = "Recall Disabled" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"; Name = "TurnOffWindowsAI"; Label = "Windows AI Disabled" }
    @{Path = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"; Name = "DisableSearchBoxSuggestions"; Label = "Search Suggestions" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"; Name = "HubsSidebarEnabled"; Label = "Edge Sidebar" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"; Name = "DiscoverPageContextEnabled"; Label = "Edge Discover" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name = "AllowTelemetry"; Label = "Telemetry Level" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "TaskbarDa"; Label = "Widgets Taskbar" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name = "SearchboxTaskbarMode"; Label = "Search Taskbar" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "ShowTaskViewButton"; Label = "Task View Button" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "TaskbarMn"; Label = "Chat/Teams Button" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "ShowCopilotButton"; Label = "Copilot Button" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "MultiTaskingAltTabFilter"; Label = "Alt+Tab Filter" }
    @{Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"; Name = "AllowDevelopmentWithoutDevLicense"; Label = "Developer Mode" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "HideFileExt"; Label = "Hide File Extensions" }
    @{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name = "LaunchTo"; Label = "Explorer Launch Target" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; Name = "NoAutoRebootWithLoggedOnUsers"; Label = "No Auto Reboot" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name = "DeferFeatureUpdatesPeriodInDays"; Label = "Defer Feature Updates" }
    @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name = "DeferQualityUpdatesPeriodInDays"; Label = "Defer Quality Updates" }
)

Write-Host "`n===== CURRENT STATUS =====" -ForegroundColor Cyan
$checks | ForEach-Object { Check-Reg @_ } | Format-Table -AutoSize

$confirm = Read-Host "Apply all settings? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit
}

# =====================
# HELPER — INSTALL (FIXED)
# =====================

function Install-WingetPackage {
    param (
        [string]$Id,
        [string]$Label,
        [string]$Source = "winget"
    )
    # Check without --source (installed packages don't filter by source reliably)
    $check = winget list --id $Id --exact --accept-source-agreements 2>&1 | Out-String
    if ($check -match [regex]::Escape($Id)) {
        Write-Host "  OK:  $Label (already installed)" -ForegroundColor DarkGray
    }
    else {
        Write-Host "  INSTALLING: $Label..." -ForegroundColor Yellow
        winget install --id $Id --source $Source --exact --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  DONE: $Label installed" -ForegroundColor Green
        }
        else {
            Write-Host "  WARN: $Label may have failed (exit code $LASTEXITCODE)" -ForegroundColor Red
        }
    }
}

# =====================
# PACKAGES (CORRECTED IDs)
# =====================

Write-Host "`n--- Software Packages ---" -ForegroundColor Cyan

$packages = @(
    @{Id = "Obsidian.Obsidian"; Label = "Obsidian" }
    @{Id = "Microsoft.VisualStudioCode"; Label = "VS Code" }
    @{Id = "Plex.Plexamp"; Label = "Plexamp" }
    @{Id = "TablePlus.TablePlus"; Label = "TablePlus" }
    @{Id = "dotPDN.PaintDotNet"; Label = "Paint.NET" }
    @{Id = "Mozilla.Firefox"; Label = "Firefox" }
    @{Id = "Microsoft.PowerToys"; Label = "PowerToys" }
    @{Id = "DevToys-app.DevToys"; Label = "DevToys" }
    @{Id = "Microsoft.WSL"; Label = "WSL" }
    @{Id = "AgileBits.1Password"; Label = "1Password" }
    @{Id = "Microsoft.DevHome"; Label = "Dev Home" }
    @{Id = "Microsoft.PowerShell"; Label = "PowerShell 7" }
    @{Id = "MHNexus.HxD"; Label = "HxD Hex Editor" }
    @{Id = "GitHub.cli"; Label = "GitHub CLI" }
    @{Id = "Git.Git"; Label = "Git" }
    @{Id = "Anthropic.Claude"; Label = "Claude Desktop" }
    @{Id = "Anthropic.ClaudeCode"; Label = "Claude Code CLI" }

)

foreach ($pkg in $packages) {
    Install-WingetPackage -Id $pkg.Id -Label $pkg.Label
}

# WinToys — msstore only
$wtCheck = winget list --name "WinToys" --accept-source-agreements 2>&1 | Out-String
if ($wtCheck -match "WinToys") {
    Write-Host "  OK:  WinToys (already installed)" -ForegroundColor DarkGray
}
else {
    Write-Host "  INSTALLING: WinToys..." -ForegroundColor Yellow
    winget install --id 9P8K0HHTG2CH --source msstore --accept-package-agreements --accept-source-agreements --silent
}
# =====================
# 2. GROUP POLICY VIA REGISTRY
# =====================

Write-Host "`n--- Copilot & AI Policies ---" -ForegroundColor Cyan

Set-Reg "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"   "TurnOffWindowsCopilot" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"   "TurnOffWindowsCopilot" 1

Write-Host "`n--- Widgets & Consumer Experiences ---" -ForegroundColor Cyan

Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"                      "AllowNewsAndInterests" 0
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"     "DisableWindowsConsumerFeatures" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"     "DisableSoftLanding" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"     "DisableCloudOptimizedContent" 1

Write-Host "`n--- Windows AI / Recall ---" -ForegroundColor Cyan

Set-Reg "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"        "DisableAIDataAnalysis" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"        "TurnOffWindowsAI" 1

Write-Host "`n--- Search & Edge ---" -ForegroundColor Cyan

Set-Reg "HKCU:\Software\Policies\Microsoft\Windows\Explorer"         "DisableSearchBoxSuggestions" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Edge"                     "HubsSidebarEnabled" 0
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Edge"                     "DiscoverPageContextEnabled" 0

# =====================
# 3. TELEMETRY
# =====================

Write-Host "`n--- Telemetry ---" -ForegroundColor Cyan

Disable-ServiceIfRunning "DiagTrack"
Disable-ServiceIfRunning "dmwappushservice"
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"   "AllowTelemetry" 0

# =====================
# 4. TASKBAR CLEANUP
# =====================

Write-Host "`n--- Taskbar ---" -ForegroundColor Cyan

$tb = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

Set-Reg $tb                                                           "TaskbarDa" 0
Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"     "SearchboxTaskbarMode" 0
Set-Reg $tb                                                           "ShowTaskViewButton" 0
Set-Reg $tb                                                           "TaskbarMn" 0
Set-Reg $tb                                                           "ShowCopilotButton" 0

# =====================
# 5. MULTITASK
# =====================

Write-Host "`n--- Multitask ---" -ForegroundColor Cyan

Set-Reg $tb "MultiTaskingAltTabFilter" 3

# =====================
# 6. SUDO & DEVELOPER MODE
# =====================

Write-Host "`n--- Developer Settings ---" -ForegroundColor Cyan

Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Sudo"          "Enabled" 1
Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 1
Set-Reg $tb "HideFileExt" 0
Set-Reg $tb "Hidden" 1

# =====================
# 7. WINDOWS UPDATE
# =====================

Write-Host "`n--- Windows Update ---" -ForegroundColor Cyan

Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"    "DeferFeatureUpdates" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"    "DeferFeatureUpdatesPeriodInDays" 30
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"    "DeferQualityUpdates" 1
Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"    "DeferQualityUpdatesPeriodInDays" 7

# =====================
# 8. KEYBOARD / REGION
# =====================

# Write-Host "`n--- Keyboard & Region ---" -ForegroundColor Cyan

# $currentGeo = (Get-WinHomeLocation).GeoId
# if ($currentGeo -ne 68) {
#     Set-WinHomeLocation -GeoId 68
#     Write-Host "  SET: Region -> Ireland (68)" -ForegroundColor Yellow
# }
# else {
#     Write-Host "  OK:  Region = Ireland (already set)" -ForegroundColor DarkGray
# }

# $currentLang = Get-WinUserLanguageList
# $needsLangUpdate = $false
# if ($currentLang.Count -ne 1 -or $currentLang[0].LanguageTag -ne "en-GB") {
#     $needsLangUpdate = $true
# }
# if ($needsLangUpdate) {
#     $langList = New-WinUserLanguageList en-GB
#     $langList[0].InputMethodTips.Clear()
#     $langList[0].InputMethodTips.Add("0809:00000809")
#     Set-WinUserLanguageList $langList -Force
#     Write-Host "  SET: Language -> en-GB, UK keyboard only" -ForegroundColor Yellow
# }
# else {
#     Write-Host "  OK:  Language = en-GB (already set)" -ForegroundColor DarkGray
# }

# =====================
# 9. FILE EXPLORER
# =====================

Write-Host "`n--- File Explorer ---" -ForegroundColor Cyan

Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0
Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0
Set-Reg $tb "LaunchTo" 1

# =====================
# RESTART EXPLORER
# =====================

Write-Host "`n--- Restarting Explorer ---" -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2

# =====================
# STATUS CHECK — AFTER
# =====================

Write-Host "`n===== STATUS (AFTER) =====" -ForegroundColor Cyan
$checks | ForEach-Object { Check-Reg @_ } | Format-Table -AutoSize

Write-Host "`nSetup complete. A reboot is recommended." -ForegroundColor Green