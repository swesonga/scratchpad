; CPack install script designed for a nmake build

;--------------------------------
; You must define these values

  !define VERSION "15.0.0"
  !define PATCH  "0"
  !define INST_DIR "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/build32_stage0/_CPack_Packages/win32/NSIS/LLVM-15.0.0-win32"

;--------------------------------
;Variables

  Var MUI_TEMP
  Var STARTMENU_FOLDER
  Var SV_ALLUSERS
  Var START_MENU
  Var DO_NOT_ADD_TO_PATH
  Var ADD_TO_PATH_ALL_USERS
  Var ADD_TO_PATH_CURRENT_USER
  Var INSTALL_DESKTOP
  Var IS_DEFAULT_INSTALLDIR
;--------------------------------
;Include Modern UI

  !include "MUI.nsh"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\LLVM"

;--------------------------------
;General

  ;Name and file
  Name "LLVM"
  OutFile "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/build32_stage0/_CPack_Packages/win32/NSIS/LLVM-15.0.0-win32.exe"

  ;Set compression
  SetCompressor /SOLID lzma 
 SetCompressorDictSize 32

  ;Require administrator access
  RequestExecutionLevel admin





  !include Sections.nsh

;--- Component support macros: ---
; The code for the add/remove functionality is from:
;   https://nsis.sourceforge.io/Add/Remove_Functionality
; It has been modified slightly and extended to provide
; inter-component dependencies.
Var AR_SecFlags
Var AR_RegFlags


; Loads the "selected" flag for the section named SecName into the
; variable VarName.
!macro LoadSectionSelectedIntoVar SecName VarName
 SectionGetFlags ${${SecName}} $${VarName}
 IntOp $${VarName} $${VarName} & ${SF_SELECTED}  ;Turn off all other bits
!macroend

; Loads the value of a variable... can we get around this?
!macro LoadVar VarName
  IntOp $R0 0 + $${VarName}
!macroend

; Sets the value of a variable
!macro StoreVar VarName IntValue
  IntOp $${VarName} 0 + ${IntValue}
!macroend

!macro InitSection SecName
  ;  This macro reads component installed flag from the registry and
  ;changes checked state of the section on the components page.
  ;Input: section index constant name specified in Section command.

  ClearErrors
  ;Reading component status from registry
  ReadRegDWORD $AR_RegFlags HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM\Components\${SecName}" "Installed"
  IfErrors "default_${SecName}"
    ;Status will stay default if registry value not found
    ;(component was never installed)
  IntOp $AR_RegFlags $AR_RegFlags & ${SF_SELECTED} ;Turn off all other bits
  SectionGetFlags ${${SecName}} $AR_SecFlags  ;Reading default section flags
  IntOp $AR_SecFlags $AR_SecFlags & 0xFFFE  ;Turn lowest (enabled) bit off
  IntOp $AR_SecFlags $AR_RegFlags | $AR_SecFlags      ;Change lowest bit

  ; Note whether this component was installed before
  !insertmacro StoreVar ${SecName}_was_installed $AR_RegFlags
  IntOp $R0 $AR_RegFlags & $AR_RegFlags

  ;Writing modified flags
  SectionSetFlags ${${SecName}} $AR_SecFlags

 "default_${SecName}:"
 !insertmacro LoadSectionSelectedIntoVar ${SecName} ${SecName}_selected
!macroend

!macro FinishSection SecName
  ;  This macro reads section flag set by user and removes the section
  ;if it is not selected.
  ;Then it writes component installed flag to registry
  ;Input: section index constant name specified in Section command.

  SectionGetFlags ${${SecName}} $AR_SecFlags  ;Reading section flags
  ;Checking lowest bit:
  IntOp $AR_SecFlags $AR_SecFlags & ${SF_SELECTED}
  IntCmp $AR_SecFlags 1 "leave_${SecName}"
    ;Section is not selected:
    ;Calling Section uninstall macro and writing zero installed flag
    !insertmacro "Remove_${${SecName}}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM\Components\${SecName}" \
  "Installed" 0
    Goto "exit_${SecName}"

 "leave_${SecName}:"
    ;Section is selected:
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM\Components\${SecName}" \
  "Installed" 1

 "exit_${SecName}:"
!macroend

!macro RemoveSection_CPack SecName
  ;  This macro is used to call section's Remove_... macro
  ;from the uninstaller.
  ;Input: section index constant name specified in Section command.

  !insertmacro "Remove_${${SecName}}"
!macroend

; Determine whether the selection of SecName changed
!macro MaybeSelectionChanged SecName
  !insertmacro LoadVar ${SecName}_selected
  SectionGetFlags ${${SecName}} $R1
  IntOp $R1 $R1 & ${SF_SELECTED} ;Turn off all other bits

  ; See if the status has changed:
  IntCmp $R0 $R1 "${SecName}_unchanged"
  !insertmacro LoadSectionSelectedIntoVar ${SecName} ${SecName}_selected

  IntCmp $R1 ${SF_SELECTED} "${SecName}_was_selected"
  !insertmacro "Deselect_required_by_${SecName}"
  goto "${SecName}_unchanged"

  "${SecName}_was_selected:"
  !insertmacro "Select_${SecName}_depends"

  "${SecName}_unchanged:"
!macroend
;--- End of Add/Remove macros ---

;--------------------------------
;Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_ABORTWARNING

;----------------------------------------
; based upon a script of "Written by KiCHiK 2003-01-18 05:57:02"
;----------------------------------------
!verbose 3
!include "WinMessages.NSH"
!verbose 4
;====================================================
; get_NT_environment
;     Returns: the selected environment
;     Output : head of the stack
;====================================================
!macro select_NT_profile UN
Function ${UN}select_NT_profile
   StrCmp $ADD_TO_PATH_ALL_USERS "1" 0 environment_single
      DetailPrint "Selected environment for all users"
      Push "all"
      Return
   environment_single:
      DetailPrint "Selected environment for current user only."
      Push "current"
      Return
