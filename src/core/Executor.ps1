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
