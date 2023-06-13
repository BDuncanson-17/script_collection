<#
.SYNOPSIS
    A script to update the user-specific TEMP and TMP environment variables.

.DESCRIPTION
    This script asks the user for a new directory path and credentials to use for a new PowerShell process.
    Then it creates a new PowerShell process with the specified credentials and changes the TEMP and TMP
    environment variables to the specified path in the new process. The environment variables are only
    updated if their current values do not match the specified path.

.PARAMETER newDirectory
    The new directory path to set the TEMP and TMP environment variables to.

.PARAMETER credentials
    The credentials to use for the new PowerShell process. The script will prompt the user for these.

.EXAMPLE
    PS C:\> .\ChangeTempAndTmp.ps1
#>

# Get the new directory path from the user
$newDirectory = Read-Host -Prompt "Enter the new directory path for TEMP and TMP"

# Make sure the directory is a valid, existing directory
if (!(Test-Path $newDirectory -PathType Container)) {
    Write-Error "Invalid directory. Please enter a valid, existing directory."
    return
}

# Prompt the user for credentials
$credentials = Get-Credential

# Start a new PowerShell process with the provided credentials
Start-Process -FilePath PowerShell.exe -Credential $credentials -ArgumentList @(
    '-NoProfile',
    '-Command', @"
        # Import the required modules for interacting with environment variables
        Import-Module PSEnvironment
        
        # Get current TMP and TEMP values
        \$currentTemp = [Environment]::GetEnvironmentVariable('TEMP', 'User')
        \$currentTmp = [Environment]::GetEnvironmentVariable('TMP', 'User')
        
        # If the new directory doesn't match the current TMP and TEMP, update them
        if (\$currentTemp -ne '$newDirectory') {
            Set-EnvironmentVariable -Name 'TEMP' -Value '$newDirectory' -Scope User
            Write-Host "TEMP updated to $newDirectory"
        }
        if (\$currentTmp -ne '$newDirectory') {
            Set-EnvironmentVariable -Name 'TMP' -Value '$newDirectory' -Scope User
            Write-Host "TMP updated to $newDirectory"
        }
"@
) -Wait
