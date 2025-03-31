@echo off && setlocal disableDelayedExpansion
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
:: Define ANSI escape sequences for colors
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "GOLDCOLOR=%ESC%[1;38;5;220m"
set "REDCOLOR=%ESC%[1;38;5;196m"
set "BLUECOLOR=%ESC%[1;38;5;75m"
set "GREENCOLOR=%ESC%[1;38;5;46m"
::================================================================================================
echo %BLUECOLOR%=============================== [DEBUG] ===============================%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Loading Version...

set "baseGitHubURL=https://raw.githubusercontent.com/AlchemistChief/MC_DogUnion_ModPack/main"

set "localBatVersion=2.5"

::================================================================================================
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty bat_version"') do set "latestBatVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty server_version"') do set "latestServerVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty client_version"') do set "latestClientVersion=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/version.json' ).Content | ConvertFrom-Json | Select-Object -ExpandProperty config_version"') do set "latestConfigVersion=%%i"

for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty serverDownLoadLink"') do set "serverDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty clientDownLoadLink"') do set "clientDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty clientDownLoadLink"') do set "configDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsDownLoadLink"') do set "optionsDownLoadLink=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri '%baseGitHubURL%/links.json').Content | ConvertFrom-Json | Select-Object -ExpandProperty optionsofDownLoadLink"') do set "optionsofDownLoadLink=%%i"
::================================================================================================
echo %BLUECOLOR%[DEBUG]%RESET% Script Author:			Mr_Alchemy/gunsgamertv
echo %BLUECOLOR%[DEBUG]%RESET% ProgressBar:			%GREENCOLOR%Custom%RESET%
echo						%GOLDCOLOR%Local%RESET% / %GREENCOLOR%Server%RESET%
if "%localBatVersion%" neq "%latestBatVersion%" ( echo %REDCOLOR%[DEBUG]%RESET% Bat version:			%GOLDCOLOR%%localBatVersion%%RESET% / %REDCOLOR%%latestBatVersion%%RESET%	%REDCOLOR%Consider updating via Github.%RESET%) else (echo %BLUECOLOR%[DEBUG]%RESET% Bat version:			%GOLDCOLOR%%localBatVersion%%RESET% / %GREENCOLOR%%latestBatVersion%%RESET%)
echo %BLUECOLOR%[DEBUG]%RESET% Server_Necessary version:	N/A / %GREENCOLOR%%latestServerVersion%%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Client_Recommended version:	N/A / %GREENCOLOR%%latestClientVersion%%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Config_Base version:		N/A / %GREENCOLOR%%latestConfigVersion%%RESET%
echo %BLUECOLOR%[DEBUG]%RESET% Script path:	%~dp0:~0,-1%
for %%A in ("%~dp0.") do echo %BLUECOLOR%[DEBUG]%RESET% Folder name:	%%~nA

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
    ) )
:done
::================================================================================================
:: Get the full path of the script
set "scriptPath=%~dp0"
set "scriptPath=%scriptPath:~0,-1%"
for %%A in ("%scriptPath%") do (
	set "folderName=%%~nxA"
	set "parentDir=%%~dpA")
set "parentDir=%parentDir:~0,-1%"

