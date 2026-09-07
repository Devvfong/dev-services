<#
    DevServices Standalone Single-File Bundle
    Built: 2026-09-07 14:17:57
#>
$ErrorActionPreference = "Stop"

# ==================================================
# FILE: src\assets\banners.ps1
# ==================================================
# ASCII Art Banners and Styling Assets for DevServices

$global:BannerStyles = @{
    "Default" = @'
  ____              ____                  _
 |  _ \  _____   __/ ___|  ___ _ ____   _(_) ___ ___  ___
 | | | |/ _ \ \ / /\___ \ / _ \ '__\ \ / / |/ __/ _ \/ __|
 | |_| |  __/\ V /  ___) |  __/ |   \ V /| | (_|  __/\__ \
 |____/ \___| \_/  |____/ \___|_|    \_/ |_|\___\___||___/
'@

    "Slant" = @'
    ____              _____                 _
   / __ \___ _   __  / ___/___  ______   __(_)_______  _____
  / / / / _ \ | / /  \__ \/ _ \/ ___/ | / / / ___/ _ \/ ___/
 / /_/ /  __/ |/ /  ___/ /  __/ /   | |/ / / /__/  __(__  )
/_____/\___/|___/  /____/\___/_/    |___/_/\___/\___/____/
'@

    "Cyber" = @'
 ██████╗ ███████╗██╗   ██╗    ███████╗███████╗██████╗ ██╗   ██╗
 ██╔══██╗██╔════╝██║   ██║    ██╔════╝██╔════╝██╔══██╗██║   ██║
 ██║  ██║█████╗  ██║   ██║    ███████╗█████╗  ██████╔╝██║   ██║
 ██║  ██║██╔══╝  ╚██╗ ██╔╝    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝
 ██████╔╝███████╗ ╚████╔╝     ███████║███████╗██║  ██║ ╚████╔╝
 ╚═════╝ ╚══════╝  ╚═══╝      ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝
'@

    "Minimal" = @'
 ┌───────────────────────────────────────────────────────────┐
 │                   D E V - S E R V I C E S                 │
 │            Ultimate Windows Developer & System Suite      │
 └───────────────────────────────────────────────────────────┘
'@

    "DevQii" = @'
  _____                ____  _ _
 |  __ \              / __ \(_|_)
 | |  | | _____   __ | |  | |_ _
 | |  | |/ _ \ \ / / | |  | | | |
 | |__| |  __/\ V /  | |__| | | |
 |_____/ \___| \_/    \___\_\_|_|
'@
}

function Get-Banner {
    param(
        [string]$Style = "Default"
    )

    if ($global:BannerStyles.ContainsKey($Style)) {
        return $global:BannerStyles[$Style]
    }
    return $global:BannerStyles["Default"]
}


# ==================================================
# FILE: src\core\Config.ps1
# ==================================================
# Configuration & State Management for DevServices

$global:DevServicesConfig = @{
    Version        = "2.0.0"
    AppName        = "DevServices"
    AppSubtitle   = "Ultimate Windows Developer & System Suite"
    Author         = "Devvfong"
    Theme          = "Rainbow"
    BannerStyle    = "DevQii"
    ShowAnimation  = $true
    FastMode       = $false
    FontSize       = 20
    FontFamily     = "JetBrains Mono"
    AutoApplyFont  = $true
    ConfigPath     = "$env:USERPROFILE\.devservices_config.json"
}

# Theme definitions with console colors
$global:Themes = @{
    "Rainbow" = @{
        Name         = "Rainbow Vibrance"
        Colors       = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
        Primary      = "Cyan"
        Secondary    = "Magenta"
        Accent       = "Yellow"
        Success      = "Green"
        Warning      = "Yellow"
        Danger       = "Red"
        Text         = "White"
        Muted        = "DarkGray"
        Highlight    = "Yellow"
    }
    "Cyberpunk" = @{
        Name         = "Cyberpunk Neon"
        Colors       = @('Magenta', 'Cyan', 'Yellow', 'Magenta', 'Cyan')
        Primary      = "Magenta"
        Secondary    = "Cyan"
        Accent       = "Yellow"
        Success      = "Green"
        Warning      = "Yellow"
        Danger       = "Red"
        Text         = "White"
        Muted        = "DarkGray"
        Highlight    = "Cyan"
    }
    "Azure" = @{
        Name         = "Azure Modern"
        Colors       = @('Cyan', 'Blue', 'Cyan', 'White', 'Blue')
        Primary      = "Cyan"
        Secondary    = "Blue"
        Accent       = "White"
        Success      = "Green"
        Warning      = "Yellow"
        Danger       = "Red"
        Text         = "White"
        Muted        = "DarkCyan"
        Highlight    = "Cyan"
    }
    "Matrix" = @{
        Name         = "Matrix Terminal"
        Colors       = @('Green', 'DarkGreen', 'Green', 'White', 'Green')
        Primary      = "Green"
        Secondary    = "DarkGreen"
        Accent       = "White"
        Success      = "Green"
        Warning      = "Yellow"
        Danger       = "Red"
        Text         = "White"
        Muted        = "DarkGray"
        Highlight    = "Green"
    }
    "Sunset" = @{
        Name         = "Sunset Glow"
        Colors       = @('Red', 'DarkYellow', 'Yellow', 'Magenta', 'Red')
        Primary      = "Yellow"
        Secondary    = "Magenta"
        Accent       = "Red"
        Success      = "Green"
        Warning      = "Yellow"
        Danger       = "Red"
        Text         = "White"
        Muted        = "DarkGray"
        Highlight    = "Yellow"
    }
}

function Load-DevServicesConfig {
    try {
        if (Test-Path $global:DevServicesConfig.ConfigPath) {
            $json = Get-Content -Path $global:DevServicesConfig.ConfigPath -Raw -ErrorAction SilentlyContinue
            if ($json) {
                $saved = ConvertFrom-Json $json
                if ($saved.Theme -and $global:Themes.ContainsKey($saved.Theme)) {
                    $global:DevServicesConfig.Theme = $saved.Theme
                }
                if ($saved.BannerStyle -and $global:BannerStyles.ContainsKey($saved.BannerStyle)) {
                    $global:DevServicesConfig.BannerStyle = $saved.BannerStyle
                }
                if ($null -ne $saved.ShowAnimation) {
                    $global:DevServicesConfig.ShowAnimation = [bool]$saved.ShowAnimation
                }
                if ($null -ne $saved.FastMode) {
                    $global:DevServicesConfig.FastMode = [bool]$saved.FastMode
                }
                if ($saved.FontSize -and [int]$saved.FontSize -ge 12 -and [int]$saved.FontSize -le 36) {
                    $global:DevServicesConfig.FontSize = [int]$saved.FontSize
                }
                if ($saved.FontFamily) {
                    $global:DevServicesConfig.FontFamily = [string]$saved.FontFamily
                }
                if ($null -ne $saved.AutoApplyFont) {
                    $global:DevServicesConfig.AutoApplyFont = [bool]$saved.AutoApplyFont
                }
            }
        }
    }
    catch {
        # Fall back to defaults on error
    }
}

function Save-DevServicesConfig {
    try {
        $toSave = @{
            Theme         = $global:DevServicesConfig.Theme
            BannerStyle   = $global:DevServicesConfig.BannerStyle
            ShowAnimation = $global:DevServicesConfig.ShowAnimation
            FastMode      = $global:DevServicesConfig.FastMode
            FontSize      = $global:DevServicesConfig.FontSize
            FontFamily    = $global:DevServicesConfig.FontFamily
            AutoApplyFont = $global:DevServicesConfig.AutoApplyFont
            Version       = $global:DevServicesConfig.Version
        }
        $json = ConvertTo-Json $toSave
        Set-Content -Path $global:DevServicesConfig.ConfigPath -Value $json -Force -ErrorAction SilentlyContinue
    }
    catch {
        # Non-fatal
    }
}

function Get-ActiveTheme {
    $themeKey = $global:DevServicesConfig.Theme
    if ($global:Themes.ContainsKey($themeKey)) {
        return $global:Themes[$themeKey]
    }
    return $global:Themes["Rainbow"]
}


# ==================================================
# FILE: src\core\Logger.ps1
# ==================================================
# Logging and Formatted Console Output for DevServices

function Write-DevLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error", "Highlight", "Muted", "Plain", "Primary", "Secondary", "Accent", "Text")]
        [string]$Level = "Info",
        [switch]$NoNewline
    )

    $theme = Get-ActiveTheme
    $prefix = ""
    $color = $theme.Text

    switch ($Level) {
        "Info" {
            $prefix = "[*] "
            $color  = $theme.Primary
        }
        "Success" {
            $prefix = "[+] "
            $color  = $theme.Success
        }
        "Warning" {
            $prefix = "[!] "
            $color  = $theme.Warning
        }
        "Error" {
            $prefix = "[-] "
            $color  = $theme.Danger
        }
        "Highlight" {
            $prefix = "[>] "
            $color  = $theme.Highlight
        }
        "Muted" {
            $prefix = "    "
            $color  = $theme.Muted
        }
        "Plain" {
            $prefix = ""
            $color  = $theme.Text
        }
        "Primary" {
            $prefix = ""
            $color  = $theme.Primary
        }
        "Secondary" {
            $prefix = ""
            $color  = $theme.Secondary
        }
        "Accent" {
            $prefix = ""
            $color  = $theme.Accent
        }
        "Text" {
            $prefix = ""
            $color  = $theme.Text
        }
    }

    $fullText = "$prefix$Message"
    if ($NoNewline) {
        Write-Host $fullText -ForegroundColor $color -NoNewline
    } else {
        Write-Host $fullText -ForegroundColor $color
    }
}

function Write-DevHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [string]$Subtitle = ""
    )
    $theme = Get-ActiveTheme
    $width = Get-WindowWidth

    Write-Host ""
    $line = "=" * [math]::Min($width - 4, 60)
    $pad = [math]::Max(0, [int](($width - $line.Length) / 2))
    $spaces = " " * $pad

    Write-Host "$spaces$line" -ForegroundColor $theme.Secondary

    $titlePad = [math]::Max(0, [int](($width - $Title.Length) / 2))
    Write-Host (" " * $titlePad + $Title) -ForegroundColor $theme.Primary

    if ($Subtitle) {
        $subPad = [math]::Max(0, [int](($width - $Subtitle.Length) / 2))
        Write-Host (" " * $subPad + $Subtitle) -ForegroundColor $theme.Muted
    }

    Write-Host "$spaces$line" -ForegroundColor $theme.Secondary
    Write-Host ""
}


# ==================================================
# FILE: src\core\Executor.ps1
# ==================================================
# Command Execution, Cancellation & Process Management for DevServices

function Test-IsAdmin {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($identity)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        return $false
    }
}

function Invoke-RequireAdmin {
    param(
        [string]$Reason = "This operation requires Administrator privileges."
    )

    if (Test-IsAdmin) {
        return $true
    }

    Write-DevLog $Reason "Warning"
    Write-DevLog "Please restart DevServices as Administrator (Right click -> Run as Administrator)." "Highlight"
    return $false
}

