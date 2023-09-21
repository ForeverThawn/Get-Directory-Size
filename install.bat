@ECHO OFF&(PUSHD "%~DP0")&(REG QUERY "HKU\S-1-5-19">NUL 2>&1)||(
powershell -Command "Start-Process '%~sdpnx0' -Verb RunAs"&&EXIT)&powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
ECHO Windows Terminal requires Windows 10 2004 (build 19041) or later
ECHO Initiating...
CD PS
powershell -Command "Add-AppxPackage .\Microsoft.VCLibs.x64.14.00.Desktop.appx"
powershell -Command "Add-AppxPackage .\Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle"
COPY /Y settings.json "%localappdata%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"

rem ECHO start "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.16.10261.0_x64__8wekyb3d8bbwe\WindowTermial.exe" >>Terminal.cmd
ECHO powershell -NoExit "%HOMEDRIVE%\ForeverUtil\Portable-Startup.ps1" >>Terminal.cmd

rem COPY /Y sudo-Terminal.cmd %HOMEDRIVE%\Desktop
MOVE /Y Terminal.cmd %HOMEDRIVE%%HOMEPATH%\Desktop

START Video_Terminal_Screen.TTF

MKDIR %HOMEDRIVE%\ForeverUtil
MKDIR %HOMEDRIVE%\ForeverUtil\Temp
CD ..\ForeverUtil
COPY /Y Portable-Startup.ps1 %HOMEDRIVE%\ForeverUtil
COPY /Y 7za.exe %HOMEDRIVE%\ForeverUtil
COPY /Y zip.exe %HOMEDRIVE%\ForeverUtil
COPY /Y unzip.exe %HOMEDRIVE%\ForeverUtil
COPY /Y dir-zip.exe %HOMEDRIVE%\ForeverUtil
COPY /Y ARC.exe %HOMEDRIVE%\ForeverUtil
COPY /Y cpl.exe %HOMEDRIVE%\ForeverUtil
COPY /Y ffmpeg.exe %HOMEDRIVE%\ForeverUtil
rem COPY /Y ffprobe.exe %HOMEDRIVE%\ForeverUtil
COPY /Y flac.exe %HOMEDRIVE%\ForeverUtil
COPY /Y libFLAC.dll %HOMEDRIVE%\ForeverUtil
COPY /Y libFLAC++.dll %HOMEDRIVE%\ForeverUtil
COPY /Y metaflac.exe %HOMEDRIVE%\ForeverUtil
COPY /Y forever-encoder.exe %HOMEDRIVE%\ForeverUtil
COPY /Y speedtest.exe %HOMEDRIVE%\ForeverUtil
COPY /Y terminator.exe %HOMEDRIVE%\ForeverUtil
COPY /Y ntsd.exe %HOMEDRIVE%\ForeverUtil
COPY /Y time-trans.exe %HOMEDRIVE%\ForeverUtil
COPY /Y UltraISO.exe %HOMEDRIVE%\ForeverUtil
COPY /Y VCRUNTIME140.DLL %HOMEDRIVE%\ForeverUtil
COPY /Y vcruntime140_1.dll %HOMEDRIVE%\ForeverUtil
rem COPY /Y fplayer.cmd %HOMEDRIVE%\ForeverUtil
COPY /Y msvcp140.dll %HOMEDRIVE%\ForeverUtil
XCOPY Module %HOMEDRIVE%\ForeverUtil\ /E
XCOPY fastgithub %HOMEDRIVE%\ForeverUtil\ /E
XCOPY gsudo %HOMEDRIVE%\ForeverUtil\ /E
rem SETX path "%path%;%HOMEDRIVE%\ForeverUTIL"
rem SETX path "%path%;%HOMEDRIVE%\ForeverUTIL\gsudo"
rem SETX path "%path%;%HOMEDRIVE%\ForeverUtil"
rem COPY /Y Add-PathEnvironmentVariable.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y e.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y e.cmd %HOMEDRIVE%\ForeverUtil\
COPY /Y init-powershell.ps1 %HOMEDRIVE%\ForeverUtil\
rem COPY /Y Add-PathEnvironmentVariable.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y get-directory-size.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y toHex.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y JetClean.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y sysmonitor.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y dllexp.cfg %HOMEDRIVE%\ForeverUtil\
COPY /Y dllexp.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y dllexp.chm %HOMEDRIVE%\ForeverUtil\
COPY /Y easyx-help.chm %HOMEDRIVE%\ForeverUtil\
COPY /Y fcopy-binary.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y hash.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y Everything.exe %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-Hex.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-KB.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-MB.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-GB.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-TB.ps1 %HOMEDRIVE%\ForeverUtil\
COPY /Y Convert-to-PB.ps1 %HOMEDRIVE%\ForeverUtil\

rem COPY /Y fplayer.cmd %HOMEDRIVE%%HOMEPATH%\Desktop
rem COPY /Y Start-FastGithub.cmd %HOMEDRIVE%%HOMEPATH%\Desktop
rem COPY /Y Stop-FastGithub.cmd %HOMEDRIVE%%HOMEPATH%\Desktop

powershell %HOMEDRIVE%\ForeverUtil\init-powershell.ps1 "%HOMEDRIVE%\ForeverUtil"
rem CALL %HOMEDRIVE%\ForeverUtil\Start-FastGithub.exe
ECHO Initiated!
PING 127.0.0.1 -n 3 >nul
EXIT