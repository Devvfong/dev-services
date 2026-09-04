# DevServices Remote Installer
# Usage: iex (irm https://raw.githubusercontent.com/Devvfong/dev-services/master/install.ps1)

$ErrorActionPreference = "Stop"

Write-Host "Downloading DevServices..." -ForegroundColor Cyan

$tempDir = Join-Path $env:TEMP "DevServices_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

$baseUrl = "https://raw.githubusercontent.com/Devvfong/dev-services/master"
$files = @(
    "DevServices.ps1",
    "src/assets/banners.ps1",
    "src/core/Config.ps1",
    "src/core/Logger.ps1",
    "src/core/Executor.ps1",
    "src/core/UI.ps1",
    "src/modules/legacy/LegacyTools.ps1",
    "src/modules/dev/DevTools.ps1",
    "src/modules/system/SystemTweaks.ps1",
    "src/modules/network/NetworkTools.ps1",
    "src/modules/customization/SettingsMenu.ps1"
)

foreach ($file in $files) {
    $url = "$baseUrl/$file"
    $dest = Join-Path $tempDir $file
    $destDir = Split-Path $dest -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
}

Set-Location $tempDir
& "$tempDir\DevServices.ps1"

# Cleanup
Set-Location $env:TEMP
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