function Restart-AsAdmin {
    param(
        [string]$ScriptPath = ""
    )

    if (-not $ScriptPath) {
        $ScriptPath = $MyInvocation.PSCommandPath
        if (-not $ScriptPath) {
            $ScriptPath = "$PSScriptRoot\..\..\DevServices.ps1"
        }
    }

    if (Test-Path $ScriptPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -Verb RunAs
        Exit
    }
}

# Ctrl+C and cancellation support
$global:CancellationRequested = $false

function Register-CancellationWatcher {
    $global:CancellationRequested = $false
    try {
        [Console]::TreatControlCAsInput = $true
    }
    catch {}
}

function Unregister-CancellationWatcher {
    try {
        [Console]::TreatControlCAsInput = $false
    }
    catch {}
}

function Test-Cancellation {
    try {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "C" -and ($key.Modifiers -band [ConsoleModifiers]::Control)) {
                $global:CancellationRequested = $true
                return $true
            }
            if ($key.Key -eq "Escape") {
                $global:CancellationRequested = $true
                return $true
            }
        }
    }
    catch {}
    return $global:CancellationRequested
}

function Invoke-CancellableAction {
    param(
        [Parameter(Mandatory=$true)]
        [ScriptBlock]$Action,
        [string]$ActivityName = "Processing...",
        [string]$SuccessMessage = "Operation completed successfully!",
        [string]$ErrorMessage = "Operation failed."
    )

    $global:CancellationRequested = $false
    Register-CancellationWatcher

    try {
        Write-DevLog "$ActivityName" "Highlight"
        Write-DevLog "(Press Ctrl+C or ESC at any time to cancel)" "Muted"
        Write-Host ""

        # Run scriptblock
        & $Action

        Write-Host ""
        if ($global:CancellationRequested) {
            Write-DevLog "Operation was cancelled by user." "Warning"
            return $false
        } else {
            Write-DevLog "$SuccessMessage" "Success"
            return $true
        }
    }
    catch {
        Write-Host ""
        Write-DevLog "$ErrorMessage Details: $($_.Exception.Message)" "Error"
        return $false
    }
    finally {
        Unregister-CancellationWatcher
    }
}

function Invoke-DevDownload {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath,
        [string]$Description = "Downloading file..."
    )

    $global:CancellationRequested = $false
    Register-CancellationWatcher

    try {
        $destDir = [System.IO.Path]::GetDirectoryName($DestinationPath)
        if ($destDir -and -not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        Write-DevLog "$Description" "Highlight"
        Write-DevLog "Source: $Url" "Muted"
        Write-DevLog "Target: $DestinationPath" "Muted"

        # Use .NET WebClient or HttpClient with progress for smooth downloading
        $webClient = New-Object System.Net.WebClient

        # Add TLS 1.2 / 1.3 support
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls12,Tls13'

        # Download file
        $webClient.DownloadFile($Url, $DestinationPath)

        if (Test-Path $DestinationPath) {
            $fileSize = (Get-Item $DestinationPath).Length
            $sizeMB = [math]::Round($fileSize / 1MB, 2)
            Write-DevLog "Downloaded successfully ($sizeMB MB)" "Success"
            return $true
        } else {
            Write-DevLog "Download completed but destination file was not found." "Error"
            return $false
        }
    }
    catch {
        Write-DevLog "Download failed: $($_.Exception.Message)" "Error"
        return $false
    }
    finally {
        Unregister-CancellationWatcher
    }
}

function Test-WingetAvailable {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    return ($null -ne $winget)
}


# ==================================================
# FILE: src\core\UI.ps1
# ==================================================
# Interactive TUI Engine, Menus, ANSI Styling & Animations for DevServices

# Win32 Console Font Interop Helper
try {
    if (-not ([System.Management.Automation.PSTypeName]'DevConsoleFontHelper').Type) {
        $fontNativeCode = @'
using System;
using System.Runtime.InteropServices;

public class DevConsoleFontHelper
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct CONSOLE_FONT_INFO_EX
    {
        public uint cbSize;
        public uint nFont;
        public short dwFontSizeX;
        public short dwFontSizeY;
        public int FontFamily;
        public int FontWeight;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string FaceName;
    }

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    public static bool ApplyFont(string fontName, short fontSizeY)
    {
        try {
            IntPtr hConsole = GetStdHandle(-11);

            // Apply to normal window
            CONSOLE_FONT_INFO_EX info = new CONSOLE_FONT_INFO_EX();
            info.cbSize = (uint)Marshal.SizeOf(info);
            info.dwFontSizeX = 0;
            info.dwFontSizeY = fontSizeY;
            info.FontFamily = 54; // TMPF_VECTOR | TMPF_TRUETYPE
            info.FontWeight = 600; // Semi-Bold
            info.FaceName = fontName;
            bool result = SetCurrentConsoleFontEx(hConsole, false, ref info);

            // Apply same font to maximized window so it doesn't shrink when maximized
            CONSOLE_FONT_INFO_EX infoMax = new CONSOLE_FONT_INFO_EX();
            infoMax.cbSize = (uint)Marshal.SizeOf(infoMax);
            infoMax.dwFontSizeX = 0;
            infoMax.dwFontSizeY = fontSizeY;
            infoMax.FontFamily = 54;
            infoMax.FontWeight = 600;
            infoMax.FaceName = fontName;
            SetCurrentConsoleFontEx(hConsole, true, ref infoMax);

            return result;
        } catch {
            return false;
        }
    }
}
'@
        Add-Type -TypeDefinition $fontNativeCode -ErrorAction SilentlyContinue
    }
} catch {}

function Set-ConsoleFont {
    param(
        [string]$FontName = "JetBrains Mono",
        [int]$FontSize = 20
    )

    try {
        if ([DevConsoleFontHelper]) {
            [DevConsoleFontHelper]::ApplyFont($FontName, [short]$FontSize) | Out-Null
        }
    } catch {}

    # Also expand the buffer so maximized window can use full width
    try {
        $maxWidth  = $Host.UI.RawUI.MaxWindowSize.Width
        $maxHeight = $Host.UI.RawUI.MaxWindowSize.Height
        if ($maxWidth -gt 0 -and $maxHeight -gt 0) {
            $buf = $Host.UI.RawUI.BufferSize
            if ($buf.Width -lt $maxWidth) {
                $Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($maxWidth, [math]::Max(9000, $buf.Height))
            }
        }
    } catch {}
}

function Get-WindowWidth {
    try {
        $w = [Console]::WindowWidth
        if ($w -ge 20) { return $w }
    } catch {}
    try {
        $w = $Host.UI.RawUI.WindowSize.Width
        if ($w -ge 20) { return $w }
    } catch {}
    return 80
}

function Get-WindowHeight {
    try {
        $h = [Console]::WindowHeight
        if ($h -ge 10) { return $h }
    } catch {}
    try {
        $h = $Host.UI.RawUI.WindowSize.Height
        if ($h -ge 10) { return $h }
    } catch {}
    return 25
}

function Test-ConsoleKeyAvailable {
    try {
        return [Console]::KeyAvailable
    } catch {
        return $null
    }
}

function Show-DevBanner {
    param(
        [string]$Breadcrumb = ""
    )

    $theme = Get-ActiveTheme
    $width = Get-WindowWidth
    $bannerText = Get-Banner -Style $global:DevServicesConfig.BannerStyle

    $lines = $bannerText -split "`r?`n" | Where-Object { $_ -match '\S' }
    $maxLength = 0
    foreach ($line in $lines) {
        if ($line.Length -gt $maxLength) { $maxLength = $line.Length }
    }

    $padding = [math]::Max(0, [int](($width - $maxLength) / 2))
    $spaces = " " * $padding
    $colors = $theme.Colors

    Write-Host ""
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $color = $colors[$i % $colors.Count]
        Write-Host "$spaces$($lines[$i])" -ForegroundColor $color
    }

    # App Subtitle
    $sub = "$($global:DevServicesConfig.AppSubtitle) v$($global:DevServicesConfig.Version)"
    $subPad = [math]::Max(0, [int](($width - $sub.Length) / 2))
    Write-Host (" " * $subPad + $sub) -ForegroundColor $theme.Muted

    # Status Bar / Breadcrumb Box
    $isAdmin = Test-IsAdmin
    $adminBadge = if ($isAdmin) { "ADMINISTRATOR" } else { "STANDARD USER" }
    $adminColor = if ($isAdmin) { "Green" } else { "Yellow" }
    $fontBadge = "$($global:DevServicesConfig.FontFamily) ($($global:DevServicesConfig.FontSize)pt)"

    $crumbText = if ($Breadcrumb) { $Breadcrumb } else { "Main Menu" }

    $badgeBar = " [ $crumbText ]  |  $adminBadge  |  $fontBadge "
    $barPad = [math]::Max(0, [int](($width - $badgeBar.Length) / 2))

    Write-Host ""
    Write-Host (" " * $barPad) -NoNewline
    Write-Host " [ $crumbText ] " -ForegroundColor $theme.Secondary -NoNewline
    Write-Host " | " -ForegroundColor $theme.Muted -NoNewline
    Write-Host "$adminBadge" -ForegroundColor $adminColor -NoNewline
    Write-Host " | " -ForegroundColor $theme.Muted -NoNewline
    Write-Host "$fontBadge" -ForegroundColor $theme.Accent
    Write-Host ""
}

function Show-SplashProgress {
    param(
        [string]$Message = "Initializing DevServices...",
        [int]$DurationSeconds = 2
    )

    if (-not $global:DevServicesConfig.ShowAnimation -or $global:DevServicesConfig.FastMode) {
        return
    }

    $theme = Get-ActiveTheme
    $width = Get-WindowWidth
    $barWidth = [math]::Min(50, [math]::Max(24, $width - 24))

    $msgPad = [math]::Max(0, [int](($width - $Message.Length) / 2))
    Write-Host "`n" + (" " * $msgPad + $Message) -ForegroundColor $theme.Primary
    Write-Host ""

    $steps = $barWidth
    $sleepMs = [int](($DurationSeconds * 1000) / $steps)

    for ($i = 0; $i -le $steps; $i++) {
        $percent = [math]::Round(($i / $steps) * 100)
        $filled = "=" * $i
        $empty = " " * ($steps - $i)
        $bar = "[$filled>$empty] $percent%"
        $barPad = [math]::Max(0, [int](($width - $bar.Length) / 2))

        Write-Host "`r" + (" " * $barPad + $bar) -NoNewline -ForegroundColor $theme.Accent
        Start-Sleep -Milliseconds $sleepMs
    }

    $completeBar = "[" + ("=" * ($steps + 1)) + "] 100%"
    $barPad = [math]::Max(0, [int](($width - $completeBar.Length) / 2))
    Write-Host "`r" + (" " * $barPad + $completeBar) -ForegroundColor $theme.Success
    Start-Sleep -Milliseconds 400
}

