;----------------------------------------
;
; Celtic CE Source Code - graphics.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 24, 2023
;
;----------------------------------------

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
    call _checkValidOSColor
    call ti.GetColorValue
    jr .fillScrn

drawLine: ; det(17)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ld ix, var2
    jr .drawLine

.sevenArgs:
    ld a, (var1)
    ld (ti.drawFGColor), a
    ld a, (var2)
    ld (ti.drawFGColor + 1), a
    ld ix, var3

.drawLine:
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
    call drawCircle.setPixel
    pop hl
    pop hl

.drawLineLoop:
    ld hl, (ix - 9)
    dec hl
    ld a, h
    or a, l
    jp z, return
    ld (ix - 9), hl
    ld hl, (ix + 21)
    ld de, (ix + 15)
    or a, a
    sbc hl, de
    ld hl, (ix + 21)
    jr nc, $ + 5
    inc hl
    jr $ + 3
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
    call drawCircle.setPixel
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
    jr nc, $ + 5
    inc hl
    jr $ + 3
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
    call drawCircle.setPixel
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

.absoluteVal: ; number = de
    or a, a
    sbc hl, hl
    sbc hl, de
    ret p
    ex de, hl
    ret

setPixel: ; det(18)
    res invertPixel, (iy + celticFlags2)
    ld a, (noArgs)
    cp a, 5
    jr z, .fiveArgs
    cp a, 4
    jp c, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    call nz, _checkValidOSColor
    call ti.GetColorValue
    push de
    ld ix, var2
    ld a, (var1)
    or a, a
    jr nz, .getCoord
    set invertPixel, (iy + celticFlags2)
    jr .getCoord

.fiveArgs:
    ld a, (var1)
    ld e, a
    ld a, (var2)
    ld d, a
    push de
    ld ix, var3

.getCoord:
    ld l, (ix + 3)
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (ix)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    ex de, hl
    ld hl, -ti.vRamEnd
    add hl, de
    ex de, hl
    jr c, .return
    bit invertPixel, (iy + celticFlags2)
    jr nz, .invertColor
    pop de
    ld (hl), e
    inc hl
    ld (hl), d
    jr .return

.invertColor:
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    ld a, (hl)
    cpl
    ld (hl), a

.return:
    jp return

getPixel: ; det(19)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (var1)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    ld de, 0
    ld e, (hl)
    push de
    inc hl
    ld e, (hl)
    ex de, hl
    call _storeThetaHL
    pop hl
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    call ti.StoAns
    jr setPixel.return

pixelTestColor: ; det(20)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
    ld a, (var1)
    cp a, 165
    jp nc, PrgmErr.INVALA
    ld c, a
    ld a, 164
    sub a, c
    ld c, a
    ld de, (var2)
    ld hl, 264
    or a, a
    sbc hl, de
    jp c, PrgmErr.INVALA
    ld a, 3
    call ti.IPoint
    or a, a
    jr z, .skipAdd
    add a, 9

.skipAdd:
    call ti.SetxxOP1
    call ti.StoAns
    jp return

putSprite: ; det(21)
    ld a, (noArgs)
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (var1)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    push hl
    ld hl, Str0
    call ti.Mov9ToOP1
    ld a, (var5)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    ld (ti.OP1 + 2), a
    call _findString + 4
    inc de
    inc de
    ex de, hl
    ld bc, (var4)
    ld a, b
    or a, c
    jp z, PrgmErr.INVALA
    ld bc, 0
    ld (currentWidth), bc
    ld bc, (var3)
    ld a, b
    or a, c
    jp z, PrgmErr.INVALA
    pop de
    ld (bufSpriteXStart), de
    ld ix, 0

.loopSprite: ; hl = string location; de = vram location; ix = height counter
    push bc
    ld a, (hl)
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    ld b, a
    inc hl
    ld a, (hl)
    call _convertTokenToHex
    add a, b
    ld (de), a
    inc de
    ld (de), a
    inc de
    inc hl
    pop bc
    push hl
    ld hl, (currentWidth)
    inc hl
    push hl
    or a, a
    sbc hl, bc
    pop hl
    call z, .moveDown
    ld (currentWidth), hl
    pop hl
    jr .loopSprite

.moveDown:
    inc ix
    ld hl, (var4)
    push bc
    push ix
    pop bc
    or a, a
    sbc hl, bc
    jr z, .return
    pop bc
    ld hl, (bufSpriteXStart)
    ld de, ti.lcdWidth * 2
    add hl, de
    ld (bufSpriteXStart), hl
    ex de, hl
    ld hl, -ti.vRamEnd
    add hl, de
    jr c, .return
    or a, a
    sbc hl, hl
    ret

