#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Fichier de configuration
configFile := A_ScriptDir . "\config.ini"

; Lecture du fichier de configuration au démarrage
IfNotExist, %configFile%
{
    IniWrite, 0, %configFile%, Categories, FightingStyle
    IniWrite, 0, %configFile%, Categories, Sword
    IniWrite, 0, %configFile%, Categories, Fruit
    IniWrite, 0, %configFile%, Categories, Gun
    IniWrite, 0, %configFile%, SkillsFightingStyle, W
    IniWrite, 0, %configFile%, SkillsFightingStyle, X
    IniWrite, 0, %configFile%, SkillsFightingStyle, C
    IniWrite, 0, %configFile%, SkillsFightingStyle, V
    IniWrite, 0, %configFile%, SkillsFightingStyle, B
    IniWrite, 0, %configFile%, SkillsFightingStyle, F
    IniWrite, 0, %configFile%, SkillsSword, W
    IniWrite, 0, %configFile%, SkillsSword, X
    IniWrite, 0, %configFile%, SkillsSword, C
    IniWrite, 0, %configFile%, SkillsSword, V
    IniWrite, 0, %configFile%, SkillsSword, B
    IniWrite, 0, %configFile%, SkillsSword, F
    IniWrite, 0, %configFile%, SkillsFruit, W
    IniWrite, 0, %configFile%, SkillsFruit, X
    IniWrite, 0, %configFile%, SkillsFruit, C
    IniWrite, 0, %configFile%, SkillsFruit, V
    IniWrite, 0, %configFile%, SkillsFruit, B
    IniWrite, 0, %configFile%, SkillsFruit, F
    IniWrite, 0, %configFile%, SkillsGun, W
    IniWrite, 0, %configFile%, SkillsGun, X
    IniWrite, 0, %configFile%, SkillsGun, C
    IniWrite, 0, %configFile%, SkillsGun, V
    IniWrite, 0, %configFile%, SkillsGun, B
    IniWrite, 0, %configFile%, SkillsGun, F
    IniWrite, 500, %configFile%, Settings, TimeInput
}

; Récupération des valeurs sauvegardées
IniRead, FightingStyle, %configFile%, Categories, FightingStyle
IniRead, Sword, %configFile%, Categories, Sword
IniRead, Fruit, %configFile%, Categories, Fruit
IniRead, Gun, %configFile%, Categories, Gun
IniRead, FSkillW, %configFile%, SkillsFightingStyle, W
IniRead, FSkillX, %configFile%, SkillsFightingStyle, X
IniRead, FSkillC, %configFile%, SkillsFightingStyle, C
IniRead, FSkillV, %configFile%, SkillsFightingStyle, V
IniRead, FSkillB, %configFile%, SkillsFightingStyle, B
IniRead, FSkillF, %configFile%, SkillsFightingStyle, F
IniRead, SSkillW, %configFile%, SkillsSword, W
IniRead, SSkillX, %configFile%, SkillsSword, X
IniRead, SSkillC, %configFile%, SkillsSword, C
IniRead, SSkillV, %configFile%, SkillsSword, V
IniRead, SSkillB, %configFile%, SkillsSword, B
IniRead, SSkillF, %configFile%, SkillsSword, F
IniRead, FruitSkillW, %configFile%, SkillsFruit, W
IniRead, FruitSkillX, %configFile%, SkillsFruit, X
IniRead, FruitSkillC, %configFile%, SkillsFruit, C
IniRead, FruitSkillV, %configFile%, SkillsFruit, V
IniRead, FruitSkillB, %configFile%, SkillsFruit, B
IniRead, FruitSkillF, %configFile%, SkillsFruit, F
IniRead, GunSkillW, %configFile%, SkillsGun, W
IniRead, GunSkillX, %configFile%, SkillsGun, X
IniRead, GunSkillC, %configFile%, SkillsGun, C
IniRead, GunSkillV, %configFile%, SkillsGun, V
IniRead, GunSkillB, %configFile%, SkillsGun, B
IniRead, GunSkillF, %configFile%, SkillsGun, F
IniRead, TimeInput, %configFile%, Settings, TimeInput

; Création de l'interface graphique
Gui, Add, Text,, Choisissez les catégories et skills à activer :
Gui, Add, Checkbox, vFightingStyle Checked%FightingStyle%, Fighting Style
Gui, Add, Checkbox, vSword Checked%Sword%, Sword
Gui, Add, Checkbox, vFruit Checked%Fruit%, Fruit
Gui, Add, Checkbox, vGun Checked%Gun%, Gun

Gui, Add, Text,, Sélectionnez les skills pour chaque catégorie :

