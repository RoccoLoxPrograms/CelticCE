;----------------------------------------
;
; Celtic CE Source Code - xLIBCE/utils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: September 9, 2026
;
;----------------------------------------

_spiParam: ; spi code by jacobly
    scf
    virtual
        jr nc, $
        load .jr_nc : byte from $$
    end virtual
    db .jr_nc

_spiCmd:
    or a, a
    ld hl, ti.mpSpiData or spiValid shl 8
    ld b, 3

.loop:
    rla
    rla
    rla
    ld (hl), a
    djnz .loop
    ld l, h
    ld (hl), 1

.wait:
    ld l, ti.spiStatus + 1

.wait1:
    ld a, (hl)
    and a, $F0
    jr nz, .wait1
    dec l

.wait2:
    bit 2, (hl)
    jr nz, .wait2
    ld l, h
    ld (hl), a
    ret

_setupSPI:
    ld hl, $2000B
    ld (ti.mpSpiRange + ti.spiCtrl1), hl
    ld hl, $1828
    ld (ti.mpSpiRange), hl
    ld hl, $0C
    ld (ti.mpSpiRange + ti.spiCtrl2), hl
    nop
    ld hl, $40
    ld (ti.mpSpiRange + ti.spiCtrl2), hl
    call ti.Delay10ms
    ld hl, $182B
    ld (ti.mpSpiRange), hl
    ld hl, $0C
    ld (ti.mpSpiRange + ti.spiCtrl2), hl
    nop
    ld hl, $40
    ld (ti.mpSpiRange + ti.spiCtrl2), hl
    call ti.Delay10ms
    ld hl, $21
    ld (ti.mpSpiRange + ti.spiIntCtrl), hl
    ld hl, $100
    ld (ti.mpSpiRange + ti.spiCtrl2), hl
    ret

_setHalfRes:
    call ti.RunIndicOff
    ld a, 1
    ld (halfresOn), a
    call _setupSPI
    call _resetShift
    spi $2A, 0, 0, 1, $40
    spi $2B, 0, 0, 0, 239
    spi $3A, $56
    spi $33, 0, 160, 0, 160, 0, 0
    spi $37, 0, 0
    spi $E4, $27, 0, $14
    ret

_setNormalRes:
    xor a, a
    ld (halfresOn), a
    call _setupSPI
    call _resetShift
    spi $2A, 0, 0, 1, $40
    spi $2B, 0, 0, 0, 239
    spi $3A, $66
    spi $33, 0, 0, 1, $40, 0, 0
    spi $37, 0, 0
    spi $E4, $27, 0, $10
    ret

_showRightBuffer:
    ld a, (halfresOn)
    dec a
    ret nz
    ; call _setupSPI
    spi $33, 0, 0, 0, 160, 0, 160
    spi $37, 1, $40
    ret

_showLeftBuffer:
    ld a, (halfresOn)
    dec a
    ret nz
    ; call _setupSPI
    spi $33, 0, 160, 0, 160, 0, 0
    spi $37, 0, 0
    ret

_resetShift:
    spi $B0, $11, $F0
    ret

_getVRAMaddrStart:
    ld a, (currentGram)
    ld hl, ti.vRam
    or a, a
    ret z
    ld hl, vBuffer
    ret

_flipActiveDraw:
    ld a, (halfresOn)
    dec a
    ret nz
    call _resetShift
    ld a, (currentGram)
    xor a, 1
    ld (currentGram), a
    jp z, _showRightBuffer
    jp _showLeftBuffer

_convertArg:
    call ti.Mov9ToOP1
    jp ConvOP1

_getXlibcVRAMaddr:
    ; a = y
    ; de = x
    add a, a
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    add hl, de
    add hl, hl
    ex de, hl
    call _getVRAMaddrStart
    add hl, de
    ret

_setPixelxlibc: ; x = ix - 12, y = ix - 15, color = ix + 9
    ld hl, (ix - 15)
    ld bc, -ti.lcdHeight / 2
    add hl, bc
    ret c
    ld hl, (ix - 12)
    ld bc, -ti.lcdWidth / 2
    add hl, bc
    ret c
    ld de, (ix - 12)
    ld a, (ix - 15)
    call _getXlibcVRAMaddr
    ld bc, ti.lcdWidth * 2
    bit invertPixel, (iy + celticFlags2)
    jr nz, .invert
    ld a, (ix + 9)
    ld (hl), a
    add hl, bc
    ld (hl), a
    inc hl
    ld (hl), a
    sbc hl, bc
    ld (hl), a
    ret

