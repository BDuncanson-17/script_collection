<#
.SYNOPSIS
    A script to find and optionally delete all empty directories in a specified path.

.DESCRIPTION
    This function will find all empty directories in the specified path (or the current location if no path is specified).
    If empty directories are found, it will prompt the user to delete them. There is no limit on the number of directories it can find.

.PARAMETER searchDir
    The directory path to search for empty directories. If not specified, the current location is used.

.EXAMPLE
    Remove-EmptyDirectories -searchDir "C:\Users\Username\Documents"

#>
function Remove-EmptyDirectories {
    param(
        [string]$searchDir = (Get-Location) # Default to current location if not specified
    )

    # Initialize an array to hold paths of empty directories
    $emptyDirs = @()

    # Recursively search the directory for empty directories
    Get-ChildItem -Path $searchDir -Recurse | ForEach-Object {
        # If the item is a directory and it's empty, add it to the array
        if ($_.PSIsContainer -and (Get-ChildItem -Path $_.FullName | Measure-Object).Count -eq 0) {
            $emptyDirs += $_.FullName
        }
    }

    # Report the number of empty directories found
    Write-Host "Found $($emptyDirs.Count) empty directories."

    # If any empty directories were found, ask the user if they want to delete them
    if ($emptyDirs.Count -gt 0) {
        $response = Read-Host "Do you want to delete all empty directories? [Y/N]"
        if ($response -eq "Y") {
            # If the user chose to delete, delete each directory
            $emptyDirs | ForEach-Object { Remove-Item $_ }
            Write-Host "Empty directories deleted."
        }
    }
}

EmptyDirectories