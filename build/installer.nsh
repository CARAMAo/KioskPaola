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
Var UserDropList ; Il controllo UI (combobox)
Var UserNameSelected ; Il valore scelto (es. "Kiosk")
Var HLine ; Handle per lettura file

RequestExecutionLevel admin

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
; PAGINA 2: SELEZIONE UTENTE ESISTENTE
; =========================================================
Page custom fnc_UserSelect_Show fnc_UserSelect_Leave

; Definizioni API Windows
; Definizioni API Windows (se non le hai già in cima al file)
!define FILTER_NORMAL_ACCOUNT 0x0002
!define NERR_Success 0

Function fnc_UserSelect_Show
    nsDialogs::Create 1018
    Pop $Dialog
    ${If} $Dialog == error
        Abort
    ${EndIf}

    ${NSD_CreateLabel} 0 0 100% 25u "Seleziona l'account locale che diventerà il Kiosk User.$\r$\n(Questo utente verrà impostato per il login automatico e l'avvio diretto dell'app)."
    Pop $Label

    ; Creiamo il menu a tendina
    ${NSD_CreateDropList} 0 35u 100% 80u ""
    Pop $UserDropList

    ; --- 1. IDENTIFICA L'AMMINISTRATORE CORRENTE ---
    ; Leggiamo il nome dell'utente che sta eseguendo l'installer per escluderlo dalla lista.
    ; Usiamo il registro $8 per memorizzarlo.
    ReadEnvStr $8 "USERNAME"

    ; --- 2. ENUMERAZIONE UTENTI (API NetUserEnum) ---
    ; r0 = Buffer, r1 = EntriesRead, r2 = Total, r3 = Resume, r4 = Status
    System::Call 'netapi32::NetUserEnum(n, i 0, i ${FILTER_NORMAL_ACCOUNT}, *i .r0, i -1, *i .r1, *i .r2, *i .r3) i .r4'

    ${If} $4 == ${NERR_Success}
        StrCpy $5 0  ; Contatore ciclo
        StrCpy $6 $0 ; Puntatore buffer corrente

        LoopUsers:
            IntCmp $5 $1 DoneUsers ; Se abbiamo letto tutti gli utenti, fine

            ; Leggi il nome utente corrente dal puntatore in memoria -> $7
            System::Call "*$6(w .r7)"

            ; --- FILTRI DI SICUREZZA ---
            ; Salta utenti di sistema
            StrCmp $7 "Administrator" SkipUser
            StrCmp $7 "Guest" SkipUser
            StrCmp $7 "DefaultAccount" SkipUser
            StrCmp $7 "WDAGUtilityAccount" SkipUser
            
            ; --- FILTRO ANTI-LOCKOUT ---
            ; Se l'utente trovato ($7) è uguale all'utente corrente ($8), SALTALO.
            ; Questo impedisce all'admin di selezionare se stesso.
            StrCmp $7 $8 SkipUser

            ; Se passa i filtri, aggiungilo alla lista
            ${NSD_CB_AddString} $UserDropList $7

            SkipUser:
            ; Avanza di 4 byte (dimensione puntatore su 32bit) o struct size
            IntOp $6 $6 + 4 
            IntOp $5 $5 + 1
            Goto LoopUsers

        DoneUsers:
        ; Pulisci la memoria
        System::Call 'netapi32::NetApiBufferFree(i r0)'
    ${Else}
        MessageBox MB_ICONSTOP "Errore nell'enumerazione degli utenti (Codice: $4).$\r$\nImpossibile popolare la lista."
    ${EndIf}

    ; Seleziona il primo elemento se disponibile
    ${NSD_CB_SelectString} $UserDropList 0

    nsDialogs::Show
FunctionEnd


Function fnc_UserSelect_Leave

    SendMessage $UserDropList 0x0147 0 0 $0 ; CB_GETCURSEL
    ${If} $0 == -1
        MessageBox MB_ICONSTOP "Errore: nessun utente selezionato."
        Abort
    ${EndIf}

    ${NSD_GetText} $UserDropList $UserNameSelected
    ${TrimNewLines} $UserNameSelected $UserNameSelected

    StrLen $1 $UserNameSelected
    ${If} $1 == 0
        MessageBox MB_ICONSTOP "Errore: nome utente non valido."
        Abort
    ${EndIf}

    MessageBox MB_YESNO \
        "Confermi la configurazione dell'utente '$UserNameSelected' come Kiosk?$\\r$\\n$\\r$\\nATTENZIONE: al prossimo avvio l'utente vedrà solo l'applicazione." \
        IDYES ok
    Abort

