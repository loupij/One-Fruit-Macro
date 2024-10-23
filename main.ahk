#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Pixel, Screen  ; S'assure que les coordonnées sont basées sur l'écran entier

; Fichier de configuration
configFile := A_ScriptDir . "\config.ini"
status := "Status : Configuration"
PixelGetColor, color, 196, 840, RGB

; Lecture du fichier de configuration au démarrage
IfNotExist, %configFile% ; création du fichier s'il n'existe pas
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
    ; IniWrite, 0, %configFile%, Settings, AutoObservationHaki
    ; IniWrite, 0, %configFile%, Settings, AutoArmamentHaki
    IniWrite, 0, %configFile%, Settings, AutoConquerorHaki
    Iniwrite, 500, %configFile%, Settings, CategoriesTimeInput ; valeur par défaut de l'intervalle = 500
    IniWrite, 1000, %configFile%, Settings, SkillTimeInput ; valeur par défaut de l'invervalle = 1000
}
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
; IniRead, AutoObservationHaki, %configFile%, Settings, AutoObservationHaki
; IniRead, AutoArmamentHaki, %configFile%, Settings, AutoArmamentHaki
IniRead, AutoConquerorHaki, %configFile%, Settings, AutoConquerorHaki
IniRead, CategoriesTimeInput, %configFile%, Settings, CategoriesTimeInput
IniRead, SkillTimeInput, %configFile%, Settings, SkillTimeInput

; Création de l'interface graphique
Gui, Add, Text,, Select what categories and skills you want to enable :
Gui, Add, Checkbox, vFightingStyle Checked%FightingStyle%, Fighting Style
Gui, Add, Checkbox, vSword Checked%Sword%, Sword
Gui, Add, Checkbox, vFruit Checked%Fruit%, Fruit
Gui, Add, Checkbox, vGun Checked%Gun%, Gun

Gui, Add, Text,, Select skills for each category:

Gui, Add, Text,, Fighting Style skills:
Gui, Add, Checkbox, vFSkillW Checked%FSkillW%, W
Gui, Add, Checkbox, vFSkillX Checked%FSkillX%, X
Gui, Add, Checkbox, vFSkillC Checked%FSkillC%, C
Gui, Add, Checkbox, vFSkillV Checked%FSkillV%, V
Gui, Add, Checkbox, vFSkillB Checked%FSkillB%, B
Gui, Add, Checkbox, vFSkillF Checked%FSkillF%, F

Gui, Add, Text,, Sword skills:
Gui, Add, Checkbox, vSSkillW Checked%SSkillW%, W
Gui, Add, Checkbox, vSSkillX Checked%SSkillX%, X
Gui, Add, Checkbox, vSSkillC Checked%SSkillC%, C
Gui, Add, Checkbox, vSSkillV Checked%SSkillV%, V
Gui, Add, Checkbox, vSSkillB Checked%SSkillB%, B
Gui, Add, Checkbox, vSSkillF Checked%SSkillF%, F

Gui, Add, Text,, Fruit skills:
Gui, Add, Checkbox, vFruitSkillW Checked%FruitSkillW%, W
Gui, Add, Checkbox, vFruitSkillX Checked%FruitSkillX%, X
Gui, Add, Checkbox, vFruitSkillC Checked%FruitSkillC%, C
Gui, Add, Checkbox, vFruitSkillV Checked%FruitSkillV%, V
Gui, Add, Checkbox, vFruitSkillB Checked%FruitSkillB%, B
Gui, Add, Checkbox, vFruitSkillF Checked%FruitSkillF%, F

Gui, Add, Text,, Gun skills:
Gui, Add, Checkbox, vGunSkillW Checked%GunSkillW%, W
Gui, Add, Checkbox, vGunSkillX Checked%GunSkillX%, X
Gui, Add, Checkbox, vGunSkillC Checked%GunSkillC%, C
Gui, Add, Checkbox, vGunSkillV Checked%GunSkillV%, V
Gui, Add, Checkbox, vGunSkillB Checked%GunSkillB%, B
Gui, Add, Checkbox, vGunSkillF Checked%GunSkillF%, F

; Champ d'entrée pour les intervalles
Gui, Add, Text,, Time interval between categories change (ms) :
Gui, Add, Edit, vTimeInput w100, %CategoriesTimeInput%
Gui, Add, Text,, Time interval between skills (ms) :
Gui, Add, Edit, vTimeInput2 w100, %SkillTimeInput%

; haki
Gui, Add, Text,, Auto Haki activation:
; Gui, Add, Checkbox, vAutoObservationHaki Checked%AutoObservationHaki%, Auto Observation Haki
; Gui, Add, Checkbox, vAutoArmamentHaki Checked%AutoArmamentHaki%, Auto Armamement Haki
Gui, Add, CHeckbox, vAutoConquerorHaki Checked%AutoConquerorHaki%, Auto Conqueror Haki

; Boutons de validation et contrôle
Gui, Add, Button, gValidate, Validate
Gui, Add, Text,,
Gui, Add, Button, gStart, F1 - Start
Gui, Add, Button, gPause, F2 - Pause
Gui, Add, Button, gStop, F3 - Stop

Gui, Add, Text, vStatusText, %status%
GuiControl,, StatusText, %status%

Gui, Show,, One Fruit Macro Configuration Panel
Return

