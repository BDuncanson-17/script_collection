<#
.SYNOPSIS
    Enables or disables a network adapter by name.

.DESCRIPTION
    This script allows you to turn off or on a network adapter by specifying its name.

.PARAMETER AdapterName
    The name of the network adapter to enable or disable.

.SWITCH TurnOff
    Indicates whether to disable the network adapter. If this switch is not provided, the network adapter will be enabled.

.EXAMPLE
    .\network-adapter.ps1 -AdapterName "Wi-Fi" -TurnOff
    Disables the Wi-Fi network adapter.

.EXAMPLE
    .\network-adapter.ps1 -AdapterName "Ethernet"
    Enables the Ethernet network adapter.

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdapterName,
    
    [switch]$TurnOff
)

# Retrieves the network adapter object based on the provided name
function Get-Adapter {
    Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetConnectionID -eq $AdapterName }
}

# Disables the specified network adapter
function Disable-Adapter {
    $adapter = Get-Adapter
    if ($adapter) {
        $adapter.Disable()
        Write-Host "The network adapter '$AdapterName' has been disabled."
    } else {
        Write-Host "Network adapter '$AdapterName' not found."
    }
}

# Enables the specified network adapter
function Enable-Adapter {
    $adapter = Get-Adapter
    if ($adapter) {
        $adapter.Enable()
        Write-Host "The network adapter '$AdapterName' has been enabled."
    } else {
        Write-Host "Network adapter '$AdapterName' not found."
    }
}

# Main script logic
if ($TurnOff) {
    Disable-Adapter
} else {
    Enable-Adapter
}
