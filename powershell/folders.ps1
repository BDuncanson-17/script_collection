# Define the array of server names
$ServerNames = @('Server1', 'Server2', 'Server3', 'Server4', 'Server5', 'Server6', 'Server7', 'Server8', 'Server9', 'Server10', 'Server11', 'Server12', 'Server13', 'Server14')
$Credential = Get-Credential -Message "Please enter your credentials"
$Messages = @() # Initialize an array to hold the messages

# ScriptBlock to count the number of folders
$ScriptBlock = {
    param ($Path)
    (Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue).Count
}

# Loop through each server and check the folder counts
foreach ($Server in $ServerNames) {
    $folderCount = Invoke-Command -ComputerName $Server -ScriptBlock $ScriptBlock -ArgumentList $LocalPath -Credential $Credential
    if ($folderCount -gt 20) {
        $Messages += "Server '$Server' has $folderCount directories."
    }
}

# Create a message string from the messages array
$FinalMessage = if ($Messages.Count -gt 0) {
    $Messages -join "`n"
} else {
    "No servers have more than 20 directories."
}

# Output the final message
Write-Host $FinalMessage
