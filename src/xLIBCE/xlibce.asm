;----------------------------------------
;
; Celtic CE Source Code - xLIBCE/xlibce.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: February 18, 2026
;
;----------------------------------------

xlibcSetup: ; real(0)
    ld a, (xlibcInt1)
    cp a, 4
    jp nc, return
    ld l, a
    ld h, 3
    mlt hl
    ld de, .lut
    add hl, de
    ld hl, (hl)
    ld bc, return
    push bc
    jp (hl)

.lut:
    dl .getXlibcVersion
    dl .setupGraphics
    dl .setSpeed
    dl .setupColorMode

.getXlibcVersion:
    ld a, 3
    call ti.SetxxOP1
    jp ti.StoAns

.setupGraphics:
    ld a, (xlibcInt2)
    or a, a
    jp nz, _setHalfRes
    call _setNormalRes
    ld a, (xlibcInt3)
    or a, a
    call nz, ti.DrawStatusBar
    ret

.setSpeed:
    ret
    ; fix this later
    ; might have to set this myself
    ;ld a, (xlibcInt2)
    ;or a, a
    ;jp nz, ti.boot.Set48MHzMode
    ;jp ti.boot.Set6MHzMode

.setupColorMode:
    ld a, (xlibcInt2)
    or a, a
    jr z, .fullColor
    dec a
    jr z, .8colorMode
    dec a
    jr z, .invert
    dec a
    jr z, .invertOff
    dec a
    jr z, .fillScreen
    dec a
    ret nz

.setColorOffset:
    ld a, (xlibcInt3)
    ld (xlibColorOffset), a
    ret

.fullColor:
    call _setupSPI
    spi $38
    ret

.8colorMode:
    call _setupSPI
    spi $39
    ret

.invert:
    ld a, $21
    jr .invertOff + 2

.invertOff:
    ld a, $20
    push af
    call _setupSPI
    pop af
    ld hl, $F80818
    ld (hl), h
    ld (hl), $44
    ld (hl), a
    ld l, h
    ld (hl), $01
    ret

.fillScreen:
    call _getVRAMaddrStart
    ld a, (xlibcInt3)
    ld b, ti.lcdHeight

.loopFill:
    ld (hl), a
    push bc
    push hl
    push hl
    pop de
    inc de
    ld bc, ti.lcdWidth - 1
    ldir
    pop hl
    ld bc, ti.lcdWidth * 2
    add hl, bc
    pop bc
    djnz .loopFill
    ld a, (xlibcInt4)
    or a, a
    call nz, _flipActiveDraw
    ret

userVariables: ; real(1)
    ld a, (xlibcInt1)
    cp a, 4
    jp nc, return
    ld l, a
    ld h, 3
    mlt hl
    ld de, .lut
    add hl, de
    ld hl, (hl)
    ld bc, return
    push bc
    jp (hl)

.lut:
    dl .getUservar
    dl .setUservar
    dl .addToUservar
    dl .subFromUservar

.getUservar:
    ld hl, uservars
    ld a, (xlibcInt2)
    ld e, a
    ld d, 9
    mlt de
    add hl, de
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    call ti.Mov9ToOP1
    jp ti.StoAns

.setUservar:
    ld hl, uservars
    ld a, (xlibcInt2)
    push af
    ld e, a
    ld d, 9
    mlt de
    add hl, de
    ex de, hl
    ld hl, xlibc3
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    ld bc, 9
    ldir
    pop af
    call ti.SetxxOP1
    jp ti.StoAns

.addToUservar:
    ld hl, uservars
    ld a, (xlibcInt2)
    ld e, a
    ld d, 9
    mlt de
    add hl, de
    push hl
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    call ti.Mov9ToOP1
    ld hl, xlibc3
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    call ti.Mov9ToOP2
    call ti.FPAdd
    pop de
    ld hl, ti.OP1
    ld bc, 9
    ldir
    ret

.subFromUservar:
    ld hl, uservars
    ld a, (xlibcInt2)
    ld e, a
    ld d, 9
    mlt de
    add hl, de
    push hl
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    call ti.Mov9ToOP1
    ld hl, xlibc3
    ld a, (hl)
    res 7, a
    or a, a
    jp nz, return
    call ti.Mov9ToOP2
    call ti.FPSub
    pop de
    ld hl, ti.OP1
    ld bc, 9
    ldir
    ret

getKeyXlibc: ; real(2)
    jp return

drawMap: ; real(3)
    jp return