FunctionEnd
!macroend
!insertmacro select_NT_profile ""
!insertmacro select_NT_profile "un."
;----------------------------------------------------
!define NT_current_env 'HKCU "Environment"'
!define NT_all_env     'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

!ifndef WriteEnvStr_RegKey
  !ifdef ALL_USERS
    !define WriteEnvStr_RegKey \
       'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
  !else
    !define WriteEnvStr_RegKey 'HKCU "Environment"'
  !endif
!endif

; AddToPath - Adds the given dir to the search path.
;        Input - head of the stack
;        Note - Win9x systems requires reboot

Function AddToPath
  Exch $0
  Push $1
  Push $2
  Push $3

  # don't add if the path doesn't exist
  IfFileExists "$0\*.*" "" AddToPath_done

  ReadEnvStr $1 PATH
  ; if the path is too long for a NSIS variable NSIS will return a 0
  ; length string.  If we find that, then warn and skip any path
  ; modification as it will trash the existing path.
  StrLen $2 $1
  IntCmp $2 0 CheckPathLength_ShowPathWarning CheckPathLength_Done CheckPathLength_Done
    CheckPathLength_ShowPathWarning:
    Messagebox MB_OK|MB_ICONEXCLAMATION "Warning! PATH too long installer unable to modify PATH!"
    Goto AddToPath_done
  CheckPathLength_Done:
  Push "$1;"
  Push "$0;"
  Call StrStr
  Pop $2
  StrCmp $2 "" "" AddToPath_done
  Push "$1;"
  Push "$0\;"
  Call StrStr
  Pop $2
  StrCmp $2 "" "" AddToPath_done
  GetFullPathName /SHORT $3 $0
  Push "$1;"
  Push "$3;"
  Call StrStr
  Pop $2
  StrCmp $2 "" "" AddToPath_done
  Push "$1;"
  Push "$3\;"
  Call StrStr
  Pop $2
  StrCmp $2 "" "" AddToPath_done

  Call IsNT
  Pop $1
  StrCmp $1 1 AddToPath_NT
    ; Not on NT
    StrCpy $1 $WINDIR 2
    FileOpen $1 "$1\autoexec.bat" a
    FileSeek $1 -1 END
    FileReadByte $1 $2
    IntCmp $2 26 0 +2 +2 # DOS EOF
      FileSeek $1 -1 END # write over EOF
    FileWrite $1 "$\r$\nSET PATH=%PATH%;$3$\r$\n"
    FileClose $1
    SetRebootFlag true
    Goto AddToPath_done

  AddToPath_NT:
    StrCmp $ADD_TO_PATH_ALL_USERS "1" ReadAllKey
      ReadRegStr $1 ${NT_current_env} "PATH"
      Goto DoTrim
    ReadAllKey:
      ReadRegStr $1 ${NT_all_env} "PATH"
    DoTrim:
    StrCmp $1 "" AddToPath_NTdoIt
      Push $1
      Call Trim
      Pop $1
      StrCpy $0 "$1;$0"
    AddToPath_NTdoIt:
      StrCmp $ADD_TO_PATH_ALL_USERS "1" WriteAllKey
        WriteRegExpandStr ${NT_current_env} "PATH" $0
        Goto DoSend
      WriteAllKey:
        WriteRegExpandStr ${NT_all_env} "PATH" $0
      DoSend:
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  AddToPath_done:
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd


; RemoveFromPath - Remove a given dir from the path
;     Input: head of the stack

Function un.RemoveFromPath
  Exch $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6

  IntFmt $6 "%c" 26 # DOS EOF

  Call un.IsNT
  Pop $1
  StrCmp $1 1 unRemoveFromPath_NT
    ; Not on NT
    StrCpy $1 $WINDIR 2
    FileOpen $1 "$1\autoexec.bat" r
    GetTempFileName $4
    FileOpen $2 $4 w
    GetFullPathName /SHORT $0 $0
    StrCpy $0 "SET PATH=%PATH%;$0"
    Goto unRemoveFromPath_dosLoop

    unRemoveFromPath_dosLoop:
      FileRead $1 $3
      StrCpy $5 $3 1 -1 # read last char
      StrCmp $5 $6 0 +2 # if DOS EOF
        StrCpy $3 $3 -1 # remove DOS EOF so we can compare
      StrCmp $3 "$0$\r$\n" unRemoveFromPath_dosLoopRemoveLine
      StrCmp $3 "$0$\n" unRemoveFromPath_dosLoopRemoveLine
      StrCmp $3 "$0" unRemoveFromPath_dosLoopRemoveLine
      StrCmp $3 "" unRemoveFromPath_dosLoopEnd
      FileWrite $2 $3
      Goto unRemoveFromPath_dosLoop
      unRemoveFromPath_dosLoopRemoveLine:
        SetRebootFlag true
        Goto unRemoveFromPath_dosLoop

    unRemoveFromPath_dosLoopEnd:
      FileClose $2
      FileClose $1
      StrCpy $1 $WINDIR 2
      Delete "$1\autoexec.bat"
      CopyFiles /SILENT $4 "$1\autoexec.bat"
      Delete $4
      Goto unRemoveFromPath_done

  unRemoveFromPath_NT:
    StrCmp $ADD_TO_PATH_ALL_USERS "1" unReadAllKey
      ReadRegStr $1 ${NT_current_env} "PATH"
      Goto unDoTrim
    unReadAllKey:
      ReadRegStr $1 ${NT_all_env} "PATH"
    unDoTrim:
    StrCpy $5 $1 1 -1 # copy last char
    StrCmp $5 ";" +2 # if last char != ;
      StrCpy $1 "$1;" # append ;
    Push $1
    Push "$0;"
    Call un.StrStr ; Find `$0;` in $1
    Pop $2 ; pos of our dir
    StrCmp $2 "" unRemoveFromPath_done
      ; else, it is in path
      # $0 - path to add
      # $1 - path var
      StrLen $3 "$0;"
      StrLen $4 $2
      StrCpy $5 $1 -$4 # $5 is now the part before the path to remove
      StrCpy $6 $2 "" $3 # $6 is now the part after the path to remove
      StrCpy $3 $5$6

      StrCpy $5 $3 1 -1 # copy last char
      StrCmp $5 ";" 0 +2 # if last char == ;
        StrCpy $3 $3 -1 # remove last char

      StrCmp $ADD_TO_PATH_ALL_USERS "1" unWriteAllKey
        WriteRegExpandStr ${NT_current_env} "PATH" $3
        Goto unDoSend
      unWriteAllKey:
        WriteRegExpandStr ${NT_all_env} "PATH" $3
      unDoSend:
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  unRemoveFromPath_done:
    Pop $6
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uninstall stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

