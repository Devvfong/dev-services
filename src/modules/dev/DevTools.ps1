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