Gui, Add, Text,, Skills pour Fighting Style:
Gui, Add, Checkbox, vFSkillW Checked%FSkillW%, W
Gui, Add, Checkbox, vFSkillX Checked%FSkillX%, X
Gui, Add, Checkbox, vFSkillC Checked%FSkillC%, C
Gui, Add, Checkbox, vFSkillV Checked%FSkillV%, V
Gui, Add, Checkbox, vFSkillB Checked%FSkillB%, B
Gui, Add, Checkbox, vFSkillF Checked%FSkillF%, F

Gui, Add, Text,, Skills pour Sword:
Gui, Add, Checkbox, vSSkillW Checked%SSkillW%, W
Gui, Add, Checkbox, vSSkillX Checked%SSkillX%, X
Gui, Add, Checkbox, vSSkillC Checked%SSkillC%, C
Gui, Add, Checkbox, vSSkillV Checked%SSkillV%, V
Gui, Add, Checkbox, vSSkillB Checked%SSkillB%, B
Gui, Add, Checkbox, vSSkillF Checked%SSkillF%, F

Gui, Add, Text,, Skills pour Fruit:
Gui, Add, Checkbox, vFruitSkillW Checked%FruitSkillW%, W
Gui, Add, Checkbox, vFruitSkillX Checked%FruitSkillX%, X
Gui, Add, Checkbox, vFruitSkillC Checked%FruitSkillC%, C
Gui, Add, Checkbox, vFruitSkillV Checked%FruitSkillV%, V
Gui, Add, Checkbox, vFruitSkillB Checked%FruitSkillB%, B
Gui, Add, Checkbox, vFruitSkillF Checked%FruitSkillF%, F

Gui, Add, Text,, Skills pour Gun:
Gui, Add, Checkbox, vGunSkillW Checked%GunSkillW%, W
Gui, Add, Checkbox, vGunSkillX Checked%GunSkillX%, X
Gui, Add, Checkbox, vGunSkillC Checked%GunSkillC%, C
Gui, Add, Checkbox, vGunSkillV Checked%GunSkillV%, V
Gui, Add, Checkbox, vGunSkillB Checked%GunSkillB%, B
Gui, Add, Checkbox, vGunSkillF Checked%GunSkillF%, F

; Champ d'entrée pour l'intervalle
Gui, Add, Text,, Intervalle de temps entre les opérations (en ms) :
Gui, Add, Edit, vTimeInput w100, %TimeInput%

; Boutons de validation et contrôle
Gui, Add, Button, gValidate, Valider
Gui, Add, Button, gStart, F9 - Start
Gui, Add, Button, gPause, F8 - Pause
Gui, Add, Button, gStop, F7 - Stop

Gui, Add, Text, vStatusText, Status: %status%

Gui, Show,, Configuration des Catégories et Skills
Return

; Validation des choix et sauvegarde dans config.ini
Validate:
    Gui, Submit, NoHide
    ; Afficher les valeurs pour déboguer
    MsgBox, FightingStyle: %FightingStyle%`nSword: %Sword%`nFruit: %Fruit%`nGun: %Gun%`n
    MsgBox, FSkillW: %FSkillW%`nFSkillX: %FSkillX%`nFSkillC: %FSkillC%`nFSkillV: %FSkillV%`nFSkillB: %FSkillB%`nFSkillF: %FSkillF%`n
    MsgBox, SSkillW: %SSkillW%`nSSkillX: %SSkillX%`nSSkillC: %SSkillC%`nSSkillV: %SSkillV%`nSSkillB: %SSkillB%`nSSkillF: %SSkillF%`n
    MsgBox, FruitSkillW: %FruitSkillW%`nFruitSkillX: %FruitSkillX%`nFruitSkillC: %FruitSkillC%`nFruitSkillV: %FruitSkillV%`nFruitSkillB: %FruitSkillB%`nFruitSkillF: %FruitSkillF%`n
    MsgBox, GunSkillW: %GunSkillW%`nGunSkillX: %GunSkillX%`nGunSkillC: %GunSkillC%`nGunSkillV: %GunSkillV%`nGunSkillB: %GunSkillB%`nGunSkillF: %GunSkillF%`n

    ; Sauvegarde des choix dans le fichier de configuration
    IniWrite, %FightingStyle%, %configFile%, Categories, FightingStyle
    IniWrite, %Sword%, %configFile%, Categories, Sword
    IniWrite, %Fruit%, %configFile%, Categories, Fruit
    IniWrite, %Gun%, %configFile%, Categories, Gun
    IniWrite, %FSkillW%, %configFile%, SkillsFightingStyle, W
    IniWrite, %FSkillX%, %configFile%, SkillsFightingStyle, X
    IniWrite, %FSkillC%, %configFile%, SkillsFightingStyle, C
    IniWrite, %FSkillV%, %configFile%, SkillsFightingStyle, V
    IniWrite, %FSkillB%, %configFile%, SkillsFightingStyle, B
    IniWrite, %FSkillF%, %configFile%, SkillsFightingStyle, F
    IniWrite, %SSkillW%, %configFile%, SkillsSword, W
    IniWrite, %SSkillX%, %configFile%, SkillsSword, X
    IniWrite, %SSkillC%, %configFile%, SkillsSword, C
    IniWrite, %SSkillV%, %configFile%, SkillsSword, V
    IniWrite, %SSkillB%, %configFile%, SkillsSword, B
    IniWrite, %SSkillF%, %configFile%, SkillsSword, F
    IniWrite, %FruitSkillW%, %configFile%, SkillsFruit, W
    IniWrite, %FruitSkillX%, %configFile%, SkillsFruit, X
    IniWrite, %FruitSkillC%, %configFile%, SkillsFruit, C
    IniWrite, %FruitSkillV%, %configFile%, SkillsFruit, V
    IniWrite, %FruitSkillB%, %configFile%, SkillsFruit, B
    IniWrite, %FruitSkillF%, %configFile%, SkillsFruit, F
    IniWrite, %GunSkillW%, %configFile%, SkillsGun, W
    IniWrite, %GunSkillX%, %configFile%, SkillsGun, X
    IniWrite, %GunSkillC%, %configFile%, SkillsGun, C
    IniWrite, %GunSkillV%, %configFile%, SkillsGun, V
    IniWrite, %GunSkillB%, %configFile%, SkillsGun, B
    IniWrite, %GunSkillF%, %configFile%, SkillsGun, F
    IniWrite, %TimeInput%, %configFile%, Settings, TimeInput
    MsgBox, Configuration sauvegardée.
