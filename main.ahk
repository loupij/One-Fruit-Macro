#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Mouse, Screen

#SingleInstance, force
#Persistent
#Requires AutoHotkey v1.1+ 64-bit

#Include fonctions.ahk

; initialisation de variables
configFile := A_ScriptDir . "\config.ini"
status := "Status : Configuration"

; Lecture du config.ini
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
    IniWrite, 0, %configFile%, AutoTasks, AutoConquerorHaki
    IniWrite, 0, %configFile%, AutoTasks, AutoClaimTimeRewards
    Iniwrite, 500, %configFile%, Intervals, CategoriesTimeInput ; valeur par défaut de l'intervalle = 500
    IniWrite, 1000, %configFile%, Intervals, SkillTimeInput ; valeur par défaut de l'invervalle = 1000
    IniWrite, 0, %configFile%, TRSettings, TRDropFruitIfStorageFull
    IniWrite, 50, %configFile%, TRSettings, TRCheckCount
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
IniRead, AutoConquerorHaki, %configFile%, AutoTasks, AutoConquerorHaki
IniRead, AutoClaimTimeRewards, %configFile%, AutoTasks, AutoClaimTimeRewards
IniRead, CategoriesTimeInput, %configFile%, Intervals, CategoriesTimeInput
IniRead, SkillTimeInput, %configFile%, Intervals, SkillTimeInput
IniRead, TRDropFruitIfStorageFull, %configFile%, TRSettings, TRDropFruitIfStorageFull
IniRead, TRCheckCount, %configFile%, TRSettings, TRCheckCount

; INTERFACE
Gui, Add, Tab2, vMyTab w600 h210, Main|Others|Settings  ; Ajoute les onglets

; --- Onglet "Configuration" ---
Gui, Tab, 1

; GroupBox pour Fighting Style
Gui, Add, GroupBox, x10 y30 w140 h180, Fighting Style
Gui, Add, Checkbox, vFightingStyle x20 y50 Checked%FightingStyle%, Enable Fighting Style
Gui, Add, Text, x20 y70, Skills:
Gui, Add, Checkbox, vFSkillW x20 y90 Checked%FSkillW%, W
Gui, Add, Checkbox, vFSkillX x20 y110 Checked%FSkillX%, X
Gui, Add, Checkbox, vFSkillC x20 y130 Checked%FSkillC%, C
Gui, Add, Checkbox, vFSkillV x20 y150 Checked%FSkillV%, V
Gui, Add, Checkbox, vFSkillB x20 y170 Checked%FSkillB%, B
Gui, Add, Checkbox, vFSkillF x20 y190 Checked%FSkillF%, F

; GroupBox pour Sword
Gui, Add, GroupBox, x160 y30 w140 h180, Sword
Gui, Add, Checkbox, vSword x170 y50 Checked%Sword%, Enable Sword
Gui, Add, Text, x170 y70, Skills:
Gui, Add, Checkbox, vSSkillW x170 y90 Checked%SSkillW%, W
Gui, Add, Checkbox, vSSkillX x170 y110 Checked%SSkillX%, X
Gui, Add, Checkbox, vSSkillC x170 y130 Checked%SSkillC%, C
Gui, Add, Checkbox, vSSkillV x170 y150 Checked%SSkillV%, V
Gui, Add, Checkbox, vSSkillB x170 y170 Checked%SSkillB%, B
Gui, Add, Checkbox, vSSkillF x170 y190 Checked%SSkillF%, F

; GroupBox pour Fruit
Gui, Add, GroupBox, x310 y30 w140 h180, Fruit
Gui, Add, Checkbox, vFruit x320 y50 Checked%Fruit%, Enable Fruit
Gui, Add, Text, x320 y70, Skills:
Gui, Add, Checkbox, vFruitSkillW x320 y90 Checked%FruitSkillW%, W
Gui, Add, Checkbox, vFruitSkillX x320 y110 Checked%FruitSkillX%, X
Gui, Add, Checkbox, vFruitSkillC x320 y130 Checked%FruitSkillC%, C
Gui, Add, Checkbox, vFruitSkillV x320 y150 Checked%FruitSkillV%, V
Gui, Add, Checkbox, vFruitSkillB x320 y170 Checked%FruitSkillB%, B
Gui, Add, Checkbox, vFruitSkillF x320 y190 Checked%FruitSkillF%, F

; GroupBox pour Gun
Gui, Add, GroupBox, x460 y30 w140 h180, Gun
Gui, Add, Checkbox, vGun x470 y50 Checked%Gun%, Enable Gun
Gui, Add, Text, x470 y70, Skills:
Gui, Add, Checkbox, vGunSkillW x470 y90 Checked%GunSkillW%, W
Gui, Add, Checkbox, vGunSkillX x470 y110 Checked%GunSkillX%, X
Gui, Add, Checkbox, vGunSkillC x470 y130 Checked%GunSkillC%, C
Gui, Add, Checkbox, vGunSkillV x470 y150 Checked%GunSkillV%, V
Gui, Add, Checkbox, vGunSkillB x470 y170 Checked%GunSkillB%, B
Gui, Add, Checkbox, vGunSkillF x470 y190 Checked%GunSkillF%, F

