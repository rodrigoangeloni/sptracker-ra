@echo off

set "TARGET=C:\Steam\SteamApps\common\assettocorsa\apps\python\ptracker"

if exist "%TARGET%" (
    echo "Removing current link"
    rmdir "%TARGET%"
)

echo "Creating link ..."
mklink /D "%TARGET%" "%~dp0%

pause
