#NoEnv
#SingleInstance, force
#Persistent
#Requires AutoHotkey v1.1+ 64-bit

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

; #Include fonctions.ahk

; initialisation de variables
global version := "1.4.0"

global configFile := A_ScriptDir . "\config.ini"
global status := "Status : Configuration"
global FirstStart := true
global running := false
global Loopcount := 0
global mouseSpeed := 500

; options
global FightingStyle
global Sword
global Fruit
global Gun
global FSkillZ
global FSkillX
global FSkillC
global FSkillV
global FSkillB
global FSkillF
global SSkillZ
global SSkillX
global SSkillC
global SSkillV
global SSkillB
global SSkillF
global FruitSkillZ
global FruitSkillX
global FruitSkillC
global FruitSkillV
global FruitSkillB
global FruitSkillF
global GunSkillZ
global GunSkillX
global GunSkillC
global GunSkillV
global GunSkillB
global GunSkillF
global AutoConquerorHaki
global AutoClaimTimeRewards
global CategoriesTimeInput
global SkillTimeInput
global TRDropFruitIfStorageFull
global TRCheckCount
global AZERTYLayout

; from DolphSol's macro, all credits goes to them - fonction importante
; move cursor and click to given location
ClickMouse(posX, posY) {
    MouseMove, % posX, % posY
    Sleep, mouseSpeed
    MouseClick
    Sleep, mouseSpeed
}

; Lecture du config.ini
IfNotExist, %configFile% ; création du fichier s'il n'existe pas
{
    IniWrite, 0, %configFile%, Categories, FightingStyle
    IniWrite, 0, %configFile%, Categories, Sword
    IniWrite, 0, %configFile%, Categories, Fruit
    IniWrite, 0, %configFile%, Categories, Gun
    IniWrite, 0, %configFile%, SkillsFightingStyle, Z
    IniWrite, 0, %configFile%, SkillsFightingStyle, X
    IniWrite, 0, %configFile%, SkillsFightingStyle, C
    IniWrite, 0, %configFile%, SkillsFightingStyle, V
    IniWrite, 0, %configFile%, SkillsFightingStyle, B
    IniWrite, 0, %configFile%, SkillsFightingStyle, F
    IniWrite, 0, %configFile%, SkillsSword, Z
    IniWrite, 0, %configFile%, SkillsSword, X
    IniWrite, 0, %configFile%, SkillsSword, C
    IniWrite, 0, %configFile%, SkillsSword, V
    IniWrite, 0, %configFile%, SkillsSword, B
    IniWrite, 0, %configFile%, SkillsSword, F
    IniWrite, 0, %configFile%, SkillsFruit, Z
    IniWrite, 0, %configFile%, SkillsFruit, X
    IniWrite, 0, %configFile%, SkillsFruit, C
    IniWrite, 0, %configFile%, SkillsFruit, V
    IniWrite, 0, %configFile%, SkillsFruit, B
    IniWrite, 0, %configFile%, SkillsFruit, F
    IniWrite, 0, %configFile%, SkillsGun, Z
    IniWrite, 0, %configFile%, SkillsGun, X
    IniWrite, 0, %configFile%, SkillsGun, C
    IniWrite, 0, %configFile%, SkillsGun, V
    IniWrite, 0, %configFile%, SkillsGun, B
    IniWrite, 0, %configFile%, SkillsGun, F
    IniWrite, 1, %configFile%, AutoTasks, AutoConquerorHaki
    IniWrite, 0, %configFile%, AutoTasks, AutoClaimTimeRewards
    Iniwrite, 500, %configFile%, Intervals, CategoriesTimeInput ; valeur par défaut de l'intervalle = 500
    IniWrite, 1000, %configFile%, Intervals, SkillTimeInput ; valeur par défaut de l'invervalle = 1000
    IniWrite, 0, %configFile%, TRSettings, TRDropFruitIfStorageFull
    IniWrite, 50, %configFile%, TRSettings, TRCheckCount
    IniWrite, 0, %configFile%, Others, AZERTYLayout
}
IniRead, FightingStyle, %configFile%, Categories, FightingStyle
IniRead, Sword, %configFile%, Categories, Sword
IniRead, Fruit, %configFile%, Categories, Fruit
IniRead, Gun, %configFile%, Categories, Gun
IniRead, FSkillZ, %configFile%, SkillsFightingStyle, Z
IniRead, FSkillX, %configFile%, SkillsFightingStyle, X
IniRead, FSkillC, %configFile%, SkillsFightingStyle, C
IniRead, FSkillV, %configFile%, SkillsFightingStyle, V
IniRead, FSkillB, %configFile%, SkillsFightingStyle, B
IniRead, FSkillF, %configFile%, SkillsFightingStyle, F
IniRead, SSkillZ, %configFile%, SkillsSword, Z
IniRead, SSkillX, %configFile%, SkillsSword, X
IniRead, SSkillC, %configFile%, SkillsSword, C
IniRead, SSkillV, %configFile%, SkillsSword, V
IniRead, SSkillB, %configFile%, SkillsSword, B
IniRead, SSkillF, %configFile%, SkillsSword, F
IniRead, FruitSkillZ, %configFile%, SkillsFruit, Z
IniRead, FruitSkillX, %configFile%, SkillsFruit, X
IniRead, FruitSkillC, %configFile%, SkillsFruit, C
IniRead, FruitSkillV, %configFile%, SkillsFruit, V
IniRead, FruitSkillB, %configFile%, SkillsFruit, B
IniRead, FruitSkillF, %configFile%, SkillsFruit, F
IniRead, GunSkillZ, %configFile%, SkillsGun, Z
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
IniRead, AZERTYLayout, %configFile%, Others, AZERTYLayout