; Validation des choix et sauvegarde dans config.ini
Validate:
    Gui, Submit, NoHide
    ; Afficher les valeurs pour déboguer (used for programmation)
    ; MsgBox, FightingStyle: %FightingStyle%`nSword: %Sword%`nFruit: %Fruit%`nGun: %Gun%`n
    ; MsgBox, FSkillW: %FSkillW%`nFSkillX: %FSkillX%`nFSkillC: %FSkillC%`nFSkillV: %FSkillV%`nFSkillB: %FSkillB%`nFSkillF: %FSkillF%`n
    ; MsgBox, SSkillW: %SSkillW%`nSSkillX: %SSkillX%`nSSkillC: %SSkillC%`nSSkillV: %SSkillV%`nSSkillB: %SSkillB%`nSSkillF: %SSkillF%`n
    ; MsgBox, FruitSkillW: %FruitSkillW%`nFruitSkillX: %FruitSkillX%`nFruitSkillC: %FruitSkillC%`nFruitSkillV: %FruitSkillV%`nFruitSkillB: %FruitSkillB%`nFruitSkillF: %FruitSkillF%`n
    ; MsgBox, GunSkillW: %GunSkillW%`nGunSkillX: %GunSkillX%`nGunSkillC: %GunSkillC%`nGunSkillV: %GunSkillV%`nGunSkillB: %GunSkillB%`nGunSkillF: %GunSkillF%`n

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
    ; IniWrite, %AutoObservationHaki%, %configFile%, Settings, AutoObservationHaki
    ; IniWrite, %AutoArmamentHaki%, %configFile%, Settings, AutoArmamentHaki
    IniWrite, %AutoConquerorHaki%, %configFile%, Settings, AutoConquerorHaki 
    Iniwrite, %CategoriesTimeInput%, %configFile%, Settings, CategoriesTimeInput
    IniWrite, %SkillTimeInput%, %configFile%, Settings, SkillTimeInput
    MsgBox, Settings have been successfully saved.
Return


; Boucle principale
Start:
    status := "Status : Starting"
    GuiControl,, StatusText, %status%
    Sleep 1000
    status := "Status : Running"
    GuiControl,, StatusText, %status%
    toggle := true

    While toggle {
        ; if AutoObservationHaki {
        ;     if (color != 0x54FBFB) {
        ;         Send {r}
        ;         Sleep, %SkillTimeInput%
        ;     }
        ; }
        ; if AutoArmamentHaki {
        ;     Send {r}
        ;     Sleep, 5000
        ; }
        if AutoConquerorHaki {
            Send {h}
            Sleep, %SkillTimeInput%
        }
        if FightingStyle {
            Send {&}
            Sleep, %SkillTimeInput%
            ; Envoyer les compétences pour Fighting Style
            if (FSkillW) {
                Send {w}
                Sleep, %SkillTimeInput%
            }
            if (FSkillX) {
                Send {x}
                Sleep, %SkillTimeInput%
            }
            if (FSkillC) {
                Send {c}
                Sleep, %SkillTimeInput%
            }
            if (FSkillV) {
                Send {v}
                Sleep, %SkillTimeInput%
            }
            if (FSkillB) {
                Send {b}
                Sleep, %SkillTimeInput%
            }
            if (FSkillF) {
                Send {f}
                Sleep, %SkillTimeInput%
            }
            Sleep, %CategoriesTimeInput%
        }
        if Sword {
            Send {"}
            Sleep, %SkillTimeInput%
            ; Envoyer les compétences pour Sword
            if (SSkillW) {
                Send {w}
                Sleep, %SkillTimeInput%
            }
            if (SSkillX) {
                Send {x}
                Sleep, %SkillTimeInput%
            }
            if (SSkillC) {
                Send {c}
                Sleep, %SkillTimeInput%
            }
            if (SSkillV) {
                Send {v}
                Sleep, %SkillTimeInput%
            }
            if (SSkillB) {
                Send {b}
                Sleep, %SkillTimeInput%
            }
            if (SSkillF) {
                Send {f}
                Sleep, %SkillTimeInput%
            }
            Sleep, %CategoriesTimeInput%
        }
        if Fruit {
            Send {'}
            Sleep, %SkillTimeInput%
            ; Envoyer les compétences pour Fruit
            if (FruitSkillW) {
                Send {w}
                Sleep, %SkillTimeInput%
            }
            if (FruitSkillX) {
                Send {x}
                Sleep, %SkillTimeInput%
            }
            if (FruitSkillC) {
                Send {c}
                Sleep, %SkillTimeInput%
            }
            if (FruitSkillV) {
                Send {v}
                Sleep, %SkillTimeInput%
            }
            if (FruitSkillB) {
                Send {b}
                Sleep, %SkillTimeInput%
            }
            if (FruitSkillF) {
                Send {f}
                Sleep, %SkillTimeInput%
            }
            Sleep, %CategoriesTimeInput%
        }
        if Gun {
            Send {(}
            Sleep, %SkillTimeInput%
            ; Envoyer les compétences pour Gun
            if (GunSkillW) {
                Send {w}
                Sleep, %SkillTimeInput%
            }
            if (GunSkillX) {
                Send {x}
                Sleep, %SkillTimeInput%
            }
            if (GunSkillC) {
                Send {c}
                Sleep, %SkillTimeInput%
            }
            if (GunSkillV) {
                Send {v}
                Sleep, %SkillTimeInput%
            }
            if (GunSkillB) {
                Send {b}
                Sleep, %SkillTimeInput%
            }
            if (GunSkillF) {
                Send {f}
                Sleep, %SkillTimeInput%
            }
            Sleep, %CategoriesTimeInput%
        }
    }
Return


; Pause avec F2
Pause:
    if (status = "Status : Paused") {
        goto Start
    } else {
        toggle := False
        status := "Status : Paused" 
        GuiControl,, StatusText, %status%
    } 
Return

; Stop avec F3
Stop:
    status := "Status : Stopping."
    GuiControl,, StatusText, %status%
    Sleep 1000
    ExitApp
Return

; Configurer les touches du clavier
F3::
    goto Stop
Return

F2::
    goto Pause
Return

F1::
    goto Start
Return
