<#
.SYNOPSIS
    A script to create 50 empty directories with random hexadecimal names in a specified path.

.DESCRIPTION
    This function will create 50 empty directories with random hexadecimal names in the specified path. If the path is not specified, it will default to '~/Desktop/testing'.
    The script will create the '~/Desktop/testing' directory if it does not exist.

.PARAMETER path
    The directory path where the empty directories will be created. If not specified, '~/Desktop/testing' will be used.

.EXAMPLE
    New-EmptyDirectories -path "C:\Users\Username\Documents"

#>
function New-EmptyDirectories {
    param(
        [string]$path = "~/Desktop/testing" # Default to '~/Desktop/testing' if not specified
    )

    # Resolve the full path
    $fullPath = Resolve-Path $path

    # Check if the directory exists, if not, create it
    if (!(Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory | Out-Null
    }

    # Create 50 empty directories with random hexadecimal names
    1..50 | ForEach-Object {
        # Generate a random hexadecimal string
        $randomHex = -join ((48..57) + (97..102) | Get-Random -Count 20 | ForEach-Object {[char]$_})

        $newDirPath = Join-Path -Path $fullPath -ChildPath $randomHex
        New-Item -Path $newDirPath -ItemType Directory | Out-Null
    }

    Write-Host "50 empty directories created at $fullPath"
}

# Call the function to start the script
New-EmptyDirectories
