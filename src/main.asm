;----------------------------------------
;
; Celtic CE Source Code - main.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 24, 2023
;
;----------------------------------------

if flag_prerelease

warning:
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
    call WaitAnyKey

end if

installPage:
    res ti.usePixelShadow2, (iy + ti.putMapFlags)
    set ti.fracDrawLFont, (iy + ti.fontFlags)
    call ti.RunIndicOff
    call ti.DisableAPD
    call ti.boot.ClearVRAM
    ld hl, $2C17
    ld.sis (ti.drawBGColor and $FFFF), hl
    ld.sis (ti.fillRectColor and $FFFF), hl
    ld hl, $FFFF
    ld.sis (ti.drawFGColor and $FFFF), hl
    or a, a
    sbc hl, hl
    ld de, 319
    ld b, 0
    ld c, 43
    call ti.FillRect
    ld hl, 107
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, aboutScrnLine1
    call ti.VPutS
    ld hl, 53
    ld (ti.penCol), hl
    ld a, 25
    ld (ti.penRow), a
    ld hl, versionString
    call ti.VPutS
    ld hl, $4249
    ld.sis (ti.drawBGColor and $FFFF), hl

skipTopBarDraw:
    ld hl, $D46E00 ; start of horizontal line
    ld (hl), 0
    push hl
    pop de
    inc de
    ld bc, (ti.lcdWidth * 2) - 1
    ldir
    call FillRect
    ld hl, 47
    ld (ti.penCol), hl
    ld a, 65
    ld (ti.penRow), a
    call loadInstallOption
    call ti.VPutS
    ld hl, 47
    ld (ti.penCol), hl
    ld a, 85
    ld (ti.penRow), a
    ld hl, installScrnOption2
    call ti.VPutS
    ld hl, 47
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
    jr z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skChs
    jr z, testNumberHit
    cp a, ti.skClear
    jr nz, selectOption

exitCelticApp:
    call ti.boot.ClearVRAM
    call ti.DrawStatusBar
    call ti.HomeUp
    res ti.apdWarmStart, (iy + ti.apdFlags)
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
    jr z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skClear
    jr z, exitCelticApp
    jr selectOption

secret: ;)
    ld hl, appName + 1
    call ti.FindAppStart
    ld de, ti.vRam
    ld bc, (ti.lcdWidth * ti.lcdHeight) * 2
    ldir
    call WaitAnyKey
    jp drawFullCredits

loadInstallOption:
    ld hl, installScrnOption1
    bit ti.parserHookActive, (iy + ti.hookflags4)
    ret z
    push hl
    ld hl, (ti.parserHookPtr)
    ld de, celticStart
    or a, a
    sbc hl, de
    pop hl
    ret nz
    ld hl, installScrnOption1Alt
    ret

aboutScrn:
    call FillRect
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
    ld hl, 80
    ld (ti.penCol), hl
    ld a, 165
    ld (ti.penRow), a
    ld hl, copyright
    call ti.VPutS
    call WaitAnyKey
    cp a, ti.skClear
    jp z, exitCelticApp
    jp skipTopBarDraw

checkHook:
    ld de, (ti.parserHookPtr)
    ld hl, celticStart
    or a, a
    sbc hl, de
    jr z, uninstallHook
    ld a, (de)
    cp a, $83
    jr nz, finishInstall
    inc de
    ld (ti.helpHookPtr), de
    res ti.helpHookActive, (iy + ti.hookflags4)
    jr finishInstall

uninstallHook:
    call ti.ClrParserHook
    call uninstallChain
    call ti.ClrCursorHook
    call ti.ClrRawKeyHook
    ld hl, celticUninstalledMsg
    ld de, celticUninstalledMsg2
    jr displayInstallmsg

installHook:
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
    ld de, celticInstalledMsg2

displayInstallmsg:
    push de
    push hl
    call FillRect
    ld hl, 29
    ld (ti.penCol), hl
    ld a, 105
    ld (ti.penRow), a
    pop hl
    call ti.VPutS
    ld hl, 29
    ld (ti.penCol), hl
    ld a, 125
    ld (ti.penRow), a
    pop hl
    call ti.VPutS
    ld hl, 29
    ld (ti.penCol), hl
    ld a, 165
    ld (ti.penRow), a
    ld hl, pressAnyKeyStr
    call ti.VPutS
    call WaitAnyKey
    jp skipTopBarDraw

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
    ld hl, $4249
    ld.sis (ti.fillRectColor and $FFFF), hl
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
    ld hl, 137
    ld (ti.penCol), hl
    ld a, 175
    ld (ti.penRow), a
    ld hl, creditsStr7
    call ti.VPutS
    ld hl, 131
    ld (ti.penCol), hl
    ld a, 195
    ld (ti.penRow), a
    ld hl, creditsStr8
    call ti.VPutS
    ld hl, 125
    ld (ti.penCol), hl
    ld a, 215
    ld (ti.penRow), a
    ld hl, creditsStr9
    call ti.VPutS
    ld hl, appName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, easterEggLen
    push hl
    call ti.CreateAppVar
    pop bc
    inc de
    inc de
    ld hl, easterEgg
    ldir
    call WaitAnyKey
    cp a, ti.skClear
    jp z, exitCelticApp
    jp installPage

FillRect:
    ld hl, $D47080 ; start of filled rectangle
    ld (hl), $49
    inc hl
    ld (hl), $42
    push hl
    pop de
    dec hl
    inc de
    ld bc, (ti.vRamEnd - $D47080) - 2
    ldir
    ret

WaitAnyKey:
    call ti.GetCSC
    or a, a
    jr z, WaitAnyKey
    ret
