#SingleInstance force
Persistent
#Requires Autohotkey v2.0
#Warn All, OutputDebug
SendMode("Event")
SetWorkingDir(A_ScriptDir)
CoordMode("Mouse", "Screen")

; #Include fonctions.ahk

; do not modify
global version := "2.2.0"
global configFile := A_ScriptDir . "\config.ini"
global logFile := A_ScriptDir . "\log.txt"
global iconFile := A_ScriptDir . "\images\MacroIcon.ico"
global status := "Waiting"
global initializing := true
global running := false
global paused := false
global Loopcount := 0
global startTime := getUnixTime()

; you can modify these ones
global devMode := false ; enable developer mode (logging & more options)
global mouseRestTime := 500 ; time interval between mouse move and click - cf. ClickMouse() default value : 500
global mouseSpeed := 5 ; mouse moving speed (0-100, 0 being faster and 100 being slower) default value : 5
global maxLogSize := 1048576 ; 1 MB

global lastLoggedMessage := false

F1::mainLoopStart()
F2::handlePause()
F3::Stop()

; options & stats
global Melee, MeleeSkillZ, MeleeSkillX, MeleeSkillC, MeleeSkillV, MeleeSkillB, MeleeSkillF
global Defence, DefenceSleepTime
global Sword, SwordSkillZ, SwordSkillX, SwordSkillC, SwordSkillV, SwordSkillB, SwordSkillF
global Fruit, FruitSkillZ, FruitSkillX, FruitSkillC, FruitSkillV, FruitSkillB, FruitSkillF
global Gun, GunSkillZ, GunSkillX, GunSkillC, GunSkillV, GunSkillB, GunSkillF
global AutoConquerorHaki, AutoClaimTimeRewards, AutoV3
global CategoriesTimeInput, SkillTimeInput
global TRDropFruit, TRCheckCount
global AZERTYLayout
global StatusBar
global statsTimeRewardsClaimed, statsMeleeSkillsEnabled, statsDefenceTimeWaited, statsSwordSkillsEnabled, statsFruitSkillsEnabled, statsGunSkillsEnabled, statsTimeElapsed

startScript() {
    Global
    logMessage("===========================================")
    logMessage("MACRO STARTING")

    logMessage("System Information:")
    logMessage("OS Version: " A_OSVersion, 1)
    logMessage("AHK Version: " A_AhkVersion, 1)
    logMessage("Screen Width: " A_ScreenWidth, 1)
    logMessage("Screen Height: " A_ScreenHeight, 1)
    logMessage("Screen DPI: " A_ScreenDPI, 1)
    logMessage("Macro Informations:")
    logMessage("Version: " version, 1)

    ; Lecture du config.ini
    loadOptionsStats()
    logMessage("Aplied options and stats from config.ini")
    createUI()
    updateStats(1)
    return
}
startScript()

; logging - inspired by DolphSol's macro
logMessage(message, indent := 0) {
    global devMode, maxLogSize, lastLoggedMessage
    
    if (!devMode) {
        return
    }

    if (message = lastLoggedMessage) {
        return
    }

    try {
        if (FileExist(logFile) && GetFileSize(logFile) > maxLogSize) {
            FileDelete(logFile)
        }

        if (indent) {
            message := "    " . message
        }
        fTime := FormatTime(, "hh:mm:ss")
        FileAppend(fTime " " message "`n", logFile)
        OutputDebug(message)

        lastLoggedMessage := message
        
    }
}


; from dolphSol's macro
GetFileSize(filePath) {
    fileSize := FileGetSize(filePath)
    return fileSize
}

ClearLog(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *) {
    global logFile
    FileDelete(logFile)
    logMessage("[ClearLog] log.txt has been cleared")
}

ResetConfig(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *) {
    global configFile
    FileDelete(logFile)
    saveOptionsStats()
    loadOptionsStats()

}

OpenLogs(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *) {
    Run(LogFile)
}

; from DolphSol's macro, all credits goes to them - fonction importante
; move cursor and click to given location
ClickMouse(posX, posY) {
    MouseMove(posX, posY, mouseSpeed)
    Sleep(mouseRestTime)
    MouseClick()
    Sleep(mouseRestTime)
}

