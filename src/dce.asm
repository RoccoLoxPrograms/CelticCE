;----------------------------------------
;
; Celtic CE Source Code - dce.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

dispText: ; det(13)
    ld a, (noArgs)
    cp a, 8
    jr z, .eightArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var3)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld.sis (ti.drawBGColor and $FFFF), de
    ld a, (var2)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ; store x, y values to draw text
    ld hl, (var4)
    ld (ti.penCol), hl
    ld a, (var5)
    ld (ti.penRow), a
    jr .drawText

.eightArgs:
    ld hl, 0
    ld a, (var4) ; low byte color
    ld l, a
    ld a, (var5) ; high byte of color
    ld h, a
    ld.sis (ti.drawBGColor and $FFFF), hl
    ; repeat process
    ld a, (var2)
    ld l, a
    ld a, (var3)
    ld h, a
    ld.sis (ti.drawFGColor and $FFFF), hl
    ; store x, y values to draw text
    ld hl, (var6)
    ld (ti.penCol), hl
    ld a, (var7)
    ld (ti.penRow), a

.drawText:
    ld a, (var1)
    or a, a
    call nz, .setLargeFont
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
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
    ld hl, $FFFF
    ld.sis (ti.drawBGColor and $FFFF), hl
    ld hl, 0
    ld.sis (ti.drawFGColor and $FFFF), hl
    jp return

.setLargeFont:
    set ti.fracDrawLFont, (iy + ti.fontFlags)
    ret

execHex: ; det(14)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    push hl
    ld hl, $2000
    or a, a
    sbc hl, bc
    pop hl
    jp c, PrgmErr.INVALS
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
    ld (hl), $C9
    call execHexLoc
    jp return

fillRect: ; det(15)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    or a, a
    jr z, .invertRect
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld.sis (ti.fillRectColor and $FFFF), de
    ld ix, var2
    jr .fillRect

.invertRect:
    ld hl, (var2) ; x coord
    ld de, (var4) ; width value
    ; calculate bottom right x coord
    add hl, de
    dec hl
    ex de, hl
    ld hl, (var2)
    ld a, (var5) ; height value
    ; calculate bottom right y coord
    ld c, a
    ld a, (var3)
    add a, c
    dec a
    ld c, a
    ld a, (var3)
    ld b, a
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
    call ti.ChkHLIs0
    jp z, return
    ld hl, (ix + 9)
    call ti.ChkHLIs0
    jp z, return
    ld de, (ix)
    ld hl, -ti.lcdWidth
    add hl, de
    jp c, return
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

.clipHeight:
    ld de, (ix + 3)
    ld hl, -ti.lcdHeight
    add hl, de
    jp c, return
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
    jp z, return
    pop hl
    pop bc
    add hl, bc
    push bc
    ld bc, (ix + 6)
    jr .fillLoop

fillScreen: ; det(16)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    dec a
    jr z, .osColor
    ld a, (var1)
    ld e, a
    ld a, (var2)
    ld d, a

.fillScrn:
    ld hl, ti.vRam
    ld (hl), e
    inc hl
    ld (hl), d
    push hl
    pop de
    dec hl
    inc de
    ld bc, ((ti.lcdWidth * ti.lcdHeight) * 2) - 2
    ldir
    jp return

.osColor:
    ld a, (var1)
    cp a, 10
    jp c, PrgmErr.INVALA
    cp a, 25
    jp nc, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    jr .fillScrn
