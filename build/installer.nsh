!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh" 
!include "TextFunc.nsh"

; --- VARIABILI GLOBALI ---
Var Dialog
Var Label
Var RadioPiazza
Var RadioMarina
Var TotemChoice

; Variabili per la selezione utente
Var UserDropList
Var UserNameSelected

; =========================================================
; DEFINIZIONI E PAGINE
; =========================================================

!define FILTER_NORMAL_ACCOUNT 0x0002
!define NERR_Success 0

Page custom fnc_TotemPage_Show fnc_TotemPage_Leave
Page custom fnc_UserSelect_Show fnc_UserSelect_Leave

Function fnc_TotemPage_Show
    nsDialogs::Create 1018
    Pop $Dialog
    ${If} $Dialog == error
        Abort
    ${EndIf}
    ${NSD_CreateLabel} 0 0 100% 12u "Seleziona la configurazione del Totem:"
    Pop $Label
    ${NSD_CreateRadioButton} 10u 30u 100% 10u "Totem Piazza"
    Pop $RadioPiazza
    ${NSD_CreateRadioButton} 10u 45u 100% 10u "Totem Marina"
    Pop $RadioMarina
    ${NSD_Check} $RadioPiazza
    nsDialogs::Show
FunctionEnd

Function fnc_TotemPage_Leave
    ${NSD_GetState} $RadioPiazza $0
    ${If} $0 == ${BST_CHECKED}
        StrCpy $TotemChoice "piazza"
    ${Else}
        StrCpy $TotemChoice "marina"
    ${EndIf}
FunctionEnd

Function fnc_UserSelect_Show
    nsDialogs::Create 1018
    Pop $Dialog
    ${If} $Dialog == error
        Abort
    ${EndIf}

    ${NSD_CreateLabel} 0 0 100% 25u "Seleziona l'account Kiosk (L'utente deve aver già effettuato l'accesso):"
    Pop $Label
    ${NSD_CreateDropList} 0 35u 100% 80u ""
    Pop $UserDropList

    ReadEnvStr $8 "USERNAME"
    System::Call 'netapi32::NetUserEnum(n, i 0, i ${FILTER_NORMAL_ACCOUNT}, *i .r0, i -1, *i .r1, *i .r2, *i .r3) i .r4'

    ${If} $4 == ${NERR_Success}
        StrCpy $5 0 
        StrCpy $6 $0 
        LoopUsers:
            IntCmp $5 $1 DoneUsers 
            System::Call "*$6(w .r7)"
            StrCmp $7 "Administrator" SkipUser
            StrCmp $7 "Guest" SkipUser
            StrCmp $7 "DefaultAccount" SkipUser
            StrCmp $7 "WDAGUtilityAccount" SkipUser
            StrCmp $7 $8 SkipUser 
            ${NSD_CB_AddString} $UserDropList $7
            SkipUser:
            IntOp $6 $6 + 4 
            IntOp $5 $5 + 1
            Goto LoopUsers
        DoneUsers:
        System::Call 'netapi32::NetApiBufferFree(i r0)'
    ${EndIf}
    ${NSD_CB_SelectString} $UserDropList 0
    nsDialogs::Show
FunctionEnd

Function fnc_UserSelect_Leave
    SendMessage $UserDropList 0x0147 0 0 $0 
    ${If} $0 == -1
        MessageBox MB_ICONSTOP "Errore: nessun utente selezionato."
        Abort
    ${EndIf}
    ${NSD_GetText} $UserDropList $UserNameSelected
    ${TrimNewLines} $UserNameSelected $UserNameSelected
FunctionEnd

