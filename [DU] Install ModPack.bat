@echo off
setlocal disableDelayedExpansion

:: =======================================================================
:: This script is licensed under the MIT License.
:: 
:: Copyright (c) 2025 Mr_Alchemy/gunsgamertv
:: 
:: Permission is hereby granted, free of charge, to use, copy, modify, merge,
:: publish, distribute, sublicense, and/or sell copies of the Software, and to
:: permit persons to whom the Software is furnished to do so, subject to the
:: following conditions:
:: 
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.
:: =======================================================================

set "localVersion=29.03.2025/1"

:: =======================================================================
:: Define ANSI escape sequences for colors
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "PTCOLOR=%ESC%[1;38;5;220m"
set "ERCOLOR=%ESC%[1;38;5;196m"
set "WGCOLOR=%ESC%[1;38;5;196m"
set "DBCOLOR=%ESC%[1;38;5;75m"
set "SSCOLOR=%ESC%[1;38;5;46m"

:: Get the full path of the script
set "scriptPath=%~dp0"
set "scriptPath=%scriptPath:~0,-1%"
for /f "delims=" %%i in ('powershell -NoProfile -Command "[System.IO.Path]::GetFullPath('%scriptPath%')"') do set "realPath=%%i"
for /f "delims=" %%i in ('powershell -Command "(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/AlchemistChief/MC_DogUnion_ModPack/main/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty version"') do set "latestVersion=%%i"

echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
echo %DBCOLOR%[DEBUG]%RESET% Local version: %localVersion%
if "%latestVersion%"=="%localVersion%" (
	echo %DBCOLOR%[DEBUG]%RESET% Server versio: %latestVersion%
) else (
    echo %WGCOLOR%[DEBUG]%RESET% A new version is available: %latestVersion%
    echo %WGCOLOR%[DEBUG]%RESET% Consider updating your script.
)
echo %DBCOLOR%[DEBUG]%RESET% Author: Mr_Alchemy/gunsgamertv
echo %DBCOLOR%[DEBUG]%RESET% Script is located at:
echo %DBCOLOR%[DEBUG]%RESET% %scriptPath%
echo %DBCOLOR%[DEBUG]%RESET% Real path:
echo %DBCOLOR%[DEBUG]%RESET% %realPath%

:: Check if the script is in a directory under \mods\
echo %realPath% | findstr /i "\\mods\\" >nul
if %errorlevel% neq 0 (
    echo echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %ERCOLOR%[ERROR]%RESET% Error: This script is not located in a directory under \mods\.
    pause
    exit /b
)

:: Ensure the directory exists
if not exist "%realPath%" (
    echo echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %ERCOLOR%[ERROR]%RESET% Error: The directory "%realPath%" does not exist!
    pause
    exit /b
)

:: Set download file paths before prompting for the choice
set "clientOutputFile=%realPath%\Client_Recommended.zip"
set "serverOutputFile=%realPath%\Server_Necessary.zip"

echo %PTCOLOR%=============================== [PROMPT] ===============================%RESET%
choice /C YN /M "%PTCOLOR%[PROMPT]%RESET% Do you want to install 'Client_Recommended'?"
set "installClient=%errorlevel%"
if %installClient% == 1 (
    choice /C YN /M "%PTCOLOR%[PROMPT]%RESET% Do you want to install preset Optifine Settings?"
    set "installOptifineSettings=%errorlevel%"
)
choice /C YN /M "%PTCOLOR%[PROMPT]%RESET% Do you want to install preset settings?"
set "installSettings=%errorlevel%"
choice /C YN /M "%PTCOLOR%[PROMPT]%RESET% Do you want to automatically extract the zip files and delete them?"
set "extractFiles=%errorlevel%"

:: Check if 'options.txt' exists and download if not
if not exist "files\options.txt" (
    echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
    echo %DBCOLOR%[DEBUG]%RESET% Downloading 'options.txt' to: 
    echo %DBCOLOR%[DEBUG]%RESET% "files\options.txt"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/AlchemistChief/MC_DogUnion_ModPack/raw/refs/heads/main/options.txt' -OutFile 'files\options.txt'"
    if exist "files\options.txt" (
        echo %SSCOLOR%=============================== [SUCCESS] ===============================%RESET%
        echo %SSCOLOR%[SUCCESS]%RESET% 'options.txt' download complete.
    ) else (
        echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
        echo %ERCOLOR%[ERROR]%RESET% Error: 'options.txt' download failed.
    )
)