drawSprite: ; real(4)
    jp return

managePic: ; real(5)
    jp return

drawString: ; real(6)
    ld a, (xlibcInt1)
    cp a, 4
    jp nc, return
    ld l, a
    ld h, 3
    mlt hl
    ld de, .lut
    add hl, de
    ld hl, (hl)
    ld bc, return
    push bc
    jp (hl)

.lut:
    dl .drawString
    dl .drawStringValueA
    dl .drawStringValueB
    dl .setXlibcFont

.drawString:
    call _findAnsStr
    ld a, (ti.OP1)
    cp a, ti.StrngObj
    ret nz
    inc de
    inc de
    push hl
    pop bc
    ex de, hl
    ld de, drawStringTemp
    push de

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
    pop de
    call .startDraw
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

.startDraw:
    ld hl, (xlibcInt2)
    ld (bufSpriteX), hl
    push de

.loop:
    ld a, (xlibcInt3)
    ld (bufSpriteY), a
    pop de
    ld a, (de)
    inc de
    or a, a
    ret z
    push de
    ld hl, xlibcInt5
    cp a, (hl)
    jp z, .newLine
    ld c, 8
    sub a, $20
    ld b, a
    ld a, (xlibcFont)
    cp a, 1
    jr nz, .fontSet1
    ld c, 6

.fontSet1:
    mlt bc
    ld hl, largeFontData
    cp a, 1
    jr nz, .fontSet2
    ld hl, smallFontData

.fontSet2:
    add hl, bc
    ld b, 8
    cp a, 1
    jr nz, .drawChar
    ld b, 6

.drawChar:
    ld a, (bufSpriteY)
    push bc
    ld c, (hl)
    push hl
    cp a, 120 ; Clip a = Y
    jr nc, .skipRow
    ld de, (bufSpriteX)
    push de
    call _getXlibcVRAMaddr
    pop de
    ld a, c
    ld b, 8

.drawRow:
    add a, a
    jr nc, .skipPixel
    or a, a
    push hl
    ld hl, 159
    sbc hl, de ; Clip de = X
    pop hl
    jr c, .skipPixel
    ld c, a
    ld a, (xlibcInt4)
    push bc
    ld b, a
    ld a, (xlibColorOffset)
    add a, b
    ld bc, ti.lcdWidth * 2
    ld (hl), a
    add hl, bc
    ld (hl), a
    inc hl
    ld (hl), a
    sbc hl, bc
    ld (hl), a
    inc hl
    pop bc
    ld a, c
    jr .next

.skipPixel:
    inc hl
    inc hl

.next:
    inc de
    djnz .drawRow

.skipRow:
    ld a, (bufSpriteY)
    inc a
    ld (bufSpriteY), a
    pop hl
    inc hl
    pop bc
    djnz .drawChar
    ld hl, (bufSpriteX)
    ld bc, 8
    ld a, (xlibcFont)
    cp a, 1
    jr nz, .scaleSet1
    ld c, 4

.scaleSet1:
    add hl, bc
    ld (bufSpriteX), hl
    jp .loop

.newLine:
    ld c, 8
    ld a, (xlibcFont)
    cp a, 1
    jr nz, .scaleSet2
    ld c, 6

.scaleSet2:
    ld a, (xlibcInt3)
    add a, c
    ld (xlibcInt3), a
    ld hl, (xlibcInt2)
    ld (bufSpriteX), hl
    jp .loop

.drawStringValueA:
    ld hl, xlibc5
    call ti.Mov9ToOP1
    call ti.TRunc
    res negative, (iy + celticFlags1)
    ld a, (ti.OP1)
    bit 7, a
    jr z, $ + 6
    set negative, (iy + celticFlags1)
    ld a, 6
    call ti.FormEReal
    ld hl, ti.OP3
    bit negative, (iy + celticFlags1)
    jr z, $ + 4
    ld (hl), '-'
    ld de, drawStringTemp
    push de
    ldir
    xor a, a
    ld (de), a
    ld (xlibcInt5), a
    pop de
    call .startDraw
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

.drawStringValueB:
    ld hl, uservars
    ld a, (xlibcInt5)
    ld e, a
    ld d, 9
    mlt de
    add hl, de
    ld a, (hl)
    or a, a
    jp nz, return
    call ti.Mov9ToOP1
    call ti.TRunc
    res negative, (iy + celticFlags1)
    ld a, (ti.OP1)
    bit 7, a
    jr z, $ + 6
    set negative, (iy + celticFlags1)
    ld a, 6
    call ti.FormEReal
    ld hl, ti.OP3
    bit negative, (iy + celticFlags1)
    jr z, $ + 4
    ld (hl), '-'
    ld de, drawStringTemp
    push de
    ldir
    xor a, a
    ld (de), a
    ld (xlibcInt5), a
    pop de
    call .startDraw
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

