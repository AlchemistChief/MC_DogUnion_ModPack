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
set "baseGitHubURL=https://raw.githubusercontent.com/AlchemistChief/MC_DogUnion_ModPack/main"
set "localBatVersion=2.4"
set "localServerVersion=1.0"
set "localClientVersion=1.0"
set "localConfigVersion=1.0"

for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty bat_version"') do set "latestBatVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty server_version"') do set "latestServerVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty client_version"') do set "latestClientVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty config_version"') do set "latestConfigVersion=%%i"
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
for %%B in ("%realPath%") do set "folderName=%%~nxB"
for %%A in ("%realPath%") do set "parentDir=%%~dpA"

echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Author:Mr_Alchemy/gunsgamertv
echo %BLUECOLOR%[DEBUG]%RESET% ProgressBar:%GREENCOLOR%Custom%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Local Bat version:%localBatVersion%
if "%latestBatVersion%" neq "%localBatVersion%" ( echo %REDCOLOR%[DEBUG] Server Bat version:%latestBatVersion%%RESET% && echo %REDCOLOR%[DEBUG] Consider updating via Github.%RESET%) else (echo %BLUECOLOR%[INFO]%RESET% Server Bat version:%latestBatVersion%)
echo %BLUECOLOR%[DEBUG]%RESET% Script path:	%scriptPath%
echo %BLUECOLOR%[DEBUG]%RESET% Absolute path:	%realPath%

echo %BLUECOLOR%=========================== [SYSTEM SPECS] ===========================%RESET%
for /f "delims=" %%A in ('powershell -command "(Get-CimInstance -ClassName Win32_OperatingSystem).Caption"') do echo %BLUECOLOR%[SYSTEM]%RESET% Installed OS:	%GOLDCOLOR%%%A%RESET%
for /f "tokens=2 delims==" %%A in ('wmic ComputerSystem get TotalPhysicalMemory /value') do set "RAM_B=%%A"
set /a RAM_GB=%RAM_B:~0,-10%
set /a RAM_MB_DIV=%RAM_B:~-10,3% / 10
echo %BLUECOLOR%[SYSTEM]%RESET% Installed RAM:	%GOLDCOLOR%%RAM_GB%.%RAM_MB_DIV% GB%RESET%
for /f "tokens=2 delims==" %%A in ('wmic cpu get Name /value ^| find "="') do echo %BLUECOLOR%[SYSTEM]%RESET% Installed CPU:	%GOLDCOLOR%%%A%RESET%
for /f "skip=1 tokens=*" %%A in ('wmic path win32_VideoController get name') do (
    if not "%%A"=="" (
        echo %BLUECOLOR%[SYSTEM]%RESET% Installed GPU:	%GOLDCOLOR%%%A%RESET%
        goto :done
    )
)
:done

::================================================================================================
if /i not "%folderName%"=="MC_DogUnion_ModPack" (
	if /i not "%folderName%"=="mods" (
	::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
	echo %REDCOLOR%[ERROR]%RESET% Error: This script is not located in a directory under \mods\.
	pause
	exit /b
	)
	if not exist "%realPath%" (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: The directory "%realPath%" does not exist!
		pause
		exit /b
	)
	if not exist "%parentDir%config" (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: 'config' folder does not exist in the parent directory!
		pause
		exit /b
	)
	if not exist "%parentDir%versions" (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: 'versions' folder does not exist in the parent directory!
		pause
		exit /b
	)
)
::================================================================================================
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty serverDownLoadLink"') do set "serverDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty clientDownLoadLink"') do set "clientDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty clientDownLoadLink"') do set "configDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsDownLoadLink"') do set "optionsDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsofDownLoadLink"') do set "optionsofDownLoadLink=%%i"
::================================================================================================
:: Set download file paths before prompting for the choice
set "serverOutputFile=%realPath%\Server_Necessary.zip"
set "clientOutputFile=%realPath%\Client_Recommended.zip"
set "configOutputFile=%realPath%\Config_Client.zip"
set "optionsFile=%parentDir%options.txt"
set "optionsOfFile=%parentDir%optionsof.txt"