###########################################
#            Utility Functions            #
###########################################

;====================================================
; IsNT - Returns 1 if the current system is NT, 0
;        otherwise.
;     Output: head of the stack
;====================================================
; IsNT
; no input
; output, top of the stack = 1 if NT or 0 if not
;
; Usage:
;   Call IsNT
;   Pop $R0
;  ($R0 at this point is 1 or 0)

!macro IsNT un
Function ${un}IsNT
  Push $0
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp $0 "" 0 IsNT_yes
  ; we are not NT.
  Pop $0
  Push 0
  Return

  IsNT_yes:
    ; NT!!!
    Pop $0
    Push 1
FunctionEnd
!macroend
!insertmacro IsNT ""
!insertmacro IsNT "un."

; StrStr
; input, top of stack = string to search for
;        top of stack-1 = string to search in
; output, top of stack (replaces with the portion of the string remaining)
; modifies no other variables.
;
; Usage:
;   Push "this is a long ass string"
;   Push "ass"
;   Call StrStr
;   Pop $R0
;  ($R0 at this point is "ass string")

!macro StrStr un
Function ${un}StrStr
Exch $R1 ; st=haystack,old$R1, $R1=needle
  Exch    ; st=old$R1,haystack
  Exch $R2 ; st=old$R1,old$R2, $R2=haystack
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
  ; $R1=needle
  ; $R2=haystack
  ; $R3=len(needle)
  ; $R4=cnt
  ; $R5=tmp
  loop:
    StrCpy $R5 $R2 $R3 $R4
    StrCmp $R5 $R1 done
    StrCmp $R5 "" done
    IntOp $R4 $R4 + 1
    Goto loop
done:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd
!macroend
!insertmacro StrStr ""
!insertmacro StrStr "un."

Function Trim ; Added by Pelaca
	Exch $R1
	Push $R2
Loop:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " RTrim
	StrCmp "$R2" "$\n" RTrim
	StrCmp "$R2" "$\r" RTrim
	StrCmp "$R2" ";" RTrim
	GoTo Done
RTrim:
	StrCpy $R1 "$R1" -1
	Goto Loop
Done:
	Pop $R2
	Exch $R1
FunctionEnd

Function ConditionalAddToRegistry
  Pop $0
  Pop $1
  StrCmp "$0" "" ConditionalAddToRegistry_EmptyString
    WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" \
    "$1" "$0"
    ;MessageBox MB_OK "Set Registry: '$1' to '$0'"
    DetailPrint "Set install registry entry: '$1' to '$0'"
  ConditionalAddToRegistry_EmptyString:
FunctionEnd

;--------------------------------

!ifdef CPACK_USES_DOWNLOAD
Function DownloadFile
    IfFileExists $INSTDIR\* +2
    CreateDirectory $INSTDIR
    Pop $0

    ; Skip if already downloaded
    IfFileExists $INSTDIR\$0 0 +2
    Return

    StrCpy $1 ""

  try_again:
    NSISdl::download "$1/$0" "$INSTDIR\$0"

    Pop $1
    StrCmp $1 "success" success
    StrCmp $1 "Cancelled" cancel
    MessageBox MB_OK "Download failed: $1"
  cancel:
    Return
  success:
FunctionEnd
!endif

;--------------------------------
; Define some macro setting for the gui
!define MUI_ICON "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/llvm-project/llvm\cmake\nsis_icon.ico"
!define MUI_UNICON "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/llvm-project/llvm\cmake\nsis_icon.ico"

!define MUI_HEADERIMAGE_BITMAP "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/llvm-project/llvm\cmake\nsis_logo.bmp"





;--------------------------------
;Pages
  
  
  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_LICENSE "C:/dev/repos/llvm-project/llvm/utils/release/llvm_package_15.0.0/llvm-project/llvm/LICENSE.TXT"

  Page custom InstallOptionsPage
  !insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "SHCTX"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\LLVM\LLVM"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER

  

  !insertmacro MUI_PAGE_INSTFILES
  
  
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Asturian"
  !insertmacro MUI_LANGUAGE "Basque"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Corsican"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Esperanto"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Pashto"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "ScotsGaelic"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Tatar"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Vietnamese"
  !insertmacro MUI_LANGUAGE "Welsh"

;--------------------------------
;Reserve Files

  ;These files should be inserted before other files in the data block
  ;Keep these lines before any File command
  ;Only for solid compression (by default, solid compression is enabled for BZIP2 and LZMA)

  ReserveFile "NSIS.InstallOptions.ini"
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

  ; for UserInfo::GetName and UserInfo::GetAccountType
  ReserveFile /plugin 'UserInfo.dll'

;--------------------------------
; Installation types


;--------------------------------
; Component sections


;--------------------------------
;Installer Sections