.setXlibcFont:
    ld a, (xlibcInt2)
    cp a, 1
    ld a, 0
    jr nz, .setSmallFont
    inc a

.setSmallFont:
    ld (xlibcFont), a
    ret

drawShape: ; real(7)
    ld a, (xlibcInt1)
    cp a, 14
    jp nc, return
    ld l, a
    ld h, 3
    mlt hl
    ld de, .lut
    add hl, de
    ld hl, (hl)
    ld bc, return
    push bc
    jp (hl)

.lut:
    dl .getPixelA
    dl .getPixelB
    dl .setPixelA
    dl .setPixelB
    dl .invertPixel
    dl .drawLine
    dl .invertLine
    dl .drawRectangle
    dl .invertRectangle
    dl .fillRectangle
    dl .invertFilledRectangle
    dl .drawCircle
    dl .drawFilledCircle
    dl .drawFilledColorRotateRectangle

.getPixelA:
    ld de, (xlibcInt2)
    ld a, (xlibcInt3)
    call _getXlibcVRAMaddr
    ex de, hl
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    jp ti.StoAns

.getPixelB:
    ld de, (xlibcInt2)
    ld a, (xlibcInt3)
    call _getXlibcVRAMaddr
    ld a, (hl)
    call ti.SetxxOP1
    jp ti.StoAns

.setPixelA:
    ld a, (xlibcInt5)
    ld e, a
    ld a, (xlibcInt4)
    ld d, a
    ld a, (xlibcInt6)
    ld (xlibcInt4), a
    ld (xlibcInt5), a
    push de
    call _clipXlibcRect
    pop de
    ret z
    jp .loopFillRect

.setPixelB:
    ld hl, xlibcInt6 + 2
    ld de, xlibcInt7 + 2
    ld bc, 9
    lddr
    jr .setPixelA

.invertPixel:
    ld hl, xlibcInt5 + 2
    ld de, xlibcInt6 + 2
    ld bc, 6
    lddr
    jp .invertFilledRectangle

.drawLine:
    res invertPixel, (iy + celticFlags2)
    or a, a
    sbc hl, hl
    ld a, (xlibcInt6)
    ld l, a
    ld h, a
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld ix, xlibcInt2
    ld hl, (ix)
    ld bc, (ix + 3)
    ld de, (ix + 6)
    ld ix, (ix + 9)
    push hl ; x1, ix + 21
    push bc ; y1, ix + 18
    push de ; x2, ix + 15
    push ix ; y2, ix + 12
    ld ix, 0
    add ix, sp
    ld.sis bc, (ti.drawFGColor and $FFFF)
    push bc ; color, ix + 9
    ex de, hl
    or a, a
    sbc hl, de
    ex de, hl
    call .absoluteVal
    push hl ; dx, ix + 6
    ld hl, (ix)
    ld de, (ix + 6)
    or a, a
    sbc hl, de
    ex de, hl
    call .absoluteVal
    push hl ; dy, ix + 3
    lea ix, ix - 12
    ld sp, ix
    ld c, 0
    ld hl, (ix + 3)
    ld de, (ix + 6)
    or a, a
    sbc hl, de
    jr c, .decisionIs0
    inc c ; decision variable is 1: x1 <> y1, x2 <> y2, and dx <> dy 
    ld hl, (ix + 3)
    ld (ix + 6), hl
    ld (ix + 3), de
    ld hl, (ix + 21)
    ld de, (ix + 18)
    ld (ix + 21), de
    ld (ix + 18), hl
    ld hl, (ix + 15)
    ld de, (ix + 12)
    ld (ix + 15), de
    ld (ix + 12), hl

.decisionIs0:
    push bc ; decision, ix - 3
    ld hl, (ix + 3)
    ld de, (ix + 6)
    add hl, hl
    or a, a
    sbc hl, de
    push hl ; pk, ix - 6
    ld hl, (ix + 6)
    inc hl
    push hl ; dx countdown for loop, ix - 9
    ld hl, (ix + 21)
    ld de, (ix + 18)
    ld a, (ix - 3)
    or a, a
    jr nz, $ + 6
    push hl
    push de
    jr $ + 4
    push de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl

