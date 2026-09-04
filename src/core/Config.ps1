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