Section "-Core installation"
  ;Use the entire tree produced by the INSTALL target.  Keep the
  ;list of directories here in sync with the RMDir commands below.
  SetOutPath "$INSTDIR"
  
  File /r "${INST_DIR}\*.*"

  ;Store installation folder
  WriteRegStr SHCTX "Software\LLVM\LLVM" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  Push "DisplayName"
  Push "LLVM"
  Call ConditionalAddToRegistry
  Push "DisplayVersion"
  Push "15.0.0"
  Call ConditionalAddToRegistry
  Push "Publisher"
  Push "LLVM"
  Call ConditionalAddToRegistry
  Push "UninstallString"
  Push "$\"$INSTDIR\Uninstall.exe$\""
  Call ConditionalAddToRegistry
  Push "NoRepair"
  Push "1"
  Call ConditionalAddToRegistry

  !ifdef CPACK_NSIS_ADD_REMOVE
  ;Create add/remove functionality
  Push "ModifyPath"
  Push "$INSTDIR\AddRemove.exe"
  Call ConditionalAddToRegistry
  !else
  Push "NoModify"
  Push "1"
  Call ConditionalAddToRegistry
  !endif

  ; Optional registration
  Push "DisplayIcon"
  Push "$INSTDIR\"
  Call ConditionalAddToRegistry
  Push "HelpLink"
  Push ""
  Call ConditionalAddToRegistry
  Push "URLInfoAbout"
  Push ""
  Call ConditionalAddToRegistry
  Push "Contact"
  Push ""
  Call ConditionalAddToRegistry
  !insertmacro MUI_INSTALLOPTIONS_READ $INSTALL_DESKTOP "NSIS.InstallOptions.ini" "Field 5" "State"
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

  ;Create shortcuts
  CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"


  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

  ;Read a value from an InstallOptions INI file
  !insertmacro MUI_INSTALLOPTIONS_READ $DO_NOT_ADD_TO_PATH "NSIS.InstallOptions.ini" "Field 2" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $ADD_TO_PATH_ALL_USERS "NSIS.InstallOptions.ini" "Field 3" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $ADD_TO_PATH_CURRENT_USER "NSIS.InstallOptions.ini" "Field 4" "State"

  ; Write special uninstall registry entries
  Push "StartMenu"
  Push "$STARTMENU_FOLDER"
  Call ConditionalAddToRegistry
  Push "DoNotAddToPath"
  Push "$DO_NOT_ADD_TO_PATH"
  Call ConditionalAddToRegistry
  Push "AddToPathAllUsers"
  Push "$ADD_TO_PATH_ALL_USERS"
  Call ConditionalAddToRegistry
  Push "AddToPathCurrentUser"
  Push "$ADD_TO_PATH_CURRENT_USER"
  Call ConditionalAddToRegistry
  Push "InstallToDesktop"
  Push "$INSTALL_DESKTOP"
  Call ConditionalAddToRegistry

  !insertmacro MUI_STARTMENU_WRITE_END



SectionEnd

Section "-Add to path"
  Push $INSTDIR\bin
  StrCmp "ON" "ON" 0 doNotAddToPath
  StrCmp $DO_NOT_ADD_TO_PATH "1" doNotAddToPath 0
    Call AddToPath
  doNotAddToPath:
SectionEnd

;--------------------------------
; Create custom pages
Function InstallOptionsPage
  !insertmacro MUI_HEADER_TEXT "Install Options" "Choose options for installing LLVM"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "NSIS.InstallOptions.ini"

FunctionEnd

;--------------------------------
; determine admin versus local install
Function un.onInit

  ClearErrors
  UserInfo::GetName
  IfErrors noLM
  Pop $0
  UserInfo::GetAccountType
  Pop $1
  StrCmp $1 "Admin" 0 +3
    SetShellVarContext all
    ;MessageBox MB_OK 'User "$0" is in the Admin group'
    Goto done
  StrCmp $1 "Power" 0 +3
    SetShellVarContext all
    ;MessageBox MB_OK 'User "$0" is in the Power Users group'
    Goto done

  noLM:
    ;Get installation folder from registry if available

  done:

FunctionEnd

;--- Add/Remove callback functions: ---
!macro SectionList MacroName
  ;This macro used to perform operation on multiple sections.
  ;List all of your components in following manner here.

!macroend

Section -FinishComponents
  ;Removes unselected components and writes component status to registry
  !insertmacro SectionList "FinishSection"

!ifdef CPACK_NSIS_ADD_REMOVE
  ; Get the name of the installer executable
  System::Call 'kernel32::GetModuleFileNameA(i 0, t .R0, i 1024) i r1'
  StrCpy $R3 $R0

  ; Strip off the last 13 characters, to see if we have AddRemove.exe
  StrLen $R1 $R0
  IntOp $R1 $R0 - 13
  StrCpy $R2 $R0 13 $R1
  StrCmp $R2 "AddRemove.exe" addremove_installed

  ; We're not running AddRemove.exe, so install it
  CopyFiles $R3 $INSTDIR\AddRemove.exe

  addremove_installed:
!endif
SectionEnd
;--- End of Add/Remove callback functions ---