.drawLineLoop:
    ld hl, (ix - 9)
    dec hl
    ld a, h
    or a, l
    jp z, .exitLine
    ld (ix - 9), hl
    ld hl, (ix + 21)
    ld de, (ix + 15)
    or a, a
    sbc hl, de
    ld hl, (ix + 21)
    jp p, .cmpXIsPositive
    inc hl
    jr $ + 3

.cmpXIsPositive:
    dec hl
    ld (ix + 21), hl
    bit 7, (ix - 4)
    jr z, .pkGreaterThan0

.pkLessThan0:
    ld hl, (ix + 21)
    ld de, (ix + 18)
    ld a, (ix - 3)
    or a, a
    jr nz, $ + 6
    push hl
    push de
    jr $ + 4
    push de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 3)
    add hl, hl
    ld de, (ix - 6)
    add hl, de
    ld (ix - 6), hl
    jr .drawLineLoop

.pkGreaterThan0:
    ld hl, (ix + 18)
    ld de, (ix + 12)
    or a, a
    sbc hl, de
    ld hl, (ix + 18)
    jp p, .cmpYIsPositive
    inc hl
    jr $ + 3

.cmpYIsPositive:
    dec hl
    ld (ix + 18), hl
    ld hl, (ix + 21)
    ld de, (ix + 18)
    ld a, (ix - 3)
    or a, a
    jr nz, $ + 6
    push hl
    push de
    jr $ + 4
    push de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    add hl, hl
    ex de, hl
    ld hl, (ix + 3)
    add hl, hl
    ld bc, (ix - 6)
    add hl, bc
    or a, a
    sbc hl, de
    ld (ix - 6), hl
    jp .drawLineLoop

.exitLine:
    bit invertPixel, (iy + celticFlags2)
    ld a, (xlibcInt7)
    jr z, $ + 6
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    lea ix, ix + 24
    ld sp, ix
    ret

.absoluteVal: ; number = de
    or a, a
    sbc hl, hl
    sbc hl, de
    ret p
    ex de, hl
    ret

.invertLine:
    set invertPixel, (iy + celticFlags2)
    jp .drawLine + 4

.drawRectangle:
    res invertPixel, (iy + celticFlags2)

.drawRectangleStart:
    ld ix, xlibcInt2
    ld a, (xlibcInt6)
    ld l, a
    ld h, a
    ld de, (xlibcInt2)
    ld a, (xlibcInt5)
    ld c, a
    push de
    push bc
    ld a, (xlibcInt3)
    bit 7, (ix + 2)
    jr nz, .clipLeftDone
    push af
    push de
    push hl
    call _drawXlibcVertLine
    pop hl
    pop de
    pop af

.clipLeftDone:
    bit 7, (ix + 5)
    jr nz, .clipTopDone
    ld bc, (xlibcInt4)
    push af
    push de
    push hl
    call _drawXlibcHorizLine
    pop hl
    pop de
    pop af

.clipTopDone:
    push hl
    ld hl, (xlibcInt4)
    dec hl
    add hl, de
    push hl
    ex de, hl
    ld hl, -ti.lcdWidth / 2
    add hl, de
    pop de
    pop hl
    pop bc
    push bc
    jr c, .clipRightDone
    push af
    push de
    push hl
    call _drawXlibcVertLine
    pop hl
    pop de
    pop af

.clipRightDone:
    pop bc
    pop de
    dec c
    add a, c
    cp a, ti.lcdHeight / 2
    jr nc, .return
    ld bc, (xlibcInt4)
    call _drawXlibcHorizLine

.return:
    ld a, (xlibcInt7)
    or a, a
    call nz, _flipActiveDraw
    ret

.invertRectangle:
    set invertPixel, (iy + celticFlags2)
    ld hl, (xlibcInt6)
    ld (xlibcInt7), hl
    jp .drawRectangleStart

.fillRectangle:
    call _clipXlibcRect
    ret z
    ld a, (xlibcInt6)
    ld e, a
    ld d, a

.loopFillRect:
    push hl
    ld (hl), e
    inc hl
    ld (hl), d
    dec hl
    push bc
    push de
    dec c
    ld a, c
    jr z, .doneFillRect
    push hl
    push hl
    or a, a
    sbc hl, hl
    ld l, a
    add hl, hl
    push hl
    pop bc
    pop hl
    pop de
    inc de
    inc de
    ldir

