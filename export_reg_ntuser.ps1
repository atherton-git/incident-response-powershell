# Limitatation of this script is that it can't copy NTUSER.DAT of a logged in user.

# Set the source and destination paths
$sourceDirectory = "$env:SystemDrive\Users"
$destinationDirectory = "$env:SystemDrive\reg-export"

# Check if the destination directory exists, if not, create it
if (-not (Test-Path -Path $destinationDirectory -PathType Container)) {
    New-Item -Path $destinationDirectory -ItemType Directory
}

# Function to copy NTUSER.DAT files with directory name prefix
function Copy-NtUserFile($file) {
    $directoryName = $file.Directory.Name
    $destinationFileName = Join-Path -Path $destinationDirectory -ChildPath "$directoryName-$($file.Name)"
    Copy-Item -Path $file.FullName -Destination $destinationFileName
    Write-Host "Copied $($file.FullName) to $($destinationFileName)"
}

# Get all NTUSER.DAT files in the source directory and its immediate subdirectories, including hidden files
$ntuserFiles = Get-ChildItem -Depth 1 -Path $sourceDirectory -File -Filter "NTUSER.DAT" -Force

# Copy each NTUSER.DAT file to the destination with the directory name prefix
foreach ($file in $ntuserFiles) {
    Copy-NtUserFile -file $file
}

Write-Host "NTUSER.DAT files (including hidden files) copied to $destinationDirectory with directory name prefix."