; INTERFACE
Gui, Add, Tab2, vMyTab w600 h210, Main|Others|Settings  ; Ajoute les onglets

; --- Onglet "Configuration" ---
Gui, Tab, 1

; GroupBox pour Fighting Style
Gui, Add, GroupBox, x10 y30 w140 h180, Fighting Style
Gui, Add, Checkbox, vFightingStyle x20 y50 Checked%FightingStyle%, Enable Fighting Style
Gui, Add, Text, x20 y70, Skills:
Gui, Add, Checkbox, vFSkillZ x20 y90 Checked%FSkillZ%, Z
Gui, Add, Checkbox, vFSkillX x20 y110 Checked%FSkillX%, X
Gui, Add, Checkbox, vFSkillC x20 y130 Checked%FSkillC%, C
Gui, Add, Checkbox, vFSkillV x20 y150 Checked%FSkillV%, V
Gui, Add, Checkbox, vFSkillB x20 y170 Checked%FSkillB%, B
Gui, Add, Checkbox, vFSkillF x20 y190 Checked%FSkillF%, F

; GroupBox pour Sword
Gui, Add, GroupBox, x160 y30 w140 h180, Sword
Gui, Add, Checkbox, vSword x170 y50 Checked%Sword%, Enable Sword
Gui, Add, Text, x170 y70, Skills:
Gui, Add, Checkbox, vSSkillZ x170 y90 Checked%SSkillZ%, Z
Gui, Add, Checkbox, vSSkillX x170 y110 Checked%SSkillX%, X
Gui, Add, Checkbox, vSSkillC x170 y130 Checked%SSkillC%, C
Gui, Add, Checkbox, vSSkillV x170 y150 Checked%SSkillV%, V
Gui, Add, Checkbox, vSSkillB x170 y170 Checked%SSkillB%, B
Gui, Add, Checkbox, vSSkillF x170 y190 Checked%SSkillF%, F

; GroupBox pour Fruit
Gui, Add, GroupBox, x310 y30 w140 h180, Fruit
Gui, Add, Checkbox, vFruit x320 y50 Checked%Fruit%, Enable Fruit
Gui, Add, Text, x320 y70, Skills:
Gui, Add, Checkbox, vFruitSkillZ x320 y90 Checked%FruitSkillZ%, Z
Gui, Add, Checkbox, vFruitSkillX x320 y110 Checked%FruitSkillX%, X
Gui, Add, Checkbox, vFruitSkillC x320 y130 Checked%FruitSkillC%, C
Gui, Add, Checkbox, vFruitSkillV x320 y150 Checked%FruitSkillV%, V
Gui, Add, Checkbox, vFruitSkillB x320 y170 Checked%FruitSkillB%, B
Gui, Add, Checkbox, vFruitSkillF x320 y190 Checked%FruitSkillF%, F