Return


; Boucle principale
Start:
    toggle := true
    status := "Running"
    GuiControl,, StatusText, %status%

    While toggle {
        if FightingStyle {
            Send {1}
            Sleep, %TimeInput%
            ; Envoyer les compétences pour Fighting Style
            if (FSkillW) 
                Send {w}
                Sleep, %TimeInput%
            if (FSkillX) 
                Send {x}
                Sleep, %TimeInput%
            if (FSkillC) 
                Send {c}
                Sleep, %TimeInput%
            if (FSkillV) 
                Send {v}
                Sleep, %TimeInput%
            if (FSkillB) 
                Send {b}
                Sleep, %TimeInput%
            if (FSkillF) 
                Send {f}
                Sleep, %TimeInput%
            Sleep, %TimeInput%
        }
        if Sword {
            Send {3}
            Sleep, %TimeInput%
            ; Envoyer les compétences pour Sword
            if (SSkillW) 
                Send {w}
                Sleep, %TimeInput%
            if (SSkillX) 
                Send {x}
                Sleep, %TimeInput%
            if (SSkillC) 
                Send {c}
                Sleep, %TimeInput%
            if (SSkillV) 
                Send {v}
                Sleep, %TimeInput%
            if (SSkillB) 
                Send {b}
                Sleep, %TimeInput%
            if (SSkillF) 
                Send {f}
                Sleep, %TimeInput%
            Sleep, %TimeInput%
        }
        if Fruit {
            Send {4}
            Sleep, %TimeInput%
            ; Envoyer les compétences pour Fruit
            if (FruitSkillW) 
                Send {w}
                Sleep, %TimeInput%
            if (FruitSkillX) 
                Send {x}
                Sleep, %TimeInput%
            if (FruitSkillC) 
                Send {c}
                Sleep, %TimeInput%
            if (FruitSkillV) 
                Send {v}
                Sleep, %TimeInput%
            if (FruitSkillB) 
                Send {b}
                Sleep, %TimeInput%
            if (FruitSkillF) 
                Send {f}
                Sleep, %TimeInput%
            Sleep, %TimeInput%
        }
        if Gun {
            Send {5}
            Sleep, %TimeInput%
            ; Envoyer les compétences pour Gun
            if (GunSkillW) 
                Send {w}
                Sleep, %TimeInput%
            if (GunSkillX) 
                Send {x}
                Sleep, %TimeInput%
            if (GunSkillC) 
                Send {c}
                Sleep, %TimeInput%
            if (GunSkillV) 
                Send {v}
                Sleep, %TimeInput%
            if (GunSkillB) 
                Send {b}
                Sleep, %TimeInput%
            if (GunSkillF) 
                Send {f}
                Sleep, %TimeInput%
            Sleep, %TimeInput%
        }
    }
Return


; Pause avec F8
Pause:
    toggle := false
    status := "Paused"
    GuiControl,, StatusText, %status%
    if A_IsPaused {
        goto Start
    }
Return

; Stop avec F7
Stop:
    ExitApp
Return

; Configurer les touches du clavier
F7::ExitApp
F8::
    goto Pause
Return
F9::
    goto Start
Return