; INTERFACE
createUI() {
    Global
    logMessage("[createUI] Creating UIs...")

    ; gui icon - from dolphsol's macro
    try {
        TraySetIcon(iconFile)
    } catch Error as e {
        TraySetIcon("shell32.dll","3")
    }

    ; Main UI
    mainUI := Gui()
        hGui := mainUI.Hwnd
    logMessage("Started creation of mainUI.", 1)

    Tab := ogcTab2MyTab := mainUI.Add("Tab2", "vMyTab w760 h210", ["Main", "Others", "Settings", "Stats", "Credits"])
    ; Ajoute les onglets
    logMessage("Creating Tabs...", 1)

    ; --- Onglet "Configuration" ---
    Tab.UseTab(1)
    logMessage("Creating first tab (Main)", 1)

        ; GroupBox pour Melee
        logMessage("Creating Melee Groupbox (Main)", 1)
        mainUI.Add("GroupBox", "x10 y30 w140 h180", "Melee")
        ogcCheckboxMelee := mainUI.Add("Checkbox", "vMelee x20 y50 Checked" . Melee, "Enable Melee")
        mainUI.Add("Text", "x20 y70", "Skills:")
        ogcCheckboxMeleeSkillZ := mainUI.Add("Checkbox", "vMeleeSkillZ x20 y90 Checked" . MeleeSkillZ, "Z")
        ogcCheckboxMeleeSkillX := mainUI.Add("Checkbox", "vMeleeSkillX x20 y110 Checked" . MeleeSkillX, "X")
        ogcCheckboxMeleeSkillC := mainUI.Add("Checkbox", "vMeleeSkillC x20 y130 Checked" . MeleeSkillC, "C")
        ogcCheckboxMeleeSkillV := mainUI.Add("Checkbox", "vMeleeSkillV x20 y150 Checked" . MeleeSkillV, "V")
        ogcCheckboxMeleeSkillB := mainUI.Add("Checkbox", "vMeleeSkillB x20 y170 Checked" . MeleeSkillB, "B")
        ogcCheckboxMeleeSkillF := mainUI.Add("Checkbox", "vMeleeSkillF x20 y190 Checked" . MeleeSkillF, "F")
    
        ; GroupBox pour Defence
        logMessage("Creating Defence Groupbox (Main)", 1)
        mainUI.Add("GroupBox", "x160 y30 w140 h180", "Defence")
        ogcCheckboxDefense := mainUI.Add("Checkbox", "vDefence x170 y50 Checked" . Defence, "Enable Defence")
        mainUI.Add("Text", "x170 y70", "Sleep Time (sec):")
        ogcEditDefenseSleepTime := mainUI.Add("Edit", "x170 y90 w100 vDefenceSleepTime Number", DefenceSleepTime)
        mainUI.Add("UpDown", "Range1-3600", DefenceSleepTime)
    
        ; GroupBox pour Sword (décalé à droite)
        logMessage("Creating Sword Groupbox (Main)", 1)
        mainUI.Add("GroupBox", "x310 y30 w140 h180", "Sword")
        ogcCheckboxSword := mainUI.Add("Checkbox", "vSword x320 y50 Checked" . Sword, "Enable Sword")
        mainUI.Add("Text", "x320 y70", "Skills:")
        ogcCheckboxSwordSkillZ := mainUI.Add("Checkbox", "vSwordSkillZ x320 y90 Checked" . SwordSkillZ, "Z")
        ogcCheckboxSwordSkillX := mainUI.Add("Checkbox", "vSwordSkillX x320 y110 Checked" . SwordSkillX, "X")
        ogcCheckboxSwordSkillC := mainUI.Add("Checkbox", "vSwordSkillC x320 y130 Checked" . SwordSkillC, "C")
        ogcCheckboxSwordSkillV := mainUI.Add("Checkbox", "vSwordSkillV x320 y150 Checked" . SwordSkillV, "V")
        ogcCheckboxSwordSkillB := mainUI.Add("Checkbox", "vSwordSkillB x320 y170 Checked" . SwordSkillB, "B")
        ogcCheckboxSwordSkillF := mainUI.Add("Checkbox", "vSwordSkillF x320 y190 Checked" . SwordSkillF, "F")
    
        ; GroupBox pour Fruit (décalé aussi)
        logMessage("Creating Fruit Groupbox (Main)", 1)
        mainUI.Add("GroupBox", "x460 y30 w140 h180", "Fruit")
        ogcCheckboxFruit := mainUI.Add("Checkbox", "vFruit x470 y50 Checked" . Fruit, "Enable Fruit")
        mainUI.Add("Text", "x470 y70", "Skills:")
        ogcCheckboxFruitSkillZ := mainUI.Add("Checkbox", "vFruitSkillZ x470 y90 Checked" . FruitSkillZ, "Z")
        ogcCheckboxFruitSkillX := mainUI.Add("Checkbox", "vFruitSkillX x470 y110 Checked" . FruitSkillX, "X")
        ogcCheckboxFruitSkillC := mainUI.Add("Checkbox", "vFruitSkillC x470 y130 Checked" . FruitSkillC, "C")
        ogcCheckboxFruitSkillV := mainUI.Add("Checkbox", "vFruitSkillV x470 y150 Checked" . FruitSkillV, "V")
        ogcCheckboxFruitSkillB := mainUI.Add("Checkbox", "vFruitSkillB x470 y170 Checked" . FruitSkillB, "B")
        ogcCheckboxFruitSkillF := mainUI.Add("Checkbox", "vFruitSkillF x470 y190 Checked" . FruitSkillF, "F")
    
        ; GroupBox pour Gun (décalé encore à droite)
        logMessage("Creating Gun Groupbox (Main)", 1)

        mainUI.Add("GroupBox", "x610 y30 w140 h180", "Gun")
        ogcCheckboxGun := mainUI.Add("Checkbox", "vGun x620 y50 Checked" . Gun, "Enable Gun")
        mainUI.Add("Text", "x620 y70", "Skills:")
        ogcCheckboxGunSkillZ := mainUI.Add("Checkbox", "vGunSkillZ x620 y90 Checked" . GunSkillZ, "Z")
        ogcCheckboxGunSkillX := mainUI.Add("Checkbox", "vGunSkillX x620 y110 Checked" . GunSkillX, "X")
        ogcCheckboxGunSkillC := mainUI.Add("Checkbox", "vGunSkillC x620 y130 Checked" . GunSkillC, "C")
        ogcCheckboxGunSkillV := mainUI.Add("Checkbox", "vGunSkillV x620 y150 Checked" . GunSkillV, "V")
        ogcCheckboxGunSkillB := mainUI.Add("Checkbox", "vGunSkillB x620 y170 Checked" . GunSkillB, "B")
        ogcCheckboxGunSkillF := mainUI.Add("Checkbox", "vGunSkillF x620 y190 Checked" . GunSkillF, "F")

    ; --- Onglet "Auto Tasks" ---
    Tab.UseTab(2)
    logMessage("Creating second tab (Auto Tasks)", 1)

        mainUI.Add("GroupBox", "x10 y30 w160 h180", "Automation")
        logMessage("Creating Automation Groupbox (Auto Tasks)", 1)
        ogcCheckboxAutoConquerorHaki := mainUI.Add("Checkbox", "x20 y50 vAutoConquerorHaki Checked" . AutoConquerorHaki, "Auto Conqueror Haki")
        ogcCheckboxAutoClaimTimeRewards := mainUI.Add("Checkbox", "x20 y70 vAutoClaimTimeRewards Checked" . AutoClaimTimeRewards, "Auto Claim Time Rewards")
        ogcCheckboxAutoClaimTimeRewards.OnEvent("Click", TRWarning.Bind("Normal"))
        ogcCheckboxAutoV3 := mainUI.Add("Checkbox", "x20 y90 vAutoV3 Checked" . AutoV3, "Auto V3")

    ; --- Onglet "Settings" ---
    Tab.UseTab(3)
    logMessage("Creating third tab (Settings)", 1)

        ; intervalles
        mainUI.Add("GroupBox", "x10 y30 w140 h180", "Intervals")
        logMessage("Creating Intervals Groupbox (Settings)", 1)
        mainUI.Add("Text", "x20 y50", "Categories change (ms):")
        ogcCategoriesTimeInput := mainUI.Add("Edit", "x20 y70 vCategoriesTimeInput w100 Number", CategoriesTimeInput)
        mainUI.Add("UpDown", "Range1-60000", CategoriesTimeInput)  ; Limite de 1 à 1000
        mainUI.Add("Text", "x20 y90", "Skills cast (ms):")
        ogcSkillTimeInput := mainUI.Add("Edit", "x20 y110 vSkillTimeInput w100 Number", SkillTimeInput)
        mainUI.Add("UpDown", "Range1-60000", SkillTimeInput)  ; Limite de 1 à 1000

        ; time rewards
        mainUI.Add("GroupBox", "x160 y30 w140 h180", "Time Rewards")
        logMessage("Creating Time Rewards Groupbox (Settings)", 1)
        ogcCheckBoxTRDropFruit := mainUI.Add("CheckBox", "vTRDropFruit x170 y50 Checked" . TRDropFruit, "Drop fruit")
        mainUI.Add("Text", "x170 y70", "Claim TR every X loops")
        ogcEditTRCheckCount := mainUI.Add("Edit", "x170 y90 vTRCheckCount w100 Number", TRCheckCount)
        mainUI.Add("UpDown", "Range1-100", TRCheckCount)  ; Limite de 1 à 1000

        ; Autres
        mainUI.Add("GroupBox", "x310 y30 w140 h60", "Others")
        logMessage("Creating Others Groupbox (Settings)", 1)
        ogcCheckboxAZERTYLayout := mainUI.Add("Checkbox", "vAZERTYLayout x320 y50 Checked" . AZERTYLayout, "AZERTY Layout")
        ogcCheckboxStatusBar := mainUI.Add("Checkbox", "vStatusBar  x320 y70 Checked" . StatusBar, "Enable Status Bar")
        ogcCheckboxStatusBar.OnEvent("Click", EnableStatusBarButton.Bind("Normal"))

        mainUI.Add("GroupBox", "x310 y90 w140 h60", "Import")
        logMessage("Creating Import Groupbox (Settings)", 1)
        ogcButtonImportSettings := mainUI.Add("Button", "x320 y110 w120 h23", "Import Settings && Stats")
        ogcButtonImportSettings.OnEvent("Click", ImportOptionsStats.Bind("Normal"))


        ; DevMode
        if devMode {
            mainUI.Add("GroupBox", "x460 y30 w140 h180", "DevMode")
            logMessage("Creating devMode groupbox (Settings)", 1)
            ogcButtonClearLogs := mainUI.Add("Button", "x470 y50 w120 h23", "Clear Logs")
            ogcButtonClearLogs.OnEvent("Click", ClearLog.Bind("Normal"))
            ogcButtonOpenlogfile := mainUI.Add("Button", "x470 y75 w120 h23", "Open log file")
            ogcButtonOpenlogfile.OnEvent("Click", OpenLogs.Bind("Normal"))
            ogcButtonResetConfig := mainUI.Add("Button", "x470 y100 w120 h23", "Reset Config")
            ogcButtonResetConfig.OnEvent("Click", ResetConfig.Bind("Normal"))
            ogcButtonEditScript := mainUI.Add("Button", "x470 y125 w120 h23", "Edit Script")
            ogcButtonEditScript.OnEvent("Click", EditScript.Bind("Normal"))
            ogcButtonShowSettings := mainUI.Add("Button", "x470 y150 w120 h23", "Show Settings")
            ogcButtonShowSettings.OnEvent("Click", ShowSettings.Bind("Normal"))
        }

    ; --- Onglet "Stats" ---
    Tab.UseTab(4)
    logMessage("Creating fourth tab (Stats)", 1)

        mainUI.Add("GroupBox", "x10 y30 w590 h180")
        ogcTextTimeRewardsClaimed := mainUI.Add("Text", "x20 y50 vTextTimeRewardsClaimedText", "Time Rewards Claimed : " . to_number(statsTimeRewardsClaimed))
        ogcTextMeleeSkillsEnabled := mainUI.Add("Text", "x20 y70 vTextMeleeSkillsEnabled", "Melee Skills Enabled : " . to_number(statsMeleeSkillsEnabled))
        ogcTextDefenceTimeWaited := mainUI.Add("Text", "x20 y90 vTextDefenseTimeWaited", "Defence Time Waited (ms) : " . getTimerDisplay(statsDefenceTimeWaited))
        ogcTextSwordSkillsEnabled := mainUI.Add("Text", "x20 y110 vTextSwordSkillsEnabled", "Sword Skills Enabled : " . to_number(statsSwordSkillsEnabled))
        ogcTextFruitSkillsEnabled := mainUI.Add("Text", "x20 y130 vTextFruitSkillsEnabled", "Fruit Skills Enabled : " . to_number(statsFruitSkillsEnabled))
        ogcTextGunSkillsEnabled := mainUI.Add("Text", "x20 y150 vTextGunSkillsEnabled", "Gun Skills Enabled : " . to_number(statsGunSkillsEnabled))
        ogcTextTimeElapsed := mainUI.Add("Text", "x20 y170 vTextTimeElapsed", "Time Elapsed : " . getTimerDisplay(statsTimeElapsed))

    ; --- Onglet "Credits" ---
    Tab.UseTab(5)
    logMessage("Creating fifth tab (credits)", 1)
        mainUI.Add("GroupBox", "x10 y30 w420 h90", "Credits")
        mainUI.Add("Text", "x30 y50 w360", "This macro was created by me and tested by my friends.")

        mainUI.Add("GroupBox", "x10 y120 w420 h90", "Inspiration")
        mainUI.Add("Link", "x30 y150 w360", "This macro was inspired by <a href=`"https://github.com/BuilderDolphin/dolphSol-Macro`">DolphSol Sol's RNG Macro</a>.")
    
    Tab.UseTab()  ; Sort des onglets
    ; --- Boutons de validation et de contrôle ---
    logMessage("Creating Buttons", 1)
        ogcButtonSave := mainUI.Add("Button", "x8 y230 w80 h23", "Save")
        ogcButtonSave.OnEvent("Click", SaveButton.Bind("Normal"))
        ogcButtonF1Start := mainUI.Add("Button", "x96 y230 w80 h23", "F1 - Start")
        ogcButtonF1Start.OnEvent("Click", StartButton.Bind("Normal"))
        ogcButtonF2Pause := mainUI.Add("Button", "x183 y230 w80 h23", "F2 - Pause")
        ogcButtonF2Pause.OnEvent("Click", PauseButton.Bind("Normal"))
        ogcButtonF3Stop := mainUI.Add("Button", "x270 y230 w80 h23", "F3 - Stop")
        ogcButtonF3Stop.OnEvent("Click", StopButton.Bind("Normal"))

    ; autres
    mainUI.Title := "loupij's One Fruit Macro " . version
    mainUI.OnEvent("Close", MainUIClose)
    mainUI.Show()
    logMessage("Showed mainUI.", 1)


    ; status bar - inspired by DolphSol's macro
    logMessage("Creating statusBar", 1)
    statusBarUI := Gui("+AlwaysOnTop -Caption")
        hGui := statusBarUI.Hwnd
    statusBarUI.SetFont("s10 norm")
    ogcStatusBarText := statusBarUI.Add("Text", "x5 y5 w210 h15 vStatusBarText", "Status : Waiting")

    ; autres instructions
    EnableStatusBar()
    logMessage("Finished building UIs.", 1)
}

; transforme "1 000" en 1000
to_number(x) {
    clearStr := RegExReplace(x, "[^\d]")
    num := Number(clearStr)
    ; MsgBox "Valeur nettoyée : " cleanStr "`nNombre : " num
    return num
}

; validation des paramètres et sauvegarde dans config.ini (bouton Valider)
saveOptionsStats(fromSaveButton := 0) {
    global
    oSaved := mainUI.Submit("0")
    
    logMessage("[saveOptionsStats] Saving Options and statistics.")
    ; sauvegarde des parametres
    if fromSaveButton {
        updateStatus("Saving options")
    }

    IniWrite(Number(Osaved.Melee), configFile, "Categories", "Melee")
    IniWrite(Number(Osaved.Defence), configFile, "Categories", "Defence")
    IniWrite(Number(Osaved.Sword), configFile, "Categories", "Sword")
    IniWrite(Number(Osaved.Fruit), configFile, "Categories", "Fruit")
    IniWrite(Number(Osaved.Gun), configFile, "Categories", "Gun")
    IniWrite(Number(Osaved.MeleeSkillZ), configFile, "MeleeSkills", "Z")
    IniWrite(Number(Osaved.MeleeSkillX), configFile, "MeleeSkills", "X")
    IniWrite(Number(Osaved.MeleeSkillC), configFile, "MeleeSkills", "C")
    IniWrite(Number(Osaved.MeleeSkillV), configFile, "MeleeSkills", "V")
    IniWrite(Number(Osaved.MeleeSkillB), configFile, "MeleeSkills", "B")
    IniWrite(Number(Osaved.MeleeSkillF), configFile, "MeleeSkills", "F")
    IniWrite(to_number(Osaved.DefenceSleepTime), configFile, "Defence", "DefenceSleepTime")
    IniWrite(Number(Osaved.SwordSkillZ), configFile, "SwordSkills", "Z")
    IniWrite(Number(Osaved.SwordSkillX), configFile, "SwordSkills", "X")
    IniWrite(Number(Osaved.SwordSkillC), configFile, "SwordSkills", "C")
    IniWrite(Number(Osaved.SwordSkillV), configFile, "SwordSkills", "V")
    IniWrite(Number(Osaved.SwordSkillB), configFile, "SwordSkills", "B")
    IniWrite(Number(Osaved.SwordSkillF), configFile, "SwordSkills", "F")
    IniWrite(Number(Osaved.FruitSkillZ), configFile, "FruitSkills", "Z")
    IniWrite(Number(Osaved.FruitSkillX), configFile, "FruitSkills", "X")
    IniWrite(Number(Osaved.FruitSkillC), configFile, "FruitSkills", "C")
    IniWrite(Number(Osaved.FruitSkillV), configFile, "FruitSkills", "V")
    IniWrite(Number(Osaved.FruitSkillB), configFile, "FruitSkills", "B")
    IniWrite(Number(Osaved.FruitSkillF), configFile, "FruitSkills", "F")
    IniWrite(Number(Osaved.GunSkillZ), configFile, "GunSkills", "Z")
    IniWrite(Number(Osaved.GunSkillX), configFile, "GunSkills", "X")
    IniWrite(Number(Osaved.GunSkillC), configFile, "GunSkills", "C")
    IniWrite(Number(Osaved.GunSkillV), configFile, "GunSkills", "V")
    IniWrite(Number(Osaved.GunSkillB), configFile, "GunSkills", "B")
    IniWrite(Number(Osaved.GunSkillF), configFile, "GunSkills", "F")
    IniWrite(Number(Osaved.AutoConquerorHaki), configFile, "AutoTasks", "AutoConquerorHaki")
    IniWrite(Number(Osaved.AutoClaimTimeRewards), configFile, "AutoTasks", "AutoClaimTimeRewards")
    IniWrite(Number(Osaved.AutoV3), configFile, "AutoTasks", "AutoV3")
    IniWrite(to_number(Osaved.CategoriesTimeInput), configFile, "Intervals", "CategoriesTimeInput")
    IniWrite(to_number(Osaved.SkillTimeInput), configFile, "Intervals", "SkillTimeInput")
    IniWrite(Number(Osaved.TRDropFruit), configFile, "TRSettings", "TRDropFruit")
    IniWrite(to_number(Osaved.TRCheckCount), configFile, "TRSettings", "TRCheckCount")
    IniWrite(Number(Osaved.AZERTYLayout), configFile, "Others", "AZERTYLayout")
    IniWrite(Number(Osaved.StatusBar), configFile, "Others", "StatusBar")
    IniWrite(to_number(statsTimeRewardsClaimed), configFile, "Stats", "statsTimeRewardsClaimed")
    IniWrite(to_number(statsMeleeSkillsEnabled), configFile, "Stats", "statsMeleeSkillsEnabled")
    IniWrite(to_number(statsDefenceTimeWaited), configFile, "Stats", "statsDefenceTimeWaited")
    IniWrite(to_number(statsSwordSkillsEnabled), configFile, "Stats", "statsSwordSkillsEnabled")
    IniWrite(to_number(statsFruitSkillsEnabled), configFile, "Stats", "statsFruitSkillsEnabled")
    IniWrite(to_number(statsGunSkillsEnabled), configFile, "Stats", "statsGunSkillsEnabled")
    IniWrite(to_number(statsTimeElapsed), configFile, "Stats", "statsTimeElapsed")
    Sleep(250)

    if fromSaveButton {
    updateStatus("Options saved")
    }
    logMessage("[saveOptionsStats] Options and statistics saved.")

    if fromSaveButton {
        Sleep(2000)
    }
    if fromSaveButton {
    updateStatus("Waiting")
    }
}

loadOptionsStats() {
    global
    if !FileExist(configFile) ; création du fichier s'il n'existe pas
        {
            logMessage("config file not found. Creating config.ini.")
            IniWrite(0, configFile, "Categories", "Melee")
            IniWrite(0, configFile, "Categories", "Defence")
            IniWrite(0, configFile, "Categories", "Sword")
            IniWrite(0, configFile, "Categories", "Fruit")
            IniWrite(0, configFile, "Categories", "Gun")
            IniWrite(0, configFile, "MeleeSkills", "Z")
            IniWrite(0, configFile, "MeleeSkills", "X")
            IniWrite(0, configFile, "MeleeSkills", "C")
            IniWrite(0, configFile, "MeleeSkills", "V")
            IniWrite(0, configFile, "MeleeSkills", "B")
            IniWrite(0, configFile, "MeleeSkills", "F")
            IniWrite(5, configFile, "Defence", "DefenceSleepTime") ; valeur par défaut : 5 secondes
            IniWrite(0, configFile, "SwordSkills", "Z")
            IniWrite(0, configFile, "SwordSkills", "X")
            IniWrite(0, configFile, "SwordSkills", "C")
            IniWrite(0, configFile, "SwordSkills", "V")
            IniWrite(0, configFile, "SwordSkills", "B")
            IniWrite(0, configFile, "SwordSkills", "F")
            IniWrite(0, configFile, "FruitSkills", "Z")
            IniWrite(0, configFile, "FruitSkills", "X")
            IniWrite(0, configFile, "FruitSkills", "C")
            IniWrite(0, configFile, "FruitSkills", "V")
            IniWrite(0, configFile, "FruitSkills", "B")
            IniWrite(0, configFile, "FruitSkills", "F")
            IniWrite(0, configFile, "GunSkills", "Z")
            IniWrite(0, configFile, "GunSkills", "X")
            IniWrite(0, configFile, "GunSkills", "C")
            IniWrite(0, configFile, "GunSkills", "V")
            IniWrite(0, configFile, "GunSkills", "B")
            IniWrite(0, configFile, "GunSkills", "F")
            IniWrite(1, configFile, "AutoTasks", "AutoConquerorHaki")
            IniWrite(0, configFile, "AutoTasks", "AutoClaimTimeRewards")
            IniWrite(1, configFile, "AutoTasks", "AutoV3")
            IniWrite(250, configFile, "Intervals", "CategoriesTimeInput") ; valeur par défaut de l'intervalle = 500
            IniWrite(500, configFile, "Intervals", "SkillTimeInput") ; valeur par défaut de l'invervalle = 1000
            IniWrite(0, configFile, "TRSettings", "TRDropFruit")
            IniWrite(50, configFile, "TRSettings", "TRCheckCount")
            IniWrite(0, configFile, "Others", "AZERTYLayout")
            IniWrite(1, configFile, "Others", "StatusBar")
            IniWrite(0, configFile, "Stats", "statsTimeRewardsClaimed")
            IniWrite(0, configFile, "Stats", "statsMeleeSkillsEnabled")
            IniWrite(0, configFile, "Stats", "statsDefenceTimeWaited")
            IniWrite(0, configFile, "Stats", "statsSwordSkillsEnabled")
            IniWrite(0, configFile, "Stats", "statsFruitSkillsEnabled")
            IniWrite(0, configFile, "Stats", "statsGunSkillSEnabled")
            IniWrite(0, configFile, "Stats", "statsTimeElapsed")
            logMessage("config.ini has been created.")
        }
        logMessage("Reading config.ini")
        Melee := Number(IniRead(configFile, "Categories", "Melee"))
        Defence := Number(IniRead(configFile, "Categories", "Defence"))
        Sword := Number(IniRead(configFile, "Categories", "Sword"))
        Fruit := Number(IniRead(configFile, "Categories", "Fruit"))
        Gun := Number(IniRead(configFile, "Categories", "Gun"))
        MeleeSkillZ := Number(IniRead(configFile, "MeleeSkills", "Z"))
        MeleeSkillX := Number(IniRead(configFile, "MeleeSkills", "X"))
        MeleeSkillC := Number(IniRead(configFile, "MeleeSkills", "C"))
        MeleeSkillV := Number(IniRead(configFile, "MeleeSkills", "V"))
        MeleeSkillB := Number(IniRead(configFile, "MeleeSkills", "B"))
        MeleeSkillF := Number(IniRead(configFile, "MeleeSkills", "F"))
        DefenceSleepTime := Number(IniRead(configFile, "Defence", "DefenceSleepTime"))
        SwordSkillZ := Number(IniRead(configFile, "SwordSkills", "Z"))
        SwordSkillX := Number(IniRead(configFile, "SwordSkills", "X"))
        SwordSkillC := Number(IniRead(configFile, "SwordSkills", "C"))
        SwordSkillV := Number(IniRead(configFile, "SwordSkills", "V"))
        SwordSkillB := Number(IniRead(configFile, "SwordSkills", "B"))
        SwordSkillF := Number(IniRead(configFile, "SwordSkills", "F"))
        FruitSkillZ := Number(IniRead(configFile, "FruitSkills", "Z"))
        FruitSkillX := Number(IniRead(configFile, "FruitSkills", "X"))
        FruitSkillC := Number(IniRead(configFile, "FruitSkills", "C"))
        FruitSkillV := Number(IniRead(configFile, "FruitSkills", "V"))
        FruitSkillB := Number(IniRead(configFile, "FruitSkills", "B"))
        FruitSkillF := Number(IniRead(configFile, "FruitSkills", "F"))
        GunSkillZ := Number(IniRead(configFile, "GunSkills", "Z"))
        GunSkillX := Number(IniRead(configFile, "GunSkills", "X"))
        GunSkillC := Number(IniRead(configFile, "GunSkills", "C"))
        GunSkillV := Number(IniRead(configFile, "GunSkills", "V"))
        GunSkillB := Number(IniRead(configFile, "GunSkills", "B"))
        GunSkillF := Number(IniRead(configFile, "GunSkills", "F"))
        AutoConquerorHaki := Number(IniRead(configFile, "AutoTasks", "AutoConquerorHaki"))
        AutoClaimTimeRewards := Number(IniRead(configFile, "AutoTasks", "AutoClaimTimeRewards"))
        AutoV3 := Number(IniRead(configFile, "AutoTasks", "AutoV3"))
        CategoriesTimeInput := Number(IniRead(configFile, "Intervals", "CategoriesTimeInput"))
        SkillTimeInput := Number(IniRead(configFile, "Intervals", "SkillTimeInput"))
        TRDropFruit := Number(IniRead(configFile, "TRSettings", "TRDropFruit"))
        TRCheckCount := Number(IniRead(configFile, "TRSettings", "TRCheckCount"))
        AZERTYLayout := Number(IniRead(configFile, "Others", "AZERTYLayout"))
        StatusBar := Number(IniRead(configFile, "Others", "StatusBar"))
        statsTimeRewardsClaimed := Number(IniRead(configFile, "Stats", "statsTimeRewardsClaimed"))
        statsMeleeSkillsEnabled := Number(IniRead(configFile, "Stats", "statsMeleeSkillsEnabled"))
        statsDefenceTimeWaited := Number(IniRead(configFile, "Stats", "statsDefenceTimeWaited"))
        statsSwordSkillsEnabled := Number(IniRead(configFile, "Stats", "statsSwordSkillsEnabled"))
        statsFruitSkillsEnabled := Number(IniRead(configFile, "Stats", "statsFruitSkillsEnabled"))
        statsGunSkillsEnabled := Number(IniRead(configFile, "Stats", "statsGunSkillsEnabled"))
        statsTimeElapsed := Number(IniRead(configFile, "Stats", "statsTimeElapsed"))
        logMessage("Aplied options and stats from config.ini")
        return
}

ImportOptionsStats(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *) {
    global
    MsgBox("Note : this will not work with versions older that 2.2.0 as the way the inforations were saved has been changed in this version.", "Caution")
    path := FileSelect(1, "", "Select a configuration file", "INI Files (*.ini)")
    if !path {
        return
    }

    Melee := Number(IniRead(path, "Categories", "Melee"))
    Defence := Number(IniRead(path, "Categories", "Defence"))
    Sword := Number(IniRead(path, "Categories", "Sword"))
    Fruit := Number(IniRead(path, "Categories", "Fruit"))
    Gun := Number(IniRead(path, "Categories", "Gun"))
    MeleeSkillZ := Number(IniRead(path, "MeleeSkills", "Z"))
    MeleeSkillX := Number(IniRead(path, "MeleeSkills", "X"))
    MeleeSkillC := Number(IniRead(path, "MeleeSkills", "C"))
    MeleeSkillV := Number(IniRead(path, "MeleeSkills", "V"))
    MeleeSkillB := Number(IniRead(path, "MeleeSkills", "B"))
    MeleeSkillF := Number(IniRead(path, "MeleeSkills", "F"))
    DefenceSleepTime := Number(IniRead(path, "Defence", "DefenceSleepTime"))
    SwordSkillZ := Number(IniRead(path, "SwordSkills", "Z"))
    SwordSkillX := Number(IniRead(path, "SwordSkills", "X"))
    SwordSkillC := Number(IniRead(path, "SwordSkills", "C"))
    SwordSkillV := Number(IniRead(path, "SwordSkills", "V"))
    SwordSkillB := Number(IniRead(path, "SwordSkills", "B"))
    SwordSkillF := Number(IniRead(path, "SwordSkills", "F"))
    FruitSkillZ := Number(IniRead(path, "FruitSkills", "Z"))
    FruitSkillX := Number(IniRead(path, "FruitSkills", "X"))
    FruitSkillC := Number(IniRead(path, "FruitSkills", "C"))
    FruitSkillV := Number(IniRead(path, "FruitSkills", "V"))
    FruitSkillB := Number(IniRead(path, "FruitSkills", "B"))
    FruitSkillF := Number(IniRead(path, "FruitSkills", "F"))
    GunSkillZ := Number(IniRead(path, "GunSkills", "Z"))
    GunSkillX := Number(IniRead(path, "GunSkills", "X"))
    GunSkillC := Number(IniRead(path, "GunSkills", "C"))
    GunSkillV := Number(IniRead(path, "GunSkills", "V"))
    GunSkillB := Number(IniRead(path, "GunSkills", "B"))
    GunSkillF := Number(IniRead(path, "GunSkills", "F"))
    AutoConquerorHaki := Number(IniRead(path, "AutoTasks", "AutoConquerorHaki"))
    AutoClaimTimeRewards := Number(IniRead(path, "AutoTasks", "AutoClaimTimeRewards"))
    AutoV3 := Number(IniRead(path, "AutoTasks", "AutoV3"))
    CategoriesTimeInput := Number(IniRead(path, "Intervals", "CategoriesTimeInput"))
    SkillTimeInput := Number(IniRead(path, "Intervals", "SkillTimeInput"))
    TRDropFruit := Number(IniRead(path, "TRSettings", "TRDropFruit"))
    TRCheckCount := Number(IniRead(path, "TRSettings", "TRCheckCount"))
    AZERTYLayout := Number(IniRead(path, "Others", "AZERTYLayout"))
    StatusBar := Number(IniRead(path, "Others", "StatusBar"))
    statsTimeRewardsClaimed := Number(IniRead(path, "Stats", "statsTimeRewardsClaimed"))
    statsMeleeSkillsEnabled := Number(IniRead(path, "Stats", "statsMeleeSkillsEnabled"))
    statsDefenceTimeWaited := Number(IniRead(path, "Stats", "statsDefenceTimeWaited"))
    statsSwordSkillsEnabled := Number(IniRead(path, "Stats", "statsSwordSkillsEnabled"))
    statsFruitSkillsEnabled := Number(IniRead(path, "Stats", "statsFruitSkillsEnabled"))
    statsGunSkillsEnabled := Number(IniRead(path, "Stats", "statsGunSkillsEnabled"))
    statsTimeElapsed := Number(IniRead(path, "Stats", "statsTimeElapsed"))

    saveOptionsStats()
    updateGUI()
    EnableStatusBar()
}

; Boucle principale
mainLoopStart() {
    global
    saveOptionsStats()
    loadOptionsStats()
    if initializing { ; first start
        logMessage("[mainLoopStart] Starting mainLoop (first start)")
        updateStatus("Starting")
        Sleep(100)
        if AutoClaimTimeRewards {
            ClaimTimeRewards()
            LoopCount += 1
        }
        updateStatus("Running")
        initializing := false
        running := true
    }

    logMessage("[mainLoopStart] Started mainLoop.")
    startTime := getUnixTime()
    SetTimer(updateStats,5000)
    while running {
        if paused {
            continue
        }

        try {
            mainLoop()
        } catch Error as e  {
            logMessage("[mainLoopStart] Error: `nwhat: " e.what "`nfile: " e.file "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra)
            MsgBox("Error!`n`nwhat: " e.what "`nfile: " e.file "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra, "", 16)
            running := false
        }
    }
}

mainLoop() {
    global
    ; time rewards
    if AutoClaimTimeRewards {
        Loopcount += 1
        if (Loopcount = TRCheckCount) {
            ClaimTimeRewards()
            Sleep(2000)
            updateStatus("Running")
            Loopcount := 0
            Sleep(CategoriesTimeInput)
        }
    }

    ; conqueror's haki
    if AutoConquerorHaki {
        logMessage("[mainLoop] Enabled Conqueror Haki", 1)
        Send("{h}")
        Sleep(CategoriesTimeInput)
    }

    ; v3
    if AutoV3 {
        logMessage("[mainLoop] Enabling V3", 1)
        if AZERTYLayout {
            Send("{_}")
            Send("{w}")
        } else {
            Send("{8}")
            Send("{z}")
        }
        Sleep(CategoriesTimeInput)
    }

    ; fithing style
    if Melee {
        logMessage("[mainLoop] Started casting Melee Skills", 1)
        if AZERTYLayout {
            Send("{&}")
        } else {
            Send("{1}")
        }
        if (MeleeSkillZ) {
            if AZERTYLayout {
                Send("{w}")
            } else {
                Send("{z}")
            }
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (MeleeSkillX) {
            Send("{x}")
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (MeleeSkillC) {
            Send("{c}")
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (MeleeSkillV) {
            Send("{v}")
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (MeleeSkillB) {
            Send("{b}")
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (MeleeSkillF) {
            Send("{f}")
            statsMeleeSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        Sleep(CategoriesTimeInput)
    }
    ; defense
    if Defence {
        logMessage("[mainLoop] Started waiting on Defence")
        if AZERTYLayout {
            Send("{é}")
        } else {
            Send("{2}")
        }
        ; MsgBox(DefenceSleepTime Type(DefenceSleepTime))
        Sleep(DefenceSleepTime * 1000) ; %DefenceSleepTime%
        statsDefenceTimeWaited += DefenceSleepTime
        Sleep(CategoriesTimeInput)
    }
    ; sword
    if Sword {
        logMessage("[mainLoop] Started casting Sword Skills", 1)
        if AZERTYLayout {
            Send("{`"}")
        } else {
            Send("{3}")
        }
        if (SwordSkillZ) {
            if AZERTYLayout {
                Send("{w}")
            } else {
                Send("{z}")
            }
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (SwordSkillX) {
            Send("{x}")
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (SwordSkillC) {
            Send("{c}")
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (SwordSkillV) {
            Send("{v}")
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (SwordSkillB) {
            Send("{b}")
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (SwordSkillF) {
            Send("{f}")
            statsSwordSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        Sleep(CategoriesTimeInput)
    }
    ; fruit
    if Fruit {
        logMessage("[mainLoop] Started casting Fruit Skills", 1)
        if AZERTYLayout {
            Send("{'}")
        } else {
            Send("{4}")
        }
        if (FruitSkillZ) {
            if AZERTYLayout {
                Send("{w}")
            } else {
                Send("{z}")
            }
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (FruitSkillX) {
            Send("{x}")
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (FruitSkillC) {
            Send("{c}")
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (FruitSkillV) {
            Send("{v}")
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (FruitSkillB) {
            Send("{b}")
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (FruitSkillF) {
            Send("{f}")
            statsFruitSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        Sleep(CategoriesTimeInput)
    }
    ; gun
    if Gun {
        logMessage("[mainLoop] Started casting Gun Skills", 1)
        if AZERTYLayout {
            Send("{(}")
        } else {
            Send("{5}")
        }
        if (GunSkillZ) {
            if AZERTYLayout {
                Send("{w}")
            } else {
                Send("{z}")
            }
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (GunSkillX) {
            Send("{x}")
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (GunSkillC) {
            Send("{c}")
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (GunSkillV) {
            Send("{v}")
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (GunSkillB) {
            Send("{b}")
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        if (GunSkillF) {
            Send("{f}")
            statsGunSkillsEnabled += 1
            Sleep(SkillTimeInput)
        }
        Sleep(CategoriesTimeInput)
    }
}

ClaimTimeRewards() {
    global
    updateStatus("Claiming Time Rewards")
    logMessage("[ClaimTimeRewards] Started Claiming Time Rewards.")
    if AZERTYLayout { ; ouvir le menu
        Send("{,}")
    } else {
        Send("{m}")
    }
    ; ClickMouse(420, 830) ouvrir le menu
    Sleep(mouseRestTime)
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
    ; ClickMouse(960, 700) ; bouton reset
    ClickMouse(1240, 300) ; fermer menu time rewards
    ClickMouse(850, 830) ; Storage (fruit)
    if TRDropFruit {
        ClickMouse(1080, 830)  ; Drop (fruit)
    }
    MouseMove(960, 280) ; Retour en haut de l'écran
    statsTimeRewardsClaimed += 1
    logMessage("[ClaimTimeRewards] Finished claiming Time Rewards.")
    updateStatus("Time Rewards claimed")
}

; Update the stats display on the UI
updateStats(logging := 0) {
    global
    ; no log message if from timer to avoid log spamming
    if logging {
    logMessage("[updateStats] Started updating statistics.", 1)
    }
    ogcTextTimeRewardsClaimed.Value := "Time Rewards Claimed : " statsTimeRewardsClaimed
    ogcTextMeleeSkillsEnabled.Value := "Melee Skills Enabled : " statsMeleeSkillsEnabled
    ogcTextDefenceTimeWaited.Value := "Defence Time Waited : " getTimerDisplay(statsDefenceTimeWaited)
    ogcTextSwordSkillsEnabled.Value := "Sword Skills Enabled : " statsSwordSkillsEnabled
    ogcTextFruitSkillsEnabled.Value := "Fruit Skills Enabled : " statsFruitSkillsEnabled
    ogcTextGunSkillsEnabled.Value := "Gun Skills Enabled : " statsGunSkillsEnabled
    
    if !initializing {
        updateTimeElapsed()
    }

    if logging {
    logMessage("[updateStats] Finished updating statistics.", 1)
    }
    return
}

updateGUI() {
    updateStats()

    ; Mises à jour des champs de type Edit
    mainUI["Melee"].Value := Melee
    mainUI["Defence"].Value := Defence
    mainUI["Sword"].Value := Sword
    mainUI["Fruit"].Value := Fruit
    mainUI["Gun"].Value := Gun
    mainUI["MeleeSkillZ"].Value := MeleeSkillZ
    mainUI["MeleeSkillX"].Value := MeleeSkillX
    mainUI["MeleeSkillC"].Value := MeleeSkillC
    mainUI["MeleeSkillV"].Value := MeleeSkillV
    mainUI["MeleeSkillB"].Value := MeleeSkillB
    mainUI["MeleeSkillF"].Value := MeleeSkillF
    mainUI["DefenceSleepTime"].Value := DefenceSleepTime
    mainUI["SwordSkillZ"].Value := SwordSkillZ
    mainUI["SwordSkillX"].Value := SwordSkillX
    mainUI["SwordSkillC"].Value := SwordSkillC
    mainUI["SwordSkillV"].Value := SwordSkillV
    mainUI["SwordSkillB"].Value := SwordSkillB
    mainUI["SwordSkillF"].Value := SwordSkillF
    mainUI["FruitSkillZ"].Value := FruitSkillZ
    mainUI["FruitSkillX"].Value := FruitSkillX
    mainUI["FruitSkillC"].Value := FruitSkillC
    mainUI["FruitSkillV"].Value := FruitSkillV
    mainUI["FruitSkillB"].Value := FruitSkillB
    mainUI["FruitSkillF"].Value := FruitSkillF
    mainUI["GunSkillZ"].Value := GunSkillZ
    mainUI["GunSkillX"].Value := GunSkillX
    mainUI["GunSkillC"].Value := GunSkillC
    mainUI["GunSkillV"].Value := GunSkillV
    mainUI["GunSkillB"].Value := GunSkillB
    mainUI["GunSkillF"].Value := GunSkillF
    mainUI["CategoriesTimeInput"].Text := CategoriesTimeInput
    mainUI["SkillTimeInput"].Text := SkillTimeInput
    mainUI["TRDropFruit"].Value := TRDropFruit
    mainUI["TRCheckCount"].Text := TRCheckCount
    mainUI["AutoConquerorHaki"].Value := AutoConquerorHaki
    mainUI["AutoClaimTimeRewards"].Value := AutoClaimTimeRewards
    mainUI["AutoV3"].Value := AutoV3
    mainUI["AZERTYLayout"].Value := AZERTYLayout
    mainUI["StatusBar"].Value := StatusBar
}

updateTimeElapsed() {
    global
    endTime := getUnixTime()
    duration := endTime - startTime
    statsTimeElapsed := statsTimeElapsed + duration
    ogcTextTimeElapsed.Value := "Time Elapsed : " . getTimerDisplay(statsTimeElapsed)
    startTime := getUnixTime()
}

getUnixTime() {
    now := A_NowUTC
    now := DateDiff(now, 1970, "seconds")
    return now
}

formatNum(n,digits := 2) {
    n := Floor(n+0.5)
    cDigits := Max(1,Ceil(Log(Max(n,1))))
    final := n
    if (digits > cDigits){
        count := digits-cDigits
        Loop count {
            final := "0" . final
        }
    }
    return final
}

getTimerDisplay(t) {
    return formatNum(Floor(t/86400)) . ":" . formatNum(Floor(Mod(t,86400)/3600)) . ":" . formatNum(Floor(Mod(t,3600)/60)) . ":" . formatNum(Mod(t,60))
}

EnableStatusBar() {
    global
    oSaved := mainUI.Submit("0")
    if oSaved.statusBar { 
        statusBarUI.Title := "Marco Status"
        statusBarUI.Show("w220 h25 x" (A_ScreenWidth-300) " y100")
    } else {
        statusBarUI.Hide()
    }
}

; inspired by DolphSol's macro
updateStatus(newStatus) {
    global
    ogcStatusBarText.Value := "Status: " newStatus
    ; logMessage("[updateStatus] Updated Status to" newStatus)
}

TRWarning(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    oSaved := mainUI.Submit("0")
    if oSaved.AutoClaimTimeRewards {
        MsgBox("Caution! This feature only works with 1920x1080 screens.`nAlso, make sure your Roblox window is fully windowed (not fullscreen)")
    }
Return

; inspired by DolphSol's Macro
}

handlePause() {
    global running, paused
    if !paused {
        paused := true
        SetTimer(updateStats,0)
        updateStats()
        updateStatus("Paused")
        logMessage("Macro Paused")
    } else {
        logMessage("[mainLoopStart from paused] Restarting mainLoop")
        updateStatus("Restarting")
        SetTimer(updateStats,5000)
        Sleep(100)
        updateStatus("Running")
        paused := false
    }
}

Stop() {
    global
    if !running {
        saveOptionsStats()
        ExitApp()
    }

    running := false
    updateStatus("Stopping")
    SetTimer(updateStats,0)
    updateStats()
    saveOptionsStats()
    Sleep(500)
    logMessage("[Stop] Macro Stopped.")
    ExitApp()
}

MainUIClose(*) {
    Stop()
}

; boutons interface
SaveButton(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    saveOptionsStats(1)
    loadOptionsStats()
Return
}

StartButton(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    mainLoopStart()
Return
}

PauseButton(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    handlePause()
Return
}

StopButton(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    Stop()
Return
}

EnableStatusBarButton(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
EnableStatusBar()
Return
}

EditScript(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{
global
    Edit()
Return
}

ShowSettings(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *) {
    global
    ListHotkeys()
    return
}