; =========================================================
; INSTALLAZIONE (customInstall)
; =========================================================
!macro customInstall

    ; --- 0. INIZIO LOG ---
    FileOpen $4 "$INSTDIR\install_log.txt" w
    FileWrite $4 "--- INSTALLAZIONE KIOSK ---$\r$\n"
    FileWrite $4 "User Selected: $UserNameSelected$\r$\n"
    FileWrite $4 "Totem Type: $TotemChoice$\r$\n"
    FileClose $4

    ; --- 1. CONFIGURAZIONE FILE ---
    DetailPrint "Scrittura configurazione..."
    FileOpen $4 "$INSTDIR\kiosk.conf" w
    FileWrite $4 "kiosk_mode=1$\r$\n"
    FileWrite $4 "totem_id=$TotemChoice$\r$\n"
    FileClose $4

    ; --- 2. RISORSE ---
    DetailPrint "Copia risorse..."
    SetOutPath "$INSTDIR\translations"
    File /nonfatal "${PROJECT_DIR}\src\locales\*.yaml"
    SetOutPath "$INSTDIR\orari-bus"
    File /nonfatal "${PROJECT_DIR}\src\bus-pdfs\*.pdf"
    SetOutPath "$INSTDIR\sponsors"
    File /nonfatal "${PROJECT_DIR}\src\sponsors\*.jpg"
    File /nonfatal "${PROJECT_DIR}\src\sponsors\*.png"
    SetOutPath "$INSTDIR" 

    ; --- 3. HARDENING SISTEMA (HKLM) ---
    DetailPrint "Applicazione policy di sistema (HKLM)..."
    WriteRegStr HKLM "SOFTWARE\Policies\Microsoft\Windows\EdgeUI" "AllowEdgeSwipe" "0"
    WriteRegDWORD HKLM "SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0
    
    ; --- 4. CONFIGURAZIONE UTENTE ---
    DetailPrint "Configurazione permessi account..."
    
    ; -- Remove Admin --
    ExecWait 'net localgroup Administrators "$UserNameSelected" /DELETE' $0
    FileOpen $4 "$INSTDIR\install_log.txt" a
    FileSeek $4 0 END
    FileWrite $4 "[EXEC] net localgroup Administrators delete - CODE: $0$\r$\n"
    FileClose $4

    ; -- Add Users --
    ExecWait 'net localgroup Users "$UserNameSelected" /ADD' $0
    FileOpen $4 "$INSTDIR\install_log.txt" a
    FileSeek $4 0 END
    FileWrite $4 "[EXEC] net localgroup Users add - CODE: $0$\r$\n"
    FileClose $4

    ; -- No Expire Password --
    ExecWait 'wmic useraccount where Name="$UserNameSelected" set PasswordExpires=FALSE' $0
    FileOpen $4 "$INSTDIR\install_log.txt" a
    FileSeek $4 0 END
    FileWrite $4 "[EXEC] wmic password expires - CODE: $0$\r$\n"
    FileClose $4

    ; AutoLogon
    DetailPrint "Impostazione AutoLogon..."
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "1"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "$UserNameSelected"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultDomainName" "."
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "" 

    ; --- 5. CREAZIONE WATCHDOG ---
    DetailPrint "Creazione script Watchdog..."
    FileOpen $4 "$INSTDIR\kiosk_watchdog.bat" w
    FileWrite $4 "@echo off$\r$\n"
    FileWrite $4 ":LOOP$\r$\n"
    FileWrite $4 "cls$\r$\n"
    FileWrite $4 "echo Kiosk Watchdog: Avvio applicazione...$\r$\n"
    FileWrite $4 'start /wait "" "$INSTDIR\KioskPaola.exe"$\r$\n'
    FileWrite $4 "echo L'applicazione si e' chiusa. Riavvio in 2 secondi...$\r$\n"
    FileWrite $4 "timeout /t 2 /nobreak >nul$\r$\n"
    FileWrite $4 "goto LOOP$\r$\n"
    FileClose $4

    ; --- 6. CREAZIONE SCRIPT DI PRIMO AVVIO (Init) ---
    DetailPrint "Creazione script init_kiosk.bat..."
    
    FileOpen $4 "$INSTDIR\init_kiosk.bat" w
    FileWrite $4 "@echo off$\r$\n"
    
    ; Log interno batch
    FileWrite $4 'ECHO [BATCH] Start setup per %USERNAME% >> "$INSTDIR\install_log.txt"$\r$\n'
    
    ; Check Utente
    FileWrite $4 'IF /I "%USERNAME%" NEQ "$UserNameSelected" ( ECHO [BATCH] Utente errato. Esco. >> "$INSTDIR\install_log.txt" & GOTO END )$\r$\n'
    
    ; Hardening HKCU
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f$\r$\n'
    FileWrite $4 'REG ADD "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f$\r$\n'
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f$\r$\n'
    
    ; Impostazione Shell -> Watchdog
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "\"$INSTDIR\kiosk_watchdog.bat\"" /f$\r$\n'
    
    ; AUTODISTRUZIONE LINK (Importante)
    FileWrite $4 'DEL "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\setup_kiosk.lnk"$\r$\n'
    
    FileWrite $4 'ECHO [BATCH] Completato. Riavvio... >> "$INSTDIR\install_log.txt"$\r$\n'
    FileWrite $4 "shutdown /r /t 0$\r$\n"
    FileWrite $4 ":END$\r$\n"
    FileWrite $4 "EXIT$\r$\n"
    FileClose $4

    ; --- 7. FIX: LINK NELLO STARTUP DELL'UTENTE ---
    DetailPrint "Creazione collegamento in Startup per $UserNameSelected..."
    
    StrCpy $R0 "C:\Users\$UserNameSelected\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    
    IfFileExists "$R0\*.*" PathFound PathNotFound

    PathNotFound:
        MessageBox MB_ICONSTOP "Errore Critico: L'utente '$UserNameSelected' non ha una cartella utente.$\r$\nDevi fare il login con quell'utente almeno una volta prima di installare!"
        Abort

    PathFound:
        CreateShortCut "$R0\setup_kiosk.lnk" "$INSTDIR\init_kiosk.bat"
        
        FileOpen $4 "$INSTDIR\install_log.txt" a
        FileSeek $4 0 END
        FileWrite $4 "[OK] Link creato in $R0\setup_kiosk.lnk$\r$\n"
        FileClose $4

    DetailPrint "Installazione Completata."
    MessageBox MB_OK "Installazione Completata!$\r$\nLog: $INSTDIR\install_log.txt$\r$\nAl riavvio, il sistema configurerà l'utente Kiosk."

!macroend

; =========================================================
; DISINSTALLAZIONE (customUnInstall)
; =========================================================
!macro customUnInstall
    Delete "$INSTDIR\kiosk.conf"
    Delete "$INSTDIR\install_log.txt"
    Delete "$INSTDIR\kiosk_watchdog.bat"
    Delete "$INSTDIR\init_kiosk.bat"
    
    RMDir /r "$INSTDIR\orari-bus"
    RMDir /r "$INSTDIR\sponsors"
    RMDir /r "$INSTDIR\translations"
!macroend
