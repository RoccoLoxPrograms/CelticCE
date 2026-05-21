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
    ; might have to set this myself
    ld a, (xlibcInt2)
    or a, a
    jp nz, ti.boot.Set48MHzMode
    jp ti.boot.Set6MHzMode

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
    or a, a
    jr z, .fontSet1
    ld c, 6

.fontSet1:
    mlt bc
    ld hl, largeFontData
    or a, a
    jr z, .fontSet2
    ld hl, smallFontData

.fontSet2:
    add hl, bc
    ld b, 8
    or a, a
    jr z, .drawChar
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
    or a, a
    jr z, .scaleSet1
    ld c, 4

.scaleSet1:
    add hl, bc
    ld (bufSpriteX), hl
    jp .loop

.newLine:
    ld c, 8
    ld a, (xlibcFont)
    or a, a
    jr z, .scaleSet2
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
    and a, 1
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
    ld de, (xlibcInt2)
    ld a, (xlibcInt3)
    call _getXlibcVRAMaddr
    ld a, (xlibcInt6)
    or a, a
    ret z
    ld c, a
    add a, a
    ld b, a
    ld a, (xlibcInt5)
    ld e, a
    ld a, (xlibcInt4)
    ld d, a

.loopSetPixelA:
    push hl
    ld (hl), e
    inc hl
    ld (hl), d
    dec hl
    push bc
    push de
    dec c
    jr z, .doneSPA
    push hl
    push hl
    or a, a
    sbc hl, hl
    ld l, a
    add hl, hl
    push hl
    pop bc
    dec bc
    pop hl
    pop de
    inc de
    inc de
    ldir

.doneSPA:
    pop de
    pop bc
    pop hl
    ld a, (xlibcInt6)
    ld c, a
    push de
    ld de, ti.lcdWidth * 2
    add hl, de
    pop de
    djnz .loopSetPixelA
    ld a, (xlibcInt7)
    or a, a
    call nz, _flipActiveDraw
    ret

.setPixelB:
    ld de, (xlibcInt2)
    ld a, (xlibcInt3)
    call _getXlibcVRAMaddr
    ld a, (xlibcInt5)
    or a, a
    ret z
    ld c, a
    add a, a
    ld b, a
    ld a, (xlibcInt4)
    ld e, a

.loopSetPixelB:
    push hl
    ld (hl), a
    inc hl
    ld (hl), a
    dec hl
    push bc
    push de
    dec c
    jr z, .doneSPB
    push hl
    push hl
    or a, a
    sbc hl, hl
    ld l, a
    add hl, hl
    push hl
    pop bc
    dec bc
    pop hl
    pop de
    inc de
    inc de
    ldir

.doneSPB:
    pop de
    pop bc
    pop hl
    ld a, (xlibcInt5)
    ld c, a
    push de
    ld de, ti.lcdWidth * 2
    add hl, de
    pop de
    djnz .loopSetPixelB
    ld a, (xlibcInt6)
    or a, a
    call nz, _flipActiveDraw
    ret

.invertPixel:
    ret

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
    ret

.invertRectangle:
    ret

.fillRectangle:
    ret

.invertFilledRectangle:
    ret

.drawCircle:
    ret

.drawFilledCircle:
    ret

.drawFilledColorRotateRectangle:
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
