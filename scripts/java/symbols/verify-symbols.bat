@echo off

if "%~4"=="" (
    echo Usage: %0 ^<arch^> ^<psu^> ^<jdkrepo^> ^<jdktag^>
    echo Example: %0 x64 2025-07 jdk21u jdk-21.0.6+7
    exit /b 1
)

set arch=%1
set psu=%2
set jdkrepo=%3
set jdktag=%4

cd D:\java\binaries\jdk\%arch%\%psu%\

set psudir=D:\java\binaries\jdk\%arch%\%psu%\windows-%jdkrepo%
echo PSU Directory: %psudir%

"C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\symchk.exe" /od /pf /r /if %psudir%\%jdktag%\bin\*.exe /s %psudir%\%jdktag%-debug-symbols\bin /av

"C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\symchk.exe" /od /pf /r %psudir%\%jdktag%\bin\*.dll /s "%psudir%\%jdktag%-debug-symbols\bin;%psudir%\%jdktag%-debug-symbols\bin\server;%psudir%\%jdktag%-debug-symbols\bin\client" /ea symchk-exclusion-list.txt