.return:
    jp return

getStringWidth: ; det(54)
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, ti.StrngObj
    jp nz, PrgmErr.SNTST
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
    ld a, (var1)
    or a, a
    jr z, .smallFont
    call ti.StrLength
    ld l, c
    ld h, 12
    mlt hl
    jr .storeTheta

.smallFont:
    call ti.FontGetWidth
    push bc
    pop hl

.storeTheta:
    call _storeThetaHL
    jp return

transSprite: ; det(55)
    ld a, (noArgs)
    cp a, 7
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (var1)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    push hl
    ld hl, Str0
    call ti.Mov9ToOP1
    ld a, (var6)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    ld (ti.OP1 + 2), a
    call _findString + 4
    inc de
    inc de
    ex de, hl
    ld bc, (var4)
    ld a, b
    or a, c
    jp z, PrgmErr.INVALA
    ld bc, 0
    ld (currentWidth), bc
    ld bc, (var3)
    ld a, b
    or a, c
    jp z, PrgmErr.INVALA
    pop de
    ld (bufSpriteXStart), de
    ld ix, 0

.loopSprite: ; hl = string location; de = vram location; ix = height counter
    push bc
    ld a, (hl)
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    ld b, a
    inc hl
    ld a, (hl)
    call _convertTokenToHex
    add a, b
    ld b, a
    ld a, (var5)
    cp a, b
    jr z, .skipDraw
    ld a, b
    ld (de), a
    inc de
    ld (de), a

.continueSprite:
    inc de
    inc hl
    pop bc
    push hl
    ld hl, (currentWidth)
    inc hl
    push hl
    or a, a
    sbc hl, bc
    pop hl
    call z, putSprite.moveDown
    ld (currentWidth), hl
    pop hl
    jr .loopSprite

.skipDraw:
    inc de
    jr .continueSprite

scaleSprite: ; det(56)
    ld a, (noArgs)
    cp a, 8
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (var1)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    push hl ; address of VRAM, ix + 18
    push hl ; address of start of row, ix + 15
    ex de, hl
    ld hl, -ti.vRamEnd
    add hl, de
    jp c, return
    ld hl, Str0
    call ti.Mov9ToOP1
    ld a, (var7)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    ld (ti.OP1 + 2), a
    call _findString + 4
    inc de
    inc de
    push de ; address of string, ix + 12
    ld ix, var3
    ld hl, (ix)
    ld a, h
    or a, l
    jp z, return
    push hl ; width, ix + 9
    ld hl, (ix + 3)
    ld a, h
    or a, l
    jp z, return
    push hl ; height, ix + 6
    ld hl, (ix + 6)
    xor a, a
    cp a, l
    jp z, return
    push hl ; x scale, ix + 3
    ld hl, (ix + 9)
    cp a, l
    jp z, return
    push hl ; y scale, ix + 0
    ld ix, 0
    add ix, sp
    or a, a
    sbc hl, hl
    push hl ; width counter, ix - 3
    push hl ; height counter, ix - 6
    ld hl, (ix)
    push hl ; y scale counter, ix - 9

.loopSprite:
    ld hl, (ix + 12)
    ld a, (hl)
    inc hl
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    ld b, a
    ld a, (hl)
    inc hl
    ld (ix + 12), hl
    call _convertTokenToHex
    add a, b
    call .setPixel
    ld hl, (ix + 9)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    jr nz, .loopSprite
    call .moveDown
    jr .loopSprite

.moveDown:
    or a, a
    sbc hl, hl
    ld (ix - 3), hl
    ld hl, (ix + 15)
    ld bc, ti.lcdWidth * 2
    add hl, bc
    ld (ix + 15), hl
    ld (ix + 18), hl
    dec (ix - 9)
    jr nz, .skipReload
    ld hl, (ix)
    ld (ix - 9), hl
    ld de, (ix - 6)
    inc de
    ld hl, (ix + 6)
    or a, a
    sbc hl, de
    jp z, return
    ld (ix - 6), de
    ret

.skipReload:
    ld hl, (ix + 9)
    add hl, hl
    ex de, hl
    ld hl, (ix + 12)
    or a, a
    sbc hl, de
    ld (ix + 12), hl
    ret

.setPixel: ; color = a
    ld hl, (ix - 3)
    inc hl
    ld (ix - 3), hl
    ld b, (ix + 3)

.loopXScale:
    ld de, (ix + 18)
    ld hl, -ti.vRamEnd
    add hl, de
    ret c
    ex de, hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (ix + 18), hl
    djnz .loopXScale
    ret

