<#
.SYNOPSIS
    A script to rename specific volumes if their current label is "New Volume".

.DESCRIPTION
    This script checks if the volumes E:, T:, and Y: are named "New Volume". If they are, it renames them to "Paging", "Temp", and "Oracle", respectively.

.PARAMETER none
    The script does not take any parameters.

.EXAMPLE
    .\RenameVolumes.ps1

.NOTES
    This script must be run with administrative privileges as changing volume labels requires admin permissions.
#>

# Define the drives and their new names
$drives = @{
    "E:\" = "Paging"
    "T:\" = "Temp"
    "Y:\" = "Oracle"
}

foreach ($drive in $drives.GetEnumerator()) {
    $driveInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$($drive.Key)'"

    if ($driveInfo.VolumeName -eq "New Volume") {
        Write-Host "Renaming $($drive.Key) from 'New Volume' to '$($drive.Value)'"
        $driveInfo | Set-WmiInstance -Arguments @{VolumeName=$drive.Value}
    } else {
        Write-Host "Skipping $($drive.Key) because its volume name is not 'New Volume'. Its current name is '$($driveInfo.VolumeName)'."
    }
}