ok:
FunctionEnd




; =========================================================
; INSTALLAZIONE
; =========================================================
!macro customInstall

    ; --- 1. CONFIGURAZIONE FILE ---
    DetailPrint "Configurazione App ($TotemChoice)..."
    FileOpen $4 "$INSTDIR\kiosk.conf" w
    FileWrite $4 "kiosk_mode=1$\r$\n"
    FileWrite $4 "totem_id=$TotemChoice$\r$\n"
    FileClose $4

    ; --- 2. RISORSE ---
    DetailPrint "Installazione risorse..."
    SetOutPath "$INSTDIR\translations"
    File /nonfatal "$PROJECT_DIR\src\locales\*.yaml"
    SetOutPath "$INSTDIR\orari-bus"
    File /nonfatal "$PROJECT_DIR\src\bus-pdfs\*.pdf"
    SetOutPath "$INSTDIR\sponsors"
    File /nonfatal "$PROJECT_DIR\src\sponsors\*.jpg"
    File /nonfatal "$PROJECT_DIR\src\sponsors\*.png"
    SetOutPath "$INSTDIR" 

    ; --- 3. CONFIGURAZIONE UTENTE ---
    DetailPrint "Configurazione Account Kiosk: $UserNameSelected"

    ; Permessi e Password
    ExecWait "net localgroup Administrators $\"$UserNameSelected$\" /DELETE"
    ExecWait "net localgroup Users $\"$UserNameSelected$\" /ADD"
    ExecWait "wmic useraccount where Name='${UserNameSelected}' set PasswordExpires=FALSE" $1

    ; AutoLogon (HKLM)
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "1"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "$UserNameSelected"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultDomainName" "."
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "" 


    ; --- 4. CREAZIONE SCRIPT DI INIZIALIZZAZIONE (SOLUZIONE BAT) ---
    ; Invece di mettere il comando nel registro, creiamo un file .bat fisico.
    ; Questo evita tutti i problemi di virgolette.
    
    DetailPrint "Creazione script di primo avvio..."
    
    FileOpen $4 "$INSTDIR\init_kiosk.bat" w
    
    ; Scriviamo il contenuto del batch riga per riga
    FileWrite $4 "@echo off$\r$\n"
    
    ; LOGICA: Se l'utente NON è quello del Kiosk, esci subito e non fare nulla.
    ; (Nota: usiamo $\" per scrivere le virgolette nel file)
    FileWrite $4 'IF /I "%USERNAME%" NEQ "$UserNameSelected" GOTO END$\r$\n'
    
    ; LOGICA: Imposta la Shell nel registro dell'utente corrente (HKCU)
    ; Attenzione: $INSTDIR ha i backslash singoli, ma nel file bat vanno bene così.
    FileWrite $4 'REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "\"$INSTDIR\KioskPaola.exe\"" /f$\r$\n'
    
    ; LOGICA: Riavvia per applicare
    FileWrite $4 "shutdown /r /t 0$\r$\n"
    
    FileWrite $4 ":END$\r$\n"
    FileWrite $4 "EXIT$\r$\n"
    
    FileClose $4


    ; --- 5. IMPOSTAZIONE RUNONCE ---
    ; Ora il registro deve solo lanciare questo file semplice.
    ; Usiamo cmd /C start ... per nascondere la finestra il più possibile e lanciare in background
    
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "SetupKioskShell" '"$INSTDIR\init_kiosk.bat"'

    DetailPrint "Configurazione completata."
    
    MessageBox MB_OK "Installazione Completata!$\r$\n$\r$\nAl riavvio:$\r$\n1. Windows entrerà automaticamente come '$UserNameSelected'.$\r$\n2. Uno script configurerà la modalità Kiosk e riavvierà il PC.$\r$\n3. Al secondo riavvio, partirà l'App."

!macroend

!macro customUnInstall
    Delete "$INSTDIR\kiosk.conf"
    RMDir /r "$INSTDIR\orari-bus"
    RMDir /r "$INSTDIR\sponsors"
    RMDir /r "$INSTDIR\translations"
    
    ; Pulizia AutoLogon
    ; DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon"
    ; DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName"
!macroend