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
