;--------------------------------------
;
; Celtic CE Source Code - installer.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022
; License: BSD 3-Clause License
; Last Built: November 29, 2022
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
    db "Celtic CE Installer - BETA v1.1", 0

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
    jp appInstalled.exit

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

.waitLoopEnter2:
    call ti.GetCSC
    cp a, ti.skEnter
    jr nz, .waitLoopEnter2
    call ti.NewLine
    call ti.NewLine
    ld hl, deleteInstallerStr
    call ti.PutS
    ld a, 16
    ld (ti.curCol), a
    ld a, 4
    ld (ti.curRow), a

.updateDisplay:
    ld a, (ti.curCol)
    ld b, a
    cp a, 6
    push bc
    call z, .yesInBlack
    pop bc
    ld a, b
    cp a, 6
    call nz, .noInBlack

.getKey:
    call ti.GetCSC
    cp a, ti.skRight
    jr z, .getInput
    cp a, ti.skClear
    jr z, .exit
    cp a, ti.skLeft
    jr z, .getInput
    cp a, ti.skEnter
    jr nz, .getKey

.getInput:
    cp a, ti.skLeft
    jr z, .leftPress
    cp a, ti.skRight
    jr z, .rightPress
    ld a, (ti.curCol)
    cp a, 16
    jr z, .exit
    ld hl, celticName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call ti.DelVarArc

.exit:
    call ti.ClrScrn
    jp ti.HomeUp

.leftPress:
    ld a, (ti.curCol)
    sub a, 10
    ld (ti.curCol), a
    cp a, 6
    jr z, .updateDisplay
    ld a, 16
    ld (ti.curCol), a
    jr .updateDisplay

.rightPress:
    ld a, (ti.curCol)
    add a, 10
    ld (ti.curCol), a
    cp a, 16
    jr z, .updateDisplay
    ld a, 6
    ld (ti.curCol), a
    jr .updateDisplay

.yesInBlack:
    ld a, 16
    ld (ti.curCol), a
    ld hl, optionNo
    call ti.PutS
    ld hl, $00FFFF
    ld de, $000000
    call ti.SetTextFGBGcolors_
    ld a, 6
    ld (ti.curCol), a
    ld hl, optionYes
    set ti.textEraseBelow, (iy + ti.textFlags)
    call ti.PutS
    ld hl, $000000
    ld de, $00FFFF
    call ti.SetTextFGBGcolors_
    ld a, 6
    ld (ti.curCol), a
    ret

.noInBlack:
    ld a, 6
    ld (ti.curCol), a
    ld hl, optionYes
    call ti.PutS
    ld hl, $00FFFF
    ld de, $000000
    call ti.SetTextFGBGcolors_
    ld a, 16
    ld (ti.curCol), a
    ld hl, optionNo
    set ti.textEraseBelow, (iy + ti.textFlags)
    call ti.PutS
    ld hl, $000000
    ld de, $00FFFF
    call ti.SetTextFGBGcolors_
    ld a, 16
    ld (ti.curCol), a
    ret

osInvalidStr:
    db  "Cannot use this OS.", 0

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

relocate installer_ports, ti.pixelShadow
define installer
namespace installer
    include 'ports.asm'
end namespace
end relocate