function Show-DevProgressBar {
    param(
        [string]$Activity,
        [int]$Seconds = 3,
        [string]$Color = ""
    )

    $theme = Get-ActiveTheme
    if (-not $Color) { $Color = $theme.Primary }
    $width = Get-WindowWidth
    $barWidth = [math]::Min(50, [math]::Max(24, $width - 24))

    $actPad = [math]::Max(0, [int](($width - $Activity.Length) / 2))
    Write-Host "`n" + (" " * $actPad + $Activity) -ForegroundColor $theme.Warning

    $steps = $barWidth
    $sleepMs = [int](($Seconds * 1000) / $steps)

    for ($i = 0; $i -le $steps; $i++) {
        if (Test-Cancellation) {
            Write-Host "`nCancelled." -ForegroundColor $theme.Danger
            return $false
        }

        $percent = [math]::Round(($i / $steps) * 100)
        $bar = "[" + ("#" * $i)
        if ($i -lt $steps) {
            $bar += ">" + ("." * ($steps - $i - 1))
        }
        $bar += "] $percent%"

        $barPad = [math]::Max(0, [int](($width - $bar.Length) / 2))
        Write-Host "`r" + (" " * $barPad + $bar) -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds $sleepMs
    }

    $completeBar = "[" + ("#" * $barWidth) + "] 100%"
    $barPad = [math]::Max(0, [int](($width - $completeBar.Length) / 2))
    Write-Host "`r" + (" " * $barPad + $completeBar) -ForegroundColor $theme.Success
    return $true
}

function Invoke-WaitPrompt {
    param(
        [string]$Message = "Press any key to return to menu..."
    )
    $theme = Get-ActiveTheme
    $lastW = Get-WindowWidth
    $lastH = Get-WindowHeight

    $pad = [math]::Max(0, [int](($lastW - $Message.Length) / 2))
    Write-Host ""
    Write-Host (" " * $pad + $Message) -ForegroundColor $theme.Muted

    while ($true) {
        $curW = Get-WindowWidth
        $curH = Get-WindowHeight
        if ($curW -ne $lastW -or $curH -ne $lastH) {
            $lastW = $curW
            $lastH = $curH
            $pad = [math]::Max(0, [int](($curW - $Message.Length) / 2))
            Write-Host "`r" + (" " * $pad + $Message) -ForegroundColor $theme.Muted
        }

        $keyAvail = Test-ConsoleKeyAvailable
        if ($null -eq $keyAvail) {
            Read-Host | Out-Null
            break
        }

        if ($keyAvail) {
            try {
                $null = [Console]::ReadKey($true)
            } catch {
                Read-Host | Out-Null
            }
            break
        }
        Start-Sleep -Milliseconds 40
    }
}

# Interactive Menu Selection Engine with Real-Time Window Resize Responsiveness
function Show-InteractiveMenu {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [array]$Options,
        [string]$Breadcrumb = "",
        [switch]$AllowExit
    )

    $theme = Get-ActiveTheme
    $selectedIndex = 0
    $totalOptions = $Options.Count

    $lastWidth = 0
    $lastHeight = 0

    while ($true) {
        $width = Get-WindowWidth
        $height = Get-WindowHeight
        $lastWidth = $width
        $lastHeight = $height

        Clear-Host
        Show-DevBanner -Breadcrumb $Breadcrumb

        # Prominent Title Header Box
        $boxTitle = "  $Title  "
        $borderLine = "═" * ($boxTitle.Length + 4)
        $topBorder = "╔$borderLine╗"
        $midBorder = "║  $boxTitle  ║"
        $botBorder = "╚$borderLine╝"

        $boxPad = [math]::Max(0, [int](($width - $topBorder.Length) / 2))
        $boxSpaces = " " * $boxPad

        Write-Host "$boxSpaces$topBorder" -ForegroundColor $theme.Secondary
        Write-Host "$boxSpaces$midBorder" -ForegroundColor $theme.Primary
        Write-Host "$boxSpaces$botBorder" -ForegroundColor $theme.Secondary
        Write-Host ""

        # Calculate max item length for centering dynamically
        $maxItemLen = 0
        foreach ($opt in $Options) {
            $d = if ($opt.Desc) { "  -  $($opt.Desc)" } else { "" }
            $l = 10 + $opt.Label.Length + $d.Length
            if ($l -gt $maxItemLen) { $maxItemLen = $l }
        }

        $menuWidth = [math]::Min($width - 4, [math]::Max(40, $maxItemLen))
        $leftPad = [math]::Max(0, [int](($width - $menuWidth) / 2))
        $spaces = " " * $leftPad

        for ($i = 0; $i -lt $totalOptions; $i++) {
            $opt = $Options[$i]
            $numKey = if ($opt.Key) { $opt.Key } else { ($i + 1).ToString() }
            $label = $opt.Label
            $desc = if ($opt.Desc) { "  -  $($opt.Desc)" } else { "" }

            if ($i -eq $selectedIndex) {
                # Highlighted Item (Larger indicator)
                $prefix = "► [$numKey] "
                $line = "$spaces$prefix$label$desc"
                if ($line.Length -gt $width - 2) {
                    $line = $line.Substring(0, [math]::Max(10, $width - 5)) + "..."
                }
                Write-Host "$line" -ForegroundColor $theme.Highlight
            } else {
                # Normal Item
                $prefix = "  [$numKey] "
                $line = "$spaces$prefix$label$desc"
                if ($line.Length -gt $width - 2) {
                    $line = $line.Substring(0, [math]::Max(10, $width - 5)) + "..."
                }
                Write-Host "$line" -ForegroundColor $theme.Text
            }
        }

        # Footer instructions bar
        Write-Host ""
        $backLabel = if ($AllowExit) { "Exit" } else { "Back" }
        $footer = "▲/▼ / 1-$totalOptions Navigate  │  ENTER Select  │  Q/ESC $backLabel"
        $footerPad = [math]::Max(0, [int](($width - $footer.Length) / 2))
        Write-Host (" " * $footerPad + $footer) -ForegroundColor $theme.Muted

        # Real-time key listening & resize polling
        $keyInfo = $null
        $isRedirected = $false

        while ($true) {
            $curW = Get-WindowWidth
            $curH = Get-WindowHeight
            if ($curW -ne $lastWidth -or $curH -ne $lastHeight) {
                $lastWidth = $curW
                $lastHeight = $curH
                break
            }

            $keyAvail = Test-ConsoleKeyAvailable
            if ($null -eq $keyAvail) {
                $isRedirected = $true
                break
            }

            if ($keyAvail) {
                try {
                    $keyInfo = [Console]::ReadKey($true)
                } catch {
                    $isRedirected = $true
                }
                break
            }

            Start-Sleep -Milliseconds 40
        }

        # Redirected input fallback
        if ($isRedirected) {
            $typed = [Console]::In.ReadLine()
            if ($null -eq $typed -or $typed -eq 'q' -or $typed -eq 'exit') {
                return $null
            }
            if ($typed -match '^\d+$') {
                $idx = [int]$typed - 1
                if ($idx -ge 0 -and $idx -lt $totalOptions) {
                    return $Options[$idx]
                }
            }
            for ($k = 0; $k -lt $totalOptions; $k++) {
                $optKey = if ($Options[$k].Key) { $Options[$k].Key } else { ($k + 1).ToString() }
                if ($optKey -eq $typed.Trim()) {
                    return $Options[$k]
                }
            }
            continue
        }

        # If window resized, re-render immediately
        if ($null -eq $keyInfo) {
            continue
        }

        switch ($keyInfo.Key) {
            "UpArrow" {
                $selectedIndex--
                if ($selectedIndex -lt 0) { $selectedIndex = $totalOptions - 1 }
            }
            "DownArrow" {
                $selectedIndex++
                if ($selectedIndex -ge $totalOptions) { $selectedIndex = 0 }
            }
            "Enter" {
                return $Options[$selectedIndex]
            }
            "Escape" {
                return $null
            }
            "Q" {
                return $null
            }
            default {
                # Check if user pressed number key 1-9
                $char = $keyInfo.KeyChar.ToString()
                for ($k = 0; $k -lt $totalOptions; $k++) {
                    $optKey = if ($Options[$k].Key) { $Options[$k].Key } else { ($k + 1).ToString() }
                    if ($optKey -eq $char) {
                        return $Options[$k]
                    }
                }
            }
        }
    }
}

# Multi-Select Menu Engine with Real-Time Window Resize Responsiveness
function Show-MultiSelectMenu {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [array]$Items,
        [string]$Breadcrumb = ""
    )

    $theme = Get-ActiveTheme
    $selectedIndex = 0
    $totalItems = $Items.Count

    # Clone selection state
    $selectedMap = @{}
    for ($i = 0; $i -lt $totalItems; $i++) {
        $selectedMap[$i] = [bool]$Items[$i].Checked
    }

    $lastWidth = 0
    $lastHeight = 0

    while ($true) {
        $width = Get-WindowWidth
        $height = Get-WindowHeight
        $lastWidth = $width
        $lastHeight = $height

        Clear-Host
        Show-DevBanner -Breadcrumb $Breadcrumb

        # Prominent Title Header Box
        $boxTitle = "  $Title  "
        $borderLine = "═" * ($boxTitle.Length + 4)
        $topBorder = "╔$borderLine╗"
        $midBorder = "║  $boxTitle  ║"
        $botBorder = "╚$borderLine╝"

        $boxPad = [math]::Max(0, [int](($width - $topBorder.Length) / 2))
        $boxSpaces = " " * $boxPad

        Write-Host "$boxSpaces$topBorder" -ForegroundColor $theme.Secondary
        Write-Host "$boxSpaces$midBorder" -ForegroundColor $theme.Primary
        Write-Host "$boxSpaces$botBorder" -ForegroundColor $theme.Secondary
        Write-Host ""

        # Dynamic width calculation
        $maxItemLen = 0
        foreach ($item in $Items) {
            $cat = if ($item.Category) { " ($($item.Category))" } else { "" }
            $l = 12 + $item.Label.Length + $cat.Length
            if ($l -gt $maxItemLen) { $maxItemLen = $l }
        }

        $menuWidth = [math]::Min($width - 4, [math]::Max(40, $maxItemLen))
        $leftPad = [math]::Max(0, [int](($width - $menuWidth) / 2))
        $spaces = " " * $leftPad

        for ($i = 0; $i -lt $totalItems; $i++) {
            $item = $Items[$i]
            $isChecked = $selectedMap[$i]
            $box = if ($isChecked) { "[✔]" } else { "[ ]" }
            $label = $item.Label
            $cat = if ($item.Category) { " ($($item.Category))" } else { "" }

            $line = "$box $label$cat"
            if ($line.Length -gt $width - $leftPad - 2) {
                $line = $line.Substring(0, [math]::Max(10, $width - $leftPad - 5)) + "..."
            }

            if ($i -eq $selectedIndex) {
                Write-Host "$spaces► $line" -ForegroundColor $theme.Highlight
            } else {
                $color = if ($isChecked) { $theme.Success } else { $theme.Text }
                Write-Host "$spaces  $line" -ForegroundColor $color
            }
        }

        # Count selected
        $selectedCount = ($selectedMap.Values | Where-Object { $_ -eq $true }).Count

        Write-Host ""
        $countText = "Selected: $selectedCount of $totalItems packages"
        $countPad = [math]::Max(0, [int](($width - $countText.Length) / 2))
        Write-Host (" " * $countPad + $countText) -ForegroundColor $theme.Accent

        $footer = "SPACE Toggle  │  A Select All  │  N None  │  ENTER Execute  │  ESC/Q Back"
        $footerPad = [math]::Max(0, [int](($width - $footer.Length) / 2))
        Write-Host (" " * $footerPad + $footer) -ForegroundColor $theme.Muted

        # Real-time key listening & resize polling
        $keyInfo = $null
        $isRedirected = $false

        while ($true) {
            $curW = Get-WindowWidth
            $curH = Get-WindowHeight
            if ($curW -ne $lastWidth -or $curH -ne $lastHeight) {
                $lastWidth = $curW
                $lastHeight = $curH
                break
            }

            $keyAvail = Test-ConsoleKeyAvailable
            if ($null -eq $keyAvail) {
                $isRedirected = $true
                break
            }

            if ($keyAvail) {
                try {
                    $keyInfo = [Console]::ReadKey($true)
                } catch {
                    $isRedirected = $true
                }
                break
            }

            Start-Sleep -Milliseconds 40
        }

        if ($isRedirected) {
            return $null
        }

        if ($null -eq $keyInfo) {
            continue
        }

        switch ($keyInfo.Key) {
            "UpArrow" {
                $selectedIndex--
                if ($selectedIndex -lt 0) { $selectedIndex = $totalItems - 1 }
            }
            "DownArrow" {
                $selectedIndex++
                if ($selectedIndex -ge $totalItems) { $selectedIndex = 0 }
            }
            "Spacebar" {
                $selectedMap[$selectedIndex] = -not $selectedMap[$selectedIndex]
            }
            "A" {
                for ($j = 0; $j -lt $totalItems; $j++) { $selectedMap[$j] = $true }
            }
            "N" {
                for ($j = 0; $j -lt $totalItems; $j++) { $selectedMap[$j] = $false }
            }
            "Enter" {
                $result = @()
                for ($j = 0; $j -lt $totalItems; $j++) {
                    if ($selectedMap[$j]) {
                        $result += $Items[$j]
                    }
                }
                return $result
            }
            "Escape" {
                return $null
            }
            "Q" {
                return $null
            }
        }
    }
}