; GroupBox pour Gun
Gui, Add, GroupBox, x460 y30 w140 h180, Gun
Gui, Add, Checkbox, vGun x470 y50 Checked%Gun%, Enable Gun
Gui, Add, Text, x470 y70, Skills:
Gui, Add, Checkbox, vGunSkillZ x470 y90 Checked%GunSkillZ%, Z
Gui, Add, Checkbox, vGunSkillX x470 y110 Checked%GunSkillX%, X
Gui, Add, Checkbox, vGunSkillC x470 y130 Checked%GunSkillC%, C
Gui, Add, Checkbox, vGunSkillV x470 y150 Checked%GunSkillV%, V
Gui, Add, Checkbox, vGunSkillB x470 y170 Checked%GunSkillB%, B
Gui, Add, Checkbox, vGunSkillF x470 y190 Checked%GunSkillF%, F

; --- Onglet "Auto Tasks" ---
Gui, Tab, 2

Gui, Add, GroupBox, x10 y30 w160 h180, Automation
Gui, Add, Checkbox, x20 y50 vAutoConquerorHaki Checked%AutoConquerorHaki%, Auto Conqueror Haki
Gui, Add, Checkbox, x20 y70 vAutoClaimTimeRewards gTRWarning Checked%AutoClaimTimeRewards%, Auto Claim Time Rewards

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
Gui, Add, Edit, x170 y90 vTRCheckCount gTRCheckCountVerifValue w100, %TRCheckCount%

; Autres
Gui, Add, GroupBox, x310 y30 w140 h40, Others
Gui, Add, Checkbox, vAZERTYLayout x320 y50 Checked%AZERTYLayout%, AZERTY Layout


Gui, Tab  ; Sort des onglets

; --- Boutons de validation et de contrôle ---
Gui, Add, Button, x20 y230 w100 gValidate, Validate
Gui, Add, Button, x120 y230 w100 gStartButton, F1 - Start
Gui, Add, Button, x220 y230 w100 gPauseButton, F2 - Pause
Gui, Add, Button, x320 y230 w100 gStopButton, F3 - Stop
Gui, Add, Text, x500 y235 vStatusText, %status%

Gui, Show,, loupij's One Fruit Macro
return


; validation des paramètres et sauvegarde dans config.ini (bouton Valider)
Validate:
    Gui, Submit, NoHide

    ; sauvegarde des parametres
    IniWrite, %FightingStyle%, %configFile%, Categories, FightingStyle
    IniWrite, %Sword%, %configFile%, Categories, Sword
    IniWrite, %Fruit%, %configFile%, Categories, Fruit
    IniWrite, %Gun%, %configFile%, Categories, Gun
    IniWrite, %FSkillZ%, %configFile%, SkillsFightingStyle, Z
    IniWrite, %FSkillX%, %configFile%, SkillsFightingStyle, X
    IniWrite, %FSkillC%, %configFile%, SkillsFightingStyle, C
    IniWrite, %FSkillV%, %configFile%, SkillsFightingStyle, V
    IniWrite, %FSkillB%, %configFile%, SkillsFightingStyle, B
    IniWrite, %FSkillF%, %configFile%, SkillsFightingStyle, F
    IniWrite, %SSkillZ%, %configFile%, SkillsSword, Z
    IniWrite, %SSkillX%, %configFile%, SkillsSword, X
    IniWrite, %SSkillC%, %configFile%, SkillsSword, C
    IniWrite, %SSkillV%, %configFile%, SkillsSword, V
    IniWrite, %SSkillB%, %configFile%, SkillsSword, B
    IniWrite, %SSkillF%, %configFile%, SkillsSword, F
    IniWrite, %FruitSkillZ%, %configFile%, SkillsFruit, Z
    IniWrite, %FruitSkillX%, %configFile%, SkillsFruit, X
    IniWrite, %FruitSkillC%, %configFile%, SkillsFruit, C
    IniWrite, %FruitSkillV%, %configFile%, SkillsFruit, V
    IniWrite, %FruitSkillB%, %configFile%, SkillsFruit, B
    IniWrite, %FruitSkillF%, %configFile%, SkillsFruit, F
    IniWrite, %GunSkillZ%, %configFile%, SkillsGun, Z
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
    IniWrite, %AZERTYLayout%, %configFile%, Others, AZERTYLayout
    MsgBox, Settings have been successfully saved.
Return


; Boucle principale

