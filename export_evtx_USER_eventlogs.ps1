# Define the directory where you want to save the EVTX files.
$LogOutputDirectory = "c:\evtx-export"

# Check if the directory exists; if not, create it.
if (-not (Test-Path -Path $LogOutputDirectory -PathType Container)) {
    New-Item -Path $LogOutputDirectory -ItemType Directory -Force
}

# Get a list of all available Windows event logs using Get-WinEvent -ListLog *.
$EventLogs = Get-WinEvent -ListLog *

foreach ($EventLog in $EventLogs) {
    # Check if the log has records (RecordCount > 0).
    if ($EventLog.RecordCount -gt 0) {
        # Build the file path for the current log topic.
        $LogOutputTopic = "Windows Event Log - $($EventLog.LogName)"
        $CurrentTimeUTC = Get-Date -Format FileDateTimeUniversal
        $LogOutputFileName = "$CurrentTimeUTC - $LogOutputTopic"
        $LogOutputEVTXFilePath = Join-Path -Path $LogOutputDirectory -ChildPath "$LogOutputFileName.evtx"

        # Export the log data as an EVTX file using wevtutil.
        Write-Output "Exporting Windows event log $($EventLog.LogName) as EVTX."
        Write-Output 'Target EVTX file path:'
        Write-Output "$LogOutputEVTXFilePath"
        wevtutil epl $($EventLog.LogName) "$LogOutputEVTXFilePath"
        Write-Output 'Finished exporting EVTX file.'
    }
    else {
        Write-Output "Skipping Windows event log $($EventLog.LogName) because it has no records."
    }
}

# Calculate script run time.
$ScriptEndTime = Get-Date
$ScriptDuration = New-Timespan -Start $ScriptStartTime -End $ScriptEndTime
Write-Output "Log export process execution time: $ScriptDuration."
