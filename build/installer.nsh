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
; MACRO PER IL LOGGING (Helper)
; =========================================================
!macro LogText Message
    Push $0
    FileOpen $0 "$INSTDIR\install_log.txt" a
    FileSeek $0 0 END
    FileWrite $0 "${Message}$\r$\n"
    FileClose $0
    Pop $0
    DetailPrint "${Message}"
!endmacro

!macro LogAndExec Command
    Push $0
    Push $1
    ; Scrive il comando nel log
    FileOpen $0 "$INSTDIR\install_log.txt" a
    FileSeek $0 0 END
    FileWrite $0 "[EXEC] ${Command}$\r$\n"
    FileClose $0
    
    ; Esegue
    DetailPrint "Esecuzione: ${Command}"
    ExecWait '${Command}' $1
    
    ; Scrive il risultato
    FileOpen $0 "$INSTDIR\install_log.txt" a
    FileSeek $0 0 END
    FileWrite $0 "[EXIT CODE] $1$\r$\n"
    FileClose $0
    Pop $1
    Pop $0
!endmacro

; =========================================================
; PAGINE UI (Totem & User Selection)
; =========================================================
; Queste funzioni devono essere registrate nel package.json o chiamate
; dalle macro standard di electron-builder se supportato, 
; oppure iniettate via nsis.include.
; Assumo che la tua configurazione chiami già queste pagine.

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

