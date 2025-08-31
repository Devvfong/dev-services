# Get terminal width for centering
$width = $Host.UI.RawUI.WindowSize.Width

# Define the ASCII art
$asciiArt = @"
  _____                ____  _ _ 
 |  __ \              / __ \(_|_)
 | |  | | _____   __ | |  | |_ _ 
 | |  | |/ _ \ \ / / | |  | | | |
 | |__| |  __/\ V /  | |__| | | |
 |_____/ \___| \_/    \___\_\_|_|
"@

# Split ASCII art into lines
$lines = $asciiArt -split "`n"

# Calculate padding for center alignment
$maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
$padding = [math]::Max(0, [int](($width - $maxLength) / 2))

# Rainbow colors array
$rainbowColors = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')

# Function to display ASCII art
function Show-ASCIIArt {
    foreach ($i in 0..($lines.Count - 1)) {
        $spaces = " " * $padding
        $color  = $rainbowColors[$i % $rainbowColors.Count]
        Write-Host "$spaces$($lines[$i])" -ForegroundColor $color
    }
}

# Function to show menu
function Show-Menu {
    param($width)

    $menuTitle = "=== SELECT OPTION ==="
    $titlePadding = [math]::Max(0, [int](($width - $menuTitle.Length) / 2))
    Write-Host (" " * $titlePadding + $menuTitle) -ForegroundColor Magenta
    Write-Host ""

    $leftPadding = [math]::Max(0, [int](($width - 40) / 2))

    Write-Host (" " * $leftPadding + "1. IDM Reset") -ForegroundColor White
    Write-Host (" " * $leftPadding + "2. Windows Activator") -ForegroundColor White
    Write-Host (" " * $leftPadding + "3. Exit") -ForegroundColor White
    Write-Host ""
}

# Simple ASCII progress function (CENTERED)
function Show-Progress {
    param($Activity, $Seconds, $Color = "Cyan")
    
    # Center the activity text
    $activityPadding = [math]::Max(0, [int](($width - $Activity.Length) / 2))
    Write-Host "`n" + (" " * $activityPadding + $Activity) -ForegroundColor Yellow
    
    $barWidth = 40
    
    for ($i = 0; $i -le $barWidth; $i++) {
        # Check if cancellation was requested
        if ($global:CancellationRequested) {
            return $false
        }
        
        $percent = [math]::Round(($i / $barWidth) * 100)
        
        # Simple ASCII progress bar
        $progressBar = "["
        $progressBar += "#" * $i
        if ($i -lt $barWidth) {
            $progressBar += ">"
            $progressBar += "." * ($barWidth - $i - 1)
        }
        $progressBar += "] $percent%"
        
        # Center the progress bar
        $barPadding = [math]::Max(0, [int](($width - $progressBar.Length) / 2))
        Write-Host "`r" + (" " * $barPadding + $progressBar) -NoNewline -ForegroundColor $Color
        
        Start-Sleep -Milliseconds ($Seconds * 1000 / $barWidth)
    }
    
    # Center the completion message
    $completeBar = "[" + ("#" * $barWidth) + "] 100%"
    $completePadding = [math]::Max(0, [int](($width - $completeBar.Length) / 2))
    Write-Host "`r" + (" " * $completePadding + $completeBar) -ForegroundColor Green
    
    return $true
}

# Function to handle Ctrl+C
function Set-CancellationHandler {
    # Register the handler for Ctrl+C
    $global:CancellationRequested = $false
    
    # Save the original handler
    $global:OriginalHandler = [Console]::TreatControlCAsInput
    
    # Set our custom handler
    [Console]::TreatControlCAsInput = $true
    
    # Create a function to check for cancellation
    $global:CheckForCancellation = {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "C" -and $key.Modifiers -eq "Control") {
                $global:CancellationRequested = $true
                return $true
            }
        }
        return $false
    }
}

# Function to restore original handler
function Restore-OriginalHandler {
    [Console]::TreatControlCAsInput = $global:OriginalHandler
}

# Function to execute command with cancellation detection
function Invoke-CommandWithCancellation {
    param(
        [ScriptBlock]$Command,
        [string]$SuccessMessage,
        [string]$CancellationMessage
    )
    
    $global:CancellationRequested = $false
    
    try {
        # Execute the command as a job to make it cancellable
        $job = Start-Job -ScriptBlock $Command
        
        # Wait for the job to complete or cancellation
        while ($job.State -eq "Running" -and -not $global:CancellationRequested) {
            Start-Sleep -Milliseconds 100
            & $global:CheckForCancellation
        }
        
        # If cancellation was requested, stop the job
        if ($global:CancellationRequested) {
            Stop-Job $job
            Remove-Job $job -Force
            
            # Center cancellation message
            $cancelPadding = [math]::Max(0, [int](($width - $CancellationMessage.Length) / 2))
            Write-Host "`n" + (" " * $cancelPadding + $CancellationMessage) -ForegroundColor Yellow
            return $false
        }
        
        # Get the job results
        $result = Receive-Job $job
        Remove-Job $job -Force
        
        # Center success message
        $successPadding = [math]::Max(0, [int](($width - $SuccessMessage.Length) / 2))
        Write-Host "`n" + (" " * $successPadding + $SuccessMessage) -ForegroundColor Green
        
        return $true
    }
    catch {
        # Center error message
        $errorText = "Error: $($_.Exception.Message)"
        $errorPadding = [math]::Max(0, [int](($width - $errorText.Length) / 2))
        Write-Host "`n" + (" " * $errorPadding + $errorText) -ForegroundColor Red
        return $false
    }
}