; --- Onglet "Auto Tasks" ---
Gui, Tab, 2

Gui, Add, GroupBox, x10 y30 w160 h180, Automation
Gui, Add, Text,x20 y50 , Auto Tasks activation:
Gui, Add, Checkbox, x20 y70 vAutoConquerorHaki Checked%AutoConquerorHaki%, Auto Conqueror Haki
Gui, Add, Checkbox, x20 y90 vAutoClaimTimeRewards gTRWarning Checked%AutoClaimTimeRewards%, Auto Claim Time Rewards

; --- Onglet "Settings" ---
Gui, Tab, 3

; intervalles
Gui, Add, GroupBox, x10 y30 w140 h180, Intervals
Gui, Add, Text, x20 y50, Categories change (ms):
Gui, Add, Edit, x20 y70 vTimeInput w100, %CategoriesTimeInput%
Gui, Add, Text, x20 y90, Skills cast (ms):
Gui, Add, Edit, x20 y110 vTimeInput2 w100, %SkillTimeInput%

; time rewards
Gui, Add, GroupBox, x160 y30 w140 h180, Time Rewards
Gui, Add, CheckBox, vTRDropFruitIfStorageFull x170 y50 Checked%TRDropFruitIfStorageFull%, Drop fruit if storage full
Gui, Add, Text, x170 y70, Claim TR every X loops
Gui, Add, Edit, x170 y90 vTRCheckCount w100, %TRCheckCount%


Gui, Tab  ; Sort des onglets

; --- Boutons de validation et de contrôle ---
Gui, Add, Button, x20 y230 w100 gValidate, Validate
Gui, Add, Button, x120 y230 w100 gStart, F1 - Start
Gui, Add, Button, x220 y230 w100 gPause, F2 - Pause
Gui, Add, Button, x320 y230 w100 gStop, F3 - Stop
Gui, Add, Text, x500 y235 vStatusText, %status%

GuiControl,, StatusText, %status%

Gui, Show,, Configuration Panel
return


; validation des paramètres et sauvegarde dans config.ini (bouton Valider)
Validate:
    Gui, Submit, NoHide

    ; sauvegarde des parametres
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
    IniWrite, %AutoConquerorHaki%, %configFile%, AutoTasks, AutoConquerorHaki
    IniWrite, %AutoClaimTimeRewards%, %configFile%, AutoTasks, AutoClaimTimeRewards
    Iniwrite, %CategoriesTimeInput%, %configFile%, Intervals, CategoriesTimeInput
    IniWrite, %SkillTimeInput%, %configFile%, Intervals, SkillTimeInput
    IniWrite, %TRDropFruitIfStorageFull%, %configFile%, TRSettings, TRDropFruitIfStorageFull
    IniWrite, %TRCheckCount%, %configFile%, TRSettings, TRCheckCount
    MsgBox, Settings have been successfully saved.
Return


; Boucle principale

Start:
    status := "Status : Starting"
    GuiControl,, StatusText, %status%
    Loopcount := 0
    Sleep 1000
    status := "Status : Running"
    GuiControl,, StatusText, %status%
    toggle := true

    if AutoClaimTimeRewards {
        ClaimTimeRewards()
    }
    While toggle {
        if AutoClaimTimeRewards {
            Loopcount := Loopcount + 1
            if (Loopcount = TRCheckCount) {
                ClaimTimeRewards()
                Loopcount := 1
                TRFirst := False
                Sleep, %CategoriesTimeInput%
            }
        }
        if AutoConquerorHaki {
            Send {h}
            Sleep, %CategoriesTimeInput%
        }
        if FightingStyle {
            Send {&}
            Sleep, %CategoriesTimeInput%
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
        }
        if Sword {
            Send {"}
            Sleep, %CategoriesTimeInput%
            if (SSkillW) {
                Send {w}
                Sleep, %CategoriesTimeInput%
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
        }
        if Fruit {
            Send {'}
            Sleep, %CategoriesTimeInput%
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
        }
        if Gun {
            Send {(}
            Sleep, %CategoriesTimeInput%
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
        }
    }
Return

TRWarning:
    Gui, Submit, NoHide
    if AutoClaimTimeRewards {
        TRWarning()
    }
Return

TRCheckCountVerifValue:
    if (TRCheckCount = 0) {
        MsgBOx, Error : value must be superior to 0 for Time Rewards claiming interval.
    }
Pause:
    if (status = "Status : Paused") {
        Goto, Start
        doTR := false
    } else {
        toggle := False
        status := "Status : Paused" 
        GuiControl,, StatusText, %status%
    } 
Return

Stop:
    status := "Status : Stopping."
    GuiControl,, StatusText, %status%
    Sleep 1000
    ExitApp
Return

F3::
    Goto, Stop
Return

F2::
    Goto, Pause
Return

F1::
    Goto, Start
Return

GuiClose:
    ExitApp
Return
