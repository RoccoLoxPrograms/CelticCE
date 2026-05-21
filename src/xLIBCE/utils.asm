;----------------------------------------
;
; Celtic CE Source Code - xLIBCE/utils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: February 18, 2026
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
    xor a, a
    ld (xlibcFont), a
    ld (xlibColorOffset), a
    inc a ; start on right side
    ld (halfresOn), a
    ld (currentGram), a
    call _setupSPI
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
    spi $2A, 0, 0, 1, $40
    spi $2B, 0, 0, 0, 239
    spi $3A, $66
    spi $33, 0, 0, 1, $40, 0, 0
    spi $37, 0, 0
    spi $E4, $27, 0, $10
    ret

_showRightBuffer:
    ld a, (halfresOn)
    or a, a
    ret z
    call _setupSPI
    spi $33, 0, 0, 0, 160, 0, 160
    spi $37, 1, $40
    ret

_showLeftBuffer:
    ld a, (halfresOn)
    or a, a
    ret z
    call _setupSPI
    spi $33, 0, 160, 0, 160, 0, 0
    spi $37, 0, 0
    ret

_getVRAMaddrStart:
    ld a, (currentGram)
    ld hl, ti.vRam
    or a, a
    ret z
    ld hl, vBuffer
    ret

_flipActiveDraw:
    ld a, (currentGram)
    xor a, 1
    ld (currentGram), a
    jp z, _showRightBuffer
    jr _showLeftBuffer

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
    ld a, (ix - 15)
    ld b, -ti.lcdHeight / 2
    add a, b
    ret c
    ld a, (ix - 12)
    ld b, -ti.lcdWidth / 2
    add a, b
    ret c
    ld a, (ix - 12)
    ld de, (ix - 15)
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
