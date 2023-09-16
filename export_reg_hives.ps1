# Define the paths for each registry hive
$RegistryHives = @(
    "HKEY_CLASSES_ROOT",
    "HKEY_CURRENT_USER",
    "HKEY_LOCAL_MACHINE",
    "HKEY_USERS",
    "HKEY_CURRENT_CONFIG"
)

# Specify the output directory where the .reg files will be saved
$OutputDirectory = "$env:SystemDrive\reg-export"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $OutputDirectory -PathType Container)) {
    New-Item -Path $OutputDirectory -ItemType Directory
}

# Loop through each registry hive and export it to a .reg file
foreach ($hive in $RegistryHives) {
    $HiveFileName = $hive -replace '\\', '-'
    $HivePath = Join-Path -Path $OutputDirectory -ChildPath "$HiveFileName.reg"
    
    try {
        Write-Host "Exporting $hive hive to $HivePath"
        Start-Process -Wait -FilePath "reg.exe" -ArgumentList "export $hive `"$HivePath`"" -NoNewWindow -ErrorAction Stop
        Write-Host "Exported $hive hive successfully."
    } catch {
        Write-Host "Error exporting $hive hive: $_"
    }
}

Write-Host "Registry export completed."
