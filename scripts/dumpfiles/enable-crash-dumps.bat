reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting" /f /t REG_DWORD /v Disabled /d 0
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /f /t REG_DWORD /v DefaultConsent /d 4
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps" /f /t REG_EXPAND_SZ /v DumpFolder /d C:\dev\crashdumps
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps" /f /t REG_DWORD /v DumpType /d 2
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps" /f /t REG_DWORD /v DumpCount /d 12000
