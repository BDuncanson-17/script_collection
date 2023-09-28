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

# Initialize an empty array to hold output strings
$outputArray = @()

# Read the list of remote computers from a text file
$remoteComputers = Get-Content "C:\path\to\computers.txt"  # Replace with the actual path to your text file

# Function to get .NET Core/.NET 5+ versions from the file system
function Get-DotNetCoreVersions {
    <#
    .SYNOPSIS
    Retrieves .NET Core/.NET 5+ SDK and Runtime versions from a remote computer.

    .PARAMETER computer
    The name or IP address of the remote computer.

    .EXAMPLE
    Get-DotNetCoreVersions -computer "Computer1"
    #>
    param(
        [string]$computer
    )

    # Define paths to .NET SDK and Runtime folders on the remote computer
    $sdkPath = "\\$computer\C$\Program Files\dotnet\sdk"
    $runtimePath = "\\$computer\C$\Program Files\dotnet\shared\Microsoft.NETCore.App"

    # Initialize empty arrays to hold version information
    $sdkVersions = @()
    $runtimeVersions = @()

    # Check if SDK path exists and list all versions if it does
    if (Test-Path $sdkPath) {
        $sdkVersions = Get-ChildItem -Path $sdkPath
    }

    # Check if Runtime path exists and list all versions if it does
    if (Test-Path $runtimePath) {
        $runtimeVersions = Get-ChildItem -Path $runtimePath
    }

    # Return the versions as a hashtable
    return @{
        "SDK" = $sdkVersions.Name
        "Runtime" = $runtimeVersions.Name
    }
}

# Loop through each remote computer and fetch .NET Core/.NET 5+ versions
foreach ($computer in $remoteComputers) {
    $coreVersions = Get-DotNetCoreVersions -computer $computer  # Call the function and store its output
    $outputArray += "Checking .NET versions on $computer"
    $outputArray += ".NET Core SDK Versions: $($coreVersions.SDK -join ', ')"
    $outputArray += ".NET Core Runtime Versions: $($coreVersions.Runtime -join ', ')"
    $outputArray += "`r`n"  # Add a newline separator
}

# Export the results to a text file
$outputArray | Out-File -FilePath "C:\path\to\dotnet_versions.txt"  # Replace with the actual path where you want to save the file