;--------------------------------
; Component dependencies
Function .onSelChange
  !insertmacro SectionList MaybeSelectionChanged
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  ReadRegStr $START_MENU SHCTX \
   "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "StartMenu"
  ;MessageBox MB_OK "Start menu is in: $START_MENU"
  ReadRegStr $DO_NOT_ADD_TO_PATH SHCTX \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "DoNotAddToPath"
  ReadRegStr $ADD_TO_PATH_ALL_USERS SHCTX \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "AddToPathAllUsers"
  ReadRegStr $ADD_TO_PATH_CURRENT_USER SHCTX \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "AddToPathCurrentUser"
  ;MessageBox MB_OK "Add to path: $DO_NOT_ADD_TO_PATH all users: $ADD_TO_PATH_ALL_USERS"
  ReadRegStr $INSTALL_DESKTOP SHCTX \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "InstallToDesktop"
  ;MessageBox MB_OK "Install to desktop: $INSTALL_DESKTOP "



  ;Remove files we installed.
  ;Keep the list of directories here in sync with the File commands above.
  Delete "$INSTDIR\bin"
  Delete "$INSTDIR\bin\analyze-build"
  Delete "$INSTDIR\bin\api-ms-win-core-console-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-console-l1-2-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-datetime-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-debug-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-errorhandling-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-fibers-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-file-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-file-l1-2-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-file-l2-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-handle-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-heap-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-interlocked-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-libraryloader-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-localization-l1-2-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-memory-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-namedpipe-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-processenvironment-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-processthreads-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-processthreads-l1-1-1.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-profile-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-rtlsupport-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-string-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-synch-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-synch-l1-2-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-sysinfo-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-timezone-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-core-util-l1-1-0.dll"
  Delete "$INSTDIR\bin\API-MS-Win-core-xstate-l2-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-conio-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-convert-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-environment-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-filesystem-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-heap-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-locale-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-math-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-multibyte-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-private-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-process-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-runtime-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-stdio-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-string-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-time-l1-1-0.dll"
  Delete "$INSTDIR\bin\api-ms-win-crt-utility-l1-1-0.dll"
  Delete "$INSTDIR\bin\clang++.exe"
  Delete "$INSTDIR\bin\clang-apply-replacements.exe"
  Delete "$INSTDIR\bin\clang-change-namespace.exe"
  Delete "$INSTDIR\bin\clang-check.exe"
  Delete "$INSTDIR\bin\clang-cl.exe"
  Delete "$INSTDIR\bin\clang-cpp.exe"
  Delete "$INSTDIR\bin\clang-doc.exe"
  Delete "$INSTDIR\bin\clang-extdef-mapping.exe"
  Delete "$INSTDIR\bin\clang-format.exe"
  Delete "$INSTDIR\bin\clang-include-fixer.exe"
  Delete "$INSTDIR\bin\clang-linker-wrapper.exe"
  Delete "$INSTDIR\bin\clang-move.exe"
  Delete "$INSTDIR\bin\clang-nvlink-wrapper.exe"
  Delete "$INSTDIR\bin\clang-offload-bundler.exe"
  Delete "$INSTDIR\bin\clang-offload-packager.exe"
  Delete "$INSTDIR\bin\clang-offload-wrapper.exe"
  Delete "$INSTDIR\bin\clang-pseudo.exe"
  Delete "$INSTDIR\bin\clang-query.exe"
  Delete "$INSTDIR\bin\clang-refactor.exe"
  Delete "$INSTDIR\bin\clang-rename.exe"
  Delete "$INSTDIR\bin\clang-reorder-fields.exe"
  Delete "$INSTDIR\bin\clang-repl.exe"
  Delete "$INSTDIR\bin\clang-scan-deps.exe"
  Delete "$INSTDIR\bin\clang-tidy.exe"
  Delete "$INSTDIR\bin\clang.exe"
  Delete "$INSTDIR\bin\clangd.exe"
  Delete "$INSTDIR\bin\concrt140.dll"
  Delete "$INSTDIR\bin\diagtool.exe"
  Delete "$INSTDIR\bin\find-all-symbols.exe"
  Delete "$INSTDIR\bin\git-clang-format"
  Delete "$INSTDIR\bin\hmaptool"
  Delete "$INSTDIR\bin\intercept-build"
  Delete "$INSTDIR\bin\ld.lld.exe"
  Delete "$INSTDIR\bin\ld64.lld.exe"
  Delete "$INSTDIR\bin\libclang.dll"
  Delete "$INSTDIR\bin\liblldb.dll"
  Delete "$INSTDIR\bin\libomp.dll"
  Delete "$INSTDIR\bin\lld-link.exe"
  Delete "$INSTDIR\bin\lld.exe"
  Delete "$INSTDIR\bin\lldb-argdumper.exe"
  Delete "$INSTDIR\bin\lldb-instr.exe"
  Delete "$INSTDIR\bin\lldb-server.exe"
  Delete "$INSTDIR\bin\lldb-vscode.exe"
  Delete "$INSTDIR\bin\lldb.exe"
  Delete "$INSTDIR\bin\llvm-ar.exe"
  Delete "$INSTDIR\bin\LLVM-C.dll"
  Delete "$INSTDIR\bin\llvm-cov.exe"
  Delete "$INSTDIR\bin\llvm-cxxfilt.exe"
  Delete "$INSTDIR\bin\llvm-dwp.exe"
  Delete "$INSTDIR\bin\llvm-lib.exe"
  Delete "$INSTDIR\bin\llvm-ml.exe"
  Delete "$INSTDIR\bin\llvm-nm.exe"
  Delete "$INSTDIR\bin\llvm-objcopy.exe"
  Delete "$INSTDIR\bin\llvm-objdump.exe"
  Delete "$INSTDIR\bin\llvm-pdbutil.exe"
  Delete "$INSTDIR\bin\llvm-profdata.exe"
  Delete "$INSTDIR\bin\llvm-ranlib.exe"
  Delete "$INSTDIR\bin\llvm-rc.exe"
  Delete "$INSTDIR\bin\llvm-readobj.exe"
  Delete "$INSTDIR\bin\llvm-size.exe"
  Delete "$INSTDIR\bin\llvm-strings.exe"
  Delete "$INSTDIR\bin\llvm-strip.exe"
  Delete "$INSTDIR\bin\llvm-symbolizer.exe"
  Delete "$INSTDIR\bin\LTO.dll"
  Delete "$INSTDIR\bin\modularize.exe"
  Delete "$INSTDIR\bin\msvcp140.dll"
  Delete "$INSTDIR\bin\msvcp140_1.dll"
  Delete "$INSTDIR\bin\msvcp140_2.dll"
  Delete "$INSTDIR\bin\msvcp140_atomic_wait.dll"
  Delete "$INSTDIR\bin\msvcp140_codecvt_ids.dll"
  Delete "$INSTDIR\bin\pp-trace.exe"
  Delete "$INSTDIR\bin\Remarks.dll"
  Delete "$INSTDIR\bin\run-clang-tidy"
  Delete "$INSTDIR\bin\scan-build"
  Delete "$INSTDIR\bin\scan-build-py"
  Delete "$INSTDIR\bin\scan-build.bat"
  Delete "$INSTDIR\bin\scan-view"
  Delete "$INSTDIR\bin\ucrtbase.dll"
  Delete "$INSTDIR\bin\vcruntime140.dll"
  Delete "$INSTDIR\bin\wasm-ld.exe"
  Delete "$INSTDIR\include"
  Delete "$INSTDIR\include\clang-c"
  Delete "$INSTDIR\include\clang-c\BuildSystem.h"
  Delete "$INSTDIR\include\clang-c\CXCompilationDatabase.h"
  Delete "$INSTDIR\include\clang-c\CXErrorCode.h"
  Delete "$INSTDIR\include\clang-c\CXString.h"
  Delete "$INSTDIR\include\clang-c\Documentation.h"
  Delete "$INSTDIR\include\clang-c\ExternC.h"
  Delete "$INSTDIR\include\clang-c\FatalErrorHandler.h"
  Delete "$INSTDIR\include\clang-c\Index.h"
  Delete "$INSTDIR\include\clang-c\Platform.h"
  Delete "$INSTDIR\include\clang-c\Rewrite.h"
  Delete "$INSTDIR\include\llvm-c"
  Delete "$INSTDIR\include\llvm-c\lto.h"
  Delete "$INSTDIR\include\llvm-c\Remarks.h"
  Delete "$INSTDIR\lib"
  Delete "$INSTDIR\lib\clang"
  Delete "$INSTDIR\lib\clang\15.0.0"
  Delete "$INSTDIR\lib\clang\15.0.0\include"
  Delete "$INSTDIR\lib\clang\15.0.0\include\adxintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\altivec.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ammintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\amxintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm64intr.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\armintr.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_acle.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_bf16.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_cde.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_cmse.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_fp16.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_mve.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_neon.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\arm_sve.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx2intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512bf16intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512bitalgintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512bwintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512cdintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512dqintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512erintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512fintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512fp16intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512ifmaintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512ifmavlintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512pfintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vbmi2intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vbmiintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vbmivlintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlbf16intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlbitalgintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlbwintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlcdintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vldqintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlfp16intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlvbmi2intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlvnniintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vlvp2intersectintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vnniintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vp2intersectintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vpopcntdqintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avx512vpopcntdqvlintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avxintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\avxvnniintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\bmi2intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\bmiintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\builtins.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cet.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cetintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cldemoteintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\clflushoptintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\clwbintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\clzerointrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cpuid.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\crc32intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cuda_wrappers"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cuda_wrappers\algorithm"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cuda_wrappers\complex"
  Delete "$INSTDIR\lib\clang\15.0.0\include\cuda_wrappers\new"
  Delete "$INSTDIR\lib\clang\15.0.0\include\emmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\enqcmdintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\f16cintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\float.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\fma4intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\fmaintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\fuzzer"
  Delete "$INSTDIR\lib\clang\15.0.0\include\fuzzer\FuzzedDataProvider.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\fxsrintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\gfniintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hexagon_circ_brev_intrinsics.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hexagon_protos.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hexagon_types.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hlsl.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hlsl_basic_types.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hlsl_intrinsics.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hresetintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\htmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\htmxlintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\hvx_hexagon_protos.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ia32intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\immintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\inttypes.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\invpcidintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\iso646.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\keylockerintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\limits.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\lwpintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\lzcntintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\mm3dnow.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\mmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\mm_malloc.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\module.modulemap"
  Delete "$INSTDIR\lib\clang\15.0.0\include\movdirintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\msa.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\mwaitxintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\nmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\omp.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\opencl-c-base.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\opencl-c.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\cmath"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\complex"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\complex.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\complex_cmath.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\math.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\new"
  Delete "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers\__clang_openmp_device_functions.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\orc"
  Delete "$INSTDIR\lib\clang\15.0.0\include\orc\c_api.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\pconfigintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\pkuintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\pmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\popcntintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\bmi2intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\bmiintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\emmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\immintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\mmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\mm_malloc.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\pmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\smmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\tmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\x86gprintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\x86intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers\xmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\prfchwintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\profile"
  Delete "$INSTDIR\lib\clang\15.0.0\include\profile\InstrProfData.inc"
  Delete "$INSTDIR\lib\clang\15.0.0\include\ptwriteintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\rdpruintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\rdseedintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\riscv_vector.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\rtmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\s390intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\allocator_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\asan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\common_interface_defs.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\coverage_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\dfsan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\hwasan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\linux_syscall_hooks.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\lsan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\msan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\netbsd_syscall_hooks.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\scudo_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\tsan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\tsan_interface_atomic.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sanitizer\ubsan_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\serializeintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\sgxintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\shaintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\smmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdalign.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdarg.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdatomic.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdbool.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stddef.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdint.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\stdnoreturn.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\tbmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\tgmath.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\tmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\tsxldtrkintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\uintrintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\unwind.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\vadefs.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\vaesintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\varargs.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\vecintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\velintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\velintrin_approx.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\velintrin_gen.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\vpclmulqdqintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\waitpkgintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\wasm_simd128.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\wbnoinvdintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\wmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\x86gprintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\x86intrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xmmintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xopintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xray"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xray\xray_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xray\xray_log_interface.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xray\xray_records.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xsavecintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xsaveintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xsaveoptintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xsavesintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\xtestintrin.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_builtin_vars.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_cmath.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_complex_builtins.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_device_functions.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_intrinsics.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_libdevice_declares.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_math.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_math_forward_declares.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_runtime_wrapper.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_cuda_texture_intrinsics.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_hip_cmath.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_hip_libdevice_declares.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_hip_math.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__clang_hip_runtime_wrapper.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__stddef_max_align_t.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__wmmintrin_aes.h"
  Delete "$INSTDIR\lib\clang\15.0.0\include\__wmmintrin_pclmul.h"
  Delete "$INSTDIR\lib\clang\15.0.0\lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan-preinit-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_cxx-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_dll_thunk-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_dynamic-i386.dll"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_dynamic-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_dynamic_runtime_thunk-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.asan_static-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.builtins-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.fuzzer-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.fuzzer_interceptors-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.fuzzer_no_main-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.profile-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.stats-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.stats_client-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.ubsan_standalone-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\lib\windows\clang_rt.ubsan_standalone_cxx-i386.lib"
  Delete "$INSTDIR\lib\clang\15.0.0\share"
  Delete "$INSTDIR\lib\clang\15.0.0\share\asan_ignorelist.txt"
  Delete "$INSTDIR\lib\clang\15.0.0\share\cfi_ignorelist.txt"
  Delete "$INSTDIR\lib\cmake"
  Delete "$INSTDIR\lib\cmake\llvm"
  Delete "$INSTDIR\lib\cmake\llvm\LLVMConfigExtensions.cmake"
  Delete "$INSTDIR\lib\libclang.lib"
  Delete "$INSTDIR\lib\libear"
  Delete "$INSTDIR\lib\libear\config.h.in"
  Delete "$INSTDIR\lib\libear\ear.c"
  Delete "$INSTDIR\lib\libear\__init__.py"
  Delete "$INSTDIR\lib\liblldb.lib"
  Delete "$INSTDIR\lib\libomp.lib"
  Delete "$INSTDIR\lib\libscanbuild"
  Delete "$INSTDIR\lib\libscanbuild\analyze.py"
  Delete "$INSTDIR\lib\libscanbuild\arguments.py"
  Delete "$INSTDIR\lib\libscanbuild\clang.py"
  Delete "$INSTDIR\lib\libscanbuild\compilation.py"
  Delete "$INSTDIR\lib\libscanbuild\intercept.py"
  Delete "$INSTDIR\lib\libscanbuild\report.py"
  Delete "$INSTDIR\lib\libscanbuild\resources"
  Delete "$INSTDIR\lib\libscanbuild\resources\scanview.css"
  Delete "$INSTDIR\lib\libscanbuild\resources\selectable.js"
  Delete "$INSTDIR\lib\libscanbuild\resources\sorttable.js"
  Delete "$INSTDIR\lib\libscanbuild\shell.py"
  Delete "$INSTDIR\lib\libscanbuild\__init__.py"
  Delete "$INSTDIR\lib\LLVM-C.lib"
  Delete "$INSTDIR\lib\LTO.lib"
  Delete "$INSTDIR\lib\Remarks.lib"
  Delete "$INSTDIR\libexec"
  Delete "$INSTDIR\libexec\analyze-c++"
  Delete "$INSTDIR\libexec\analyze-cc"
  Delete "$INSTDIR\libexec\c++-analyzer"
  Delete "$INSTDIR\libexec\c++-analyzer.bat"
  Delete "$INSTDIR\libexec\ccc-analyzer"
  Delete "$INSTDIR\libexec\ccc-analyzer.bat"
  Delete "$INSTDIR\libexec\intercept-c++"
  Delete "$INSTDIR\libexec\intercept-cc"
  Delete "$INSTDIR\share"
  Delete "$INSTDIR\share\clang"
  Delete "$INSTDIR\share\clang\clang-doc-default-stylesheet.css"
  Delete "$INSTDIR\share\clang\clang-format-bbedit.applescript"
  Delete "$INSTDIR\share\clang\clang-format-diff.py"
  Delete "$INSTDIR\share\clang\clang-format-sublime.py"
  Delete "$INSTDIR\share\clang\clang-format.el"
  Delete "$INSTDIR\share\clang\clang-format.py"
  Delete "$INSTDIR\share\clang\clang-include-fixer.el"
  Delete "$INSTDIR\share\clang\clang-include-fixer.py"
  Delete "$INSTDIR\share\clang\clang-rename.el"
  Delete "$INSTDIR\share\clang\clang-rename.py"
  Delete "$INSTDIR\share\clang\clang-tidy-diff.py"
  Delete "$INSTDIR\share\clang\index.js"
  Delete "$INSTDIR\share\clang\run-find-all-symbols.py"
  Delete "$INSTDIR\share\man"
  Delete "$INSTDIR\share\man\man1"
  Delete "$INSTDIR\share\man\man1\scan-build.1"
  Delete "$INSTDIR\share\opt-viewer"
  Delete "$INSTDIR\share\opt-viewer\opt-diff.py"
  Delete "$INSTDIR\share\opt-viewer\opt-stats.py"
  Delete "$INSTDIR\share\opt-viewer\opt-viewer.py"
  Delete "$INSTDIR\share\opt-viewer\optpmap.py"
  Delete "$INSTDIR\share\opt-viewer\optrecord.py"
  Delete "$INSTDIR\share\opt-viewer\style.css"
  Delete "$INSTDIR\share\scan-build"
  Delete "$INSTDIR\share\scan-build\scanview.css"
  Delete "$INSTDIR\share\scan-build\sorttable.js"
  Delete "$INSTDIR\share\scan-view"
  Delete "$INSTDIR\share\scan-view\bugcatcher.ico"
  Delete "$INSTDIR\share\scan-view\Reporter.py"
  Delete "$INSTDIR\share\scan-view\ScanView.py"
  Delete "$INSTDIR\share\scan-view\startfile.py"

  RMDir "$INSTDIR\bin"
  RMDir "$INSTDIR\include\clang-c"
  RMDir "$INSTDIR\include\llvm-c"
  RMDir "$INSTDIR\include"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\cuda_wrappers"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\fuzzer"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\openmp_wrappers"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\orc"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\ppc_wrappers"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\profile"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\sanitizer"
  RMDir "$INSTDIR\lib\clang\15.0.0\include\xray"
  RMDir "$INSTDIR\lib\clang\15.0.0\include"
  RMDir "$INSTDIR\lib\clang\15.0.0\lib\windows"
  RMDir "$INSTDIR\lib\clang\15.0.0\lib"
  RMDir "$INSTDIR\lib\clang\15.0.0\share"
  RMDir "$INSTDIR\lib\clang\15.0.0"
  RMDir "$INSTDIR\lib\clang"
  RMDir "$INSTDIR\lib\cmake\llvm"
  RMDir "$INSTDIR\lib\cmake"
  RMDir "$INSTDIR\lib\libear"
  RMDir "$INSTDIR\lib\libscanbuild\resources"
  RMDir "$INSTDIR\lib\libscanbuild"
  RMDir "$INSTDIR\lib"
  RMDir "$INSTDIR\libexec"
  RMDir "$INSTDIR\share\clang"
  RMDir "$INSTDIR\share\man\man1"
  RMDir "$INSTDIR\share\man"
  RMDir "$INSTDIR\share\opt-viewer"
  RMDir "$INSTDIR\share\scan-build"
  RMDir "$INSTDIR\share\scan-view"
  RMDir "$INSTDIR\share"


