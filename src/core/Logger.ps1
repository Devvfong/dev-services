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
