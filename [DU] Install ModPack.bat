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

set "localVersion=30.03.2025/8"
set "baseGitHubURL=https://raw.githubusercontent.com/AlchemistChief/MC_DogUnion_ModPack/main"

:: =======================================================================
:: Define ANSI escape sequences for colors
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "GOLDCOLOR=%ESC%[1;38;5;220m"
set "REDCOLOR=%ESC%[1;38;5;196m"
set "BLUECOLOR=%ESC%[1;38;5;75m"
set "GREENCOLOR=%ESC%[1;38;5;46m"

:: Get the full path of the script
set "scriptPath=%~dp0"
set "scriptPath=%scriptPath:~0,-1%"
for /f "delims=" %%i in ('powershell -NoProfile -Command "[System.IO.Path]::GetFullPath('%scriptPath%')"') do set "realPath=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty version"') do set "latestVersion=%%i"

echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Local version: %localVersion%
if "%latestVersion%"=="%localVersion%" (
	echo %BLUECOLOR%[DEBUG]%RESET% Server versio: %latestVersion%
) else (
    echo %REDCOLOR%[DEBUG]%RESET% A new version is available: %latestVersion%
    echo %REDCOLOR%[DEBUG]%RESET% Consider updating your script.
)
echo %BLUECOLOR%[DEBUG]%RESET% Author: Mr_Alchemy/gunsgamertv
echo %BLUECOLOR%[DEBUG]%RESET% ProgressBar: %GREENCOLOR%Custom%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Script is located at:
echo %BLUECOLOR%[DEBUG]%RESET% %scriptPath%
echo %BLUECOLOR%[DEBUG]%RESET% Real path:
echo %BLUECOLOR%[DEBUG]%RESET% %realPath%

:: Check if the script is in a directory under \mods\
set "folderName="
for %%B in ("%realPath%") do set "folderName=%%~nxB"
for %%A in ("%realPath%") do set "parentDir=%%~dpA"

if /i not "%folderName%"=="mods" (
    echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %REDCOLOR%[ERROR]%RESET% Error: This script is not located in a directory under \mods\.
    pause
    exit /b
)

if not exist "%realPath%" (
    echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %REDCOLOR%[ERROR]%RESET% Error: The directory "%realPath%" does not exist!
    pause
    exit /b
)
if not exist "%parentDir%config" (
    echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %REDCOLOR%[ERROR]%RESET% Error: 'config' folder does not exist in the parent directory!
    pause
    exit /b
)
if not exist "%parentDir%versions" (
    echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
    echo %REDCOLOR%[ERROR]%RESET% Error: 'versions' folder does not exist in the parent directory!
    pause
    exit /b
)

for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty serverDownLoadLink"') do set "serverDownLoadLink=%%i"

for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty clientDownLoadLink"') do set "clientDownLoadLink=%%i"

for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsDownLoadLink"') do set "optionsDownLoadLink=%%i"

for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsofDownLoadLink"') do set "optionsofDownLoadLink=%%i"

:: Set download file paths before prompting for the choice
set "clientOutputFile=%realPath%\Client_Recommended.zip"
set "serverOutputFile=%realPath%\Server_Necessary.zip"
set "optionsFile=%parentDir%options.txt"
set "optionsOfFile=%parentDir%optionsof.txt"

echo %GOLDCOLOR%=============================== [PROMPT] ===============================%RESET%
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Server_Necessary' (NEEDED TO JOIN)?"
set "installServer=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Client_Recommended'?"
set "installClient=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install preset Optifine Settings? (Only if 'Client_Recommended' = true)"
set "installOptifineSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install preset settings?"
set "installSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to automatically extract the zip files and delete them?"
set "extractFiles=%errorlevel%"

:: Download 'Server_Necessary' if chosen
if %installServer%==1 (
	echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Server_Necessary' to: 
	echo %BLUECOLOR%[DEBUG]%RESET% "%serverOutputFile%"
	powershell -NoProfile -Command "$url = '%serverDownLoadLink%'; $output = '%serverOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%serverOutputFile%" (
		echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Server_Necessary' download complete.
	) else (
		echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: 'Server_Necessary' download failed.
	)
)

:: Download 'Client_Recommended' if chosen
if %installClient%==1 (
    echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
    echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Client_Recommended' to: 
    echo %BLUECOLOR%[DEBUG]%RESET% "%clientOutputFile%"
    powershell -NoProfile -Command "$url = '%clientDownLoadLink%'; $output = '%clientOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
    if exist "%clientOutputFile%" (
        echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
        echo %GREENCOLOR%[SUCCESS]%RESET% 'Client_Recommended' download complete.
    ) else (
        echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
        echo %REDCOLOR%[ERROR]%RESET% 'Client_Recommended' download failed.
    )
)

:: Check if 'options.txt' exists and download if not
if %installSettings%==1 (
    echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
    echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'options.txt' to: 
    echo %BLUECOLOR%[DEBUG]%RESET% "%optionsFile%"
    powershell -NoProfile -Command "$url = '%optionsDownLoadLink%'; $output = '%optionsFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
    if exist "%optionsFile%" (
        echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
        echo %GREENCOLOR%[SUCCESS]%RESET% 'options.txt' download complete.
    ) else (
        echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
        echo %REDCOLOR%[ERROR]%RESET% Error: 'options.txt' download failed.
    )
)
:: Download 'optionsof.txt' if Optifine settings are chosen and Client is installed
if "%installOptifineSettings%"=="1" if "%installClient%"=="1" (
    echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
    echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'optionsof.txt' to: 
    echo %BLUECOLOR%[DEBUG]%RESET% "%optionsOfFile%"
    powershell -NoProfile -Command "$url = '%optionsofDownLoadLink%'; $output = '%optionsOfFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
    if exist "%optionsOfFile%" (
        echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
        echo %GREENCOLOR%[SUCCESS]%RESET% 'optionsof.txt' download complete.
    ) else (
        echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
        echo %REDCOLOR%[ERROR]%RESET% 'optionsof.txt' download failed.
    )
)

:: Extract files
if %extractFiles%==1 (
	echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
    if exist "%serverOutputFile%" (
        echo %BLUECOLOR%[DEBUG]%RESET% Extracting 'Server_Necessary.zip'
        for /f "delims=" %%f in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%realPath%' -Force"') do (
            if not exist "%realPath%\%%f" (
                powershell -NoProfile -Command "Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%realPath%'"
                echo %BLUECOLOR%[DEBUG]%RESET% Extracting '%%f'...
            ) else (
                echo %BLUECOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
            )
        )
        del "%serverOutputFile%"
    )
    
    if exist "%clientOutputFile%" (
        echo %BLUECOLOR%[DEBUG]%RESET% Extracting 'Client_Recommended.zip'
        for /f "delims=" %%f in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%realPath%' -Force"') do (
            if not exist "%realPath%\%%f" (
                powershell -NoProfile -Command "Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%realPath%'"
                echo %BLUECOLOR%[DEBUG]%RESET% Extracting '%%f'...
            ) else (
                echo %BLUECOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
            )
        )
        del "%clientOutputFile%"
    )
    
    echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
    echo %GREENCOLOR%[SUCCESS]%RESET% Extraction and cleanup complete.
	echo %GREENCOLOR%[SUCCESS]%RESET% Mods successfully downloaded and installed.
    echo %GREENCOLOR%=======================================================================%RESET%
)

pause