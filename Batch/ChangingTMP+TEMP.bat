@echo off
setlocal

:: Check if parameter was provided
IF "%~1"=="" (
    echo No directory specified
    exit /b
)

:: Get full path of the specified directory
FOR %%i IN ("%~1") DO SET "NewTempDir=%%~fi"

:: Get current values of TMP and TEMP
FOR /F "tokens=2* delims= " %%i IN ('reg query "HKCU\Environment" /v TEMP') DO set CurrentTemp=%%j
FOR /F "tokens=2* delims= " %%i IN ('reg query "HKCU\Environment" /v TMP') DO set CurrentTmp=%%j

:: Compare and update if different
IF NOT "%CurrentTemp%"=="%NewTempDir%" (
    setx TEMP "%NewTempDir%"
    echo Changed TEMP to %NewTempDir%
)

IF NOT "%CurrentTmp%"=="%NewTempDir%" (
    setx TMP "%NewTempDir%"
    echo Changed TMP to %NewTempDir%
)
