#Requires AutoHotkey v1.1+ 64-bit

; sleep
global movespeed
movespeed := 500

; from DolphSol's macro, all credits goes to them
ClickMouse(posX, posY) {
    MouseMove, % posX, % posY
    Sleep, movespeed
    MouseClick
    Sleep, movespeed
}

ClaimTimeRewards() {
    ClickMouse(420, 840) ; bouton MENU
    ClickMouse(1320, 500)  ; bouton TIME REWARDS
    ClickMouse(740, 430) ; 1
    ClickMouse(850, 430) ; 2
    ClickMouse(955, 430) ; 3
    ClickMouse(1060, 430)  ; 4
    ClickMouse(1170, 430)  ; 5 - fruit
    ClickMouse(740, 550) ; 6
    ClickMouse(850, 550) ; 7
    ClickMouse(960, 550) ; 8
    ClickMouse(1070, 550)  ; 9
    ClickMouse(1160, 550)  ; 10 - fruit
    ClickMouse(1240, 300)  ; fermer menu time rewards
    ClickMouse(850, 845) ; Storage (fruit)
    if TRDropFruitIfStorageFull {
        ClickMouse(1080, 845)  ; Drop (fruit)
    }
    ClickMouse(960, 280) ; Retour en haut de l'écran
}

TRWarning() {
    MsgBox, Caution! This feature only works with 1920x1080 screens.`nAlso, make sure your Roblox window is fully windowed (not fullscreen)
}