:: Download 'Server_Necessary' automatically
echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
echo %DBCOLOR%[DEBUG]%RESET% Downloading 'Server_Necessary' to: 
echo %DBCOLOR%[DEBUG]%RESET% "%serverOutputFile%"
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/AlchemistChief/MC_DogUnion_ModPack/raw/refs/heads/main/Server_Necessary.zip' -OutFile '%serverOutputFile%'"
if exist "%serverOutputFile%" (
    echo %SSCOLOR%=============================== [SUCCESS] ===============================%RESET%
    echo %SSCOLOR%[SUCCESS]%RESET% 'Server_Necessary' download complete.
) else (
    echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %ERCOLOR%[ERROR]%RESET% Error: 'Server_Necessary' download failed.
)

:: Download 'Client_Recommended' if chosen
if %installClient%==1 (
    echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
    echo %DBCOLOR%[DEBUG]%RESET% Downloading 'Client_Recommended' to: 
    echo %DBCOLOR%[DEBUG]%RESET% "%clientOutputFile%"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/AlchemistChief/MC_DogUnion_ModPack/raw/refs/heads/main/Client_Recommended.zip' -OutFile '%clientOutputFile%'"
    if exist "%clientOutputFile%" (
        echo %SSCOLOR%=============================== [SUCCESS] ===============================%RESET%
        echo %SSCOLOR%[SUCCESS]%RESET% 'Client_Recommended' download complete.
        
        :: Download 'optionsof.txt' if Optifine settings are chosen
        if %installOptifineSettings%==1 (
            echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
            echo %DBCOLOR%[DEBUG]%RESET% Downloading 'optionsof.txt' to: 
            echo %DBCOLOR%[DEBUG]%RESET% "files\optionsof.txt"
            powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/AlchemistChief/MC_DogUnion_ModPack/raw/refs/heads/main/optionsof.txt' -OutFile 'files\optionsof.txt'"
            if exist "files\optionsof.txt" (
                echo %SSCOLOR%=============================== [SUCCESS] ===============================%RESET%
                echo %SSCOLOR%[SUCCESS]%RESET% 'optionsof.txt' download complete.
            ) else (
                echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
                echo %ERCOLOR%[ERROR]%RESET% 'optionsof.txt' download failed.
            )
        )
    ) else (
        echo %ERCOLOR%=============================== [ERROR] ===============================%RESET%
        echo %ERCOLOR%[ERROR]%RESET% 'Client_Recommended' download failed.
    )
)

:: Extract files
if %extractFiles%==1 (
    if exist "%serverOutputFile%" (
        echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
        echo %DBCOLOR%[DEBUG]%RESET% Extracting 'Server_Necessary.zip'
        for /f "delims=" %%f in ('powershell -NoProfile -Command "Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%realPath%' -Force"') do (
            if not exist "%realPath%\%%f" (
                powershell -NoProfile -Command "Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%realPath%'"
                echo %DBCOLOR%[DEBUG]%RESET% Extracting '%%f'...
            ) else (
                echo %DBCOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
            )
        )
        del "%serverOutputFile%"
    )
    
    if exist "%clientOutputFile%" (
        echo %DBCOLOR%=============================== [DEBUG] ===============================%RESET%
        echo %DBCOLOR%[DEBUG]%RESET% Extracting 'Client_Recommended.zip'
        for /f "delims=" %%f in ('powershell -NoProfile -Command "Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%realPath%' -Force"') do (
            if not exist "%realPath%\%%f" (
                powershell -NoProfile -Command "Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%realPath%'"
                echo %DBCOLOR%[DEBUG]%RESET% Extracting '%%f'...
            ) else (
                echo %DBCOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
            )
        )
        del "%clientOutputFile%"
    )
    
    echo %SSCOLOR%=============================== [SUCCESS] ===============================%RESET%
    echo %SSCOLOR%[SUCCESS]%RESET% Extraction and cleanup complete.
	echo %SSCOLOR%[SUCCESS]%RESET% Mods successfully downloaded and installed.
    echo =======================================================================
)

pause
