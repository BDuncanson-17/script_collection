@echo off
setlocal enabledelayedexpansion

REM If no directory specified, use the current directory
if "%~1"=="" (set "searchDir=%cd%") else (set "searchDir=%~1")

REM Initialize the counter
set count=0

REM Recursively search the directory for empty directories
for /r "%searchDir%" /d %%D in (*) do (
    dir /b "%%D" 2>nul | findstr "^" >nul || (
        set /a count+=1
        echo Empty directory found: %%D
        set emptyDir[!count!]=%%D
    )
)

REM Report the number of empty directories found
echo Found %count% empty directories.

REM If any empty directories were found, ask the user if they want to delete them
if %count% gtr 0 (
    choice /C YN /M "Do you want to delete all empty directories?"
    if errorlevel 2 goto :eof
    REM If the user chose to delete, delete each directory
    for /l %%N in (1,1,%count%) do (
        rd "!emptyDir[%%N]!" 2>nul && echo Deleted: "!emptyDir[%%N]!"
    )
)
