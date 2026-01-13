@echo off
setlocal enabledelayedexpansion

:: Checks if the Mods folder has files and requests to clear
if exist "%~dp0Mods\*" (
    :: This checks if there are actually files inside the folder
    dir /b /a "%~dp0Mods\*" | findstr "^" >nul
    if %errorlevel% == 0 (
        set /p clear_mods="Do u want to remove any mods in the Mods folder? [y/n]: "
        if /i "!clear_mods!"=="y" (
            echo Clearing source Mods folder...
            del /q "%~dp0Mods\*"
            for /d %%x in ("%~dp0Mods\*") do rd /s /q "%%x"
        )
    )
)

:: Ask to delete server folder
if exist "%~dp0Server" (
    set /p del_choice="Do you want to delete the old Server folder? (Recommended) [y/n]: "
    if /i "!del_choice!"=="y" (
        echo Deleting old Server folder...
        rd /s /q "%~dp0Server"
    )
)

:: Asks for what version
set /p version="Enter version (e.g., 1.21.11): "

:: paths
set "sourceDir=%~dp0Versions\%version%"
set "baseDir=%~dp0Base"
set "modsSource=%~dp0Mods"
set "targetDir=%~dp0Server"
set "modsTarget=%~dp0Server\mods"

:: Checks if the version folder exists
if not exist "%sourceDir%\" (
    echo [ERROR] Version folder "%version%" not found in Versions directory.
    pause
    exit /b
)

:: Creates Server folder
if not exist "%targetDir%" mkdir "%targetDir%"

:: Copys version to server folder
echo Copying version %version% files...
xcopy "%sourceDir%\*" "%targetDir%\" /s /e /y /i >nul

:: Copys Base files to server
if exist "%baseDir%" (
    echo Copying Base files...
    xcopy "%baseDir%\*" "%targetDir%\" /s /e /y /i >nul
)

:: Copy mods to server mods folder
if exist "%modsSource%" (
    echo Copying Mods to Server...
    xcopy "%modsSource%\*" "%modsTarget%\" /s /e /y /i >nul
)

:: Ask to start server
set /p start_choice="Do you want to start the server now? [y/n]: "

if /i "!start_choice!"=="y" (
    if exist "%targetDir%\Start.bat" (
        echo Launching server...
        cd /d "%targetDir%"
        start Start.bat
    ) else (
        echo [ERROR] Start.bat not found in the Server folder.
        echo Opening explorer instead...
        start explorer "%targetDir%"
        pause
    )
) else (
    echo Opening Server folder...
    start explorer "%targetDir%"
)

exit