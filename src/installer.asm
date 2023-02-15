;--------------------------------------
;
; Celtic CE Source Code - installer.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: February 15, 2023
;
;--------------------------------------

    jp  installApp
    db	$01
___icon:
    db	$10, $10
    db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $FF, $07, $25, $25, $07, $FF, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $07, $25, $8F, $8F, $25, $07, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $25, $8F, $07, $25, $8F, $25, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $25, $8F, $25, $8F, $8F, $25, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $8F, $8F, $25, $8F, $25, $25, $07, $07, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $8F, $25, $07, $25, $25, $25, $25, $25, $25, $8F, $FF, $FF, $FF
    db	$FF, $FF, $07, $25, $8F, $25, $8F, $25, $25, $8F, $8F, $8F, $25, $07, $FF, $FF
    db	$FF, $FF, $07, $25, $07, $25, $8F, $25, $25, $8F, $25, $07, $25, $07, $FF, $FF
    db	$FF, $FF, $07, $25, $8F, $8F, $8F, $25, $8F, $8F, $25, $8F, $25, $07, $FF, $FF
    db	$FF, $FF, $FF, $8F, $25, $25, $25, $8F, $FF, $8F, $07, $25, $8F, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $07, $07, $07, $FF, $FF, $FF, $8F, $8F, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
___description:
    db "Celtic CE Installer - BETA v1.2", 0

installApp:
    call .clearScreen
    
    installer_ports.copy

    call installer.port_setup
    or a, a
    ld hl, osInvalidStr
    jp nz, .printMessage
    
    app_create
    
    jr z, appInstalled
    ld hl, celticAppAlreadyExists
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS

.getKey:
    call ti.GetCSC
    cp a, ti.skEnter
    jr nz, .getKey
    jr .clearScreen

.printMessage:
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
    call ti.GetKey
    call ti.NewLine
    call ti.NewLine
    ld hl, deleteInstallerStr
    call ti.PutS
    ld a, 4
    ld (ti.curRow), a
    ld hl, $FFFF
    ld (ti.fillRectColor), hl
    res ti.textInverse, (iy + ti.textFlags)

.updateDisplay:
    ld hl, 72
    ld de, 241
    ld b, 117
    ld c, 134
    call ti.FillRect
    ld a, 6
    ld (ti.curCol), a
    ld hl, optionYes
    call ti.PutS
    ld a, 16
    ld (ti.curCol), a
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
    ld hl, celticName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call ti.DelVarArc

.exit:
    call ti.ClrScrn
    jp ti.HomeUp

osInvalidStr:
    db "Cannot use this OS.", 0

celticInstalledStr:
    db " Celtic CE app installed.", 0

deleteInstallerStr:
    db " Delete Celtic installer?", 0

celticAppAlreadyExists:
    db "Celtic CE app is already", 0
    db "installed. Delete first,  then run installer again.", 0
    db "Press ", $C1, "enter]", 0

optionYes:
    db " Yes ", 0

optionNo:
    db " No ", 0

celticName:
    db ti.ProgObj, "CELTICCE", 0

relocate installer_ports, ti.saveSScreen
define installer
namespace installer
    include 'ports.asm'
end namespace
end relocate
