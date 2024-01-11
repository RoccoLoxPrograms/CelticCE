;----------------------------------------
;
; Celtic CE Source Code - installer.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2024
; License: BSD 3-Clause License
; Last Built: January 11, 2024
;
;----------------------------------------

    jp installApp
    db $01 ; icon byte

    iconData

description:
    db "Celtic CE Installer - 1.0.1", 0

installApp:
    call .clearScreen
    call ti.RunIndicOff
    ld hl, installingStr
    call ti.PutS

    installerPorts.copy

    call installer.port_setup
    or a, a
    ld hl, osInvalidStr
    jp nz, .printMessage
    call ti.PushOP1

    app_create

    jr z, appInstalled
    call ti.PopOP1
    call .clearScreen
    ld hl, celticAppAlreadyExists
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.GetKey
    jr .clearScreen

.printMessage:
    call .clearScreen
    call ti.PutS
    call ti.GetKey

.clearScreen:
    call ti.ClrScrn
    jp ti.HomeUp

appInstalled:
    call ti.ClrScrn
    call ti.HomeUp
    ld hl, celticInstalledStr
    call ti.PutS
    ld hl, 3
    ld (ti.curRow), hl
    call ti.GetKey
    ld hl, deleteInstallerStr
    call ti.PutS
    ld a, 5
    ld (ti.curRow), a
    res ti.textInverse, (iy + ti.textFlags)
    call ti.PopOP1

.updateDisplay:
    ld hl, 72
    ld de, 241
    ld b, 137
    ld c, 154
    call ti.ClearRect
    ld hl, 6
    ld.sis (ti.curCol and $FFFF), hl
    ld hl, optionYes
    call ti.PutS
    ld hl, 16
    ld.sis (ti.curCol and $FFFF), hl
    ld a, (iy + ti.textFlags)
    xor a, 8
    ld (iy + ti.textFlags), a
    ld hl, optionNo
    call ti.PutS

.getKey:
    call ti.GetCSC
    cp a, ti.skRight
    jr z, .updateDisplay
    cp a, ti.skLeft
    jr z, .updateDisplay
    cp a, ti.skClear
    jr z, .exit
    cp a, ti.skEnter
    jr nz, .getKey
    bit ti.textInverse, (iy + ti.textFlags)
    jr nz, .exit
    call ti.ChkFindSym
    call ti.DelVarArc

.exit:
    call ti.ClrScrn
    jp ti.HomeUp

installingStr:
    db "Installing app...", 0

osInvalidStr:
    db "Cannot use this OS.", 0

celticInstalledStr:
    db " Celtic CE app installed. Open app to enable Celtic.", 0

deleteInstallerStr:
    db " Delete Celtic installer?", 0

celticAppAlreadyExists:
    db "Celtic CE app is already", 0
    db "installed. Delete first,  then run installer again.", 0

optionYes:
    db " Yes ", 0

optionNo:
    db " No ", 0

relocate installerPorts, ti.saveSScreen
define installer
namespace installer
    include 'ports.asm'
end namespace
end relocate
