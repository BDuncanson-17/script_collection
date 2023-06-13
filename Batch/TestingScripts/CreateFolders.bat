@echo off
setlocal enabledelayedexpansion

REM Set the default path
set "path=%UserProfile%\Desktop\testing"

REM Create the path if it doesn't exist
if not exist "%path%" (
    mkdir "%path%"
)

REM Create 50 empty directories
for /l %%i in (1, 1, 50) do (
    set "newDirPath=%path%\emptyDir%%i"
    if not exist "!newDirPath!" (
        mkdir "!newDirPath!"
    )
)

echo 50 empty directories created at %path%

:end
