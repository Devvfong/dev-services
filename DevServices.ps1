<#
.SYNOPSIS
    DevServices - Ultimate Windows Developer & System Maintenance Suite
.DESCRIPTION
    A modern, modular, interactive terminal utility suite featuring:
    - Legacy & Activation Tools (IDM Reset, Microsoft Activation Scripts, Office ODT)
    - Developer Environment Setup (Winget Batch Installer, Runtime Diagnostics, Package Updater)
    - System Maintenance & Tweaks (Deep Junk Cleaner, DISM/SFC Repair, Windows Update Reset, Power Plans)
    - Network Tools (DNS Switcher, Winsock/DNS Flush, Ping Benchmarks, IP Config)
    - Custom Themes, ASCII Banners, Interactive Arrow-Key Navigation & Single-File Compilation
.NOTES
    Author: Devvfong
    Version: 2.0.0
#>

[CmdletBinding()]
param(
    [switch]$Fast,
    [string]$Module = "",
    [switch]$Admin
)

$ErrorActionPreference = "Stop"

# Force UTF-8 console output for box-drawing characters
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Auto-elevate if -Admin flag is passed
if ($Admin -and -not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Determine base directory
$BaseDir = $PSScriptRoot
if (-not $BaseDir) {
    $BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
}
if (-not $BaseDir) {
    $BaseDir = (Get-Location).Path
}

# Source Core files
$coreFiles = @(
    "src\assets\banners.ps1",
    "src\core\Config.ps1",
    "src\core\Logger.ps1",
    "src\core\Executor.ps1",
    "src\core\UI.ps1"
)

# Source Modules
$moduleFiles = @(
    "src\modules\legacy\LegacyTools.ps1",
    "src\modules\dev\DevTools.ps1",
    "src\modules\system\SystemTweaks.ps1",
    "src\modules\network\NetworkTools.ps1",
    "src\modules\customization\SettingsMenu.ps1"
)

foreach ($relPath in ($coreFiles + $moduleFiles)) {
    $fullPath = Join-Path $BaseDir $relPath
    if (Test-Path $fullPath) {
        . $fullPath
    } else {
        Write-Warning "Required component not found: $fullPath"
    }
}

# Initialize Configuration
Load-DevServicesConfig
if ($Fast) {
    $global:DevServicesConfig.FastMode = $true
}

# Apply configured font and size (JetBrains Mono 20pt)
if ($global:DevServicesConfig.AutoApplyFont) {
    Set-ConsoleFont -FontName $global:DevServicesConfig.FontFamily -FontSize $global:DevServicesConfig.FontSize
}

# Main Application Entry Point
function Start-DevServices {
    [Console]::Title = "$($global:DevServicesConfig.AppName) v$($global:DevServicesConfig.Version) - $($global:DevServicesConfig.AppSubtitle)"

    # Direct Module Execution Mode
    if ($Module) {
        switch ($Module.ToLower()) {
            "legacy"  { Show-LegacyToolsMenu; return }
            "dev"     { Show-DevToolsMenu; return }
            "system"  { Show-SystemTweaksMenu; return }
            "network" { Show-NetworkToolsMenu; return }
            "settings"{ Show-SettingsMenu; return }
        }
    }

    # Initial Splash / Loading Screen
    if ($global:DevServicesConfig.ShowAnimation -and -not $global:DevServicesConfig.FastMode) {
        Clear-Host
        Show-DevBanner -Breadcrumb "Starting..."
        Show-SplashProgress -Message "Loading DevServices Core Modules & Catalog..." -DurationSeconds 2
    }

    # Main Interactive Loop
    while ($true) {
        $isAdmin = Test-IsAdmin

        $mainOptions = @(
            @{
                Key = "1"
                Label = "Legacy & Activation Utilities"
                Desc = "IDM Reset, Microsoft Activation Scripts (MAS), Office ODT"
                Action = { Show-LegacyToolsMenu }
            },
            @{
                Key = "2"
                Label = "Developer Environment Suite"
                Desc = "Winget Batch Installer, Dev Runtimes, Package Updater, WSL2"
                Action = { Show-DevToolsMenu }
            },
            @{
                Key = "3"
                Label = "System Maintenance & Tweaks"
                Desc = "Temp Cleaner, DISM/SFC Health, Power Plans, Win11 UI Tweaks"
                Action = { Show-SystemTweaksMenu }
            },
            @{
                Key = "4"
                Label = "Network Utilities & DNS Switcher"
                Desc = "Cloudflare/Google/AdGuard DNS, Ping Benchmark, Network Flush"
                Action = { Show-NetworkToolsMenu }
            },
            @{
                Key = "5"
                Label = "Settings & Personalization"
                Desc = "Change Themes, ASCII Banners, Animation & Performance Settings"
                Action = { Show-SettingsMenu }
            }
        )

        if (-not $isAdmin) {
            $mainOptions += @{
                Key = "6"
                Label = "Restart as Administrator"
                Desc = "Relaunch with elevated privileges for full system control"
                Action = {
                    Restart-AsAdmin -ScriptPath "$BaseDir\DevServices.ps1"
                }
            }
        }

        $exitKey = if ($isAdmin) { "6" } else { "7" }
        $mainOptions += @{
            Key = $exitKey
            Label = "Exit DevServices"
            Desc = "Quit application"
            Action = {
                Clear-Host
                $theme = Get-ActiveTheme
                $width = Get-WindowWidth
                $byeText = "Thank you for using $($global:DevServicesConfig.AppName)! Have a great day!"
                $pad = [math]::Max(0, [int](($width - $byeText.Length) / 2))
                Write-Host ""
                Write-Host (" " * $pad + $byeText) -ForegroundColor $theme.Primary
                Write-Host ""
                Start-Sleep -Milliseconds 800
                Exit
            }
        }

        $selected = Show-InteractiveMenu -Title "Main Service Catalog" -Options $mainOptions -Breadcrumb "Home" -AllowExit
        if ($null -eq $selected) {
            Clear-Host
            break
        }
        & $selected.Action
    }
}

# Run
Start-DevServices
