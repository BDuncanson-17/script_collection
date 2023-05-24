   <#
.SYNOPSIS
    Opens a file dialog and returns the selected file path.

.DESCRIPTION
    This function displays a file dialog window that allows the user to select a file. The selected file path is returned.

.EXAMPLE
    $selectedFilePath = Get-FilePath
    if ($selectedFilePath) {
        Write-Host "Selected file path: $selectedFilePath"
    } else {
        Write-Host "No file selected."
    }
#>

function Get-FilePath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Specify the initial directory.")]
        [string]$InitialDirectory = [Environment]::GetFolderPath('Desktop'),

        [Parameter(Mandatory=$false, HelpMessage="Specify the file filter.")]
        [string]$Filter = "All Files (*.*)|*.*",

        [switch]$Multiselect
    )

    $script:WindowHelper = @'
    using System;
    using System.Diagnostics;
    using System.Drawing;
    using System.Runtime.InteropServices;
    using System.Windows.Forms;

    public static class WindowHelper
    {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();

        [DllImport("user32.dll")]
        public static extern bool GetWindowRect(IntPtr hWnd, out Rectangle rect);
    }
'@

    Add-Type -TypeDefinition $script:WindowHelper -ReferencedAssemblies System.Drawing

    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.InitialDirectory = $InitialDirectory
    $fileDialog.Filter = $Filter
    $fileDialog.Multiselect = $Multiselect

    $ownerHandle = [WindowHelper]::GetForegroundWindow()
    $ownerRectangle = [System.Drawing.Rectangle]::Empty
    [WindowHelper]::GetWindowRect($ownerHandle, [ref]$ownerRectangle)
    $ownerScreenBounds = [System.Windows.Forms.Screen]::FromHandle($ownerHandle).Bounds


    $result = $fileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $fileDialog.FileName
    }
    else {
        return $null
    }
}
 
