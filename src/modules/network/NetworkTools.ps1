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