# ==================================================
# FILE: src\modules\legacy\LegacyTools.ps1
# ==================================================
# Legacy Utilities Module: IDM Reset, Windows & Office Activator, Microsoft Deployment Tool

function Show-LegacyToolsMenu {
    $options = @(
        @{
            Key = "1"
            Label = "IDM Trial Reset & Optimizer"
            Desc = "Reset trial and fix registry entries for IDM"
            Action = { Invoke-IDMReset }
        },
        @{
            Key = "2"
            Label = "Microsoft Activation Scripts (MAS)"
            Desc = "Official MAS for Windows & Office Activation"
            Action = { Invoke-WindowsActivator }
        },
        @{
            Key = "3"
            Label = "Office Deployment Tool (ODT)"
            Desc = "Download and configure Microsoft Office Deployment Tool"
            Action = { Invoke-OfficeDeploymentTool }
        },
        @{
            Key = "4"
            Label = "Office 365 / LTSC Quick Installer"
            Desc = "Generate XML config and install Office directly"
            Action = { Invoke-OfficeQuickInstaller }
        }
    )

    while ($true) {
        $selected = Show-InteractiveMenu -Title "Legacy & Activation Utilities" -Options $options -Breadcrumb "Main Menu > Legacy Tools"
        if ($null -eq $selected) { break }
        & $selected.Action
    }
}

