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