# Set up cancellation handler
Set-CancellationHandler

# Initial display
Clear-Host
Show-ASCIIArt

# Loading message (CENTERED)
$loadingText = "Loading Options ..."
$loadingPadding = [math]::Max(0, [int](($width - $loadingText.Length) / 2))
Write-Host "`n" + (" " * $loadingPadding + $loadingText) -ForegroundColor Yellow

# Progress bar (CENTERED)
$barWidth = 50
$seconds = 2
Write-Host "`n"

for ($i = 0; $i -le $barWidth; $i++) {
    $percent = [math]::Round(($i / $barWidth) * 100)
    $progressBar = "["
    $progressBar += "#" * $i
    if ($i -lt $barWidth) {
        $progressBar += ">"
        $progressBar += "." * ($barWidth - $i - 1)
    }
    $progressBar += "] $percent%"
    
    $barPadding = [math]::Max(0, [int](($width - $progressBar.Length) / 2))
    Write-Host "`r" + (" " * $barPadding + $progressBar) -NoNewline -ForegroundColor Cyan
    Start-Sleep -Milliseconds ($seconds * 1000 / $barWidth)
}

$completeBar = "[" + ("#" * $barWidth) + "] 100%"
$completePadding = [math]::Max(0, [int](($width - $completeBar.Length) / 2))
Write-Host "`r" + (" " * $completePadding + $completeBar) -ForegroundColor Green
Start-Sleep -Seconds 1

# Main menu loop
do {
    # Reset cancellation flag
    $global:CancellationRequested = $false
    
    Clear-Host
    Show-ASCIIArt
    Show-Menu $width
    
    # Centered prompt
    $promptText = "Enter your choice (1-3): "
    $promptPadding = [math]::Max(0, [int](($width - $promptText.Length) / 2))
    Write-Host (" " * $promptPadding + $promptText) -NoNewline
    $choice = Read-Host

    switch ($choice) {
        '1' {
            Clear-Host
            Show-ASCIIArt
            
            # Show progress with cancellation detection
            $completed = Show-Progress -Activity "Executing IDM Reset..." -Seconds 3 -Color "Yellow"
            
            if (-not $completed -or $global:CancellationRequested) {
                # Center cancellation message
                $cancelText = "IDM Reset was cancelled. No changes were made."
                $cancelPadding = [math]::Max(0, [int](($width - $cancelText.Length) / 2))
                Write-Host "`n" + (" " * $cancelPadding + $cancelText) -ForegroundColor Yellow
            }
            else {
                # Execute the command with cancellation detection
                $success = Invoke-CommandWithCancellation -Command {
                    iex (irm is.gd/idm_reset)
                } -SuccessMessage "IDM Reset executed successfully!" -CancellationMessage "IDM Reset was cancelled. No changes were made."
            }
            
            # Center continue message
            $continueText = "Press any key to continue..."
            $continuePadding = [math]::Max(0, [int](($width - $continueText.Length) / 2))
            Write-Host "`n" + (" " * $continuePadding + $continueText) -ForegroundColor White
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        '2' {
            Clear-Host
            Show-ASCIIArt
            
            # Show progress with cancellation detection
            $completed = Show-Progress -Activity "Executing Windows Activator..." -Seconds 4 -Color "Magenta"
            
            if (-not $completed -or $global:CancellationRequested) {
                # Center cancellation message
                $cancelText = "Windows Activation was cancelled. No changes were made."
                $cancelPadding = [math]::Max(0, [int](($width - $cancelText.Length) / 2))
                Write-Host "`n" + (" " * $cancelPadding + $cancelText) -ForegroundColor Yellow
            }
            else {
                # Execute the command with cancellation detection
                $success = Invoke-CommandWithCancellation -Command {
                    irm https://get.activated.win  | iex
                } -SuccessMessage "Windows Activator executed successfully!" -CancellationMessage "Windows Activation was cancelled. No changes were made."
            }
            
            # Center continue message
            $continueText = "Press any key to continue..."
            $continuePadding = [math]::Max(0, [int](($width - $continueText.Length) / 2))
            Write-Host "`n" + (" " * $continuePadding + $continueText) -ForegroundColor White
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        '3' {
            Clear-Host
            $exitText = "Thank you for using! Goodbye!"
            $exitPadding = [math]::Max(0, [int](($width - $exitText.Length) / 2))
            Write-Host (" " * $exitPadding + $exitText) -ForegroundColor Cyan
            Start-Sleep -Seconds 2
            break
        }
        default {
            Write-Host "Invalid choice, please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)

# Restore original handler when script exits
Restore-OriginalHandler