function Invoke-IDMReset {
    Clear-Host
    Write-DevHeader -Title "IDM Trial Reset Utility" -Subtitle "Internet Download Manager Maintenance"

    if (-not (Invoke-RequireAdmin -Reason "IDM registry modifications require Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    $completed = Show-DevProgressBar -Activity "Preparing IDM Reset routine..." -Seconds 2
    if (-not $completed) { return }

    Invoke-CancellableAction -ActivityName "Running IDM Trial Reset..." -Action {
        Write-DevLog "Checking for running IDM processes..." "Info"
        Get-Process -Name "IDMan", "IEMonitor" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

        Write-DevLog "Cleaning IDM trial registry keys..." "Info"
        $keysToClean = @(
            "HKCU:\Software\DownloadManager",
            "HKCU:\Software\Tonec"
        )

        # Try fetching online community script if internet is available
        $onlineResetSuccess = $false
        try {
            Write-DevLog "Connecting to IDM reset repository..." "Info"
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            iex (irm is.gd/idm_reset)
            $onlineResetSuccess = $true
        }
        catch {
            Write-DevLog "Online repository unavailable or blocked. Applying native cleanup..." "Warning"

            # Native Registry Cleanup
            $regPaths = @(
                "HKCU:\Software\DownloadManager",
                "HKLM:\SOFTWARE\Classes\CLSID\{7B8E91E0-DA7A-4AE5-86F3-09D87E114AB4}"
            )
            foreach ($path in $regPaths) {
                if (Test-Path $path) {
                    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                    Write-DevLog "Cleaned $path" "Success"
                }
            }
        }
    } -SuccessMessage "IDM Reset procedure completed!" -ErrorMessage "Failed to run IDM Reset."

    Invoke-WaitPrompt
}

function Invoke-WindowsActivator {
    Clear-Host
    Write-DevHeader -Title "Microsoft Activation Scripts (MAS)" -Subtitle "Open-source Windows & Office Activator"

    if (-not (Invoke-RequireAdmin -Reason "Windows/Office Activation requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "This tool connects to the open-source Microsoft Activation Scripts (MAS) project." "Info"
    Write-DevLog "Supports HWID (Permanent Windows 10/11), Ohook (Office), and KMS38." "Muted"
    Write-Host ""

    $completed = Show-DevProgressBar -Activity "Connecting to MAS repository..." -Seconds 2
    if (-not $completed) { return }

    Invoke-CancellableAction -ActivityName "Launching MAS..." -Action {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        irm https://get.activated.win | iex
    } -SuccessMessage "MAS session finished." -ErrorMessage "Could not launch MAS."

    Invoke-WaitPrompt
}

function Invoke-OfficeDeploymentTool {
    Clear-Host
    Write-DevHeader -Title "Microsoft Office Deployment Tool" -Subtitle "Official Microsoft Deployment Suite"

    $url = "https://download.microsoft.com/download/6c1eeb25-cf8b-41d9-8d0d-cc1dbc032140/officedeploymenttool_19029-20136.exe"
    $downloadsFolder = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
    $destination = [System.IO.Path]::Combine($downloadsFolder, "officedeploymenttool.exe")

    Write-DevLog "Download location: $destination" "Info"
    Write-Host ""

    $success = Invoke-DevDownload -Url $url -DestinationPath $destination -Description "Downloading Office Deployment Tool..."

    if ($success) {
        Write-Host ""
        Write-DevLog "ODT executable is saved to: $destination" "Success"
        Write-DevLog "Do you want to extract ODT to $downloadsFolder\OfficeODT now? (Y/N or Q=Back)" "Highlight" -NoNewline
        $resp = Read-Host
        if ($resp -match "^[qQ]$") { return }
        if ($resp -match "^[yY]") {
            $extractDir = [System.IO.Path]::Combine($downloadsFolder, "OfficeODT")
            if (-not (Test-Path $extractDir)) {
                New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
            }
            Start-Process -FilePath $destination -ArgumentList "/extract:`"$extractDir`" /quiet" -Wait
            Write-DevLog "Extracted successfully to: $extractDir" "Success"
        }
    }

    Invoke-WaitPrompt
}

function Invoke-OfficeQuickInstaller {
    Clear-Host
    Write-DevHeader -Title "Office 365 / LTSC Deployment Configurator" -Subtitle "Generate XML configuration and install"

    if (-not (Invoke-RequireAdmin -Reason "Office installation requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    $officeDir = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads", "OfficeSetup")
    if (-not (Test-Path $officeDir)) {
        New-Item -ItemType Directory -Path $officeDir -Force | Out-Null
    }

    $setupExe = [System.IO.Path]::Combine($officeDir, "setup.exe")
    $odtUrl = "https://download.microsoft.com/download/6c1eeb25-cf8b-41d9-8d0d-cc1dbc032140/officedeploymenttool_19029-20136.exe"

    if (-not (Test-Path $setupExe)) {
        $tempODT = [System.IO.Path]::Combine($officeDir, "odt_temp.exe")
        Write-DevLog "Downloading official setup engine..." "Info"
        $dlOk = Invoke-DevDownload -Url $odtUrl -DestinationPath $tempODT -Description "Fetching Office Deployment Tool..."
        if ($dlOk) {
            Start-Process -FilePath $tempODT -ArgumentList "/extract:`"$officeDir`" /quiet" -Wait
            Remove-Item $tempODT -Force -ErrorAction SilentlyContinue
        }
    }

    # Configuration XML Generator
    $xmlContent = @'
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="ProPlus2024Volume">
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Bing" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Updates Enabled="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
'@

    $configPath = [System.IO.Path]::Combine($officeDir, "configuration.xml")
    Set-Content -Path $configPath -Value $xmlContent -Force

    Write-DevLog "Configuration file generated at: $configPath" "Success"
    Write-DevLog "Included Apps: Word, Excel, PowerPoint" "Muted"
    Write-Host ""
    Write-DevLog "Start Microsoft Office installation now? (Y/N or Q=Back)" "Highlight" -NoNewline
    $confirm = Read-Host

    if ($confirm -match "^[qQ]$") { return }
    if ($confirm -match "^[yY]") {
        Write-DevLog "Starting Office installer in background... Please wait for completion." "Info"
        Start-Process -FilePath $setupExe -ArgumentList "/configure `"$configPath`"" -Wait
        Write-DevLog "Office installation command finished!" "Success"
    }

    Invoke-WaitPrompt
}


# ==================================================
# FILE: src\modules\dev\DevTools.ps1
# ==================================================
# Developer Environment Setup & Package Management Module

function Show-DevToolsMenu {
    $options = @(
        @{
            Key = "1"
            Label = "Batch Install Dev Packages"
            Desc = "Interactive multi-select installer via Winget"
            Action = { Invoke-BatchDevInstaller }
        },
        @{
            Key = "2"
            Label = "Check Installed Dev Runtimes"
            Desc = "Scan system for Node, Python, Git, Docker, Go, .NET, Java"
            Action = { Invoke-CheckRuntimes }
        },
        @{
            Key = "3"
            Label = "Upgrade All Installed Packages"
            Desc = "Run winget upgrade --all to update software"
            Action = { Invoke-UpgradeAllPackages }
        },
        @{
            Key = "4"
            Label = "WSL2 (Windows Subsystem for Linux)"
            Desc = "Install / Enable WSL2 and Ubuntu"
            Action = { Invoke-WSLSetup }
        }
    )

    while ($true) {
        $selected = Show-InteractiveMenu -Title "Developer Environment Suite" -Options $options -Breadcrumb "Main Menu > Dev Suite"
        if ($null -eq $selected) { break }
        & $selected.Action
    }
}

function Get-DevPackageCatalog {
    return @(
        # Runtimes & Languages
        @{ Id = "OpenJS.NodeJS.LTS"; Label = "Node.js (LTS)"; Category = "Runtime"; Checked = $true },
        @{ Id = "Python.Python.3.12"; Label = "Python 3.12"; Category = "Runtime"; Checked = $true },
        @{ Id = "Microsoft.DotNet.SDK.8"; Label = ".NET 8 SDK"; Category = "Runtime"; Checked = $false },
        @{ Id = "GoLang.Go"; Label = "Go Language"; Category = "Runtime"; Checked = $false },
        @{ Id = "Rustlang.Rustup"; Label = "Rust (Rustup)"; Category = "Runtime"; Checked = $false },
        @{ Id = "Oracle.JDK.21"; Label = "Java OpenJDK 21"; Category = "Runtime"; Checked = $false },
        @{ Id = "Oven-sh.Bun"; Label = "Bun JavaScript Runtime"; Category = "Runtime"; Checked = $false },

        # Editors & IDEs
        @{ Id = "Microsoft.VisualStudioCode"; Label = "Visual Studio Code"; Category = "Editor"; Checked = $true },
        @{ Id = "Anysphere.Cursor"; Label = "Cursor AI Code Editor"; Category = "Editor"; Checked = $false },
        @{ Id = "Microsoft.VisualStudio.2022.Community"; Label = "Visual Studio 2022 Community"; Category = "IDE"; Checked = $false },
        @{ Id = "Neovim.Neovim"; Label = "Neovim"; Category = "Editor"; Checked = $false },
        @{ Id = "JetBrains.Toolbox"; Label = "JetBrains Toolbox"; Category = "IDE"; Checked = $false },

        # Shells & Version Control
        @{ Id = "Git.Git"; Label = "Git for Windows"; Category = "VCS"; Checked = $true },
        @{ Id = "Microsoft.PowerShell"; Label = "PowerShell 7 (pwsh)"; Category = "Shell"; Checked = $true },
        @{ Id = "Microsoft.WindowsTerminal"; Label = "Windows Terminal"; Category = "Terminal"; Checked = $true },
        @{ Id = "Starship.Starship"; Label = "Starship Cross-Shell Prompt"; Category = "Shell"; Checked = $false },
        @{ Id = "GitHub.cli"; Label = "GitHub CLI (gh)"; Category = "VCS"; Checked = $false },

        # Containers & API Tools
        @{ Id = "Docker.DockerDesktop"; Label = "Docker Desktop"; Category = "DevOps"; Checked = $false },
        @{ Id = "Postman.Postman"; Label = "Postman API Platform"; Category = "DevTools"; Checked = $false },
        @{ Id = "dbeaver.dbeaver"; Label = "DBeaver Community (SQL DB)"; Category = "Database"; Checked = $false },
        @{ Id = "MongoDB.Compass.Full"; Label = "MongoDB Compass"; Category = "Database"; Checked = $false },

        # Utilities
        @{ Id = "Microsoft.PowerToys"; Label = "Microsoft PowerToys"; Category = "Utility"; Checked = $true },
        @{ Id = "7zip.7zip"; Label = "7-Zip Compression"; Category = "Utility"; Checked = $true },
        @{ Id = "Google.Chrome"; Label = "Google Chrome"; Category = "Browser"; Checked = $false },
        @{ Id = "Brave.Brave"; Label = "Brave Browser"; Category = "Browser"; Checked = $false }
    )
}

function Invoke-BatchDevInstaller {
    Clear-Host
    if (-not (Test-WingetAvailable)) {
        Write-DevHeader -Title "Winget Not Detected"
        Write-DevLog "Windows Package Manager (winget) is required for batch installations." "Error"
        Write-DevLog "Please install App Installer from Microsoft Store or update Windows." "Warning"
        Invoke-WaitPrompt
        return
    }

    $catalog = Get-DevPackageCatalog
    $selectedPackages = Show-MultiSelectMenu -Title "Select Developer Tools to Install" -Items $catalog -Breadcrumb "Dev Suite > Batch Installer"

    if ($null -eq $selectedPackages -or $selectedPackages.Count -eq 0) {
        return
    }

    Clear-Host
    Write-DevHeader -Title "Installing Selected Packages" -Subtitle "Windows Package Manager (Winget)"

    $total = $selectedPackages.Count
    $current = 0

    foreach ($pkg in $selectedPackages) {
        $current++
        Write-DevLog "[$current/$total] Installing $($pkg.Label) ($($pkg.Id))..." "Highlight"

        try {
            $process = Start-Process -FilePath "winget" -ArgumentList "install --id $($pkg.Id) -e --accept-source-agreements --accept-package-agreements --silent" -NoNewWindow -PassThru -Wait
            if ($process.ExitCode -eq 0 -or $process.ExitCode -eq -1978335189) { # 0 or already installed
                Write-DevLog "Successfully processed $($pkg.Label)" "Success"
            } else {
                Write-DevLog "Winget exited with code $($process.ExitCode) for $($pkg.Label)" "Warning"
            }
        }
        catch {
            Write-DevLog "Failed to install $($pkg.Label): $($_.Exception.Message)" "Error"
        }
        Write-Host ""
    }

    Write-DevLog "Batch installation routine completed!" "Success"
    Invoke-WaitPrompt
}

function Invoke-CheckRuntimes {
    Clear-Host
    Write-DevHeader -Title "System Runtime Diagnostics" -Subtitle "Installed Developer Tools & Versions"

    $runtimes = @(
        @{ Name = "Git"; Cmd = "git --version" },
        @{ Name = "Node.js"; Cmd = "node --version" },
        @{ Name = "NPM"; Cmd = "npm --version" },
        @{ Name = "Python"; Cmd = "python --version" },
        @{ Name = ".NET SDK"; Cmd = "dotnet --version" },
        @{ Name = "Go"; Cmd = "go version" },
        @{ Name = "Rust (rustc)"; Cmd = "rustc --version" },
        @{ Name = "Java"; Cmd = "java -version" },
        @{ Name = "Docker"; Cmd = "docker --version" },
        @{ Name = "PowerShell 7"; Cmd = "pwsh --version" },
        @{ Name = "Winget"; Cmd = "winget --version" }
    )

    $theme = Get-ActiveTheme
    $width = Get-WindowWidth

    Write-Host ("{0,-20} {1,-35} {2,-15}" -f "TOOL", "STATUS / VERSION", "AVAILABILITY") -ForegroundColor $theme.Secondary
    Write-Host ("-" * [math]::Min($width - 4, 70)) -ForegroundColor $theme.Muted

    foreach ($rt in $runtimes) {
        try {
            $output = Invoke-Expression $rt.Cmd 2>&1 | Select-Object -First 1
            if ($output -and $LASTEXITCODE -eq 0 -or $output -match '\d') {
                $cleanOut = ($output -replace '\r|\n', '').Trim()
                if ($cleanOut.Length -gt 32) { $cleanOut = $cleanOut.Substring(0, 29) + "..." }
                Write-Host ("{0,-20} " -f $rt.Name) -NoNewline -ForegroundColor $theme.Text
                Write-Host ("{0,-35} " -f $cleanOut) -NoNewline -ForegroundColor $theme.Success
                Write-Host "[INSTALLED]" -ForegroundColor "Green"
            } else {
                Write-Host ("{0,-20} " -f $rt.Name) -NoNewline -ForegroundColor $theme.Text
                Write-Host ("{0,-35} " -f "Not found in PATH") -NoNewline -ForegroundColor $theme.Muted
                Write-Host "[MISSING]" -ForegroundColor "DarkGray"
            }
        }
        catch {
            Write-Host ("{0,-20} " -f $rt.Name) -NoNewline -ForegroundColor $theme.Text
            Write-Host ("{0,-35} " -f "Not installed") -NoNewline -ForegroundColor $theme.Muted
            Write-Host "[MISSING]" -ForegroundColor "DarkGray"
        }
    }

    Invoke-WaitPrompt
}

function Invoke-UpgradeAllPackages {
    Clear-Host
    Write-DevHeader -Title "Upgrade All Installed Packages" -Subtitle "Winget Global Updater"

    if (-not (Test-WingetAvailable)) {
        Write-DevLog "Winget is not available." "Error"
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "Checking for available package updates..." "Info"
    Start-Process -FilePath "winget" -ArgumentList "upgrade" -NoNewWindow -Wait

    Write-Host ""
    Write-DevLog "Proceed with upgrading all updatable packages? (Y/N or Q=Back)" "Highlight" -NoNewline
    $ans = Read-Host
    if ($ans -match "^[qQ]$") { return }
    if ($ans -match "^[yY]") {
        Start-Process -FilePath "winget" -ArgumentList "upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait
        Write-DevLog "Upgrade process finished!" "Success"
    }

    Invoke-WaitPrompt
}

function Invoke-WSLSetup {
    Clear-Host
    Write-DevHeader -Title "WSL2 (Windows Subsystem for Linux)" -Subtitle "Linux Environment on Windows"

    if (-not (Invoke-RequireAdmin -Reason "WSL installation requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "1. Install WSL & Ubuntu (Default)" "Text"
    Write-DevLog "2. Update WSL Kernel" "Text"
    Write-DevLog "3. List Installed WSL Distributions" "Text"
    Write-DevLog "Q. Return to Dev Tools Menu" "Muted"
    Write-Host ""
    Write-DevLog "Enter selection (1-3, Q=Back): " "Highlight" -NoNewline
    $wslChoice = Read-Host

    if ($wslChoice -eq "Q" -or $wslChoice -eq "q") {
        return
    }

    switch ($wslChoice) {
        "1" {
            Write-DevLog "Running wsl --install..." "Info"
            Start-Process -FilePath "wsl.exe" -ArgumentList "--install" -NoNewWindow -Wait
            Write-DevLog "WSL installation triggered. A system restart may be required." "Success"
        }
        "2" {
            Write-DevLog "Updating WSL kernel..." "Info"
            Start-Process -FilePath "wsl.exe" -ArgumentList "--update" -NoNewWindow -Wait
            Write-DevLog "WSL kernel updated." "Success"
        }
        "3" {
            Start-Process -FilePath "wsl.exe" -ArgumentList "--list --verbose" -NoNewWindow -Wait
        }
    }

    Invoke-WaitPrompt
}


# ==================================================
# FILE: src\modules\system\SystemTweaks.ps1
# ==================================================
# Windows System Optimization, Maintenance & Health Tweaks Module

function Show-SystemTweaksMenu {
    $options = @(
        @{
            Key = "1"
            Label = "Deep Junk & Temporary Files Cleanup"
            Desc = "Clean User/Win Temp, Prefetch, Crash Dumps, Recycle Bin"
            Action = { Invoke-DeepSystemCleanup }
        },
        @{
            Key = "2"
            Label = "System Health & File Integrity Repair"
            Desc = "Run DISM RestoreHealth and SFC /scannow repair"
            Action = { Invoke-SystemHealthRepair }
        },
        @{
            Key = "3"
            Label = "Windows Update Cache & Service Reset"
            Desc = "Reset SoftwareDistribution cache and update services"
            Action = { Invoke-ResetWindowsUpdate }
        },
        @{
            Key = "4"
            Label = "Power Plan & Performance Optimizer"
            Desc = "Unlock Ultimate Performance mode and optimize power settings"
            Action = { Invoke-PowerPlanOptimizer }
        },
        @{
            Key = "5"
            Label = "Privacy, Telemetry & Background Tweaks"
            Desc = "Disable telemetry tracking and bloat services safely"
            Action = { Invoke-PrivacyTelemetryTweaks }
        },
        @{
            Key = "6"
            Label = "Windows 11 Explorer & Taskbar Tweaks"
            Desc = "Classic Context Menu, End Task on Right Click, File Extensions"
            Action = { Invoke-Windows11Tweaks }
        }
    )

    while ($true) {
        $selected = Show-InteractiveMenu -Title "System Tweaks & Maintenance" -Options $options -Breadcrumb "Main Menu > System Maintenance"
        if ($null -eq $selected) { break }
        & $selected.Action
    }
}

function Invoke-DeepSystemCleanup {
    Clear-Host
    Write-DevHeader -Title "Deep Temporary Files & Junk Cleaner" -Subtitle "Reclaim storage space and remove stale caches"

    if (-not (Invoke-RequireAdmin -Reason "System cleanup requires Administrator privileges to access system temp folders.")) {
        Invoke-WaitPrompt
        return
    }

    $completed = Show-DevProgressBar -Activity "Scanning junk folders..." -Seconds 2
    if (-not $completed) { return }

    Invoke-CancellableAction -ActivityName "Cleaning temporary directories..." -Action {
        $cleanTargets = @(
            "$env:TEMP\*",
            "$env:SystemRoot\Temp\*",
            "$env:SystemRoot\Prefetch\*",
            "$env:LOCALAPPDATA\CrashDumps\*",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db"
        )

        $freedCount = 0
        foreach ($pattern in $cleanTargets) {
            Write-DevLog "Cleaning pattern: $pattern" "Info"
            try {
                $items = Get-ChildItem -Path $pattern -Force -Recurse -ErrorAction SilentlyContinue
                foreach ($item in $items) {
                    try {
                        Remove-Item -LiteralPath $item.FullName -Force -Recurse -ErrorAction SilentlyContinue
                        $freedCount++
                    } catch {}
                }
            } catch {}
        }

        # Clear Recycle Bin
        try {
            Write-DevLog "Emptying Recycle Bin..." "Info"
            Clear-RecycleBin -Force -ErrorAction SilentlyContinue
            Write-DevLog "Recycle bin emptied." "Success"
        } catch {}

        Write-DevLog "Purged $freedCount cached items and files." "Success"
    } -SuccessMessage "System junk cleanup finished successfully!" -ErrorMessage "Some files were locked by active processes."

    Invoke-WaitPrompt
}

function Invoke-SystemHealthRepair {
    Clear-Host
    Write-DevHeader -Title "Windows System Health & Integrity Repair" -Subtitle "DISM Component Store & SFC File Checker"

    if (-not (Invoke-RequireAdmin -Reason "DISM and SFC require Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "This process will verify and repair corrupted Windows system files." "Info"
    Write-DevLog "Phase 1: DISM /Online /Cleanup-Image /RestoreHealth" "Muted"
    Write-DevLog "Phase 2: SFC /scannow" "Muted"
    Write-Host ""

    Write-DevLog "Start System Integrity Repair? (Y/N or Q=Back)" "Highlight" -NoNewline
    $ans = Read-Host
    if ($ans -match "^[qQ]$") { return }
    if ($ans -notmatch "^[yY]") { return }

    Invoke-CancellableAction -ActivityName "Running DISM Component Cleanup & Repair..." -Action {
        Write-DevLog "Running DISM. This may take several minutes..." "Info"
        Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -NoNewWindow -Wait

        Write-DevLog "Running SFC System File Checker..." "Info"
        Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -NoNewWindow -Wait
    } -SuccessMessage "System health checks and repairs completed!" -ErrorMessage "System repair experienced errors."

    Invoke-WaitPrompt
}

function Invoke-ResetWindowsUpdate {
    Clear-Host
    Write-DevHeader -Title "Windows Update Reset & Cache Purge" -Subtitle "Fix stuck downloads and reset WU services"

    if (-not (Invoke-RequireAdmin -Reason "Managing Windows Update services requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Invoke-CancellableAction -ActivityName "Resetting Windows Update..." -Action {
        Write-DevLog "Stopping Windows Update services..." "Info"
        Stop-Service -Name "wuauserv", "bits", "cryptsvc", "msiserver" -Force -ErrorAction SilentlyContinue

        Write-DevLog "Clearing SoftwareDistribution and Catroot2 caches..." "Info"
        $wuPath = "$env:SystemRoot\SoftwareDistribution"
        $catPath = "$env:SystemRoot\System32\catroot2"

        if (Test-Path $wuPath) {
            Remove-Item -Path "$wuPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-DevLog "SoftwareDistribution cache cleared." "Success"
        }

        Write-DevLog "Restarting Windows Update services..." "Info"
        Start-Service -Name "cryptsvc", "bits", "wuauserv" -ErrorAction SilentlyContinue
    } -SuccessMessage "Windows Update reset completed!" -ErrorMessage "Failed to reset Windows Update."

    Invoke-WaitPrompt
}

function Invoke-PowerPlanOptimizer {
    Clear-Host
    Write-DevHeader -Title "Power Plan & Performance Optimizer" -Subtitle "Unlock Ultimate Performance Scheme"

    if (-not (Invoke-RequireAdmin -Reason "Power plan modifications require Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "1. Unlock & Enable Ultimate Performance Plan" "Text"
    Write-DevLog "2. Switch to High Performance Plan" "Text"
    Write-DevLog "3. Switch to Balanced Plan (Default)" "Text"
    Write-DevLog "4. List All Available Power Plans" "Text"
    Write-DevLog "Q. Return to System Menu" "Muted"
    Write-Host ""
    Write-DevLog "Enter selection (1-4, Q=Back): " "Highlight" -NoNewline
    $pChoice = Read-Host

    if ($pChoice -eq "Q" -or $pChoice -eq "q") {
        return
    }

    switch ($pChoice) {
        "1" {
            Write-DevLog "Enabling Ultimate Performance plan..." "Info"
            $out = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1
            if ($out -match "([a-f0-9\-]{36})") {
                $guid = $matches[1]
                powercfg -setactive $guid
                Write-DevLog "Ultimate Performance plan activated ($guid)!" "Success"
            } else {
                powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c # High perf fallback
                Write-DevLog "High performance scheme activated." "Success"
            }
        }
        "2" {
            powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
            Write-DevLog "High Performance plan activated." "Success"
        }
        "3" {
            powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
            Write-DevLog "Balanced plan activated." "Success"
        }
        "4" {
            powercfg /list
        }
    }

    Invoke-WaitPrompt
}

function Invoke-PrivacyTelemetryTweaks {
    Clear-Host
    Write-DevHeader -Title "Privacy & Telemetry Optimizer" -Subtitle "Disable Diagnostics Tracking & Background Bloat"

    if (-not (Invoke-RequireAdmin -Reason "Registry and Service tweaks require Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Write-DevLog "This will safely disable diagnostic telemetry services and tracking keys." "Info"
    Write-Host ""
    Write-DevLog "Apply privacy and telemetry tweaks? (Y/N or Q=Back)" "Highlight" -NoNewline
    $ans = Read-Host
    if ($ans -match "^[qQ]$") { return }
    if ($ans -notmatch "^[yY]") { return }

    Invoke-CancellableAction -ActivityName "Applying privacy tweaks..." -Action {
        # Disable Telemetry services
        $services = @("DiagTrack", "dmwappushservice")
        foreach ($srv in $services) {
            Write-DevLog "Disabling service $srv..." "Info"
            Stop-Service -Name $srv -Force -ErrorAction SilentlyContinue
            Set-Service -Name $srv -StartupType Disabled -ErrorAction SilentlyContinue
        }

        # Registry telemetry tweaks
        $regData = @(
            @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name = "AllowTelemetry"; Value = 0; Type = "DWord" },
            @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; Name = "Enabled"; Value = 0; Type = "DWord" },
            @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"; Name = "TailoredExperiencesWithDiagnosticDataEnabled"; Value = 0; Type = "DWord" }
        )

        foreach ($r in $regData) {
            if (-not (Test-Path $r.Path)) {
                New-Item -Path $r.Path -Force | Out-Null
            }
            Set-ItemProperty -Path $r.Path -Name $r.Name -Value $r.Value -Type $r.Type -Force -ErrorAction SilentlyContinue
        }

        Write-DevLog "Privacy and telemetry settings updated." "Success"
    } -SuccessMessage "Telemetry optimizations applied!" -ErrorMessage "Failed to update telemetry settings."

    Invoke-WaitPrompt
}

function Invoke-Windows11Tweaks {
    Clear-Host
    Write-DevHeader -Title "Windows 11 Explorer & UI Customizer" -Subtitle "Customize Context Menus, File Extensions and Taskbar"

    Write-DevLog "1. Restore Classic Right-Click Context Menu (Win 11)" "Text"
    Write-DevLog "2. Restore Modern Default Context Menu" "Text"
    Write-DevLog "3. Show File Name Extensions & Hidden Files" "Text"
    Write-DevLog "4. Enable 'End Task' in Taskbar Right-Click Menu" "Text"
    Write-DevLog "Q. Return to System Menu" "Muted"
    Write-Host ""
    Write-DevLog "Enter selection (1-4, Q=Back): " "Highlight" -NoNewline
    $choice = Read-Host

    if ($choice -eq "Q" -or $choice -eq "q") {
        return
    }

    switch ($choice) {
        "1" {
            # Classic context menu
            $regKey = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
            if (-not (Test-Path $regKey)) {
                New-Item -Path $regKey -Force | Out-Null
            }
            Set-ItemProperty -Path $regKey -Name "(Default)" -Value "" -Force
            Write-DevLog "Classic context menu enabled! Restarting Explorer..." "Success"
            Stop-Process -Name "explorer" -Force
        }
        "2" {
            # Default modern context menu
            $regKey = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
            if (Test-Path $regKey) {
                Remove-Item -Path $regKey -Recurse -Force
            }
            Write-DevLog "Modern context menu restored! Restarting Explorer..." "Success"
            Stop-Process -Name "explorer" -Force
        }
        "3" {
            # Show file extensions and hidden files
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force
            Write-DevLog "File extensions and hidden files are now visible!" "Success"
        }
        "4" {
            # End task on taskbar
            $taskbarKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
            if (-not (Test-Path $taskbarKey)) {
                New-Item -Path $taskbarKey -Force | Out-Null
            }
            Set-ItemProperty -Path $taskbarKey -Name "TaskbarEndTask" -Value 1 -Type DWord -Force
            Write-DevLog "'End Task' option added to taskbar right-click menu!" "Success"
        }
    }

    Invoke-WaitPrompt
}


# ==================================================
# FILE: src\modules\network\NetworkTools.ps1
# ==================================================
# Network Utilities, DNS Switcher & Diagnostics Module

function Show-NetworkToolsMenu {
    $options = @(
        @{
            Key = "1"
            Label = "Quick DNS Switcher (Cloudflare / Google / AdGuard)"
            Desc = "Change DNS servers for faster and secure browsing"
            Action = { Invoke-DNSSwitcher }
        },
        @{
            Key = "2"
            Label = "Flush DNS & Reset Winsock"
            Desc = "Fix connection issues, flush DNS cache, and reset stack"
            Action = { Invoke-FlushAndResetNetwork }
        },
        @{
            Key = "3"
            Label = "Network Latency & Speed Benchmark"
            Desc = "Ping test across Cloudflare, Google, GitHub, AWS"
            Action = { Invoke-PingLatencyTest }
        },
        @{
            Key = "4"
            Label = "View IP Configuration & Active Adapters"
            Desc = "Display Local IP, Public IP, Gateway, and Adapter details"
            Action = { Invoke-ShowNetworkInfo }
        }
    )

    while ($true) {
        $selected = Show-InteractiveMenu -Title "Network Utilities & DNS" -Options $options -Breadcrumb "Main Menu > Network"
        if ($null -eq $selected) { break }
        & $selected.Action
    }
}

function Invoke-DNSSwitcher {
    Clear-Host
    Write-DevHeader -Title "DNS Switcher Utility" -Subtitle "Optimize internet latency and security"

    if (-not (Invoke-RequireAdmin -Reason "Changing DNS servers requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    $dnsOptions = @(
        @{ Key = "1"; Name = "Cloudflare (1.1.1.1 / 1.0.0.1)"; Primary = "1.1.1.1"; Secondary = "1.0.0.1"; Desc = "Fastest general DNS" },
        @{ Key = "2"; Name = "Google Public (8.8.8.8 / 8.8.4.4)"; Primary = "8.8.8.8"; Secondary = "8.8.4.4"; Desc = "Highly reliable global DNS" },
        @{ Key = "3"; Name = "AdGuard DNS (94.140.14.14 / 94.140.15.15)"; Primary = "94.140.14.14"; Secondary = "94.140.15.15"; Desc = "Blocks ads & trackers system-wide" },
        @{ Key = "4"; Name = "Quad9 Secure (9.9.9.9 / 149.112.112.112)"; Primary = "9.9.9.9"; Secondary = "149.112.112.112"; Desc = "Blocks malicious domains & phishing" },
        @{ Key = "5"; Name = "Reset to Automatic (DHCP / Router Default)"; Primary = ""; Secondary = ""; Desc = "Restore original settings" },
        @{ Key = "Q"; Name = "Back to Network Menu"; Primary = ""; Secondary = ""; Desc = "Return without changes" }
    )

    Write-DevLog "Select DNS Profile:" "Highlight"
    foreach ($d in $dnsOptions) {
        Write-DevLog "  [$($d.Key)] $($d.Name) - $($d.Desc)" "Text"
    }
    Write-Host ""
    Write-DevLog "Enter choice (1-5, Q=Back): " "Highlight" -NoNewline
    $choice = Read-Host

    if ($choice -eq "Q" -or $choice -eq "q") { return }

    $chosen = $dnsOptions | Where-Object { $_.Key -eq $choice }
    if (-not $chosen) {
        Write-DevLog "Invalid selection." "Warning"
        Invoke-WaitPrompt
        return
    }

    # Find active network adapters
    $adapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" }
    if (-not $adapters) {
        $adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" }
    }

    if (-not $adapters) {
        Write-DevLog "No active network adapters found." "Error"
        Invoke-WaitPrompt
        return
    }

    foreach ($adapter in $adapters) {
        Write-DevLog "Configuring adapter '$($adapter.Name)' ($($adapter.InterfaceDescription))..." "Info"
        if ($chosen.Primary) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses @($chosen.Primary, $chosen.Secondary) -ErrorAction SilentlyContinue
            Write-DevLog "Set DNS to $($chosen.Primary), $($chosen.Secondary)" "Success"
        } else {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ResetServerAddresses -ErrorAction SilentlyContinue
            Write-DevLog "Reset DNS to DHCP default." "Success"
        }
    }

    # Flush DNS to apply immediately
    ipconfig /flushdns | Out-Null
    Write-DevLog "DNS cache flushed." "Success"

    Invoke-WaitPrompt
}

function Invoke-FlushAndResetNetwork {
    Clear-Host
    Write-DevHeader -Title "Network Reset & Cache Flush" -Subtitle "Fix connectivity issues and purge caches"

    if (-not (Invoke-RequireAdmin -Reason "Resetting network stacks requires Administrator privileges.")) {
        Invoke-WaitPrompt
        return
    }

    Invoke-CancellableAction -ActivityName "Flushing DNS and resetting IP stacks..." -Action {
        Write-DevLog "Flushing DNS Resolver cache..." "Info"
        ipconfig /flushdns

        Write-DevLog "Releasing and renewing DHCP lease..." "Info"
        ipconfig /release | Out-Null
        ipconfig /renew | Out-Null

        Write-DevLog "Resetting Winsock Catalog..." "Info"
        netsh winsock reset | Out-Null

        Write-DevLog "Resetting TCP/IP stack..." "Info"
        netsh int ip reset | Out-Null
    } -SuccessMessage "Network stack refreshed successfully! (A system reboot is recommended for Winsock changes)." -ErrorMessage "Network reset encountered an issue."

    Invoke-WaitPrompt
}

function Invoke-PingLatencyTest {
    Clear-Host
    Write-DevHeader -Title "Network Latency & Server Benchmark" -Subtitle "Measure ICMP ping response times"

    $targets = @(
        @{ Name = "Cloudflare (1.1.1.1)"; Host = "1.1.1.1" },
        @{ Name = "Google DNS (8.8.8.8)"; Host = "8.8.8.8" },
        @{ Name = "GitHub (github.com)"; Host = "github.com" },
        @{ Name = "Microsoft (microsoft.com)"; Host = "microsoft.com" },
        @{ Name = "Amazon AWS (aws.amazon.com)"; Host = "aws.amazon.com" }
    )

    $theme = Get-ActiveTheme
    $width = Get-WindowWidth

    Write-Host ("{0,-25} {1,-15} {2,-15}" -f "TARGET", "STATUS", "AVG LATENCY") -ForegroundColor $theme.Secondary
    Write-Host ("-" * [math]::Min($width - 4, 60)) -ForegroundColor $theme.Muted

    foreach ($t in $targets) {
        try {
            $ping = Test-Connection -ComputerName $t.Host -Count 3 -ErrorAction SilentlyContinue
            if ($ping) {
                $avg = [math]::Round(($ping | Measure-Object -Property ResponseTime -Average).Average)
                $color = if ($avg -lt 50) { "Green" } elseif ($avg -lt 120) { "Yellow" } else { "Red" }
                Write-Host ("{0,-25} " -f $t.Name) -NoNewline -ForegroundColor $theme.Text
                Write-Host ("{0,-15} " -f "[ONLINE]") -NoNewline -ForegroundColor "Green"
                Write-Host ("{0} ms" -f $avg) -ForegroundColor $color
            } else {
                Write-Host ("{0,-25} " -f $t.Name) -NoNewline -ForegroundColor $theme.Text
                Write-Host ("{0,-15} " -f "[TIMEOUT]") -NoNewline -ForegroundColor "Red"
                Write-Host "--" -ForegroundColor $theme.Muted
            }
        }
        catch {
            Write-Host ("{0,-25} " -f $t.Name) -NoNewline -ForegroundColor $theme.Text
            Write-Host ("{0,-15} " -f "[FAILED]") -NoNewline -ForegroundColor "Red"
            Write-Host "--" -ForegroundColor $theme.Muted
        }
    }

    Invoke-WaitPrompt
}

function Invoke-ShowNetworkInfo {
    Clear-Host
    Write-DevHeader -Title "Network Information & IP Details" -Subtitle "Local & Public network configuration"

    # Fetch public IP
    Write-DevLog "Querying Public IP Address..." "Info"
    try {
        $ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/json" -TimeoutSec 5 -ErrorAction Stop
        if ($ipInfo -and $ipInfo.ip) {
            Write-DevLog "Public IP:   $($ipInfo.ip)" "Highlight"
            if ($ipInfo.org) { Write-DevLog "ISP / Org:   $($ipInfo.org)" "Text" }
            if ($ipInfo.city) { Write-DevLog "City / Reg:  $($ipInfo.city), $($ipInfo.region), $($ipInfo.country)" "Text" }
            if ($ipInfo.timezone) { Write-DevLog "Timezone:    $($ipInfo.timezone)" "Muted" }
        } else {
            Write-DevLog "Could not retrieve public IP info." "Muted"
        }
    } catch {
        Write-DevLog "Public IP query timed out or offline." "Muted"
    }

    Write-Host ""
    Write-DevLog "Active Network Interfaces:" "Highlight"

    $adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" }
    if (-not $adapters) {
        $adapters = Get-NetAdapter -ErrorAction SilentlyContinue
    }

    foreach ($ad in $adapters) {
        $ips = Get-NetIPAddress -InterfaceIndex $ad.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty IPAddress
        $dns = (Get-DnsClientServerAddress -InterfaceIndex $ad.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).ServerAddresses -join ", "
        Write-DevLog "  Adapter:   $($ad.Name) ($($ad.InterfaceDescription))" "Primary"
        if ($ips) {
            Write-DevLog "  IPv4:      $($ips -join ', ')" "Text"
        }
        if ($ad.MacAddress) {
            Write-DevLog "  MAC:       $($ad.MacAddress)" "Muted"
        }
        if ($ad.LinkSpeed) {
            Write-DevLog "  Speed:     $($ad.LinkSpeed)" "Muted"
        }
        if ($dns) {
            Write-DevLog "  DNS:       $dns" "Muted"
        }
        Write-Host ""
    }

    Invoke-WaitPrompt
}


# ==================================================
# FILE: src\modules\customization\SettingsMenu.ps1
# ==================================================
# Customization & Settings Module for DevServices

function Show-SettingsMenu {
    $options = @(
        @{
            Key = "1"
            Label = "Console Font Size & Scaling"
            Desc = "Make text bigger/smaller (16pt, 18pt, 20pt, 24pt, 28pt)"
            Action = { Invoke-FontSizeSelector }
        },
        @{
            Key = "2"
            Label = "Console Font Family (JetBrains Mono / Cascadia)"
            Desc = "Switch active console typeface"
            Action = { Invoke-FontFamilySelector }
        },
        @{
            Key = "3"
            Label = "Install JetBrains Mono (Nerd Font)"
            Desc = "1-Click automated download & install JetBrains Mono font"
            Action = { Invoke-InstallJetBrainsMono }
        },
        @{
            Key = "4"
            Label = "Change Color Theme"
            Desc = "Rainbow, Cyberpunk, Azure, Matrix, or Sunset"
            Action = { Invoke-ThemeSelector }
        },
        @{
            Key = "5"
            Label = "Change ASCII Banner Style"
            Desc = "DevQii, Slant, Cyber, Minimal, or Default"
            Action = { Invoke-BannerSelector }
        },
        @{
            Key = "6"
            Label = "Toggle Splash Animations"
            Desc = "Enable or disable startup animation progress bars"
            Action = { Invoke-ToggleAnimations }
        },
        @{
            Key = "7"
            Label = "Toggle Fast Mode"
            Desc = "Skip confirmation pauses and animations"
            Action = { Invoke-ToggleFastMode }
        },
        @{
            Key = "8"
            Label = "About DevServices"
            Desc = "Version info, credits, repository and environment"
            Action = { Invoke-AboutDevServices }
        }
    )

    while ($true) {
        $selected = Show-InteractiveMenu -Title "Settings & Personalization" -Options $options -Breadcrumb "Settings"
        if ($null -eq $selected) { break }
        & $selected.Action
    }
}

function Invoke-FontSizeSelector {
    Clear-Host
    Write-DevHeader -Title "Console Font Size Scaling" -Subtitle "Current: $($global:DevServicesConfig.FontSize) pt"

    $sizeOpts = @(
        @{ Key = "1"; Label = "Standard (16 pt)"; Size = 16; Desc = "Default compact view" },
        @{ Key = "2"; Label = "Medium (18 pt)"; Size = 18; Desc = "Slightly larger, crisp" },
        @{ Key = "3"; Label = "Large (20 pt) [Recommended]"; Size = 20; Desc = "Big and clear readability" },
        @{ Key = "4"; Label = "Extra Large (24 pt)"; Size = 24; Desc = "Big bold presentation" },
        @{ Key = "5"; Label = "Huge (28 pt)"; Size = 28; Desc = "Maximum size visibility" }
    )

    $selected = Show-InteractiveMenu -Title "Select Font Size" -Options $sizeOpts -Breadcrumb "Settings > Font Size"
    if ($selected) {
        $global:DevServicesConfig.FontSize = $selected.Size
        Save-DevServicesConfig
        Set-ConsoleFont -FontName $global:DevServicesConfig.FontFamily -FontSize $global:DevServicesConfig.FontSize
        Write-DevLog "Font size set to $($selected.Size) pt!" "Success"
        Start-Sleep -Milliseconds 700
    }
}

function Invoke-FontFamilySelector {
    Clear-Host
    Write-DevHeader -Title "Console Font Family" -Subtitle "Current: $($global:DevServicesConfig.FontFamily)"

    $fontOpts = @(
        @{ Key = "1"; Label = "JetBrains Mono"; Font = "JetBrains Mono"; Desc = "Developer favorite monospace font" },
        @{ Key = "2"; Label = "JetBrainsMono Nerd Font"; Font = "JetBrainsMono Nerd Font"; Desc = "JetBrains Mono with developer icons" },
        @{ Key = "3"; Label = "Cascadia Code"; Font = "Cascadia Code"; Desc = "Modern Windows Terminal font" },
        @{ Key = "4"; Label = "Consolas"; Font = "Consolas"; Desc = "Classic Windows monospace font" },
        @{ Key = "5"; Label = "Lucida Console"; Font = "Lucida Console"; Desc = "Clean standard font" }
    )

    $selected = Show-InteractiveMenu -Title "Select Font Family" -Options $fontOpts -Breadcrumb "Settings > Font Family"
    if ($selected) {
        $global:DevServicesConfig.FontFamily = $selected.Font
        Save-DevServicesConfig
        Set-ConsoleFont -FontName $global:DevServicesConfig.FontFamily -FontSize $global:DevServicesConfig.FontSize
        Write-DevLog "Font family set to '$($selected.Font)'!" "Success"
        Start-Sleep -Milliseconds 700
    }
}

function Invoke-InstallJetBrainsMono {
    Clear-Host
    Write-DevHeader -Title "Install JetBrains Mono (Nerd Font)" -Subtitle "Automated Font Installer"

    Write-DevLog "This utility installs JetBrains Mono (including Nerd Font icon glyphs) to Windows." "Info"
    Write-Host ""
    Write-DevLog "Start JetBrains Mono installation? (Y/N or Q=Back)" "Highlight" -NoNewline
    $ans = Read-Host
    if ($ans -match "^[qQ]$") { return }
    if ($ans -notmatch "^[yY]") { return }

    # Method 1: Try winget if available
    $installed = $false
    if (Test-WingetAvailable) {
        Write-DevLog "Attempting installation via Windows Package Manager (Winget)..." "Info"
        try {
            $p = Start-Process -FilePath "winget" -ArgumentList "install --id DEVCOM.JetBrainsMonoNerdFont -e --accept-source-agreements --accept-package-agreements" -NoNewWindow -PassThru -Wait
            if ($p.ExitCode -eq 0 -or $p.ExitCode -eq -1978335189) {
                $installed = $true
            }
        } catch {}
    }

    # Method 2: Direct GitHub Release download & registration fallback
    if (-not $installed) {
        Write-DevLog "Fetching JetBrains Mono from GitHub Releases..." "Info"
        $zipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        $tempZip = Join-Path $env:TEMP "JetBrainsMono.zip"
        $tempExtract = Join-Path $env:TEMP "JetBrainsMono_Fonts"

        $dlOk = Invoke-DevDownload -Url $zipUrl -DestinationPath $tempZip -Description "Downloading JetBrains Mono Nerd Font Archive..."
        if ($dlOk) {
            Write-DevLog "Extracting font files..." "Info"
            if (-not (Test-Path $tempExtract)) { New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null }
            Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

            # Copy TTF files to Windows Fonts or User Fonts
            $fontFiles = Get-ChildItem -Path $tempExtract -Filter "*.ttf"
            $userFontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
            if (-not (Test-Path $userFontDir)) { New-Item -ItemType Directory -Path $userFontDir -Force | Out-Null }

            $count = 0
            foreach ($f in $fontFiles) {
                $dest = Join-Path $userFontDir $f.Name
                Copy-Item -Path $f.FullName -Destination $dest -Force -ErrorAction SilentlyContinue
                # Register in registry
                Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$($f.BaseName) (TrueType)" -Value $dest -Force -ErrorAction SilentlyContinue
                $count++
            }

            Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

            Write-DevLog "Successfully registered $count JetBrains Mono font files!" "Success"
            $installed = $true
        }
    }

    if ($installed) {
        $global:DevServicesConfig.FontFamily = "JetBrains Mono"
        $global:DevServicesConfig.FontSize = 20
        Save-DevServicesConfig
        Set-ConsoleFont -FontName "JetBrains Mono" -FontSize 20
        Write-DevLog "JetBrains Mono is installed and applied as active font!" "Success"
    } else {
        Write-DevLog "Could not complete automatic font installation." "Warning"
    }

    Invoke-WaitPrompt
}

function Invoke-ThemeSelector {
    Clear-Host
    Write-DevHeader -Title "Select Color Theme" -Subtitle "Current Theme: $($global:DevServicesConfig.Theme)"

    $themeKeys = @($global:Themes.Keys)
    $opts = @()
    for ($i = 0; $i -lt $themeKeys.Count; $i++) {
        $key = $themeKeys[$i]
        $themeObj = $global:Themes[$key]
        $opts += @{
            Key = ($i + 1).ToString()
            Label = "$key"
            Desc = $themeObj.Name
            ThemeKey = $key
        }
    }

    $selected = Show-InteractiveMenu -Title "Color Themes" -Options $opts -Breadcrumb "Settings > Theme"
    if ($selected) {
        $global:DevServicesConfig.Theme = $selected.ThemeKey
        Save-DevServicesConfig
        Write-DevLog "Theme changed to $($selected.Label)!" "Success"
        Start-Sleep -Milliseconds 700
    }
}

function Invoke-BannerSelector {
    Clear-Host
    Write-DevHeader -Title "Select ASCII Banner Style" -Subtitle "Current: $($global:DevServicesConfig.BannerStyle)"

    $bannerKeys = @($global:BannerStyles.Keys)
    $opts = @()
    for ($i = 0; $i -lt $bannerKeys.Count; $i++) {
        $key = $bannerKeys[$i]
        $opts += @{
            Key = ($i + 1).ToString()
            Label = "$key"
            Desc = "Preview banner style"
            BannerKey = $key
        }
    }

    $selected = Show-InteractiveMenu -Title "Banner Styles" -Options $opts -Breadcrumb "Settings > Banner"
    if ($selected) {
        $global:DevServicesConfig.BannerStyle = $selected.BannerKey
        Save-DevServicesConfig
        Write-DevLog "Banner style updated to $($selected.Label)!" "Success"
        Start-Sleep -Milliseconds 700
    }
}

function Invoke-ToggleAnimations {
    $global:DevServicesConfig.ShowAnimation = -not $global:DevServicesConfig.ShowAnimation
    Save-DevServicesConfig
    $state = if ($global:DevServicesConfig.ShowAnimation) { "ENABLED" } else { "DISABLED" }
    Write-DevLog "Splash and loading animations are now $state." "Success"
    Start-Sleep -Milliseconds 800
}

function Invoke-ToggleFastMode {
    $global:DevServicesConfig.FastMode = -not $global:DevServicesConfig.FastMode
    Save-DevServicesConfig
    $state = if ($global:DevServicesConfig.FastMode) { "ENABLED" } else { "DISABLED" }
    Write-DevLog "Fast mode is now $state." "Success"
    Start-Sleep -Milliseconds 800
}

function Invoke-AboutDevServices {
    Clear-Host
    Write-DevHeader -Title "About DevServices" -Subtitle "Windows Developer & Maintenance Suite"

    $theme = Get-ActiveTheme
    Write-DevLog "Application:   $($global:DevServicesConfig.AppName)" "Highlight"
    Write-DevLog "Version:       $($global:DevServicesConfig.Version)" "Text"
    Write-DevLog "Author:        $($global:DevServicesConfig.Author)" "Text"
    Write-DevLog "Font:          $($global:DevServicesConfig.FontFamily) ($($global:DevServicesConfig.FontSize)pt)" "Accent"
    Write-DevLog "OS Platform:   $([System.Environment]::OSVersion.VersionString)" "Text"
    Write-DevLog "PowerShell:    $($PSVersionTable.PSVersion)" "Text"
    Write-DevLog "Config Path:   $($global:DevServicesConfig.ConfigPath)" "Muted"
    Write-DevLog "Repository:    https://github.com/Devvfong/dev-services" "Primary"
    Write-Host ""
    Write-DevLog "Built with love for developers and power users." "Success"

    Invoke-WaitPrompt
}


# ==================================================
# MAIN EXECUTION LOGIC
# ==================================================
Load-DevServicesConfig
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

