;----------------------------------------
;
; Celtic CE Source Code - main.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

if flag_prerelease

installPage:
    call ti.ClrScrn
    call ti.HomeUp
    ld hl, warningMsg
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call waitAnyKey

installPageSkipWarn:

else

installPage:

end if

    set ti.fracDrawLFont, (iy + ti.fontFlags)
    call ti.RunIndicOff
    call ti.DisableAPD
    ld hl, $4249
    push hl
    call FillScreen
    pop hl
    ld.sis (ti.drawBGColor and $FFFF), hl
    ld hl, $FFFF
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld hl, 11
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, installScrnLine1
    call ti.VPutS
    ld hl, 65
    ld (ti.penCol), hl
    ld a, 25
    ld (ti.penRow), a
    ld hl, versionString
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 65
    ld (ti.penRow), a
    call loadInstallOption
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 85
    ld (ti.penRow), a
    ld hl, installScrnOption2
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 105
    ld (ti.penRow), a
    ld hl, installScrnOption3
    call ti.VPutS

selectOption:
    call ti.GetCSC
    cp a, ti.sk1
    jp z, installHook
    cp a, ti.sk2
    jp z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skChs
    jr z, testNumberHit
    cp a, ti.skClear
    jr nz, selectOption

exitCelticApp:
    res ti.fracDrawLFont, (iy + ti.fontFlags)
    or a, a
    sbc hl, hl
    ld.sis (ti.drawBGColor and $FFFF), hl
    call ti.ClrScrn
    call ti.DrawStatusBar
    call ti.HomeUp
    call ti.ApdSetup
    call ti.EnableAPD
    ld a, ti.kClear
    jp ti.JForceCmd

testNumberHit:
    call ti.GetCSC
    or a, a
    jr z, testNumberHit
    cp a, ti.sk0
    jr z, secret
    cp a, ti.sk1
    jp z, installHook
    cp a, ti.sk2
    jp z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skClear
    jr z, exitCelticApp
    jr selectOption

secret: ;)
    ld bc, (ti.lcdWidth * ti.lcdHeight) * 2

if flag_prerelease

    ld hl, installPageSkipWarn

else

    ld hl, installPage

end if

    ld de, ti.vRam
    ldir
    call waitAnyKey
    jp drawFullCredits

loadInstallOption:
    ld hl, installScrnOption1
    bit ti.parserHookActive, (iy + ti.hookflags4)
    ret z
    ld hl, (ti.parserHookPtr)
    ld de, celticStart
    or a, a
    sbc hl, de
    ld hl, installScrnOption1
    ret nz
    ld hl, installScrnOption1Alt
    ret

aboutScrn:
    ld hl, $4249
    call FillScreen
    ld hl, 107
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, aboutScrnLine1
    call ti.VPutS
    ld hl, 65
    ld (ti.penCol), hl
    ld a, 25
    ld (ti.penRow), a
    ld hl, versionString
    call ti.VPutS
    ld hl, 41
    ld (ti.penCol), hl
    ld a, 105
    ld (ti.penRow), a
    ld hl, aboutScrnLine2
    call ti.VPutS
    ld hl, 71
    ld (ti.penCol), hl
    ld a, 125
    ld (ti.penRow), a
    ld hl, aboutScrnLine3
    call ti.VPutS
    ld hl, 3
    ld (ti.penCol), hl
    ld a, 221
    ld (ti.penRow), a
    ld hl, copyright
    call ti.VPutS
    call waitAnyKey
    cp a, ti.skClear
    jp z, exitCelticApp

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

installHook:
    call ti.HomeUp
    ld hl, $4249
    call FillScreen
    ld hl, $FFFF
    ld de, $4249
    call ti.SetTextFGBGcolors_
    call uninstallChain ; reset all this hook stuff to be safe
    bit ti.parserHookActive, (iy + ti.hookflags4)
    jr nz, checkHook

finishInstall:
    ld hl, celticStart
    call ti.SetParserHook
    ld hl, getkeyHook
    call ti.SetGetKeyHook
    ld hl, cursorHook
    call ti.SetCursorHook
    ld hl, celticInstalledMsg

displayInstallmsg:
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS
    call waitAnyKey

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

checkHook:
    ld hl, (ti.parserHookPtr)
    ld de, celticStart
    or a, a
    sbc hl, de
    jr z, uninstallHook
    add hl, de
    ld a, (hl)
    cp a, $83
    jr nz, finishInstall
    inc hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    jr finishInstall

uninstallHook:
    call ti.ClrParserHook
    call uninstallChain
    call ti.ClrCursorHook
    call ti.ClrRawKeyHook
    ld hl, celticUninstalledMsg
    jr displayInstallmsg

uninstallChain:
    or a, a
    sbc hl, hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    ret

drawFullCredits:
    or a, a
    sbc hl, hl
    ld.sis (ti.fillRectColor and $FFFF), hl
    ld hl, 80
    ld de, 239
    ld b, 0
    ld c, 239
    call ti.FillRect
    or a, a
    sbc hl, hl
    ld.sis (ti.drawBGColor and $FFFF), hl
    ld hl, $FFFF
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld hl, 107
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, aboutScrnLine1
    call ti.VPutS
    ld hl, 84
    ld (ti.penCol), hl
    ld a, 45
    ld (ti.penRow), a
    ld hl, creditsStr1
    call ti.VPutS
    ld hl, 119
    ld (ti.penCol), hl
    ld a, 75
    ld (ti.penRow), a
    ld hl, creditsStr2
    call ti.VPutS
    ld hl, 143
    ld (ti.penCol), hl
    ld a, 95
    ld (ti.penRow), a
    ld hl, creditsStr3
    call ti.VPutS
    ld hl, 89
    ld (ti.penCol), hl
    ld a, 115
    ld (ti.penRow), a
    ld hl, creditsStr4
    call ti.VPutS
    ld hl, 125
    ld (ti.penCol), hl
    ld a, 135
    ld (ti.penRow), a
    ld hl, creditsStr5
    call ti.VPutS
    ld hl, 119
    ld (ti.penCol), hl
    ld a, 155
    ld (ti.penRow), a
    ld hl, creditsStr6
    call ti.VPutS
    ld hl, 131
    ld (ti.penCol), hl
    ld a, 175
    ld (ti.penRow), a
    ld hl, creditsStr7
    call ti.VPutS
    ld hl, 125
    ld (ti.penCol), hl
    ld a, 195
    ld (ti.penRow), a
    ld hl, creditsStr8
    call ti.VPutS
    ld hl, 137
    ld (ti.penCol), hl
    ld a, 215
    ld (ti.penRow), a
    ld hl, creditsStr9
    call ti.VPutS
    ld hl, appName
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    ld hl, easterEggLen
    push hl
    call ti.CreateAppVar
    pop bc
    inc de
    inc de
    ld hl, easterEgg
    ldir
    call waitAnyKey
    cp a, ti.skClear
    jp z, exitCelticApp

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if
