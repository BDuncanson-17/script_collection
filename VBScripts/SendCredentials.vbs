Option Explicit

Dim WshShell, oExec, strUserName, strPassword

If WScript.Arguments.Count <> 2 Then
    WScript.Echo "Please provide username and password as arguments."
    WScript.Quit
End If

strUserName = WScript.Arguments.Item(0)
strPassword = WScript.Arguments.Item(1)

Set WshShell = CreateObject("WScript.Shell")

' Send the username and password as keystrokes
WshShell.SendKeys strUserName
WshShell.SendKeys "{TAB}"
WshShell.SendKeys strPassword
WshShell.SendKeys "{ENTER}"

Set WshShell = Nothing
