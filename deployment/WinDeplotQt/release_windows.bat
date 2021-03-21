:: BAT script to release the application for Windows. This script must be executed from its own folder.
@echo OFF

:: Example usage: .\release_windows.bat C:\Users\Ricardo\Qt\5.14.2\mingw73_64\bin C:\Users\Ricardo\Libraries\build-translator_app-Desktop_Qt_5_14_2_MinGW_64_bit-Release\release
set USAGE_MSG=".\release_windws.bat <PATH_TO_QT_BIN> <PATH_TO_APP_EXE_FILE>"

:: App executable binary file
set APP_EXE_FILENAME=translator_app.exe
:: App executable binary file
set QML_DIR=../../qml

::Check argument 1
set QT_BIN_PATH=%1
if "%1"=="" (
    echo Invalid arguments number. Usage: %USAGE_MSG%
    exit
) else (
    echo -- Using QtEnv setup script: %QT_BIN_PATH%\qtenv2.bat
)

::Check argument 2
set APP_EXE_PATH=%2
if "%2"=="" (
    echo Invalid arguments number. Usage: %USAGE_MSG%
    exit
) else (
    echo -- Using current executable: %APP_EXE_PATH%\%APP_EXE_FILENAME%
)

:: Source qtenv2 script to set up the Qt Enviroment
echo -- Setting up Qt Enviroment
cmd /C %QT_BIN_PATH%\qtenv2.bat

:: Remove all the files except the application executable
echo -- Cleaning the release folder
setlocal
:PROMPT
SET /P AREYOUSURE=All the files at %APP_EXE_PATH% except %APP_EXE_FILENAME% will be deleted, do you want to continue (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
echo Removing files ...
FOR %%a IN ("%APP_EXE_PATH%\*") DO IF /i NOT "%%~nxa"=="%APP_EXE_FILENAME%" DEL "%%a"

:: Release the application using the tool windeployqt
echo -- Deploying App
cmd /C %QT_BIN_PATH%/windeployqt --qmldir %QML_DIR% --no-translations %APP_EXE_PATH%\%APP_EXE_FILENAME%

:: Add Openssl DLLs to the the release
echo -- Third Party Lib: OpenSSL
copy C:\Windows\System32\libcrypto-1_1-x64.dll %APP_EXE_PATH%
copy C:\Windows\System32\libssl-1_1-x64.dll %APP_EXE_PATH%

:END
endlocal