!define FILTER_NORMAL_ACCOUNT 0x0002
!define NERR_Success 0

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
; INSTALLAZIONE (Macro customInstall)
; =========================================================
!macro customInstall

    ; --- 0. INIZIALIZZA LOG ---
    FileOpen $4 "$INSTDIR\install_log.txt" w
    FileWrite $4 "--- INSTALLAZIONE KIOSK (Electron-Builder) ---$\r$\n"
    FileWrite $4 "User Selected: $UserNameSelected$\r$\n"
    FileWrite $4 "Totem Type: $TotemChoice$\r$\n"
    FileClose $4

    ; --- 1. CONFIGURAZIONE FILE ---
    ${LogText} "Scrittura file di configurazione..."
    FileOpen $4 "$INSTDIR\kiosk.conf" w
    FileWrite $4 "kiosk_mode=1$\r$\n"
    FileWrite $4 "totem_id=$TotemChoice$\r$\n"
    FileClose $4

    ; --- 2. RISORSE (Simulate, electron-builder gestisce i file principali) ---
    ${LogText} "Copia risorse aggiuntive..."
    SetOutPath "$INSTDIR\translations"
    File /nonfatal "${PROJECT_DIR}\src\locales\*.yaml"
    SetOutPath "$INSTDIR\orari-bus"
    File /nonfatal "${PROJECT_DIR}\src\bus-pdfs\*.pdf"
    SetOutPath "$INSTDIR\sponsors"
    File /nonfatal "${PROJECT_DIR}\src\sponsors\*.jpg"
    File /nonfatal "${PROJECT_DIR}\src\sponsors\*.png"
    SetOutPath "$INSTDIR" 

    ; --- 3. HARDENING SISTEMA (HKLM) ---
    ${LogText} "Applicazione policy di sistema (HKLM)..."
    WriteRegStr HKLM "SOFTWARE\Policies\Microsoft\Windows\EdgeUI" "AllowEdgeSwipe" "0"
    WriteRegDWORD HKLM "SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0
    
    ; --- 4. CONFIGURAZIONE UTENTE ---
    ${LogText} "Configurazione permessi account..."
    
    ; Utilizzo della macro LogAndExec per tracciare i comandi
    ${LogAndExec} 'net localgroup Administrators "$UserNameSelected" /DELETE'
    ${LogAndExec} 'net localgroup Users "$UserNameSelected" /ADD'
    ${LogAndExec} 'wmic useraccount where Name="$UserNameSelected" set PasswordExpires=FALSE'

    ; AutoLogon
    ${LogText} "Impostazione AutoLogon..."
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "1"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "$UserNameSelected"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultDomainName" "."
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "" 

    ; --- 5. CREAZIONE WATCHDOG (Shell Loop) ---
    ${LogText} "Creazione script Watchdog..."
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
    ${LogText} "Creazione script di setup iniziale (init_kiosk.bat)..."
    
    FileOpen $4 "$INSTDIR\init_kiosk.bat" w
    FileWrite $4 "@echo off$\r$\n"
    
    ; Log interno al batch per debug
    FileWrite $4 'ECHO [BATCH] Start setup per %USERNAME% >> "$INSTDIR\install_log.txt"$\r$\n'
    
    ; Controllo Username
    FileWrite $4 'IF /I "%USERNAME%" NEQ "$UserNameSelected" ( ECHO [BATCH] Utente errato. Esco. >> "$INSTDIR\install_log.txt" & GOTO END )$\r$\n'
    
    ; Hardening HKCU
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f$\r$\n'
    FileWrite $4 'REG ADD "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f$\r$\n'
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f$\r$\n'
    
    ; IMPOSTAZIONE SHELL -> WATCHDOG
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "\"$INSTDIR\kiosk_watchdog.bat\"" /f$\r$\n'
    
    ; *** AUTODISTRUZIONE DAL STARTUP ***
    FileWrite $4 'DEL "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\setup_kiosk.lnk"$\r$\n'
    
    FileWrite $4 'ECHO [BATCH] Configurazione completata. Riavvio... >> "$INSTDIR\install_log.txt"$\r$\n'
    FileWrite $4 "shutdown /r /t 0$\r$\n"
    FileWrite $4 ":END$\r$\n"
    FileWrite $4 "EXIT$\r$\n"
    FileClose $4

    ; --- 7. FIX DEFINITIVO: LINK DIRETTO NELLO STARTUP DELL'UTENTE ---
    ; Poiché siamo Admin, possiamo scrivere nella cartella dell'utente.
    ; Supponiamo che l'utente esista già e abbia fatto accesso (quindi la cartella esiste).
    
    ${LogText} "Creazione collegamento in Esecuzione Automatica per $UserNameSelected..."
    
    ; Costruzione percorso Startup dell'utente target
    StrCpy $R0 "C:\Users\$UserNameSelected\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    
    ; Controllo esistenza cartella (Sicurezza)
    IfFileExists "$R0\*.*" PathFound PathNotFound

    PathNotFound:
        ${LogText} "ERRORE CRITICO: Cartella Startup non trovata in $R0"
        MessageBox MB_ICONSTOP "Errore: L'utente '$UserNameSelected' non ha una cartella utente.$\r$\nAssicurati di aver fatto il login con quell'utente almeno una volta!"
        Abort

    PathFound:
        ; Creazione del link
        CreateShortCut "$R0\setup_kiosk.lnk" "$INSTDIR\init_kiosk.bat"
        ${LogText} "Link creato con successo in: $R0\setup_kiosk.lnk"

    ${LogText} "Installazione Completata."
    MessageBox MB_OK "Installazione Completata!$\r$\n$\r$\nLog: $INSTDIR\install_log.txt$\r$\nAl riavvio, il sistema farà login automatico e configurerà l'utente."

!macroend

; =========================================================
; DISINSTALLAZIONE (Macro customUnInstall)
; =========================================================
!macro customUnInstall
    Delete "$INSTDIR\kiosk.conf"
    Delete "$INSTDIR\install_log.txt" ; Rimuove il log alla disinstallazione
    Delete "$INSTDIR\kiosk_watchdog.bat"
    Delete "$INSTDIR\init_kiosk.bat"
    
    RMDir /r "$INSTDIR\orari-bus"
    RMDir /r "$INSTDIR\sponsors"
    RMDir /r "$INSTDIR\translations"
    
    ; Nota: Non rimuoviamo le chiavi di registro di sistema per evitare di rompere policy globali,
    ; ma potresti voler rimuovere l'AutoLogon se necessario.
!macroend
