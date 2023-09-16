# Define source and destination folders
$sourceDirectory = "$env:windir\System32\winevt"
$destinationDirectory = "$env:SystemDrive\evtx-export"

# Create the destination folder if it doesn't exist
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory | Out-Null
}

# Get a list of .evt and .evtx files recursively from the source folder
$logFiles = Get-ChildItem -Path $sourceDirectory -File -Recurse | Where-Object { $_.Extension -match '\.(evt|evtx)$' }

# Loop through each log file
foreach ($logFile in $logFiles) {
    # Use Get-WinEvent to check if the log file is empty
    $events = Get-WinEvent -Path $logFile.FullName -ErrorAction SilentlyContinue
    if ($null -ne $events -and $events.Count -gt 0) {
        # Copy the log file to the destination folder
        $destinationPath = Join-Path $destinationDirectory $logFile.Name
        Copy-Item -Path $logFile.FullName -Destination $destinationPath -Force
        Write-Host "Copied $($logFile.FullName) to $($destinationPath)"
    }
}

Write-Host "Copying complete."
