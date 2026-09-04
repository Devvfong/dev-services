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
