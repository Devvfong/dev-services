# DevServices ⚡

> **Ultimate Windows Developer & System Maintenance Suite**  
> A modern, modular, interactive terminal utility designed for developers, power users, and system administrators.

```text
  _____                ____  _ _ 
 |  __ \              / __ \(_|_)
 | |  | | _____   __ | |  | |_ _ 
 | |  | |/ _ \ \ / / | |  | | | |
 | |__| |  __/\ V /  | |__| | | |
 |_____/ \___| \_/    \___\_\_|_|
    Ultimate Windows Developer & System Suite v2.0.0
```

---

## 🌟 Highlights & Features

### 1. 🛠️ Legacy & Activation Utilities
- **IDM Trial Reset & Optimizer**: Safely reset trial period and fix registry keys.
- **Microsoft Activation Scripts (MAS)**: Direct integration with official open-source MAS for Windows 10/11 & Office activation (HWID, KMS38, Ohook).
- **Microsoft Office Deployment Tool (ODT)**: Automated download, configuration generator, and quick installer for Office 365 ProPlus & LTSC 2024.

### 2. 💻 Developer Environment Setup
- **Batch Dev Package Installer**: Interactive multi-select installer powered by Windows Package Manager (`winget`).
  - *Runtimes*: Node.js (LTS), Python 3.12, .NET 8 SDK, Go, Rust (Rustup), Bun, Java OpenJDK 21.
  - *Editors & IDEs*: VS Code, Cursor, Visual Studio 2022 Community, Neovim, JetBrains Toolbox.
  - *Shells & Tools*: Git, Windows Terminal, PowerShell 7, GitHub CLI, Starship Prompt.
  - *Containers & DBs*: Docker Desktop, DBeaver, MongoDB Compass, Postman.
- **Runtime Diagnostics Scanner**: Scan installed tools and report versions across your system.
- **Global Package Updater**: Upgrade all installed applications via `winget upgrade --all`.
- **WSL2 Manager**: Install, update, and manage Ubuntu / WSL2 distributions.

### 3. 🧹 System Maintenance & Optimization
- **Deep Junk & Temp Cleaner**: Purge User Temp, Windows Temp, Prefetch, Thumbnails, and Crash Dumps.
- **System Health & Integrity Repair**: Automated `DISM /Online /Cleanup-Image /RestoreHealth` and `SFC /scannow`.
- **Windows Update Reset**: Purge corrupt `SoftwareDistribution` download cache and reset update services.
- **Power Plan Optimizer**: Unlock and activate the hidden **Ultimate Performance** power plan.
- **Privacy & Telemetry Optimizer**: Safely disable diagnostic telemetry services (`DiagTrack`) and background bloat.
- **Windows 11 Tweaks**: Restore Classic Context Menu, enable "End Task" on taskbar right-click, show file extensions.

### 4. 🌐 Network Utilities & DNS Switcher
- **1-Click DNS Switcher**:
  - Cloudflare (`1.1.1.1` / `1.0.0.1`)
  - Google Public DNS (`8.8.8.8` / `8.8.4.4`)
  - AdGuard Ad-Blocking DNS (`94.140.14.14` / `94.140.15.15`)
  - Quad9 Secure DNS (`9.9.9.9` / `149.112.112.112`)
  - Restore Automatic (DHCP)
- **Flush DNS & Reset Winsock**: Reset TCP/IP stack and renew DHCP leases.
- **Latency & Ping Benchmark**: Measure ping response times to Cloudflare, Google, GitHub, and AWS.
- **Network Interface Diagnostics**: View local IPv4, MAC address, gateway, and public IP / ISP details.

### 5. 🎨 Interactive TUI & Customization
- **Full Arrow-Key & Hotkey Navigation**: Use `↑` / `↓` keys, number keys `1-9`, `Space` for multi-selection, `Enter` to run, and `ESC`/`Q` to go back.
- **Themes**: Rainbow Vibrance, Cyberpunk Neon, Azure Modern, Matrix Terminal, Sunset Glow.
- **ASCII Art Banners**: DevQii, Slant, Cyber, Minimal, Default.
- **Ctrl+C / ESC Cancellation**: Gracefully interrupt long-running tasks without crashing.

---

## 🚀 Quick Start

### Method 1: Launch via Batch Wrapper (Recommended)
Simply double-click `DevServices.bat` in Windows Explorer (or Right-Click → **Run as Administrator**).

### Method 2: Launch via PowerShell
```powershell
# Open PowerShell in the project directory
powershell.exe -ExecutionPolicy Bypass -File .\DevServices.ps1
```

### CLI Options & Direct Automation
```powershell
# Launch directly into a specific module
.\DevServices.ps1 -Module dev
.\DevServices.ps1 -Module system
.\DevServices.ps1 -Module legacy
.\DevServices.ps1 -Module network
.\DevServices.ps1 -Module settings

# Fast mode (skips splash animations and pauses)
.\DevServices.ps1 -Fast

# Auto-elevate to Administrator
.\DevServices.ps1 -Admin
```

---

## 📦 Building Standalone Executable (EXE)

DevServices includes an automated build pipeline that bundles all modular scripts into a single self-contained script and compiles a standalone `.exe`.

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\build\build-exe.ps1
```

Output files will be generated in `dist/`:
- `dist\DevServices.exe` — Standalone native Windows executable.
- `dist\DevServices.standalone.ps1` — Single-file bundled PowerShell script.

---

## 📁 Project Architecture

```text
dev-services/
├── DevServices.ps1             # Main application entry point
├── DevServices.bat             # Explorer launcher wrapper
├── README.md                   # Project documentation
├── .gitignore                  # Git ignore definitions
├── build/
│   └── build-exe.ps1           # Bundler & standalone EXE compiler
└── src/
    ├── assets/
    │   └── banners.ps1         # ASCII art headers and banners
    ├── core/
    │   ├── Config.ps1          # Theme settings, app config, persistent state
    │   ├── UI.ps1              # Interactive menu engine, ANSI render, multi-select
    │   ├── Executor.ps1        # Process runner, Ctrl+C cancellation, Admin checks
    │   └── Logger.ps1          # Formatted logging, status indicators
    └── modules/
        ├── legacy/
        │   └── LegacyTools.ps1 # IDM Reset, MAS Activator, Office ODT
        ├── dev/
        │   └── DevTools.ps1    # Winget batch installer, runtime scanner, WSL2
        ├── system/
        │   └── SystemTweaks.ps1# Junk cleaner, DISM/SFC repair, Power plans, Win11 tweaks
        ├── network/
        │   └── NetworkTools.ps1# DNS switcher, Winsock/DNS flush, Ping benchmark
        └── customization/
            └── SettingsMenu.ps1# Theme & banner switcher, animations toggle
```

---

## ⌨️ Controls & Keybindings

| Key | Action |
|---|---|
| `↑` / `↓` | Navigate menu items |
| `1` - `9` | Instant item selection |
| `Enter` | Confirm / execute selected action |
| `Space` | Toggle checkbox (in multi-select installer) |
| `A` / `N` | Select All / Select None (multi-select mode) |
| `Ctrl + C` / `ESC` | Cancel current task or return to previous menu |
| `Q` | Exit / Back |

---

## 📜 License & Credits

- Developed by **Devvfong**.
- MAS integration powered by the [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts) community.
- Built for Windows 10 & Windows 11.
