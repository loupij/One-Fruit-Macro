#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; init toggle & status
toggle := false
status := "Configuration"

; créarion de l'ui & catégories
Gui, Add, Text,, Choisissez les catégories et skills à activer :
Gui, Add, Checkbox, vFightingStyle, Fighting Style
Gui, Add, Checkbox, vSword, Sword
Gui, Add, Checkbox, vFruit, Fruit
Gui, Add, Checkbox, vGun, Gun

Gui, Add, Text,, Sélectionnez les skills pour chaque catégorie :

; skills FS
Gui, Add, Text,, Skills pour Fighting Style:
Gui, Add, Checkbox, vFSkillW, W
Gui, Add, Checkbox, vFSkillX, X
Gui, Add, Checkbox, vFSkillC, C
Gui, Add, Checkbox, vFSkillV, V
Gui, Add, Checkbox, vFSkillB, B
Gui, Add, Checkbox, vFSkillF, F

; skills sword
Gui, Add, Text,, Skills pour Sword:
Gui, Add, Checkbox, vSSkillW, W
Gui, Add, Checkbox, vSSkillX, X
Gui, Add, Checkbox, vSSkillC, C
Gui, Add, Checkbox, vSSkillV, V
Gui, Add, Checkbox, vSSkillB, B
Gui, Add, Checkbox, vSSkillF, F

; skills fruit
Gui, Add, Text,, Skills pour Fruit:
Gui, Add, Checkbox, vFruitSkillW, W
Gui, Add, Checkbox, vFruitSkillX, X
Gui, Add, Checkbox, vFruitSkillC, C
Gui, Add, Checkbox, vFruitSkillV, V
Gui, Add, Checkbox, vFruitSkillB, B
Gui, Add, Checkbox, vFruitSkillF, F

; skills gun
Gui, Add, Text,, Skills pour Gun:
Gui, Add, Checkbox, vGunSkillW, W
Gui, Add, Checkbox, vGunSkillX, X
Gui, Add, Checkbox, vGunSkillC, C
Gui, Add, Checkbox, vGunSkillV, V
Gui, Add, Checkbox, vGunSkillB, B
Gui, Add, Checkbox, vGunSkillF, F

; champ entré pour intervalle
Gui, Add, Text,, Intervalle de temps entre les opérations (en ms) :
Gui, Add, Edit, vTimeInput w100, 500  ; valeur par défaut

; bouton valider
Gui, Add, Button, gValidate, Valider

; boutons controle
Gui, Add, Button, gStart, F9 - Start
Gui, Add, Button, gPause, F8 - Pause
Gui, Add, Button, gStop, F7 - Stop

; affichage du statut
Gui, Add, Text, vStatusText, %status%

Gui, Show,, Configuration des Catégories et Skills
Return

; validation des choix (bouton valider)
Validate:
    Gui, Submit, NoHide  ; enregistre les choix de l'utilisateur (sans fermer l'interface)

    ; vérif valeur intervalle
    if (TimeInput == "")
    {
        MsgBox, Veuillez entrer une valeur pour l'intervalle de temps.
        Return
    }
    
    ; convertir l'entrée en nombre
    intervalle := TimeInput + 0

    ; stocker skills pour chaque catégorie
    FSskills := []
    if FSkillW
        FSskills.Push("w")
    if FSkillX
        FSskills.Push("x")
    if FSkillC
        FSskills.Push("c")
    if FSkillV
        FSskills.Push("v")
    if FSkillB
        FSskills.Push("b")
    if FSkillF
        FSskills.Push("f")

    Swordskills := []
    if SSkillW
        Swordskills.Push("w")
    if SSkillX
        Swordskills.Push("x")
    if SSkillC
        Swordskills.Push("c")
    if SSkillV
        Swordskills.Push("v")
    if SSkillB
        Swordskills.Push("b")
    if SSkillF
        Swordskills.Push("f")

    FruitSkills := []
    if FruitSkillW
        FruitSkills.Push("w")
    if FruitSkillX
        FruitSkills.Push("x")
    if FruitSkillC
        FruitSkills.Push("c")
    if FruitSkillV
        FruitSkills.Push("v")
    if FruitSkillB
        FruitSkills.Push("b")
    if FruitSkillF
        FruitSkills.Push("f")

    GunSkills := []
    if GunSkillW
        GunSkills.Push("w")
    if GunSkillX
        GunSkills.Push("x")
    if GunSkillC
        GunSkills.Push("c")
    if GunSkillV
        GunSkills.Push("v")
    if GunSkillB
        GunSkills.Push("b")
    if GunSkillF
        GunSkills.Push("f")

    ; message config terminée
    MsgBox, Configuration terminée.
Return

; boucle principale
Start:
    toggle := true
    status := "Running"
    GuiControl,, StatusText, %status% 

    While toggle {
        if FightingStyle {
            Send {1}
            Sleep intervalle
            for index, skill in FSskills {
                Send {%skill%}
                Sleep intervalle
            }
        }
        if Sword {
            Send {3}
            Sleep intervalle
            for index, skill in Swordskills {
                Send {%skill%}
                Sleep intervalle
            }
        }
        if Fruit {
            Send {4}
            Sleep intervalle
            for index, skill in FruitSkills {
                Send {%skill%}
                Sleep intervalle
            }
        }
        if Gun {
            Send {5}
            Sleep intervalle
            for index, skill in GunSkills {
                Send {%skill%}
                Sleep intervalle
            }
        }
    }
Return

; pause avec F8 (bouton)
Pause:
    toggle := false
    status := "Paused"
    GuiControl,, StatusText, %status% 
Return

; stop avec F7 (bouton)
Stop:
    ExitApp
Return

; config les touches (clavier)
F8::
	status := "Paused"
	GuiControl,, StatusText, %status%	
	Pause
Return

F7::ExitApp

F9::
    status := "Starting"
    GuiControl,, StatusText, %status%
    goto Start
Return
