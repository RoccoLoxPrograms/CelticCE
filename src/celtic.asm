;----------------------------------------
;
; Celtic CE Source Code - celtic.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2024
; License: BSD 3-Clause License
; Last Built: January 11, 2024
;
;----------------------------------------

include 'include/macros.inc'

include 'installer.asm'

;--------------------------------------------------------------------------

    app_start 'CelticCE', '(C)  2022-2024  RoccoLox  Programs', appIconLen

appIcon:
    db $01 ; icon byte

    iconData
appIconLen := $ - appIcon

hookPointers:
    jr $ + 11 ; skip over the pointers
    dl cursorHook ; used to easily find hook pointers for AINSTALL
    dl getkeyHook
    dl celticStart

    celticMain.run

relocate celticMain, ti.cursorImage
    include 'main.asm'
end relocate

    include 'hooks.asm'
    include 'celtic2cse.asm'
    include 'dce.asm'
    include 'graphics.asm'
    include 'osutils.asm'
    include 'celtic3.asm'
    include 'utils.asm'
    include 'convop1.asm'
    include 'error.asm'
    include 'rodata.asm'

;--------------------------------------------------------------------------

    app_data 
    ; stick all of this here since it's only used when the app is run

appName:
    db ti.AppVarObj, "CelticCE", 0

celticInstalledMsg:
    db "Celtic CE installation", 0

celticInstalledMsg2:
    db "successful.", 0

celticUninstalledMsg:
    db "Celtic CE has been", 0

celticUninstalledMsg2:
    db "uninstalled.", 0

pressAnyKeyStr:
    db "Press any key.", 0

installScrnOption1:
    db "1: Install Celtic", 0

installScrnOption1Alt:
    db "1: Uninstall Celtic", 0

installScrnOption2:
    db "2: About", 0

installScrnOption3:
    db "3: Quit", 0

aboutScrnLine1:
    db "Celtic CE", 0

aboutScrnLine2:
    db "By RoccoLox Programs", 0

aboutScrnLine3:
    db "and TIny_Hacker", 0

versionString:
    db "Version 1.0.1", 0

copyright:
    db "(c) 2022-2024", 0

creditsStr1:    db "Thank you to:", 0
creditsStr2:    db "Iambian", 0
creditsStr3:    db "PT_", 0
creditsStr4:    db "Kerm Martian", 0
creditsStr5:    db "MateoC", 0
creditsStr6:    db "jacobly", 0
creditsStr7:    db "DJ_O", 0
creditsStr8:    db "NoahK", 0
creditsStr9:    db "Oxiti8", 0

easterEgg:
    db "EASTER", ti.tSpace, "EGG", ti.tFact
easterEggLen := $ - easterEgg

if flag_prerelease

warningMsg:
    db "WARNING!", 0
    db "This program is still in", 0
    db "development. Please", 0
    db "proceed with caution.", 0

end if