scaleTSprite: ; det(57)
    ld a, (noArgs)
    cp a, 9
    jp c, PrgmErr.INVALA
    ld hl, (var7)
    push hl ; transparent color, ix + 21
    ld a, (var2)
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (var1)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    push hl ; address of VRAM, ix + 18
    push hl ; address of start of row, ix + 15
    ex de, hl
    ld hl, -ti.vRamEnd
    add hl, de
    jp c, return
    ld hl, Str0
    call ti.Mov9ToOP1
    ld a, (var8)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    ld (ti.OP1 + 2), a
    call _findString + 4
    inc de
    inc de
    push de ; address of string, ix + 12
    ld ix, var3
    ld hl, (ix)
    ld a, h
    or a, l
    jp z, return
    push hl ; width, ix + 9
    ld hl, (ix + 3)
    ld a, h
    or a, l
    jp z, return
    push hl ; height, ix + 6
    ld hl, (ix + 6)
    xor a, a
    cp a, l
    jp z, return
    push hl ; x scale, ix + 3
    ld hl, (ix + 9)
    cp a, l
    jp z, return
    push hl ; y scale, ix + 0
    ld ix, 0
    add ix, sp
    or a, a
    sbc hl, hl
    push hl ; width counter, ix - 3
    push hl ; height counter, ix - 6
    ld hl, (ix)
    push hl ; y scale counter, ix - 9

.loopSprite:
    ld hl, (ix + 12)
    ld a, (hl)
    inc hl
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    ld b, a
    ld a, (hl)
    inc hl
    ld (ix + 12), hl
    call _convertTokenToHex
    add a, b
    cp a, (ix + 21)
    jr z, .skipPixel
    call scaleSprite.setPixel

.pixelDrawn:
    ld hl, (ix + 9)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    jr nz, .loopSprite
    call scaleSprite.moveDown
    jr .loopSprite

.skipPixel:
    ld hl, (ix - 3)
    inc hl
    ld (ix - 3), hl
    ld b, (ix + 3)

.skipLoop:
    ld hl, (ix + 18)
    inc hl
    inc hl
    ld (ix + 18), hl
    djnz .skipLoop
    jr .pixelDrawn

shiftScreen: ; det(58)
    ld a, (noArgs)
    cp a, 3
    jr z, .setDefaults
    cp a, 7
    jr nc, .checkDirection
    jp PrgmErr.INVALA

.setDefaults:
    or a, a
    sbc hl, hl
    ld (var3), hl
    ld (var4), hl
    ld hl, ti.lcdWidth
    ld (var5), hl
    ld hl, ti.lcdHeight
    ld (var6), hl

.checkDirection:
    ld ix, var3 ; pixelAmount (var2) = ix - 3, XOrigin = ix + 0, YOrigin = ix + 3, width = ix + 6, height = ix + 9
    call .checkBounds
    ld a, (ix + 3)
    call _vramAddrShiftScrn
    ld a, (ix - 6)
    or a, a ; 0
    jr z, .shiftUp
    dec a ; 1
    jr z, .shiftDown
    dec a ;  2
    jp z, .shiftLeft
    dec a ; 3
    jr z, .shiftRight
    jp PrgmErr.INVALA

.shiftUp:
    push hl
    ld hl, (ix - 3)
    ld de, (ix + 9)
    or a, a
    sbc hl, de
    jp nc, return
    ld a, (ix - 3)
    add a, (ix + 3)
    call _vramAddrShiftScrn
    push hl
    ld hl, (ix + 6)
    add hl, hl
    push hl
    pop bc
    ld a, (ix + 9)
    sub a, (ix - 3)
    pop hl
    pop de
    jp .shiftLDIR