!ifdef CPACK_NSIS_ADD_REMOVE
  ;Remove the add/remove program
  Delete "$INSTDIR\AddRemove.exe"
!endif

  ;Remove the uninstaller itself.
  Delete "$INSTDIR\Uninstall.exe"
  DeleteRegKey SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM"

  ;Remove the installation directory if it is empty.
  RMDir "$INSTDIR"

  ; Remove the registry entries.
  DeleteRegKey SHCTX "Software\LLVM\LLVM"

  ; Removes all optional components
  !insertmacro SectionList "RemoveSection_CPack"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP

  Delete "$SMPROGRAMS\$MUI_TEMP\Uninstall.lnk"



  ;Delete empty start menu parent directories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"

  startMenuDeleteLoop:
    ClearErrors
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."

    IfErrors startMenuDeleteLoopDone

    StrCmp "$MUI_TEMP" "$SMPROGRAMS" startMenuDeleteLoopDone startMenuDeleteLoop
  startMenuDeleteLoopDone:

  ; If the user changed the shortcut, then uninstall may not work. This should
  ; try to fix it.
  StrCpy $MUI_TEMP "$START_MENU"
  Delete "$SMPROGRAMS\$MUI_TEMP\Uninstall.lnk"


  ;Delete empty start menu parent directories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"

  secondStartMenuDeleteLoop:
    ClearErrors
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."

    IfErrors secondStartMenuDeleteLoopDone

    StrCmp "$MUI_TEMP" "$SMPROGRAMS" secondStartMenuDeleteLoopDone secondStartMenuDeleteLoop
  secondStartMenuDeleteLoopDone:

  DeleteRegKey /ifempty SHCTX "Software\LLVM\LLVM"

  Push $INSTDIR\bin
  StrCmp $DO_NOT_ADD_TO_PATH_ "1" doNotRemoveFromPath 0
    Call un.RemoveFromPath
  doNotRemoveFromPath:
