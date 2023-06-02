;----------------------------------------
;
; Celtic CE Source Code - utils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

FillScreen:
    ld a, l
    ld b, h
    ld hl, ti.vRam
    ld (hl), a
    inc hl
    ld (hl), b
    ld bc, ((ti.lcdWidth * ti.lcdHeight) * 2) - 2
    push hl
    pop de
    inc de
    dec hl
    ldir
    ret

waitAnyKey:
    call ti.GetCSC
    or a, a
    jr z, waitAnyKey
    ret

returnOS: ; return and let the OS handle the function
    ei
    cp a, a
    ret

return:
    call ti.RclAns
    ld sp, (stackPtr)
    ei
    or a, 1
    ret

_decBCretNZ:
    pop hl
    dec bc
    or a, 1
    ret

_getProgNameLen:
    ld a, (de)
    inc de
    inc de
    ret

_searchLine: ; bc = address being read; de = line counter; ix = where to jump at EOF; hl is destroyed
    call _checkEOF
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .not2byte
    inc bc
    inc bc
    jr _searchLine

.not2byte:
    inc bc
    cp a, $3F
    jr nz, _searchLine
    inc de
    ld hl, (ans)
    or a, a
    sbc hl, de
    jr z, _decBCretZ
    jr _searchLine

_decBCretZ:
    dec bc
    cp a, a
    ret

_decDEretZ:
    dec de
    cp a, a
    ret

_checkEOF: ; bc = current address being read; ix = where to jump back to; destroys hl and a
    ld hl, (EOF)
    inc hl
    or a, a
    sbc hl, bc
    ret nc
    jp (ix)

_getEOF: ; args: hl = size of var; de = start of variable; preserves both registers
    push hl
    dec hl
    add hl, de
    ld (EOF), hl
    pop hl
    ret

.deleteLine:
    push hl
    inc hl
    add hl, de
    ld (EOF), hl
    pop hl
    ret

_getNextLine: ; bc = address being read; de = byte counter; preserves hl (starting address)
    inc bc
    inc de
    ld ix, _decBCretZ
    push hl
    call _checkEOF
    pop hl
    ret z
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .not2byteTok
    inc bc
    inc de
    jr _getNextLine

.not2byteTok:
    cp a, $3F
    jr nz, _getNextLine
    or a, 1 ; return nz
    ret

_checkHidden:
    ld hl, prgmName + 1
    ld a, (ti.OP1)
    cp a, $15
    jr nz, .check
    inc hl

.check:
    ld a, (hl)
    sub a, 64
    ld (hl), a
    dec hl
    res hidden, (iy + ti.asm_Flag2)
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ret c
    set hidden, (iy + ti.asm_Flag2)
    ret

_moveDown:
    ld a, (bufSpriteY)
    dec a
    ld (bufSpriteY), a
    ld bc, (bufSpriteXStart)
    dec bc
    ld (bufSpriteX), bc
    ld ix, 0
    ret

_convertTokenToColor:
    cp a, $30
    jr nc, .checkTwo
    jp PrgmErr.INVALA

.checkTwo:
    cp a, $49
    jr c, .continue
    jp PrgmErr.INVALA

.continue:
    sub a, $30
    cp a, $0A
    ret c
    cp a, $11
    jr nc, .subA
    jp PrgmErr.INVALA

.subA:
    sub a, $07
    ret

_getGrphColor:
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 3
    call ti.IPoint
    ret

_storeColorToStr9:
    add a, $30
    cp a, $3A
    jr c, .skipAdd
    add a, 7

.skipAdd:
    cp a, $30
    jr z, .isH
    ld (de), a
    ret

.isH:
    ld a, $48
    ld (de), a
    ret

_convertChars:
.varName: ; a = size of string; hl = location of string
    ld b, a
    ld de, prgmName + 1
    ld c, 8
    ld a, (hl)
    cp a, $15
    jr z, .appvar
    cp a, $17
    jr nz, .loop

.appvar:
    ld (de), a
    inc hl
    inc de
    dec b

.loop:
    ld a, (hl)
    call ti.Isa2ByteTok
    call z, .lowercase
    ld (de), a
    inc de
    inc hl
    dec c
    jr z, .endLoop
    djnz .loop

.endLoop:
    ex de, hl
    ld (hl), 0
    ret

.lowercase:
    inc hl
    ld a, (hl)
    cp a, $CB
    ret nc
    cp a, $B0
    ret c
    cp a, $BB
    jr c, .skipDec
    dec a

.skipDec:
    sub a, $4F
    dec b
    ret

