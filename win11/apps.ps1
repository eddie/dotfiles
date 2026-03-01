#Requires -RunAsAdministrator

$apps = @(
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
    "Neovim.Neovim"
    "Valve.Steam"
)

foreach ($app in $apps) { winget install --id $app --exact --accept-package-agreements --accept-source-agreements --silent }
winget install --id 9P8K0HHTG2CH --source msstore --accept-package-agreements --accept-source-agreements --silent