.doneFillRect:
    pop de
    pop bc
    pop hl
    push de
    ld de, ti.lcdWidth * 2
    add hl, de
    pop de
    djnz .loopFillRect
    ld a, (xlibcInt7)
    or a, a
    call nz, _flipActiveDraw
    ret

.invertFilledRectangle:
    call _clipXlibcRect
    ret z

.loopIFRRow:
    push hl
    push bc

.loopInvertFillRect:
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    dec c
    jr z, .doneIFR
    jr .loopInvertFillRect

.doneIFR:
    pop bc
    pop hl
    ld de, ti.lcdWidth * 2
    add hl, de
    djnz .loopIFRRow
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

.drawCircle:
    res invertPixel, (iy + celticFlags2)
    ld a, (xlibcInt5)
    or a, a
    sbc hl, hl
    ld l, a
    ld h, a
    push hl
    ld de, (xlibcInt2)
    ld bc, (xlibcInt3)
    ld hl, (xlibcInt4)
    push de ; x center, ix + 6
    push bc ; y center, ix + 3
    push hl ; radius, ix + 0
    ld ix, 0
    add ix, sp
    push hl ; x, ix - 3
    ld bc, 0
    push bc ; y, ix - 6
    push bc ; uninitialized var
    ld hl, (ix - 3)
    ld bc, (ix + 6)
    add hl, bc
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    ld a, d
    or a, e
    jp z, .exitCircle
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld de, (ix - 3)
    ld hl, (ix + 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    or a, a
    sbc hl, hl
    inc hl
    ld de, (ix)
    or a, a
    sbc hl, de
    pop de
    push hl ; perimeter, ix - 9

.loopCircle:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, .exitCircle
    ld hl, (ix - 6)
    inc hl
    ld (ix - 6), hl
    ld de, (ix - 9)
    or a, a
    sbc hl, hl
    sbc hl, de
    jr z, .Pis0orLess
    bit 7, (ix - 7) ; upper byte of perimeter
    jr z, .PisMoreThan0

.Pis0orLess:
    ld hl, (ix - 6)
    add hl, hl
    ld de, (ix - 9)
    add hl, de
    inc hl
    ld (ix - 9), hl
    jr .continueDraw

.PisMoreThan0:
    ld hl, (ix - 3)
    dec hl
    ld (ix - 3), hl
    ld hl, (ix - 6)
    add hl, hl
    ld de, (ix - 9)
    add hl, de
    push hl
    ld hl, (ix - 3)
    add hl, hl
    ex de, hl
    pop hl
    or a, a
    sbc hl, de
    inc hl
    ld (ix - 9), hl

.continueDraw:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, .exitCircle
    ld hl, (ix - 3)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix - 3)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix - 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    jp z, .loopCircle
    ld hl, (ix - 6)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix - 6)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    jp .loopCircle

.exitCircle:
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    lea ix, ix + 12
    ld sp, ix
    ret

.drawFilledCircle:
    res invertPixel, (iy + celticFlags2)
    ld a, (xlibcInt5)
    or a, a
    sbc hl, hl
    ld l, a
    ld h, a
    push hl
    ld de, (xlibcInt2)
    ld bc, (xlibcInt3)
    ld hl, (xlibcInt4)
    push de ; x center, ix + 6
    push bc ; y center, ix + 3
    push hl ; radius, ix + 0
    ld ix, 0
    add ix, sp
    push hl ; x, ix - 3
    ld bc, 0
    push bc ; y, ix - 6
    push bc ; uninitialized var
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    ld a, d
    or a, e
    jp z, .exitFilledCircle
    add hl, de
    push hl
    call _setPixelxlibc
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    push hl
    ld hl, (ix - 3)
    add hl, hl
    inc hl
    push hl
    call .drawHorizLine
    pop hl
    pop hl
    pop hl
    or a, a
    sbc hl, hl
    inc hl
    ld de, (ix)
    or a, a
    sbc hl, de
    pop de
    push hl ; perimeter, ix - 9

.loopFilledCircle:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, .exitFilledCircle
    ld hl, (ix - 6)
    inc hl
    ld (ix - 6), hl
    ld de, (ix - 9)
    or a, a
    sbc hl, hl
    sbc hl, de
    jr z, .Pis0orLessFilled
    bit 7, (ix - 7) ; upper byte of perimeter
    jr z, .PisMoreThan0Filled