.dispText: ; a = token value
    push de
    push bc
    push hl
    push af
    call ti.Get_Tok_Strng
    pop af
    pop hl
    ld e, c
    pop bc
    call ti.Isa2ByteTok
    jr nz, .dispText2
    inc hl
    dec bc

.dispText2:
    ld a, e
    pop de
    push bc
    push hl
    ld b, a
    ld hl, ti.OP3

.loopDispText:
    ld a, (hl)
    ld (de), a
    inc de
    inc hl
    djnz .loopDispText
    pop hl
    pop bc
    ret

_checkValidHex:
    cp a, $30
    jr nc, .checkTwo
    jp PrgmErr.INVALS

.checkTwo:
    cp a, $47
    jr c, .continue
    jp PrgmErr.INVALS

.continue:
    cp a, $3A
    ret c
    cp a, $40
    ret nc
    jp PrgmErr.INVALS

_convertTokenToHex: ; a = token
    sub a, $30
    cp a, 10
    ret c
    sub a, 7
    ret

_setArchivedFlag:
    set archived, (iy + ti.asm_Flag2)
    call ti.Arc_Unarc
    call ti.OP6ToOP1
    call ti.ChkFindSym
    ret

_re_archive:
    call ti.OP6ToOP1
    call ti.Arc_Unarc
    ret

_findNthItem: ; item number to find in ixl
    ld a, (de)
    cp a, $05
    jr z, .isCounted
    cp a, $06
    jr z, .isCounted
    cp a, $15
    jr nz, .skip ; only count programs and appvars

.isCounted:
    dec ixl
    jr nz, .skip
    or a, 1
    ret

.skip:
    ld hl, .next
    push hl
    ld hl, 6
    add hl, de
    ex de, hl
    ld hl, 3
    ld h, a
    mlt hl
    ld bc, .itemTypes
    add hl, bc
    ld hl, (hl)
    jp (hl)

.next:
    push de
    pop bc
    push ix
    ld ix, _decBCretZ
    call _checkEOF
    pop ix
    ret z
    jr _findNthItem

.real:
    ld hl, 12
    add hl, de
    ex de, hl

.ret: ; use this for things that aren't listed
    ret

.list:
    ld a, (de)
    ld hl, 0
    ld l, a
    inc l
    add hl, de ; skip name
    ex de, hl
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push de
    push hl
    pop de
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de ; multiply by nine
    pop de
    add hl, de
    ex de, hl
    ret

.matrix:
    inc de
    inc de
    inc de
    ld hl, 0
    ld a, (de)
    ld h, a
    inc de
    ld a, (de)
    ld l, a
    mlt hl
    inc de
    push de
    push hl
    pop de
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de ; multiply by nine
    pop de
    add hl, de
    ex de, hl
    ret

.equation:
.string:
.picture:
.gdb:
.window:
.zsto:
.tableRange:
    inc de
    inc de
    inc de
    ld hl, 0
    ld a, (de)
    ld l, a 
    inc de
    ld a, (de)
    ld h, a
    inc de
    add hl, de
    ex de, hl
    ret

.program:
.appvar:
    ld hl, 0
    ld a, (de)
    ld l, a
    inc l
    add hl, de
    ld de, 0
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    add hl, de
    ex de, hl
    ret

.complex:
    ld hl, 21
    add hl, de
    ex de, hl
    ret

.complexList:
    ld a, (de)
    ld hl, 0
    ld l, a
    inc l
    add hl, de ; skip name
    ex de, hl
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push de
    add hl, hl
    push hl
    pop de
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de ; multiply by eighteen
    pop de
    add hl, de
    ex de, hl
    ret

.itemTypes:
    dl .real
    dl .list
    dl .matrix
    dl .equation
    dl .string
    dl .program
    dl .program
    dl .picture
    dl .gdb
    dl .ret
    dl .ret
    dl .ret
    dl .complex
    dl .complexList
    dl .ret
    dl .window
    dl .zsto
    dl .tableRange
    dl .ret
    dl .ret
    dl .ret
    dl .appvar

_byteToToken: ; returns in bc; b = first token, c = second token
    ld b, a
    and a, $0F
    add a, $30
    cp a, $3A
    jr c, .notLetter
    add a, 7

.notLetter:
    ld c, a
    ld a, b
    and a, $F0
    srl a
    srl a
    srl a
    srl a
    add a, $30
    cp a, $3A
    jr c, .notLetter2
    add a, 7

.notLetter2:
    ld b, a
    ret

_getVramAddr:
    ld l, (ix - 15)
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (ix - 12)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    ret

_correctCoords:
    pop de
    pop bc
    ex (sp), hl
    dec hl
    dec hl
    ex (sp), hl
    push bc
    push de
    ret