mainLoopStart() {
    if FirstStart {
        updateStatus("Starting")
        Sleep 1000
        updateStatus("Running")
        running := true
        FirstStart := false
        if AutoClaimTimeRewards {
            ClaimTimeRewards()
        }
        mainLoop()
    } else {
        updateStatus("Restarting")
        Sleep 1000
        updateStatus("Running")
        running := true
        mainLoop()
    }
}

mainLoop() {
    While running {
        ; time rewards
        if AutoClaimTimeRewards {
            Loopcount := Loopcount + 1
            if (Loopcount = TRCheckCount) {
                ClaimTimeRewards()
                Loopcount := 1
                Sleep, %CategoriesTimeInput%
            }
        }

        ; conqueror's haki
        if AutoConquerorHaki {
            Send {h}
            Sleep, %CategoriesTimeInput%
        }

        ; fithing style
        if FightingStyle {
            if AZERTYLayout {
                Send {&}
            } else {
                Send {1}
            }
            Sleep, %CategoriesTimeInput%
            if (FSkillZ) {
                if AZERTYLayout {
                    Send {w}
                } else {
                    Send {z}
                }
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
            if AZERTYLayout {
                Send {"}
            } else {
                Send {3}
            }
            Sleep, %CategoriesTimeInput%
            if (SSkillZ) {
                if AZERTYLayout {
                    Send {w}
                } else {
                    Send {z}
                }
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
            if AZERTYLayout {
                Send {'}
            } else {
                Send {4}
            }
            Sleep, %CategoriesTimeInput%
            if (FruitSkillZ) {
                if AZERTYLayout {
                    Send {w}
                } else {
                    Send {z}
                }
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
            if AZERTYLayout {
                Send {(}
            } else {
                Send {5}
            }
            Sleep, %CategoriesTimeInput%
            if (GunSkillZ) {
                if AZERTYLayout {
                    Send {w}
                } else {
                    Send {z}
                }
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
}

ClaimTimeRewards() {
    if AZERTYLayout { ; ouvir le menu
        Send {,}
    } else {
        Send {m}
    }
    Sleep mouseSpeed
    ClickMouse(1320, 500) ; bouton TIME REWARDS
    ClickMouse(740, 430) ; 1
    ClickMouse(850, 430) ; 2
    ClickMouse(955, 430) ; 3
    ClickMouse(1060, 430) ; 4
    ClickMouse(1170, 430) ; 5 - fruit
    ClickMouse(740, 550) ; 6
    ClickMouse(850, 550) ; 7
    ClickMouse(960, 550) ; 8
    ClickMouse(1070, 550) ; 9
    ClickMouse(1160, 550) ; 10 - fruit
    ClickMouse(1240, 300) ; fermer menu time rewards
    ClickMouse(850, 845) ; Storage (fruit)
    if TRDropFruitIfStorageFull {
        ClickMouse(1080, 845)  ; Drop (fruit)
    }
    MouseMove, 960, 280 ; Retour en haut de l'écran
}

; inspired by DolphSol's macro
updateStatus(newStatus) {
    GuiControl,, StatusText, % "Status : " newStatus
}

TRWarning:
    Gui, Submit, NoHide
    if AutoClaimTimeRewards {
        MsgBox, Caution! This feature only works with 1920x1080 screens.`nAlso, make sure your Roblox window is fully windowed (not fullscreen)
    }
Return

TRCheckCountVerifValue:
    Gui, Submit, NoHide
    if (TRCheckCount = "") {
        Return
    }
    if RegExMatch(TRCheckCount, "^\d+$") { ; vérifie si TRCheckCount est un chiffre
        if (TRCheckCount < 1) {
            MsgBox, Error : value must be greater than or equal to 0 for Time Rewards claiming interval.
            Return
        }
    } else {
        MsgBox, Error : value must be a valid number.
        Return
    }
Return

; inspired by DolphSol's Macro
handlePause() {
    if running {
        running := false
        updateStatus("Paused")
        MsgBox, Please note that the pause feature isn't very stable currently. It is suggested to stop instead.
    } else {
        running = false
        mainLoopStart()
    }
}

Stop() {
    updateStatus("Stopping")
    Sleep 1000
    ExitApp
}

; boutons interface
StartButton:
    mainLoopStart()
Return

PauseButton:
    handlePause()
Return

StopButton:
    Stop()
Return

; touches du clavier
F3::Stop()

F2::handlePause()

F1::mainLoopStart()

GuiClose:
    ExitApp
Return
