!include "nsDialogs.nsh"
!include "LogicLib.nsh"

; --- VARIABILI GLOBALI ---
Var Dialog
Var Label
Var RadioPiazza
Var RadioMarina
Var TotemChoice
Var UserText
Var UserNameEntered

; =========================================================
; PAGINA 1: SCELTA TOTEM
; =========================================================
Page custom fnc_TotemPage_Show fnc_TotemPage_Leave

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

; =========================================================
; PAGINA 2: CREAZIONE UTENTE KIOSK
; =========================================================
Page custom fnc_UserPage_Show fnc_UserPage_Leave

Function fnc_UserPage_Show
    nsDialogs::Create 1018
    Pop $Dialog
    ${If} $Dialog == error
        Abort
    ${EndIf}
    ${NSD_CreateLabel} 0 0 100% 25u "Inserisci il nome dell'Utente Windows limitato da creare.$\r$\n(Solo lettere, niente spazi, non deve esistere)."
    Pop $Label
    ${NSD_CreateText} 0 30u 100% 12u "Kiosk"
    Pop $UserText
    nsDialogs::Show
FunctionEnd

Function fnc_UserPage_Leave
    ; 1. Input
    ${NSD_GetText} $UserText $UserNameEntered
    
    ; 2. Controllo Vuoto
    StrLen $0 $UserNameEntered
    ${If} $0 == 0
        MessageBox MB_ICONSTOP "Il nome utente non può essere vuoto."
        Abort
    ${EndIf}

    ; 3. Controllo Lettere (ASCII Check)
    StrCpy $1 0 
    LoopCheck:
        IntCmp $1 $0 CheckDone
        StrCpy $2 $UserNameEntered 1 $1 
        System::Call '*(&t1 "$2") p .r3'
        System::Call '*$3(&i1 .r4)'
        System::Free $3
        ${If} $4 >= 65
        ${AndIf} $4 <= 90
        ${ElseIf} $4 >= 97
        ${AndIf} $4 <= 122
        ${Else}
            MessageBox MB_ICONSTOP "Il nome utente deve contenere SOLO lettere (A-Z). Carattere non valido: '$2'"
            Abort
        ${EndIf}
        IntOp $1 $1 + 1
        Goto LoopCheck
    CheckDone:

    ; 4. Controllo Esistenza (ExecWait con escape corretto)
    SetDetailsPrint none
    ExecWait "cmd /C net user $\"$UserNameEntered$\" > NUL 2>&1" $0
    SetDetailsPrint both
    
    ${If} $0 == 0
        MessageBox MB_ICONSTOP "L'utente '$UserNameEntered' esiste già. Scegline un altro."
        Abort
    ${EndIf}
FunctionEnd


; =========================================================
; INSTALLAZIONE
; =========================================================
!macro customInstall

    ; --- 1. Configurazione ---
    DetailPrint "Configurazione App ($TotemChoice)..."
    FileOpen $4 "$INSTDIR\kiosk.conf" w
    FileWrite $4 "kiosk_mode=1$\r$\n"
    FileWrite $4 "totem_id=$TotemChoice$\r$\n"
    FileClose $4

    ; --- 2. Utente Windows ---
    DetailPrint "Creazione utente '$UserNameEntered'..."

    StrCpy $0 0
    
    ; Sintassi ExecWait con virgolette interne escapeate
    ExecWait "net user $\"$UserNameEntered$\" $\"$\" /ADD /fullname:$\"Kiosk User App$\" /comment:$\"Account Kiosk$\" /active:yes /passwordchg:no" $0
    
    ${If} $0 == 0
        DetailPrint "Utente creato."
        
        ; WMIC
        ExecWait "wmic useraccount where Name='${UserNameEntered}' set PasswordExpires=FALSE" $1

        ; Gruppi
        ExecWait "net localgroup Users $\"$UserNameEntered$\" /ADD"
        ExecWait "net localgroup Administrators $\"$UserNameEntered$\" /DELETE"
        
        ; --- 3. CONFIGURAZIONE AUTOMATICA KIOSK (AUTOLOGON + SHELL) ---
        DetailPrint "Impostazione AutoLogon e Shell..."

        ; A) AUTOLOGON (HKLM)
        WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "1"
        WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "$UserNameEntered"
        WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultDomainName" "."
        WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "" 

        ; B) SHELL REPLACEMENT (RunOnce)
        ; Usiamo StrCpy con apici SINGOLI ' per contenere la stringa complessa con doppi apici "
        ; Questo evita l'errore "got 13 parameters".
        ; Nota: le virgolette intorno al path del file exe sono escapeate per il comando REG (\")
        
        StrCpy $0 'cmd.exe /C "IF /I "%USERNAME%" == "$UserNameEntered" ( REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "\"$INSTDIR\KioskPaola.exe\"" /f & shutdown /r /t 0 )"'
        
        WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "SetupKioskShell" $0

        DetailPrint "Configurazione completata. Al riavvio il Kiosk si configurerà."
        MessageBox MB_OK "Utente '$UserNameEntered' creato e configurato.$\r$\nRiavvia il PC per attivare la modalità Kiosk."
        
    ${ElseIf} $0 == 2245
        MessageBox MB_ICONSTOP "ERRORE: Policy Password attiva.$\r$\nImpossibile creare utente senza password.$\r$\nDisabilita 'Requisiti di complessità password' in secpol.msc."
        Abort
    ${Else}
        MessageBox MB_ICONSTOP "Errore creazione utente. Codice: $0"
        Abort
    ${EndIf}

!macroend

!macro customUnInstall
    Delete "$INSTDIR\kiosk.conf"
    RMDir /r "$INSTDIR\orari-bus"
    RMDir /r "$INSTDIR\sponsors"
    RMDir /r "$INSTDIR\translations"
    
    ; Pulizia AutoLogon
    DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon"
    DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName"
!macroend