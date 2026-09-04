<#
.SYNOPSIS
    Build & Packaging Script for DevServices
.DESCRIPTION
    1. Bundles all modular files into a single self-contained script (dist/DevServices.standalone.ps1)
    2. Compiles the bundled script into a standalone Windows executable (dist/DevServices.exe)
#>

[CmdletBinding()]
param(
    [switch]$NoExe,
    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if (-not $ScriptDir) { $ScriptDir = $PSScriptRoot }
if (-not $ScriptDir) { $ScriptDir = "$((Get-Location).Path)\build" }

$RootDir = (Resolve-Path "$ScriptDir\..").Path

if (-not $OutputDir) {
    $OutputDir = Join-Path $RootDir "dist"
} else {
    $OutputDir = [System.IO.Path]::GetFullPath($OutputDir)
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "      DevServices Build & Packaging Pipeline      " -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Source Directory: $RootDir" -ForegroundColor White
Write-Host "[*] Output Directory: $OutputDir" -ForegroundColor White
Write-Host ""

# 1. Bundling all modules into a single standalone script
Write-Host "[1/3] Bundling modular scripts into standalone distribution..." -ForegroundColor Cyan

$bundleOrder = @(
    "src\assets\banners.ps1",
    "src\core\Config.ps1",
    "src\core\Logger.ps1",
    "src\core\Executor.ps1",
    "src\core\UI.ps1",
    "src\modules\legacy\LegacyTools.ps1",
    "src\modules\dev\DevTools.ps1",
    "src\modules\system\SystemTweaks.ps1",
    "src\modules\network\NetworkTools.ps1",
    "src\modules\customization\SettingsMenu.ps1"
)

$bundleContent = New-Object System.Text.StringBuilder
[void]$bundleContent.AppendLine("<#")
[void]$bundleContent.AppendLine("    DevServices Standalone Single-File Bundle")
[void]$bundleContent.AppendLine("    Built: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$bundleContent.AppendLine("#>")
[void]$bundleContent.AppendLine('$ErrorActionPreference = "Stop"')
[void]$bundleContent.AppendLine("")

foreach ($relFile in $bundleOrder) {
    $srcPath = Join-Path $RootDir $relFile
    if (Test-Path $srcPath) {
        Write-Host "  + Appending $relFile" -ForegroundColor DarkGray
        [void]$bundleContent.AppendLine("# ==================================================")
        [void]$bundleContent.AppendLine("# FILE: $relFile")
        [void]$bundleContent.AppendLine("# ==================================================")
        $fileText = Get-Content -Path $srcPath -Raw
        [void]$bundleContent.AppendLine($fileText)
        [void]$bundleContent.AppendLine("")
    } else {
        Write-Warning "File not found: $srcPath"
    }
}

# Append the Main App Logic from DevServices.ps1 (excluding module loader)
$mainScript = Get-Content -Path (Join-Path $RootDir "DevServices.ps1") -Raw
# Extract Start-DevServices function and main runner
$mainLogic = $mainScript.Substring($mainScript.IndexOf("function Start-DevServices"))
[void]$bundleContent.AppendLine("# ==================================================")
[void]$bundleContent.AppendLine("# MAIN EXECUTION LOGIC")
[void]$bundleContent.AppendLine("# ==================================================")
[void]$bundleContent.AppendLine("Load-DevServicesConfig")
[void]$bundleContent.AppendLine($mainLogic)

$standaloneScriptPath = Join-Path $OutputDir "DevServices.standalone.ps1"
Set-Content -Path $standaloneScriptPath -Value $bundleContent.ToString() -Encoding UTF8
Write-Host "[+] Standalone script created: $standaloneScriptPath" -ForegroundColor Green

if ($NoExe) {
    Write-Host "[*] Skipping EXE generation (-NoExe specified)." -ForegroundColor Yellow
    Exit 0
}

# 2. Compiling standalone EXE
Write-Host ""
Write-Host "[2/3] Compiling standalone Windows Executable (DevServices.exe)..." -ForegroundColor Cyan

$targetExePath = Join-Path $OutputDir "DevServices.exe"

# Method A: Try ps2exe if available or install it
$usePs2exe = $false
try {
    if (Get-Command "Invoke-PS2EXE" -ErrorAction SilentlyContinue) {
        $usePs2exe = $true
    } elseif (Get-Module -ListAvailable -Name "ps2exe") {
        Import-Module ps2exe -ErrorAction SilentlyContinue
        $usePs2exe = $true
    }
} catch {}

if ($usePs2exe) {
    Write-Host "  -> Using PS2EXE compiler..." -ForegroundColor Cyan
    Invoke-PS2EXE -InputFile $standaloneScriptPath -OutputFile $targetExePath -Title "DevServices" -Description "Ultimate Windows Developer & System Suite" -Company "Devvfong" -Product "DevServices" -Copyright "2026 Devvfong" -Version "2.0.0.0" -NoConsole:$false -RequireAdmin:$false
    Write-Host "[+] DevServices.exe generated via PS2EXE!" -ForegroundColor Green
} else {
    # Method B: Native C# .NET Windows Host Compiler via Roslyn / Add-Type / Csc with Embedded Resource
    Write-Host "  -> Compiling native C# .NET Console host wrapper..." -ForegroundColor Cyan

    $csharpSource = @'
using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;

namespace DevServices
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Extract embedded script resource
                Assembly asm = Assembly.GetExecutingAssembly();
                string script = "";
                using (Stream stream = asm.GetManifestResourceStream("DevServices.script"))
                {
                    if (stream == null)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine("Error: Embedded script resource not found.");
                        Console.ResetColor();
                        Console.ReadLine();
                        return;
                    }
                    using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
                    {
                        script = reader.ReadToEnd();
                    }
                }

                // Write to temp file and execute
                string tempScriptPath = Path.Combine(Path.GetTempPath(), "DevServices_" + Guid.NewGuid().ToString("N") + ".ps1");
                File.WriteAllText(tempScriptPath, script, new UTF8Encoding(true));

                ProcessStartInfo psi = new ProcessStartInfo();
                psi.FileName = "powershell.exe";
                psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + tempScriptPath + "\"";
                psi.UseShellExecute = false;

                Process p = Process.Start(psi);
                p.WaitForExit();

                try
                {
                    if (File.Exists(tempScriptPath))
                    {
                        File.Delete(tempScriptPath);
                    }
                }
                catch {}

                Environment.Exit(p.ExitCode);
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Error launching DevServices: " + ex.Message);
                Console.ResetColor();
                Console.ReadLine();
            }
        }
    }
}
'@

    # Find csc.exe in .NET Framework
    $cscPaths = @(
        "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\csc.exe",
        "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\csc.exe"
    )
    $csc = $cscPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($csc) {
        $tempCsFile = Join-Path $OutputDir "Host.cs"
        Set-Content -Path $tempCsFile -Value $csharpSource -Encoding UTF8

        # Compile with embedded resource
        $compileOutput = & $csc /target:exe /out:"$targetExePath" /optimize+ "/resource:$standaloneScriptPath,DevServices.script" "$tempCsFile" 2>&1
        Remove-Item $tempCsFile -Force -ErrorAction SilentlyContinue

        if (Test-Path $targetExePath) {
            $exeInfo = Get-Item $targetExePath
            if ($exeInfo.Length -gt 0) {
                Write-Host "[+] Native Executable compiled successfully at: $targetExePath" -ForegroundColor Green
            } else {
                Write-Host "[!] C# compilation produced 0-byte file." -ForegroundColor Red
                $compileOutput | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkRed }
            }
        } else {
            Write-Host "[!] C# compilation failed. Compiler output:" -ForegroundColor Red
            $compileOutput | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkRed }
        }
    } else {
        Write-Host "  -> csc.exe not found, creating portable CMD wrapper binary." -ForegroundColor Yellow
        $batWrapper = "@echo off`r`npowershell -NoProfile -ExecutionPolicy Bypass -File `"%~dp0DevServices.standalone.ps1`""
        Set-Content -Path (Join-Path $OutputDir "DevServices.cmd") -Value $batWrapper
    }
}

Write-Host ""
Write-Host "[3/3] Build completed successfully!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Artifacts created in $OutputDir :" -ForegroundColor White
Get-ChildItem -Path $OutputDir | ForEach-Object {
    $sizeKb = [math]::Round($_.Length / 1KB, 1)
    Write-Host "  - $($_.Name) ($sizeKb KB)" -ForegroundColor Yellow
}
Write-Host "==================================================" -ForegroundColor Cyan