:: Set download file paths before prompting for the choice
set "serverOutputFile=%parentDir%\mods\Server_Necessary.zip"
set "clientOutputFile=%parentDir%\mods\Client_Recommended.zip"
set "configOutputFile=%parentDir%\config\Config_Base.zip"
set "optionsOutputFile=%parentDir%\options.txt"
set "optionsOfOutputFile=%parentDir%\optionsof.txt"
::================================================================================================
::Check for correct Folder
if /i not "%folderName%"=="MC_DogUnion_ModPack" (
	if not exist "%scriptPath%" (
		echo %REDCOLOR%[ERROR]%RESET% The directory "%scriptPath%" does not exist!
		pause
		exit /b)
	if /i not "%folderName%"=="mods" (
		echo %REDCOLOR%[ERROR]%RESET% This script is not located in a directory under \mods.
		pause
		exit /b)
	if not exist "%parentDir%\config" (
		echo %REDCOLOR%[ERROR]%RESET% 'config' folder does not exist in the parent directory!
		pause
		exit /b)
)
::================================================================================================
echo %GOLDCOLOR%=============================== [PROMPT] ===============================%RESET%
echo %GOLDCOLOR%[INFO]%RESET% %REDCOLOR%NECESSARY%RESET%'Server_Necessary', Install to join the server
echo %GOLDCOLOR%[INFO]%RESET% %GREENCOLOR%OPTIONAL%RESET%	'Client_Recommended', Install for QOL and Performance Mods
echo %GOLDCOLOR%[INFO]%RESET% %GREENCOLOR%OPTIONAL%RESET%	'Config_Base', Install to fix some bugs and QOL
echo %GOLDCOLOR%[INFO]%RESET% %GREENCOLOR%OPTIONAL%RESET%	'options.txt', Install for preset keybinds and graphic options
echo %GOLDCOLOR%[INFO]%RESET% %GREENCOLOR%OPTIONAL%RESET%	'optionsof.txt', Install for preset Optifine settings graphic options 'Client_Recommended' must be %GREENCOLOR%TRUE%RESET%
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Server_Necessary'?"
set "installServer=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Client_Recommended'?"
set "installClient=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'Config_Base'?"
set "installConfigs=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'options.txt'?"
set "installSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to install 'optionsof.txt' (Optifine)?"
set "installOptifineSettings=%errorlevel%"
choice /C YN /M "%GOLDCOLOR%[PROMPT]%RESET% Do you want to automatically extract the zip files?"
set "extractFiles=%errorlevel%"
::================================================================================================
:: Download 'Server_Necessary.zip' if chosen
if %installServer%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Server_Necessary'
	powershell -NoProfile -Command "$url = '%serverDownLoadLink%'; $output = '%serverOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%serverOutputFile%" (
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Server_Necessary' download complete.
	) else (
		echo %REDCOLOR%[ERROR]%RESET% Error: 'Server_Necessary' download failed.
	))
:: Download 'Client_Recommended.zip' if chosen
if %installClient%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Client_Recommended'
	powershell -NoProfile -Command "$url = '%clientDownLoadLink%'; $output = '%clientOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%clientOutputFile%" (
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Client_Recommended' download complete.
	) else (
		echo %REDCOLOR%[ERROR]%RESET% 'Client_Recommended' download failed.
	))
:: Download 'Config_Base.zip' if chosen
if %installConfigs%==1 (
		echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'Config_Base'
	powershell -NoProfile -Command "$url = '%configDownLoadLink%'; $output = '%configOutputFile%'; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFileAsync($url, $output); while ($webClient.IsBusy) { Start-Sleep -Seconds 2; $fileSizeBytes = (Get-Item $output).Length; $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2); Write-Host '%BLUECOLOR%[DEBUG]%RESET% Downloaded%GOLDCOLOR%' $fileSizeMB '%RESET%MB'; }"
	if exist "%configOutputFile%" (
		echo %GREENCOLOR%[SUCCESS]%RESET% 'Config_Base' download complete.
	) else (
		echo %REDCOLOR%[ERROR]%RESET% 'Config_Base' download failed.
	))
:: Check if 'options.txt' exists and download if not
if %installSettings%==1 (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'options.txt'
	powershell -NoProfile -Command "Invoke-WebRequest -Uri '%optionsDownLoadLink%' -OutFile '%optionsOutputFile%'"
	if exist "%optionsOutputFile%" (
		echo %GREENCOLOR%[SUCCESS]%RESET% 'options.txt' download complete.
	) else (
		echo %REDCOLOR%[ERROR]%RESET% Error: 'options.txt' download failed.
	))
:: Download 'optionsof.txt' if Optifine settings are chosen and Client is installed
if "%installOptifineSettings%"=="1" if "%installClient%"=="1" (
	echo %BLUECOLOR%=============================== [DOWNLOAD] ===============================%RESET%
	echo %BLUECOLOR%[DEBUG]%RESET% Downloading 'optionsof.txt'
	powershell -NoProfile -Command "Invoke-WebRequest -Uri '%optionsofDownLoadLink%' -OutFile '%optionsOutputOfFile%'"
	if exist "%optionsOutputOfFile%" (
		echo %GREENCOLOR%[SUCCESS]%RESET% 'optionsof.txt' download complete.
	) else (
		echo %REDCOLOR%[ERROR]%RESET% 'optionsof.txt' download failed.
	))