.shiftRight:
    ld hl, (ix - 3)
    ld de, (ix + 6)
    or a, a
    sbc hl, de
    jp nc, return
    ld a, (ix + 3)
    add a, (ix + 9)
    dec a
    ld de, (ix)
    ld hl, (ix + 6)
    add hl, de
    ld (ix), hl
    call _vramAddrShiftScrn
    dec hl
    push hl
    ld hl, (ix - 3)
    add hl, hl
    ex de, hl
    pop hl
    push hl
    or a, a
    sbc hl, de
    push hl
    ld hl, (ix + 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    add hl, hl
    push hl
    pop bc
    pop hl
    pop de
    ld a, (ix + 9)
    jr .shiftLDDR

.shiftDown:
    ld hl, (ix - 3)
    ld de, (ix + 9)
    or a, a
    sbc hl, de
    jp nc, return
    ld de, (ix)
    ld hl, (ix + 6)
    add hl, de
    ld (ix), hl
    ld a, (ix + 3)
    add a, (ix + 9)
    dec a
    push af
    call _vramAddrShiftScrn
    dec hl
    pop af
    push hl
    sub a, (ix - 3)
    call _vramAddrShiftScrn
    dec hl
    pop de
    push hl
    ld hl, (ix + 6)
    add hl, hl
    push hl
    pop bc
    ld a, (ix + 9)
    sub a, (ix - 3)
    pop hl
    jr .shiftLDDR

.shiftLeft:
    push hl
    ld hl, (ix - 3)
    ld de, (ix + 6)
    or a, a
    sbc hl, de
    jr nc, .return
    ld hl, (ix - 3)
    ex de, hl
    or a, a
    sbc hl, de
    add hl, hl
    push hl
    pop bc
    ld hl, (ix - 3)
    add hl, hl
    pop de
    add hl, de
    ld a, (ix + 9)

.shiftLDIR: ; for shifting up and left
    push bc
    push hl
    push de
    ldir
    pop hl
    pop de
    ld bc, ti.lcdWidth * 2
    add hl, bc
    ex de, hl
    add hl, bc
    pop bc
    dec a
    jr nz, .shiftLDIR
    jr .return

.shiftLDDR: ; for shifting down and right
    push bc
    push hl
    push de
    lddr
    pop hl
    pop de
    ld bc, ti.lcdWidth * 2
    or a, a
    sbc hl, bc
    ex de, hl
    or a, a
    sbc hl, bc
    pop bc
    dec a
    jr nz, .shiftLDDR

.return:
    jp return

.checkBounds:
    ld hl, (ix - 3)
    ld a, h
    or a, l
    jr z, .return
    ld de, (ix)
    ld hl, -ti.lcdWidth
    add hl, de
    jr c, .return
    ld de, (ix + 3)
    ld hl, -ti.lcdHeight
    add hl, de
    jr c, .return
    ld hl, (ix)
    ld de, (ix + 6)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdWidth
    add hl, de
    jr nc, .goodXBounds
    ex de, hl
    ld hl, (ix + 6)
    or a, a
    sbc hl, de
    ld (ix + 6), hl

.goodXBounds:
    ld hl, (ix + 3)
    ld de, (ix + 9)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdHeight
    add hl, de
    jr nc, .goodYBounds
    ex de, hl
    ld hl, (ix + 9)
    or a, a
    sbc hl, de
    ld (ix + 9), hl

.goodYBounds:
    ld hl, (ix + 6)
    ld a, h
    or a, l
    jr z, .return
    ld hl, (ix + 9)
    ld a, h
    or a, l
    jr z, .return
    ret

rgbto565: ; det(59)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
    ld a, (var1)
    and a, $F8
    ld de, 0
    ld e, a
    ld b, 8

.leftShiftLoop:
    sla e
    rl d
    djnz .leftShiftLoop
    ld a, (var2)
    and a, $FC
    or a, a
    sbc hl, hl
    ld l, a
    ld b, 3
    add hl, hl
    add hl, hl
    add hl, hl
    ld a, (var3)
    srl a
    srl a
    srl a
    or a, l
    or a, e
    ld l, a
    ld a, h
    or a, d
    ld h, a
    push hl
    ld l, h
    ld h, 0
    call _storeThetaHL
    pop hl
    ld h, 0
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    call ti.StoAns
    jp return

drawRect: ; det(60)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ld hl, (var2)
    ld de, (var4)
    add hl, de
    dec hl
    ex de, hl
    ld hl, (var2)
    ld a, (var5)
    ld c, a
    ld a, (var3)
    ld b, a
    add a, c
    dec a
    ld c, a
    jr .drawRect

.sevenArgs:
    ld a, (var1)
    ld (ti.drawFGColor), a
    ld a, (var2)
    ld (ti.drawFGColor + 1), a
    ld hl, (var3)
    ld de, (var5)
    add hl, de
    dec hl
    ex de, hl
    ld hl, (var3)
    ld a, (var6)
    ld c, a
    ld a, (var4)
    ld b, a
    add a, c
    dec a
    ld c, a

.drawRect:
    call ti.DrawRectBorder
    jp return

drawCircle: ; det(61)
    ld a, (noArgs)
    cp a, 6
    jr z, .sixArgs
    cp a, 5
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    push de
    ld ix, var2
    jr .drawCircle

.sixArgs:
    or a, a
    sbc hl, hl
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    push hl
    ld ix, var3

.drawCircle: ; color = ix + 9
    ld de, (ix)
    ld hl, (ix + 6)
    ld bc, (ix + 3)
    ld a, h
    or a, l
    jp z, return
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
    call .setPixel
    pop hl
    pop hl
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    jp c, return
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
    jp c, return
    ld hl, (ix - 3)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    call .setPixel
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
    call .setPixel
    pop hl
    pop hl
    jp .loopCircle

.setPixel: ; x = ix - 12, y = ix - 15, color = ix + 9
    ld de, (ix - 15)
    ld hl, -ti.lcdHeight
    add hl, de
    ret c
    ld bc, (ix - 12)
    ld hl, -ti.lcdWidth
    add hl, bc
    ret c
    call _getVramAddr
    ld de, (ix + 9)
    ld (hl), e
    inc hl
    ld (hl), d
    ret

fillCircle: ; det(62)
    ld a, (noArgs)
    cp a, 6
    jr z, .sixArgs
    cp a, 5
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    push de
    ld ix, var2
    jr .drawCircle

.sixArgs:
    or a, a
    sbc hl, hl
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    push hl
    ld ix, var3

.drawCircle: ; color = ix + 9
    ld de, (ix)
    ld hl, (ix + 6)
    ld bc, (ix + 3)
    ld a, h
    or a, l
    jp z, return
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
    call drawCircle.setPixel
    pop hl
    pop hl
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    add hl, de
    push hl
    call drawCircle.setPixel
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

.loopCircle:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, return
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
    jp c, return
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
    jp .loopCircle

.drawHorizLine: ; x = ix - 12, y = ix - 15, length = ix - 18, color = ix + 9
    ld de, (ix - 15)
    ld hl, -ti.lcdHeight
    add hl, de
    ret c
    ld hl, (ix - 12)
    ld bc, (ix - 18)
    add hl, bc
    ex de, hl
    ld hl, -ti.lcdWidth
    add hl, de
    jr nc, .clipStart
    ld (ix - 18), de
    bit 7, (ix - 16)
    ret nz
    ld de, ti.lcdWidth

.clipStart:
    ld (ix - 18), de
    ld de, (ix - 12)
    ld hl, -ti.lcdWidth
    add hl, de
    jr nc, .drawLine
    bit 7, (ix - 10)
    ret z
    ld de, 0

.drawLine:
    or a, a
    ld (ix - 12), de
    ld hl, (ix - 18)
    sbc hl, de
    add hl, hl
    push hl
    call _getVramAddr
    pop bc
    ld de, (ix + 9)
    ld (hl), e
    inc hl
    ld (hl), d
    dec bc
    dec bc
    ld a, b
    or a, c
    ret z
    push hl
    pop de
    inc de
    dec hl
    ldir
    ret

drawArc: ; det(63)
    ld a, (noArgs)
    cp a, 8
    jr z, .eightArgs
    cp a, 7
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    push de
    ld hl, var6 + 2 ; shift the arguments over
    ld de, var7 + 2
    ld bc, 18
    lddr
    pop de
    ld a, e
    ld (var1), a
    ld a, d
    ld (var2), a

.eightArgs:
    ld hl, 360
    ld de, (var6)
    or a, a
    sbc hl, de
    jp c, return
    ld hl, 360
    ld de, (var7)
    or a, a
    sbc hl, de
    jr nc, .calculatePoints
    ld hl, 360
    ld (var7), hl

.calculatePoints:
    ld hl, (var6)
    ld de, (var7)
    or a, a
    sbc hl, de
    jp nc, return
    ld hl, -96
    call ti._frameset
    ld hl, (var6)
    lea bc, ix - 9
    ld (ix - 96), bc
    lea de, ix - 18
    ld (ix - 93), de
    lea de, ix - 27
    ld (ix - 87), de
    lea de, ix - 36
    ld (ix - 78), de
    lea de, ix - 45
    ld (ix - 84), de
    lea de, ix - 54
    ld (ix - 75), de
    lea de, ix - 63
    ld (ix - 81), de
    lea de, ix - 72
    ld (ix - 90), de
    push hl
    push bc
    call ti.os.Int24ToReal
    pop hl
    pop hl
    ld hl, (var7)
    push hl
    ld hl, (ix - 93)
    push hl
    call ti.os.Int24ToReal
    pop hl
    pop hl
    ld hl, (var5)
    push hl
    ld hl, (ix - 87)
    push hl
    call ti.os.Int24ToReal
    pop hl
    pop hl
    ld hl, (ix - 96)
    push hl
    ld hl, (ix - 78)
    push hl
    call ti.os.RealDegToRad
    pop hl
    pop hl
    ld de, (ix - 96)
    ld iy, (ix - 78)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 93)
    push hl
    push iy
    call ti.os.RealDegToRad
    pop hl
    pop hl
    ld de, (ix - 93)
    ld iy, (ix - 78)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 96)
    push hl
    push iy
    call ti.os.RealCosRad
    pop hl
    pop hl
    ld hl, (ix - 96)
    push hl
    ld hl, (ix - 84)
    push hl
    call ti.os.RealSinRad
    pop hl
    pop hl
    ld hl, (ix - 87)
    push hl
    ld hl, (ix - 78)
    push hl
    ld hl, (ix - 75)
    push hl
    call ti.os.RealMul
    pop hl
    pop hl
    pop hl
    ld de, (ix - 78)
    ld iy, (ix - 75)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 87)
    push hl
    ld hl, (ix - 84)
    push hl
    push iy
    call ti.os.RealMul
    pop hl
    pop hl
    pop hl
    ld de, (ix - 84)
    ld iy, (ix - 75)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 78)
    push hl
    push iy
    call ti.os.RealRoundInt
    pop hl
    pop hl
    ld de, (ix - 78)
    ld iy, (ix - 75)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 84)
    push hl
    push iy
    call ti.os.RealRoundInt
    pop hl
    pop hl
    ld de, (ix - 84)
    ld hl, (ix - 75)
    ld bc, 9
    ldir
    ld hl, (ix - 78)
    push hl
    call ti.os.RealToInt24
    ld de, (var3)
    add hl, de
    ld (XStart), hl
    pop hl
    ld hl, (ix - 84)
    push hl
    call ti.os.RealToInt24
    ld de, (var4)
    add hl, de
    ld (YStart), hl
    pop hl
    ld hl, (ix - 93)
    push hl
    ld hl, (ix - 75)
    push hl
    call ti.os.RealCosRad
    pop hl
    pop hl
    ld hl, (ix - 93)
    push hl
    ld hl, (ix - 81)
    push hl
    call ti.os.RealSinRad
    pop hl
    pop hl
    ld hl, (ix - 87)
    push hl
    ld hl, (ix - 75)
    push hl
    ld hl, (ix - 90)
    push hl
    call ti.os.RealMul
    pop hl
    pop hl
    pop hl
    ld de, (ix - 75)
    ld iy, (ix - 90)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 87)
    push hl
    ld hl, (ix - 81)
    push hl
    push iy
    call ti.os.RealMul
    pop hl
    pop hl
    pop hl
    ld de, (ix - 81)
    ld iy, (ix - 90)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 75)
    push hl
    push iy
    call ti.os.RealRoundInt
    pop hl
    pop hl
    ld de, (ix - 75)
    ld iy, (ix - 90)
    lea hl, iy
    ld bc, 9
    ldir
    ld hl, (ix - 81)
    push hl
    push iy
    call ti.os.RealRoundInt
    pop hl
    pop hl
    ld de, (ix - 81)
    ld hl, (ix - 90)
    ld bc, 9
    ldir
    ld hl, (ix - 75)
    push hl
    call ti.os.RealToInt24
    ld de, (var3)
    add hl, de
    ld (XEnd), hl
    pop hl
    ld hl, (ix - 81)
    push hl
    call ti.os.RealToInt24
    ld de, (var4)
    add hl, de
    ld (YEnd), hl
    pop hl
    ld sp, ix
    pop ix
    or a, a
    sbc hl, hl
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    push hl ; color = ix + 9
    ld de, (var3)
    ld hl, (var5)
    ld bc, (var4)
    ld a, h
    or a, l
    jp z, return
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
    ld de, (var6)
    or a, a
    sbc hl, hl
    sbc hl, de
    jr z, .setPixel
    ld de, (var7)
    ld hl, 360
    or a, a
    sbc hl, de

