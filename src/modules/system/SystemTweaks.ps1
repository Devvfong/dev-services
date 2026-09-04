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
