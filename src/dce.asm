;----------------------------------------
;
; Celtic CE Source Code - dce.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2024
; License: BSD 3-Clause License
; Last Built: January 11, 2024
;
;----------------------------------------

dispText: ; det(13)
    ld a, (noArgs)
    cp a, 8
    jr z, .eightArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var3)
    call _checkValidOSColor
    ld.sis (ti.drawBGColor and $FFFF), de
    ld a, (var2)
    call _checkValidOSColor
    ld.sis (ti.drawFGColor and $FFFF), de
    ld hl, (var4)
    ld (ti.penCol), hl
    ld a, (var5)
    ld (ti.penRow), a
    jr .drawText

.eightArgs:
    or a, a
    sbc hl, hl
    ld a, (var4)
    ld l, a
    ld a, (var5)
    ld h, a
    ld.sis (ti.drawBGColor and $FFFF), hl
    ld a, (var2)
    ld l, a
    ld a, (var3)
    ld h, a
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld hl, (var6)
    ld (ti.penCol), hl
    ld a, (var7)
    ld (ti.penRow), a

.drawText:
    ld a, (var1)
    or a, a
    jr z, $ + 6
    set ti.fracDrawLFont, (iy + ti.fontFlags)
    ld hl, Str9
    call _findString
    ex de, hl
    push de
    pop bc
    ld de, execHexLoc

.storeText:
    ld a, (hl)
    call _convertChars.dispText
    inc hl
    dec bc
    ld a, b
    or a, c
    jr nz, .storeText
    xor a, a
    ld (de), a
    ld hl, execHexLoc
    call ti.VPutS
    res ti.fracDrawLFont, (iy + ti.fontFlags) ; in case the flag was set earlier, just always reset it
    ; reset text color
    or a, a
    sbc hl, hl
    ld.sis (ti.drawFGColor and $FFFF), hl
    dec hl
    ld.sis (ti.drawBGColor and $FFFF), hl
    jp return

execHex: ; det(14)
    call _findAnsStr
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, ti.StrngObj
    jp nz, PrgmErr.SNTST
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    push hl
    ld hl, $2000 ; max allowed length of hex code
    or a, a
    sbc hl, bc
    pop hl
    jr c, $ + 6
    srl b
    rr c
    jp c, PrgmErr.INVALS
    ld de, execHexLoc
    push de

.loop:
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    inc hl
    ld e, a
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, e
    pop de
    ld (de), a
    inc hl
    inc de
    push de
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
    pop hl
    ld (hl), $C9 ; ret instruction
    call execHexLoc
    jp return

fillRect: ; det(15)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld ix, var2
    ld a, (var1)
    or a, a
    jr z, .invertRect
    call _checkValidOSColor
    ld.sis (ti.fillRectColor and $FFFF), de
    jr .fillRect

.invertRect:
    ld hl, (ix)
    push hl
    ld de, (ix + 6)
    ld a, d
    or a, e
    jr z, .return
    add hl, de
    dec hl
    ex de, hl
    pop hl
    ld b, (ix + 3)
    ld a, (ix + 9)
    or a, a
    jr z, .return
    add a, b
    dec a
    ld c, a
    call ti.InvertRect
    jp return

.sevenArgs:
    ld a, (var1)
    ld (ti.fillRectColor), a
    ld a, (var2)
    ld (ti.fillRectColor + 1), a
    ld ix, var3

.fillRect: ; x, y, w, h : 0, +3, +6, +9
    ld hl, (ix + 6)
    ld a, h
    or a, l
    jr z, .return
    ld hl, (ix + 9)
    ld a, h
    or a, l
    jr z, .return
    ld de, (ix)
    ld hl, -ti.lcdWidth
    add hl, de
    jr c, .return
    ld hl, (ix + 6)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdWidth
    add hl, de
    jr nc, .clipHeight
    ex de, hl
    ld hl, (ix + 6)
    or a, a
    sbc hl, de
    ld (ix + 6), hl
    jr .clipHeight

.return:
    jp return

.clipHeight:
    ld de, (ix + 3)
    ld hl, -ti.lcdHeight
    add hl, de
    jr c, .return
    ld hl, (ix + 9)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdHeight
    add hl, de
    jr nc, .startFilledRect
    ex de, hl
    ld hl, (ix + 9)
    or a, a
    sbc hl, de
    ld (ix + 9), hl

.startFilledRect:
    ld l, (ix + 3)
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (ix)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    push hl
    ld hl, (ix + 6)
    add hl, hl
    ld (ix + 6), hl
    push hl
    pop bc
    pop hl
    ld de, ti.lcdWidth * 2
    push de

.fillLoop:
    push hl
    ld.sis de, (ti.fillRectColor and $FFFF)
    ld (hl), e
    inc hl
    ld (hl), d
    dec bc
    dec bc
    ld a, b
    or a, c
    jr z, .checkLoop
    push hl
    pop de
    dec hl
    inc de
    ldir

.checkLoop:
    dec (ix + 9)
    jr z, .return
    pop hl
    pop bc
    add hl, bc
    push bc
    ld bc, (ix + 6)
    jr .fillLoop