.setPixel:
    call z, drawCircle.setPixel
    pop hl
    pop hl
    ld hl, (ix + 6)
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    push hl
    ld hl, 90
    push hl
    call .checkQuarters
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
    ld hl, 180
    push hl
    call .checkQuarters
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
    ld hl, 270
    push hl
    call .checkQuarters
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

.loopArc:
    ld de, (ix - 6)
    ld hl, (ix - 3)
    or a, a
    sbc hl, de
    jp c, return
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
    jp c, return
    ld hl, (ix - 3)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix - 6)
    ld de, (ix + 3)
    add hl, de
    push hl
    call .checkSecondHalf
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
    call .checkSecondHalf
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
    call .checkFirstHalf
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
    call .checkFirstHalf
    pop hl
    pop hl
    ld hl, (ix - 6)
    ld de, (ix - 3)
    or a, a
    sbc hl, de
    jp z, .loopArc
    ld hl, (ix - 6)
    ld de, (ix + 6)
    add hl, de
    push hl
    ld hl, (ix + 3)
    ld de, (ix - 3)
    add hl, de
    push hl
    call .checkSecondHalf
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
    call .checkSecondHalf
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
    call .checkFirstHalf
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
    call .checkFirstHalf
    pop hl
    pop hl
    jp .loopArc