.invert:
    ld a, (hl)
    cpl
    ld (hl), a
    add hl, bc
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    ld a, (hl)
    cpl
    ld (hl), a
    or a, a
    sbc hl, bc
    ld a, (hl)
    cpl
    ld (hl), a
    ret

_clipXlibcRect: ; x = xlibcInt2, y = xlibcInt3, width = xlibcInt4, height = xlibcInt5
    or a, a
    sbc hl, hl
    ld ix, xlibcInt2
    bit 7, (ix + 2)
    jr z, .clipY
    ld a, (xlibcInt2)
    ld (xlibcInt2), hl
    ld a, (xlibcInt4)
    or a, a
    ret z
    push hl
    ld l, a
    pop de
    push de
    ld e, a
    add hl, de
    ld (xlibcInt4), hl
    pop hl

.clipY:
    bit 7, (ix + 5)
    jr z, .clipWidth
    ld de, (xlibcInt3)
    ld (xlibcInt3), hl
    ld a, (xlibcInt5)
    or a, a
    ret z
    ld l, a
    add hl, de
    ld (xlibcInt5), hl

.clipWidth:
    ex de, hl
    ld hl, (xlibcInt2)
    ld a, (xlibcInt4)
    ld e, a
    ld bc, -ti.lcdWidth / 2
    add hl, bc
    jr c, .return
    add hl, de
    jr nc, .clipHeight
    sub a, l

.clipHeight:
    ld c, a
    ld a, (xlibcInt5)
    ld e, a
    push bc
    ld hl, (xlibcInt3)
    ld bc, -ti.lcdHeight / 2
    add hl, bc
    pop bc
    jr c, .return
    add hl, de
    jr nc, .clipDone
    sub a, l

.clipDone:
    add a, a
    ld b, a
    ld de, (xlibcInt2)
    ld a, (xlibcInt3)
    push bc
    call _getXlibcVRAMaddr
    pop bc
    or a, 1
    ret ; width = c, height = b, vram = hl

.return:
    xor a, a
    ret

_drawXlibcHorizLine: ; x = de, y = a, width = bc, color = l
    ld h, a
    ld a, b
    or a, c
    ret z
    ld a, h
    push hl
    call _getXlibcVRAMaddr
    pop de
    bit invertPixel, (iy + celticFlags2)
    jr nz, .invert
    ld (hl), e
    inc hl
    ld (hl), e
    dec bc
    ld a, b
    or a, c
    ret z
    push hl
    push hl
    push bc
    pop hl
    add hl, hl
    push hl
    pop bc
    pop de
    pop hl
    inc de
    push hl
    push bc
    ldir
    pop bc
    pop hl
    ld a, (hl)
    ld de, ti.lcdWidth * 2
    add hl, de
    ex de, hl
    push de
    pop hl
    inc de
    dec hl
    ld (hl), a
    inc hl
    ld (hl), a
    ldir
    ret

.invert:
    dec bc
    dec bc
    inc hl
    inc hl
    push hl
    push hl
    push bc

.loopInvert:
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    dec bc
    ld a, b
    or a, c
    jr nz, .loopInvert
    pop hl
    add hl, hl
    push hl
    pop bc
    pop hl
    ld de, ti.lcdWidth * 2
    add hl, de
    pop de
    ex de, hl
    ldir
    ret

_drawXlibcVertLine: ; x = de, y = a, height = c, color = l
    bit 7, a
    jr z, .clipNext
    add a, c
    ld c, a
    xor a, a

.clipNext:
    push af
    add a, c
    sub a, ti.lcdHeight / 2
    jr c, .clipDone
    ld b, a
    ld a, c
    sub a, b
    ld c, a

.clipDone:
    pop af
    ld b, c
    push bc
    push hl
    call _getXlibcVRAMaddr
    pop de
    pop af
    ld bc, ti.lcdWidth * 2
    add a, a
    bit invertPixel, (iy + celticFlags2)
    jr nz, .invert

.loop:
    ld (hl), e
    inc hl
    ld (hl), e
    dec hl
    add hl, bc
    dec a
    jr nz, .loop
    ret

.invert:
    ld e, a

.loopInvert:
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    ld a, (hl)
    cpl
    ld (hl), a
    dec hl
    add hl, bc
    dec e
    jr nz, .loopInvert
    ret