SectionEnd

;--------------------------------
; determine admin versus local install
; Is install for "AllUsers" or "JustMe"?
; Default to "JustMe" - set to "AllUsers" if admin or on Win9x
; This function is used for the very first "custom page" of the installer.
; This custom page does not show up visibly, but it executes prior to the
; first visible page and sets up $INSTDIR properly...
; Choose different default installation folder based on SV_ALLUSERS...
; "Program Files" for AllUsers, "My Documents" for JustMe...

Function .onInit
  StrCmp "ON" "ON" 0 inst

  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LLVM" "UninstallString"
  StrCmp $0 "" inst

  MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION \
  "LLVM is already installed. $\n$\nDo you want to uninstall the old version before installing the new one?" \
  /SD IDYES IDYES uninst IDNO inst
  Abort

;Run the uninstaller
uninst:
  ClearErrors
  StrCpy $2 $0 1
  StrCmp '"' $2 0 +3 ; checks if string is quoted (CPack before v3.20.6 did not quote it)
  ExecWait '$0 /S'
  Goto +2
  ExecWait '"$0" /S'

  IfErrors uninst_failed inst
uninst_failed:
  MessageBox MB_OK|MB_ICONSTOP "Uninstall failed."
  Abort


inst:
  ; Reads components status for registry
  !insertmacro SectionList "InitSection"

  ; check to see if /D has been used to change
  ; the install directory by comparing it to the
  ; install directory that is expected to be the
  ; default
  StrCpy $IS_DEFAULT_INSTALLDIR 0
  StrCmp "$INSTDIR" "$PROGRAMFILES\LLVM" 0 +2
    StrCpy $IS_DEFAULT_INSTALLDIR 1

  StrCpy $SV_ALLUSERS "JustMe"
  ; if default install dir then change the default
  ; if it is installed for JustMe
  StrCmp "$IS_DEFAULT_INSTALLDIR" "1" 0 +2
    StrCpy $INSTDIR "$DOCUMENTS\LLVM"

  ClearErrors
  UserInfo::GetName
  IfErrors noLM
  Pop $0
  UserInfo::GetAccountType
  Pop $1
  StrCmp $1 "Admin" 0 +4
    SetShellVarContext all
    ;MessageBox MB_OK 'User "$0" is in the Admin group'
    StrCpy $SV_ALLUSERS "AllUsers"
    Goto done
  StrCmp $1 "Power" 0 +4
    SetShellVarContext all
    ;MessageBox MB_OK 'User "$0" is in the Power Users group'
    StrCpy $SV_ALLUSERS "AllUsers"
    Goto done

  noLM:
    StrCpy $SV_ALLUSERS "AllUsers"
    ;Get installation folder from registry if available

  done:
  StrCmp $SV_ALLUSERS "AllUsers" 0 +3
    StrCmp "$IS_DEFAULT_INSTALLDIR" "1" 0 +2
      StrCpy $INSTDIR "$PROGRAMFILES\LLVM"

  StrCmp "ON" "ON" 0 noOptionsPage
    !insertmacro MUI_INSTALLOPTIONS_EXTRACT "NSIS.InstallOptions.ini"

  noOptionsPage:
FunctionEnd
