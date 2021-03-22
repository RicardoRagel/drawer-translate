:: BAT script to create an installer of the previous released application using the release_windows.bat script
:: WARNING: This script must be executed from its own folder.
@echo OFF

:: Example usage: .\create_installer.bat C:\Users\Ricardo\Libraries\build-translator_app-Desktop_Qt_5_14_2_MinGW_64_bit-Release\release
set USAGE_MSG=".\release_windws.bat <PATH_TO_RELEASED_APP>"

::Check argument 1
set RELEASE_PATH=%1
if "%1"=="" (
    echo Invalid arguments number. Usage: %USAGE_MSG%
    exit
) else (
    echo -- Using release: %RELEASE_PATH%
)

:: Get QtInstallerFramework installer
echo -- Downloading QtInstallerFramework ...
if NOT EXIST QtInstallerFramework-win-x86.exe (
    ::(unavailable while writting this script) curl -o QtInstallerFramework-win-x86.exe "https://download.qt.io/official_releases/qt-installer-framework/4.0.1/QtInstallerFramework-win-x86.exe"
    curl -o QtInstallerFramework-win-x86.exe "http://qt-mirror.dannhauer.de/official_releases/qt-installer-framework/4.0.1/QtInstallerFramework-win-x86.exe"
) else (
    echo Found previously downloaded installer.
)

:: Install QtInstallerFramework
echo -- Launching QtInstallerFramework installation ...
if NOT EXIST C:\Qt\QtIFW-4.0.1\bin\binarycreator.exe (
    cmd /C C:\Users\Ricardo\Libraries\translator-minimal-app\deployment\WinDeplotQt\QtInstallerFramework-win-x86.exe
    echo [PAUSED] Press any key once you completed the installation
    PAUSE
) else (
    echo Found previously installed QtInstallerFramework at C:\Qt\QtIFW-4.0.1.
)

:: Copy the release to the package folder
set TARGET_PACKAGE_DATA_PATH=".\installer\packages\org.qtproject.ifw\data\"
echo -- Copying release files from %RELEASE_PATH% to %TARGET_PACKAGE_DATA_PATH% ...
xcopy /E %RELEASE_PATH%\* %TARGET_PACKAGE_DATA_PATH%

:: Generate the installer
echo -- Generating Installer executable ...
C:\Qt\QtIFW-4.0.1\bin\binarycreator.exe --offline-only -c installer/config/config.xml -p installer/packages TranslatorAppWinInstaller.exe