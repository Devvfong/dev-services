export type Platform = 'win' | 'linux'

export interface Tool {
  id: string
  name: string
  desc: string
  platforms: Platform[]
  stable: string
  latest: string
  cmdWin?: string
  cmdLinux?: string
  note?: string
}

export interface Category {
  id: number
  title: string
  desc: string
  platforms: Platform[]
  tools: Tool[]
}

export const CATEGORIES: Category[] = [
  // -------------------------------------------------------------
  // [1] Legacy & Activation Utilities (Windows Only)
  // -------------------------------------------------------------
  {
    id: 1,
    title: 'Legacy & Activation Utilities',
    desc: 'IDM Reset, Microsoft Activation Scripts (MAS), Office ODT',
    platforms: ['win'],
    tools: [
      {
        id: 'mas',
        name: 'Microsoft Activation Scripts (MAS)',
        desc: 'Open-source Windows & Office activator using HWID / Ohook / KMS38 methods.',
        platforms: ['win'],
        stable: 'v2.6',
        latest: 'v2.8',
        cmdWin: 'irm https://get.activated.win | iex',
        note: 'Windows only',
      },
      {
        id: 'office-odt',
        name: 'Office Deployment Tool (ODT)',
        desc: 'Official Microsoft Office deployment & customized XML installer.',
        platforms: ['win'],
        stable: '16.0.17628',
        latest: '16.0.18025',
        cmdWin: 'setup.exe /configure configuration.xml',
        note: 'Windows only',
      },
      {
        id: 'idm-reset',
        name: 'IDM Trial Reset Utility',
        desc: 'Registry reset helper for Internet Download Manager trial period.',
        platforms: ['win'],
        stable: 'v1.4.2',
        latest: 'v1.4.5',
        cmdWin: 'DevServices -Run IDMReset',
        note: 'Windows only',
      },
    ],
  },

  // -------------------------------------------------------------
  // [2] Developer Environment Suite (Cross-platform)
  // -------------------------------------------------------------
  {
    id: 2,
    title: 'Developer Environment Suite',
    desc: 'Runtimes, compilers, package managers, and WSL2/container tools',
    platforms: ['win', 'linux'],
    tools: [
      {
        id: 'nodejs',
        name: 'Node.js',
        desc: 'JavaScript runtime built on Chrome\'s V8 engine with npm/pnpm support.',
        platforms: ['win', 'linux'],
        stable: 'v20.18.0 (LTS)',
        latest: 'v22.11.0 (Current)',
        cmdWin: 'winget install OpenJS.NodeJS.LTS',
        cmdLinux: 'curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs',
      },
      {
        id: 'python',
        name: 'Python',
        desc: 'Modern programming language for scripting, backend, data science & AI.',
        platforms: ['win', 'linux'],
        stable: 'v3.12.7',
        latest: 'v3.13.0',
        cmdWin: 'winget install Python.Python.3.12',
        cmdLinux: 'sudo apt update && sudo apt install -y python3 python3-pip python3-venv',
      },
      {
        id: 'git',
        name: 'Git',
        desc: 'Distributed version control system with credential manager.',
        platforms: ['win', 'linux'],
        stable: 'v2.46.2',
        latest: 'v2.47.0',
        cmdWin: 'winget install Git.Git',
        cmdLinux: 'sudo apt install -y git git-lfs',
      },
      {
        id: 'docker',
        name: 'Docker & Docker Compose',
        desc: 'Container platform for building, sharing, and running containerized apps.',
        platforms: ['win', 'linux'],
        stable: 'v27.3.1',
        latest: 'v27.3.1',
        cmdWin: 'winget install Docker.DockerDesktop',
        cmdLinux: 'curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $USER',
      },
      {
        id: 'vscode',
        name: 'Visual Studio Code',
        desc: 'Extensible code editor with built-in Git, debugging, and terminal support.',
        platforms: ['win', 'linux'],
        stable: 'v1.94.2',
        latest: 'v1.95.0',
        cmdWin: 'winget install Microsoft.VisualStudioCode',
        cmdLinux: 'sudo snap install --classic code',
      },
      {
        id: 'rust',
        name: 'Rust (rustup)',
        desc: 'Systems programming language that runs blazingly fast with memory safety.',
        platforms: ['win', 'linux'],
        stable: 'v1.81.0',
        latest: 'v1.82.0',
        cmdWin: 'winget install Rustlang.Rustup',
        cmdLinux: 'curl --proto \'=https\' --tlsv1.2 -sSf https://sh.rustup.rs | sh',
      },
      {
        id: 'golang',
        name: 'Go (Golang)',
        desc: 'Fast, reliable, and efficient open source programming language from Google.',
        platforms: ['win', 'linux'],
        stable: 'v1.23.2',
        latest: 'v1.23.2',
        cmdWin: 'winget install GoLang.Go',
        cmdLinux: 'sudo apt install -y golang-go',
      },
      {
        id: 'wsl2',
        name: 'WSL2 (Windows Subsystem for Linux)',
        desc: 'Run a full Ubuntu/Debian Linux kernel directly inside Windows.',
        platforms: ['win'],
        stable: 'v2.3.24',
        latest: 'v2.3.26',
        cmdWin: 'wsl --install -d Ubuntu-24.04',
        note: 'Windows only',
      },
    ],
  },

  // -------------------------------------------------------------
  // [3] System Maintenance & Tweaks (Cross-platform)
  // -------------------------------------------------------------
  {
    id: 3,
    title: 'System Maintenance & Tweaks',
    desc: 'Temp cleaner, journal purge, DISM/SFC health, power plans, and OS tweaks',
    platforms: ['win', 'linux'],
    tools: [
      {
        id: 'cleaner',
        name: 'Junk & Cache Deep Cleaner',
        desc: 'Purges user/system temp directories, crash dumps, and package caches.',
        platforms: ['win', 'linux'],
        stable: 'v2.0.0',
        latest: 'v2.1.0',
        cmdWin: 'DevServices -Module SystemTweaks -Action CleanTemp',
        cmdLinux: 'sudo apt autoremove -y && sudo apt clean && rm -rf ~/.cache/*',
      },
      {
        id: 'disk-health',
        name: 'System File & Disk Health Check',
        desc: 'Verifies OS integrity, repairs corrupted components (SFC/DISM or fsck).',
        platforms: ['win', 'linux'],
        stable: 'v2.0.0',
        latest: 'v2.0.0',
        cmdWin: 'sfc /scannow && dism /online /cleanup-image /restorehealth',
        cmdLinux: 'sudo journalctl --vacuum-time=3d && sudo dmesg -l err,warn',
      },
      {
        id: 'power-plan',
        name: 'Ultimate Performance Power Plan',
        desc: 'Unlocks ultimate performance power profiles and disables CPU throttling.',
        platforms: ['win', 'linux'],
        stable: 'v1.1',
        latest: 'v1.2',
        cmdWin: 'powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61',
        cmdLinux: 'sudo apt install -y tlp tlp-rdw && sudo tlp start',
      },
      {
        id: 'privacy-tweaks',
        name: 'OS Telemetry & Privacy Optimizer',
        desc: 'Disables diagnostic telemetry, Cortana, background trackers, and ads.',
        platforms: ['win', 'linux'],
        stable: 'v2.0.0',
        latest: 'v2.1.0',
        cmdWin: 'DevServices -Module SystemTweaks -Action Privacy',
        cmdLinux: 'sudo systemctl disable --now whoopsie.service apport.service',
      },
    ],
  },

  // -------------------------------------------------------------
  // [4] Network Utilities & DNS Switcher (Cross-platform)
  // -------------------------------------------------------------
  {
    id: 4,
    title: 'Network Utilities & DNS Switcher',
    desc: 'Cloudflare/Google/AdGuard DNS, ping benchmark, flush resolver & diagnostics',
    platforms: ['win', 'linux'],
    tools: [
      {
        id: 'dns-cloudflare',
        name: 'Cloudflare DNS (1.1.1.1 & 1.0.0.1)',
        desc: 'Fast, privacy-first secure DNS resolver with DNS-over-HTTPS support.',
        platforms: ['win', 'linux'],
        stable: 'v1.1.1.1',
        latest: 'v1.1.1.1',
        cmdWin: 'netsh interface ip set dns "Wi-Fi" static 1.1.1.1',
        cmdLinux: 'sudo resolvectl dns $(ip route show default | awk \'{print $5}\') 1.1.1.1 1.0.0.1',
      },
      {
        id: 'dns-adguard',
        name: 'AdGuard Ad-Blocking DNS',
        desc: 'Blocks ads, tracking scripts, and phishing domains at the DNS level.',
        platforms: ['win', 'linux'],
        stable: 'v94.140.14.14',
        latest: 'v94.140.14.14',
        cmdWin: 'netsh interface ip set dns "Wi-Fi" static 94.140.14.14',
        cmdLinux: 'sudo resolvectl dns $(ip route show default | awk \'{print $5}\') 94.140.14.14 94.140.15.15',
      },
      {
        id: 'dns-flush',
        name: 'Network & DNS Resolver Flush',
        desc: 'Flushes DNS resolver cache, resets Winsock/systemd-resolved stack.',
        platforms: ['win', 'linux'],
        stable: 'v2.0.0',
        latest: 'v2.0.0',
        cmdWin: 'ipconfig /flushdns && netsh winsock reset',
        cmdLinux: 'sudo resolvectl flush-caches && sudo systemctl restart systemd-resolved',
      },
      {
        id: 'speedtest-cli',
        name: 'Speedtest CLI & Latency Benchmark',
        desc: 'Command-line internet speed and ping benchmark utility by Ookla.',
        platforms: ['win', 'linux'],
        stable: 'v1.2.0',
        latest: 'v1.2.0',
        cmdWin: 'winget install Ookla.Speedtest.CLI',
        cmdLinux: 'sudo apt install -y speedtest-cli',
      },
    ],
  },

  // -------------------------------------------------------------
  // [5] Settings & Personalization (Cross-platform)
  // -------------------------------------------------------------
  {
    id: 5,
    title: 'Settings & Personalization',
    desc: 'Change themes, ASCII banners, fonts, shell prompt, and terminal profiles',
    platforms: ['win', 'linux'],
    tools: [
      {
        id: 'jetbrains-mono',
        name: 'JetBrains Mono Font',
        desc: 'Free and open-source font designed specifically for developers.',
        platforms: ['win', 'linux'],
        stable: 'v2.304',
        latest: 'v2.304',
        cmdWin: 'winget install JetBrains.JetBrainsMono',
        cmdLinux: 'sudo apt install -y fonts-jetbrains-mono',
      },
      {
        id: 'oh-my-posh',
        name: 'Oh My Posh / Starship Prompt',
        desc: 'Fast, highly customizable prompt engine for PowerShell, bash, and zsh.',
        platforms: ['win', 'linux'],
        stable: 'v24.5.1',
        latest: 'v24.6.0',
        cmdWin: 'winget install JanDeDobbeleer.OhMyPosh',
        cmdLinux: 'curl -sS https://starship.rs/install.sh | sh',
      },
      {
        id: 'fastfetch',
        name: 'Fastfetch / Neofetch System Info',
        desc: 'Blazingly fast system info and ASCII hardware badge generator.',
        platforms: ['win', 'linux'],
        stable: 'v2.26.1',
        latest: 'v2.27.0',
        cmdWin: 'winget install Fastfetch-cli.Fastfetch',
        cmdLinux: 'sudo apt install -y fastfetch',
      },
    ],
  },

  // -------------------------------------------------------------
  // [6] Linux: Package Management & Updates (Ubuntu / Debian)
  // -------------------------------------------------------------
  {
    id: 6,
    title: 'Linux Package Management & Updates',
    desc: 'Modern CLI package managers, Flatpak, Snap, and unattended upgrade utilities',
    platforms: ['linux'],
    tools: [
      {
        id: 'nala',
        name: 'Nala (Frontend for APT)',
        desc: 'Beautiful front-end for libapt-pkg with parallel downloads and rich formatting.',
        platforms: ['linux'],
        stable: 'v0.15.1',
        latest: 'v0.15.3',
        cmdLinux: 'sudo apt install -y nala',
      },
      {
        id: 'flatpak',
        name: 'Flatpak & Flathub App Store',
        desc: 'Universal sandbox packaging format to run any app on any Linux distribution.',
        platforms: ['linux'],
        stable: 'v1.14.10',
        latest: 'v1.15.10',
        cmdLinux: 'sudo apt install -y flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo',
      },
      {
        id: 'snapd',
        name: 'Snapd Package Manager',
        desc: 'Canonical containerized software deployment and package management system.',
        platforms: ['linux'],
        stable: 'v2.63',
        latest: 'v2.65',
        cmdLinux: 'sudo apt install -y snapd',
      },
      {
        id: 'ubuntu-drivers',
        name: 'Ubuntu Drivers Autoinstaller',
        desc: 'Detects and installs proprietary hardware drivers (NVIDIA GPU, Wi-Fi).',
        platforms: ['linux'],
        stable: 'v0.9.7',
        latest: 'v0.9.7',
        cmdLinux: 'sudo ubuntu-drivers install',
      },
    ],
  },

  // -------------------------------------------------------------
  // [7] Linux: Shell, CLI & Productivity Tools
  // -------------------------------------------------------------
  {
    id: 7,
    title: 'Linux CLI & Terminal Utilities',
    desc: 'Modern replacements for ls, cat, top, find, and terminal multiplexers',
    platforms: ['linux'],
    tools: [
      {
        id: 'zsh-ohmyzsh',
        name: 'Zsh & Oh My Zsh',
        desc: 'Community-driven framework for managing your zsh configuration with themes & plugins.',
        platforms: ['linux'],
        stable: 'v5.9',
        latest: 'v5.9',
        cmdLinux: 'sudo apt install -y zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"',
      },
      {
        id: 'btop',
        name: 'btop++ Resource Monitor',
        desc: 'Modern, interactive terminal task manager for CPU, memory, disks and network.',
        platforms: ['linux'],
        stable: 'v1.3.2',
        latest: 'v1.4.0',
        cmdLinux: 'sudo apt install -y btop',
      },
      {
        id: 'eza',
        name: 'eza (Modern ls replacement)',
        desc: 'A modern, maintained replacement for ls with colors, git status, and tree views.',
        platforms: ['linux'],
        stable: 'v0.19.4',
        latest: 'v0.20.0',
        cmdLinux: 'sudo apt install -y eza',
      },
      {
        id: 'bat',
        name: 'bat (cat with syntax highlight)',
        desc: 'A cat clone with syntax highlighting, Git integration, and line numbers.',
        platforms: ['linux'],
        stable: 'v0.24.0',
        latest: 'v0.24.0',
        cmdLinux: 'sudo apt install -y bat',
      },
      {
        id: 'ripgrep',
        name: 'ripgrep (rg)',
        desc: 'Line-oriented search tool that recursively searches directories ultra fast.',
        platforms: ['linux'],
        stable: 'v14.1.0',
        latest: 'v14.1.1',
        cmdLinux: 'sudo apt install -y ripgrep',
      },
      {
        id: 'tmux',
        name: 'tmux Terminal Multiplexer',
        desc: 'Workspace manager that lets you switch easily between several programs in one terminal.',
        platforms: ['linux'],
        stable: 'v3.4',
        latest: 'v3.5',
        cmdLinux: 'sudo apt install -y tmux',
      },
    ],
  },

  // -------------------------------------------------------------
  // [8] Media & Content Creation Tools (Cross-platform)
  // -------------------------------------------------------------
  {
    id: 8,
    title: 'Media & Content Creation Tools',
    desc: 'Video playback, recording, graphic design, audio and 3D modeling tools',
    platforms: ['win', 'linux'],
    tools: [
      {
        id: 'vlc',
        name: 'VLC Media Player',
        desc: 'Free and open-source cross-platform multimedia player for almost all codecs.',
        platforms: ['win', 'linux'],
        stable: 'v3.0.21',
        latest: 'v3.0.21',
        cmdWin: 'winget install VideoLAN.VLC',
        cmdLinux: 'sudo apt install -y vlc',
      },
      {
        id: 'obs-studio',
        name: 'OBS Studio',
        desc: 'Open-source software for video recording and live streaming.',
        platforms: ['win', 'linux'],
        stable: 'v30.2.3',
        latest: 'v31.0.0-rc1',
        cmdWin: 'winget install OBSProject.OBSStudio',
        cmdLinux: 'sudo apt install -y obs-studio',
      },
      {
        id: 'gimp',
        name: 'GIMP Image Editor',
        desc: 'Free & open-source raster graphics editor for photo retouching & composition.',
        platforms: ['win', 'linux'],
        stable: 'v2.10.38',
        latest: 'v3.0.0-RC1',
        cmdWin: 'winget install GIMP.GIMP',
        cmdLinux: 'sudo apt install -y gimp',
      },
      {
        id: 'blender',
        name: 'Blender 3D Suite',
        desc: 'Open source 3D creation pipeline supporting modeling, animation, rendering.',
        platforms: ['win', 'linux'],
        stable: 'v4.2.3 (LTS)',
        latest: 'v4.3.0',
        cmdWin: 'winget install BlenderFoundation.Blender',
        cmdLinux: 'sudo snap install blender --classic',
      },
    ],
  },

  // -------------------------------------------------------------
  // [9] Backup, Security & Recovery (Linux & Ubuntu)
  // -------------------------------------------------------------
  {
    id: 9,
    title: 'Linux Backup, Security & Firewall',
    desc: 'System restore points, incremental snapshots, and ufw firewall rules',
    platforms: ['linux'],
    tools: [
      {
        id: 'timeshift',
        name: 'Timeshift System Restore',
        desc: 'Creates incremental filesystem snapshots (RSYNC or BTRFS) for instant rollbacks.',
        platforms: ['linux'],
        stable: 'v24.06.2',
        latest: 'v24.06.2',
        cmdLinux: 'sudo apt install -y timeshift',
      },
      {
        id: 'ufw',
        name: 'UFW (Uncomplicated Firewall)',
        desc: 'Easy-to-use host-based firewall manager with simple CLI rules.',
        platforms: ['linux'],
        stable: 'v0.36.2',
        latest: 'v0.36.2',
        cmdLinux: 'sudo apt install -y ufw && sudo ufw default deny incoming && sudo ufw enable',
      },
      {
        id: 'restic',
        name: 'Restic Encrypted Backup',
        desc: 'Secure, deduplicated and encrypted backup program for cloud & local storage.',
        platforms: ['linux', 'win'],
        stable: 'v0.17.1',
        latest: 'v0.17.1',
        cmdWin: 'winget install restic.restic',
        cmdLinux: 'sudo apt install -y restic',
      },
    ],
  },
]