.checkQuarters:
    pop hl
    pop de
    push hl
    ld hl, (var7)
    or a, a
    sbc hl, de
    ret c
    ex de, hl
    ld de, (var6)
    or a, a
    sbc hl, de
    ret c
    jp drawCircle.setPixel

.checkFirstHalf: ; x = ix - 12, y = ix - 15
    ld hl, (YStart)
    ld de, (ix + 3)
    or a, a
    sbc hl, de
    ret c
    ld hl, 179
    ld de, (var6)
    or a, a
    sbc hl, de
    ret c
    ld hl, (XStart)
    ld de, (ix - 12)
    or a, a
    sbc hl, de
    ret c
    ld hl, (YEnd)
    ld de, (ix + 3)
    or a, a
    sbc hl, de
    jp c, drawCircle.setPixel
    ld hl, 360
    ld de, (var7)
    or a, a
    sbc hl, de
    jp z, drawCircle.setPixel
    ld hl, (ix - 12)
    ld de, (XEnd)
    or a, a
    sbc hl, de
    ret c
    jp drawCircle.setPixel

.checkSecondHalf: ; x = ix - 12, y = ix - 15
    ld hl, (ix + 3)
    ld de, (YEnd)
    or a, a
    sbc hl, de
    ret c
    ld hl, (var7)
    ld de, 181
    or a, a
    sbc hl, de
    ret c
    ld hl, (XEnd)
    ld de, (ix - 12)
    or a, a
    sbc hl, de
    ret c
    ld hl, (ix + 3)
    ld de, (YStart)
    or a, a
    sbc hl, de
    jp c, drawCircle.setPixel
    or a, a
    sbc hl, hl
    ld de, (var6)
    sbc hl, de
    jp z, drawCircle.setPixel
    ld hl, (ix - 12)
    ld de, (XStart)
    or a, a
    sbc hl, de
    ret c
    jp drawCircle.setPixel