.Pis0orLessFilled:
    ld hl, (ix - 6)
    add hl, hl
    ld de, (ix - 9)
    add hl, de
    inc hl
    ld (ix - 9), hl
    jr .continueDrawFilled

.PisMoreThan0Filled:
    ld hl, (ix - 3)
    dec hl
    ld (ix - 3), hl
    ld hl, (ix - 6)
    add hl, hl
    ld de, (ix - 9)
    add hl, de
    push hl
    ld hl, (ix - 3)
    add hl, hl
    ex de, hl
    pop hl
    or a, a
    sbc hl, de
    inc hl
    ld (ix - 9), hl

.continueDrawFilled:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, .exitFilledCircle
    ld hl, (ix + 6)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    add hl, de
    push hl
    ld hl, (ix - 6)
    add hl, hl
    inc hl
    push hl
    call .drawHorizLine
    pop hl
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix - 6)
    add hl, hl
    inc hl
    push hl
    call .drawHorizLine
    pop hl
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 6)
    add hl, de
    push hl
    ld hl, (ix - 3)
    add hl, hl
    inc hl
    push hl
    call .drawHorizLine
    pop hl
    pop hl
    pop hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 6)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix - 3)
    add hl, hl
    inc hl
    push hl
    call .drawHorizLine
    pop hl
    pop hl
    pop hl
    jp .loopFilledCircle

.exitFilledCircle:
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    lea ix, ix + 12
    ld sp, ix
    ret

.drawHorizLine: ; x = ix - 12, y = ix - 15, length = ix - 18, color = ix + 9
    ld de, (ix - 15)
    ld hl, -ti.lcdHeight / 2
    add hl, de
    ret c
    ld hl, (ix - 12)
    ld bc, (ix - 18)
    add hl, bc
    ex de, hl
    ld hl, -ti.lcdWidth / 2
    add hl, de
    jr nc, .clipLineStart
    ld (ix - 18), de
    bit 7, (ix - 16)
    ret nz
    ld de, ti.lcdWidth / 2

.clipLineStart:
    ld (ix - 18), de
    ld de, (ix - 12)
    ld hl, -ti.lcdWidth / 2
    add hl, de
    jr nc, .drawLineFC
    bit 7, (ix - 10)
    ret z
    ld de, 0

.drawLineFC:
    or a, a
    ld (ix - 12), de
    ld hl, (ix - 18)
    sbc hl, de
    push hl
    pop bc
    ld a, (ix - 15)
    ld hl, (ix + 9)
    jp _drawXlibcHorizLine

.drawFilledColorRotateRectangle:
    call _clipXlibcRect
    ret z
    ld a, (xlibColorOffset)
    ld e, a

.rowFCRRect:
    push bc
    push hl

.loopFCRRect:
    ld a, (hl)
    add a, e
    ld (hl), a
    inc hl
    ld a, (hl)
    add a, e
    ld (hl), a
    inc hl
    dec c
    jr nz, .loopFCRRect

.doneFCRRect:
    pop hl
    pop bc
    push de
    ld de, ti.lcdWidth * 2
    add hl, de
    pop de
    djnz .rowFCRRect
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

xlibcUtility: ; real(8)
    ld a, (xlibcInt1)
    cp a, 4
    jp nc, return
    ld l, a
    ld h, 3
    mlt hl
    ld de, .lut
    add hl, de
    ld hl, (hl)
    ld bc, return
    push bc
    jp (hl)

.lut:
    dl .getLcdBuffer
    dl .setLcdBuffer
    dl .setGramOffset
    dl .getRand

.getLcdBuffer:
    ld a, (currentGram)
    call ti.SetxxOP1
    jp ti.StoAns

.setLcdBuffer:
    ld a, (xlibcInt2)
    and a, 1
    ld (currentGram), a
    or a, a
    jp z, _showRightBuffer
    jp _showLeftBuffer

.setGramOffset:
    ; figure this out later
    ret

.getRand:
    ld a, ($F30044) ; rtc_time
    ld (randSeed), a

.loopRand:
    ld a, (randSeed)
    ld c, a
    add a, a
    add a, c
    add a, a
    add a, a
    add a, c
    add a, 83
    ld (randSeed), a
    ld b, a
    ld a, (xlibcInt2)
    or a, a
    jr z, .storeRand
    cp a, b
    jr c, .loopRand
    ld a, b

.storeRand:
    call ti.SetxxOP1
    jp ti.StoAns

updateLCD: ; real(9)
    call _flipActiveDraw
    jp return
