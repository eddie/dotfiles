#Requires -RunAsAdministrator
# ============================================
# Windows 11 Setup Script
# ============================================

# =====================
# PACKAGES
# =====================
$packages = @(
    "Obsidian.Obsidian"
    "Microsoft.VisualStudioCode"
    "Plex.Plexamp"
    "TablePlus.TablePlus"
    "dotPDN.PaintDotNet"
    "Mozilla.Firefox"
    "Microsoft.PowerToys"
    "DevToys-app.DevToys"
    "Microsoft.WSL"
    "AgileBits.1Password"
    "1password-cli.1password-cli"
    "Microsoft.PowerShell"
    "MHNexus.HxD"
    "GitHub.cli"
    "Git.Git"
    "Anthropic.Claude"
    "Anthropic.ClaudeCode"
    "Espanso.Espanso"
)

$msstorePackages = @(
    @{Id="9P8K0HHTG2CH"; Name="WinToys"}
)

# =====================
# REGISTRY SETTINGS
# =====================
$regSettings = @(
    # AI & Copilot
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"; Name="TurnOffWindowsCopilot"; Value=1; Why="Disable Copilot (user policy)"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"; Name="TurnOffWindowsCopilot"; Value=1; Why="Disable Copilot (machine policy)"}
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"; Name="DisableAIDataAnalysis"; Value=1; Why="Disable Recall/AI data analysis"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"; Name="TurnOffWindowsAI"; Value=1; Why="Disable Windows AI system-wide"}

    # Widgets & Bloat
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Dsh"; Name="AllowNewsAndInterests"; Value=0; Why="Disable Widgets/News feed"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsConsumerFeatures"; Value=1; Why="No app suggestions/tips"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name="DisableSoftLanding"; Value=1; Why="No app install prompts"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name="DisableCloudOptimizedContent"; Value=1; Why="No cloud content"}

    # Search & Edge
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\Explorer"; Name="DisableSearchBoxSuggestions"; Value=1; Why="No web search suggestions"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Edge"; Name="HubsSidebarEnabled"; Value=0; Why="Disable Edge sidebar"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Edge"; Name="DiscoverPageContextEnabled"; Value=0; Why="Disable Edge Discover"}

    # Telemetry
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Value=0; Why="Minimal telemetry"}

    # Taskbar
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="TaskbarDa"; Value=0; Why="Hide Widgets button"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name="SearchboxTaskbarMode"; Value=0; Why="Hide Search box"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="ShowTaskViewButton"; Value=0; Why="Hide Task View"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="TaskbarMn"; Value=0; Why="Hide Chat/Teams"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="ShowCopilotButton"; Value=0; Why="Hide Copilot button"}

    # Multitasking
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="MultiTaskingAltTabFilter"; Value=3; Why="Alt+Tab: current desktop only"}

    # Developer
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Sudo"; Name="Enabled"; Value=1; Why="Enable sudo command"}
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"; Name="AllowDevelopmentWithoutDevLicense"; Value=1; Why="Developer mode"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="HideFileExt"; Value=0; Why="Show file extensions"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="Hidden"; Value=1; Why="Show hidden files"}

    # Windows Update
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; Name="NoAutoRebootWithLoggedOnUsers"; Value=1; Why="No forced reboot"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name="DeferFeatureUpdates"; Value=1; Why="Defer feature updates"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name="DeferFeatureUpdatesPeriodInDays"; Value=30; Why="Defer features 30d"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name="DeferQualityUpdates"; Value=1; Why="Defer quality updates"}
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name="DeferQualityUpdatesPeriodInDays"; Value=7; Why="Defer quality 7d"}

    # File Explorer
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"; Name="ShowRecent"; Value=0; Why="Hide recent files"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"; Name="ShowFrequent"; Value=0; Why="Hide frequent folders"}
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="LaunchTo"; Value=1; Why="Open to This PC"}
)

$servicesToDisable = @(
    "DiagTrack"         # Telemetry
    "dmwappushservice"  # WAP Push
)

# =====================
# HELPERS
# =====================
function Set-Reg($Path, $Name, $Value) {
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    try { $current = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop } catch { $current = $null }
    if ($current -ne $Value) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord
        Write-Host "  ✓ $Name = $Value" -ForegroundColor Yellow
    } else {
        Write-Host "  · $Name" -ForegroundColor DarkGray
    }
}

function Install-Package($Id) {
    $check = winget list --id $Id --exact --accept-source-agreements 2>&1 | Out-String
    if ($check -match [regex]::Escape($Id)) {
        Write-Host "  · $Id" -ForegroundColor DarkGray
    } else {
        Write-Host "  ⬇ $Id" -ForegroundColor Yellow
        winget install --id $Id --exact --accept-package-agreements --accept-source-agreements --silent | Out-Null
        if ($LASTEXITCODE -eq 0) { Write-Host "  ✓ $Id" -ForegroundColor Green }
        else { Write-Host "  ✗ $Id (exit $LASTEXITCODE)" -ForegroundColor Red }
    }
}

function Disable-Svc($Name) {
    $svc = Get-Service -Name $Name -ErrorAction SilentlyContinue
    if (!$svc) { Write-Host "  · $Name (not found)" -ForegroundColor DarkGray; return }
    if ($svc.StartType -ne 'Disabled') {
        Set-Service -Name $Name -StartupType Disabled
        Write-Host "  ✓ $Name disabled" -ForegroundColor Yellow
    } else {
        Write-Host "  · $Name" -ForegroundColor DarkGray
    }
    if ($svc.Status -eq 'Running') {
        Stop-Service -Name $Name -Force
        Write-Host "  ✓ $Name stopped" -ForegroundColor Yellow
    }
}

# =====================
# PREVIEW & CONFIRM
# =====================
Write-Host "`n========== REGISTRY SETTINGS ==========" -ForegroundColor Cyan
$regSettings | ForEach-Object { Write-Host "  $($_.Why)" -ForegroundColor White }

Write-Host "`n========== PACKAGES ==========" -ForegroundColor Cyan
$packages | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
$msstorePackages | ForEach-Object { Write-Host "  $($_.Name) (msstore)" -ForegroundColor White }

Write-Host "`n========== SERVICES TO DISABLE ==========" -ForegroundColor Cyan
$servicesToDisable | ForEach-Object { Write-Host "  $_" -ForegroundColor White }

$confirm = Read-Host "`nApply all settings? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit
}

# =====================
# EXECUTE
# =====================
Write-Host "`n--- Packages ---" -ForegroundColor Cyan
foreach ($pkg in $packages) { Install-Package $pkg }
foreach ($pkg in $msstorePackages) {
    $check = winget list --name $pkg.Name --accept-source-agreements 2>&1 | Out-String
    if ($check -match $pkg.Name) {
        Write-Host "  · $($pkg.Name)" -ForegroundColor DarkGray
    } else {
        Write-Host "  ⬇ $($pkg.Name)" -ForegroundColor Yellow
        winget install --id $pkg.Id --source msstore --accept-package-agreements --accept-source-agreements --silent | Out-Null
    }
}

Write-Host "`n--- Registry Settings ---" -ForegroundColor Cyan
foreach ($setting in $regSettings) {
    Write-Host "`n$($setting.Why):" -ForegroundColor White
    Set-Reg $setting.Path $setting.Name $setting.Value
}

Write-Host "`n--- Services ---" -ForegroundColor Cyan
foreach ($svc in $servicesToDisable) { Disable-Svc $svc }

Write-Host "`n--- Restart Explorer ---" -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2

Write-Host "`n✓ Setup complete. Reboot recommended." -ForegroundColor Green