dispTransText: ; det(64)
    ld a, (noArgs)
    cp a, 6
    jr z, .sixArgs
    cp a, 5
    jp c, PrgmErr.INVALA
    ld a, (var2)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ld hl, (var4)
    push hl
    ld hl, (var3)
    dec hl
    push hl
    jr .drawText

.sixArgs:
    or a, a
    sbc hl, hl
    ld a, (var2)
    ld l, a
    ld a, (var3)
    ld h, a
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld hl, (var5)
    push hl
    ld hl, (var4)
    dec hl
    push hl

.drawText:
    ld hl, (var1)
    call .loadFont
    ld hl, Str9
    call _findString
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
    bit largeFont, (iy + celticFlags1)
    call z, _correctCoords
    ld hl, execHexLoc
    push hl
    call ti.os.FontDrawTransText
    jp return

.loadFont:
    res largeFont, (iy + celticFlags1)
    ld a, h
    or a, l
    jr z, .setFont
    ld hl, 1
    set largeFont, (iy + celticFlags1)

.setFont:
    push hl
    call ti.os.FontSelect
    pop hl
    ret

chkRect: ; det(65)
    ld a, (noArgs)
    cp a, 9
    jp c, PrgmErr.INVALA
    xor a, a
    ld hl, (x0)
    ld de, (w0)
    add hl, de
    ex de, hl
    ld hl, (x1)
    or a, a
    sbc hl, de
    jr nc, .storeAns
    ld hl, (w1)
    ld de, (x1)
    add hl, de
    ex de, hl
    ld hl, (x0)
    or a, a
    sbc hl, de
    jr nc, .storeAns
    ld hl, (y0)
    ld de, (h0)
    add hl, de
    ex de, hl
    ld hl, (y1)
    or a, a
    sbc hl, de
    jr nc, .storeAns
    ld hl, (y1)
    ld de, (h1)
    add hl, de
    ex de, hl
    ld hl, (y0)
    or a, a
    sbc hl, de
    jr nc, .storeAns
    inc a

.storeAns:
    call ti.SetxxOP1
    call ti.StoAns
    jp return

