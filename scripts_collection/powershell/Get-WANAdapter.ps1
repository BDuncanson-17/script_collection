<#
.SYNOPSIS
    Retrieves the network adapter that has sent the most packets.

.DESCRIPTION
    This script retrieves the network adapter that has sent the most packets. It uses the Get-NetAdapter cmdlet to
    retrieve the network adapters and filters them based on their status. It then sorts the adapters based on the
    number of packets sent and displays the adapter with the highest count.

.EXAMPLE
    Get-AdapterWithMostPacketsSent
    Retrieves the network adapter that has sent the most packets and displays its name, description, and packet count.

#>

function Get-AdapterWithMostPacketsSent {
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    
    if ($adapters) {
        $adapterWithMostPackets = $adapters | Sort-Object -Property PacketsSent -Descending | Select-Object -First 1
        return $adapterWithMostPackets
    } else {
        return $null
    }
}

# Main script logic
$adapterWithMostPacketsSent = Get-AdapterWithMostPacketsSent

if ($adapterWithMostPacketsSent) {
    Write-Host "Adapter with Most Packets Sent:"
    Write-Host "Name: $($adapterWithMostPacketsSent.Name)"
    Write-Host "Description: $($adapterWithMostPacketsSent.Description)"
    Write-Host "Packets Sent: $($adapterWithMostPacketsSent.PacketsSent)"
} else {
    Write-Host "No network adapter found."
}