::================================================================================================
:: Extract files
if %extractFiles%==1 (
	echo %BLUECOLOR%=============================== [EXTRACTION] ===============================%RESET%
	if exist "%serverOutputFile%" (
		echo %BLUECOLOR%[DEBUG]%RESET% Extracting 'Server_Necessary.zip'
		for /f "delims=" %%f in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%scriptPath%' -Force"') do (
			if not exist "%scriptPath%\%%f" (
				powershell -NoProfile -Command "Expand-Archive -Path '%serverOutputFile%' -DestinationPath '%scriptPath%'"
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
		for /f "delims=" %%f in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%scriptPath%' -Force"') do (
			if not exist "%scriptPath%\%%f" (
				powershell -NoProfile -Command "Expand-Archive -Path '%clientOutputFile%' -DestinationPath '%scriptPath%'"
				echo %BLUECOLOR%[DEBUG]%RESET% Extracting '%%f'...
			) else (
				echo %BLUECOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
			)
		)
		del "%clientOutputFile%"
		echo %GREENCOLOR%[SUCCESS]%RESET% Client_Recommended Extraction and cleanup complete.
	)
	if exist "%configOutputFile%" (
		echo %BLUECOLOR%[DEBUG]%RESET% Extracting 'Config_Base.zip'
		for /f "delims=" %%f in ('powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%configOutputFile%' -DestinationPath '%parentDir%' -Force"') do (
			if not exist "%parentDir%\%%f" (
				powershell -NoProfile -Command "Expand-Archive -Path '%configOutputFile%' -DestinationPath '%parentDir%'"
				echo %BLUECOLOR%[DEBUG]%RESET% Extracting '%%f'...
			) else (
				echo %BLUECOLOR%[DEBUG]%RESET% Skipping existing file: '%%f'
			)
		)
		del "%configOutputFile%"
		echo %GREENCOLOR%[SUCCESS]%RESET% Config_Base Extraction and cleanup complete.
	)
	
	echo %GREENCOLOR%[SUCCESS]%RESET% Mods/Settings successfully downloaded and installed.
	echo %GREENCOLOR%=======================================================================%RESET%
)

pause










::echo %GREENCOLOR%=============================== [SUCCESS] ===============================%RESET%
::echo %REDCOLOR%=============================== [ERROR] ===============================%RESET%
::set "localServerVersion=1.10"
::set "localClientVersion=1.10"
::set "localConfigVersion=1.10"
::if "%localServerVersion%" neq "%latestServerVersion%"	( echo %REDCOLOR%[DEBUG]%RESET% Server_Necessary version:	%GOLDCOLOR%%localServerVersion%%RESET% / %REDCOLOR%%latestServerVersion%%RESET%	%REDCOLOR%Consider updating via Github.%RESET%) else (echo %BLUECOLOR%[DEBUG]%RESET% Server_Necessary version:	%GOLDCOLOR%%localServerVersion%%RESET% / %GREENCOLOR%%latestServerVersion%%RESET%)
::if "%localClientVersion%" neq "%latestClientVersion%"	( echo %REDCOLOR%[DEBUG]%RESET% Client_Recommended version:	%GOLDCOLOR%%localClientVersion%%RESET% / %REDCOLOR%%latestClientVersion%%RESET%	%REDCOLOR%Consider updating via Github.%RESET%) else (echo %BLUECOLOR%[DEBUG]%RESET% Client_Recommended version:	%GOLDCOLOR%%localClientVersion%%RESET% / %GREENCOLOR%%latestClientVersion%%RESET%)
::if "%localConfigVersion%" neq "%latestConfigVersion%"	( echo %REDCOLOR%[DEBUG]%RESET% Config_Base version:		%GOLDCOLOR%%localConfigVersion%%RESET% / %REDCOLOR%%latestConfigVersion%%RESET%	%REDCOLOR%Consider updating via Github.%RESET%) else (echo %BLUECOLOR%[DEBUG]%RESET% Config_Base version:		%GOLDCOLOR%%localConfigVersion%%RESET% / %GREENCOLOR%%latestConfigVersion%%RESET%)