putChar: ; det(66)
    ld a, (noArgs)
    cp a, 9
    jr z, .nineArgs
    cp a, 7
    jp c, PrgmErr.INVALA
    ld a, (var3)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawBGColor and $FFFF), de
    ld a, (var2)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ld hl, (var4)
    ld (ti.penCol), hl
    ld a, (var5)
    ld (ti.penRow), a
    ld a, (var6)
    push af
    jr .putChar

.nineArgs:
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
    ld a, (var8)
    push af

.putChar:
    ld a, (var1)
    or a, a
    jr z, $ + 6
    set ti.fracDrawLFont, (iy + ti.fontFlags)
    pop af
    call ti.VPutMap
    res ti.fracDrawLFont, (iy + ti.fontFlags)
    or a, a
    sbc hl, hl
    ld.sis (ti.drawFGColor and $FFFF), hl
    dec hl
    ld.sis (ti.drawBGColor and $FFFF), hl
    jp return

putTransChar: ; det(67)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var2)
    call _checkValidOSColor
    call ti.GetColorValue
    ld.sis (ti.drawFGColor and $FFFF), de
    ld hl, (var4)
    push hl
    ld hl, (var3)
    dec hl
    push hl
    ld a, (var5)
    push af
    jr .putChar

.sevenArgs:
    or a, a
    sbc hl, hl
    ld a, (var2)
    ld l, a
    ld a, (var3)
    ld h, a
    ld.sis (ti.drawFGColor and $FFFF), hl
    ld hl, (var5)
    push hl
    ld hl, (var4)
    dec hl
    push hl
    ld a, (var6)
    push af

.putChar:
    ld hl, (var1)
    call dispTransText.loadFont
    pop af
    ld hl, execHexLoc
    ld (hl), a
    inc hl
    ld (hl), 0
    bit largeFont, (iy + celticFlags1)
    call z, _correctCoords
    ld hl, execHexLoc
    push hl
    call ti.os.FontDrawTransText
    jp return

horizLine: ; det(68)
    ld a, (noArgs)
    cp a, 6
    jr z, .sixArgs
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    push de
    ld ix, var2
    jr .drawHorizLine

.sixArgs:
    or a, a
    sbc hl, hl
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    push hl
    ld ix, var3

.drawHorizLine: ; x, y, l : 0, +3, +6
    ld hl, (ix + 6)
    ld a, h
    or a, l
    jp z, return
    ld de, (ix + 3)
    ld hl, -ti.lcdHeight
    add hl, de
    jp c, return
    ld de, (ix)
    ld hl, -ti.lcdWidth
    add hl, de
    jp c, return
    ld hl, (ix + 6)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdWidth
    add hl, de
    jr nc, .startHorizLine
    ex de, hl
    ld hl, (ix + 6)
    or a, a
    sbc hl, de
    ld (ix + 6), hl

.startHorizLine:
    ld a, (ix + 3)
    call _vramAddrShiftScrn ; use this call to get the VRAM address
    push hl
    ld hl, (ix + 6)
    add hl, hl
    push hl
    pop bc
    pop hl
    pop de
    ld (hl), e
    inc hl
    ld (hl), d
    dec bc
    dec bc
    ld a, b
    or a, c
    jr z, .return
    push hl
    pop de
    dec hl
    inc de
    ldir

.return:
    jp return

vertLine: ; det(69)
    ld a, (noArgs)
    cp a, 6
    jr z, .sixArgs
    ld a, (var1)
    call _checkValidOSColor
    call ti.GetColorValue
    push de
    ld ix, var2
    jr .drawVertLine

.sixArgs:
    or a, a
    sbc hl, hl
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    push hl
    ld ix, var3

.drawVertLine: ; x, y, l : 0, +3, +6
    ld hl, (ix + 6)
    ld a, h
    or a, l
    jp z, return
    ld de, (ix)
    ld hl, -ti.lcdWidth
    add hl, de
    jp c, return
    ld de, (ix + 3)
    ld hl, -ti.lcdHeight
    add hl, de
    jp c, return
    ld hl, (ix + 6)
    add hl, de
    ex de, hl
    ld hl, -ti.lcdHeight
    add hl, de
    jr nc, .startVertLine
    ex de, hl
    ld hl, (ix + 6)
    or a, a
    sbc hl, de
    ld (ix + 6), hl

.startVertLine:
    ld a, (ix + 3)
    call _vramAddrShiftScrn ; use this call to get the VRAM address
    ld a, (ix + 6)
    ld bc, ti.lcdWidth * 2
    pop de

.vertLineLoop:
    ld (hl), e
    inc hl
    ld (hl), d
    dec hl
    add hl, bc
    dec a
    jr nz, .vertLineLoop
    jp return