echo %GOLDCOLOR%=============================== [PROMPT] ===============================%RESET%
echo "%GOLDCOLOR%[INFO]%RESET% 'Server_Necessary' => %REDCOLOR%NECESSARY%GOLDCOLOR% to join the server"
echo "%GOLDCOLOR%[INFO]%RESET% 'Client_Recommended' => %GREENCOLOR%OPTIONAL%GOLDCOLOR% for QOL & Performance Mods"
echo "%GOLDCOLOR%[INFO]%RESET% 'Configs_Client' is %GREENCOLOR%OPTIONAL%GOLDCOLOR% => Install to fix some bugs & QOL"
echo "%GOLDCOLOR%[INFO]%RESET% The preset settings (options.txt) sets keybinds & graphic options"
echo "%GOLDCOLOR%[INFO]%RESET% The preset Optifine settings (optionsof.txt) graphic options 'Client_Recommended' must be %GREENCOLOR%TRUE%RESET%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Server_Necessary'?"
set "installServer=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Client_Recommended'?"
set "installClient=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Configs'?"
set "installConfigs=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install preset settings?"
set "installSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install preset Optifine Settings?"
set "installOptifineSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to automatically extract the zip files?"
set "extractFiles=%errorlevel%"

::================================================================================================
:: Download 'Server_Necessary' if chosen
if %installServer%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Server_Necessary'
	powershell -NoProfile -Command "$url = '%serverDownLoadLink%'; $output = '%serverOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%serverOutputFile%" (
		::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Server_Necessary' download complete.
	) else (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: 'Server_Necessary' download failed.
	)
)

:: Download 'Client_Recommended' if chosen
if %installClient%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Client_Recommended'
	powershell -NoProfile -Command "$url = '%clientDownLoadLink%'; $output = '%clientOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%clientOutputFile%" (
		::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Client_Recommended' download complete.
	) else (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% 'Client_Recommended' download failed.
	)
)

:: Download 'Configs' if chosen
if %installConfigs%==1 (
		echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Config_Client'
	powershell -NoProfile -Command "$url = '%configDownLoadLink%'; $output = '%configOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%configOutputFile%" (
		::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Config_Client' download complete.
	) else (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% 'Config_Client' download failed.
	)
)

:: Check if 'options.txt' exists and download if not
if %installSettings%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'options.txt'
	powershell -NoProfile -Command "Invoke-WebRequest -Uri '%optionsDownLoadLink%' -OutFile '%optionsFile%'"
	if exist "%optionsFile%" (
		::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'options.txt' download complete.
	) else (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% Error: 'options.txt' download failed.
	)
)
:: Download 'optionsof.txt' if Optifine settings are chosen and Client is installed
if "%installOptifineSettings%"=="1" if "%installClient%"=="1" (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'optionsof.txt'
	powershell -NoProfile -Command "Invoke-WebRequest -Uri '%optionsofDownLoadLink%' -OutFile '%optionsOfFile%'"
	if exist "%optionsOfFile%" (
		::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
		echo %GREENCOLOR%[SUCCESS]%RESET% 'optionsof.txt' download complete.
	) else (
		::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
		echo %REDCOLOR%[ERROR]%RESET% 'optionsof.txt' download failed.
	)
)

:: Extract files
if %extractFiles%==1 (
	echo %BLUECOLOR%=============================== [EXTRACTION] ===============================%RESET%
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
		echo %GREENCOLOR%[SUCCESS]%RESET% Server_Necessary Extraction and cleanup complete.
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
		echo %GREENCOLOR%[SUCCESS]%RESET% Client_Recommended Extraction and cleanup complete.
	)
	
	::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
	echo %GREENCOLOR%[SUCCESS]%RESET% Mods/Settings successfully downloaded and installed.
	echo %GREENCOLOR%=======================================================================%RESET%
)

pause