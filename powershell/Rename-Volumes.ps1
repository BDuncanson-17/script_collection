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
    "E" = "Paging"
    "T" = "Temp"
    "Y" = "Oracle"
}

foreach ($drive in $drives.GetEnumerator()) {
    $letter = $drive.Key
    $name = $drives[$letter]
    $volume = Get-Volume -DriveLetter $letter
    
    if ($volume.FileSystemLabel -eq "New Volume") {
        Write-Host ("Renaming {0} from 'New Volume' to {1}" -f $letter, $name)
        Set-Volume -NewFileSystemLabel $name -Path $volume.Path
    } else {
        Write-Host ("Skipping {0} because its volume name is not 'New Volume'. Its current name is '{1}'." -f $letter, $volume.FileSystemLabel)
    }
}
