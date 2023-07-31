;----------------------------------------
;
; Celtic CE Source Code - utils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 31, 2023
;
;----------------------------------------

_getProgFromStr: ; finds a variable with the name in a string
    call _findString
    ld a, (de)
    inc de
    inc de
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, ti.AppVarObj
    jr z, .getPtr
    dec hl
    ld (hl), ti.ProgObj

.getPtr:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN

_checkSysVar: ; checks if a user is trying to mess with one of the system programs
    push hl
    push de
    push bc
    ld hl, ti.OP1
    push hl
    ld de, sysVarEP
    push de
    ld b, 3
    call ti.StrCmpre
    jr z, return
    pop hl
    inc hl
    inc hl
    inc hl
    ex de, hl
    pop hl
    ld b, 3
    call ti.StrCmpre
    pop bc
    pop de
    pop hl
    ret nz

return: ; all args are popped off and the OS continues parsing
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
    cp a, ti.tEnter
    jr nz, _searchLine
    inc de
    ld hl, (ans)
    or a, a
    sbc hl, de
    jr nz, _searchLine

_decBCretZ:
    dec bc
    cp a, a
    ret

_checkEOF: ; bc = current address being read; ix = where to jump back to; destroys hl
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

.deleteLine: ; alter it slightly for DeleteLine command (I don't know why, but it works)
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
    cp a, ti.tEnter
    jr nz, _getNextLine
    or a, 1 ; return nz
    ret

_checkHidden: ; see if a variable is hidden and return data pointer (sets hidden flag)
    ld hl, prgmName + 1
    ld a, (ti.OP1)
    cp a, ti.AppVarObj
    jr nz, .check
    inc hl

.check:
    ld a, (hl)
    sub a, 64
    ld (hl), a
    dec hl
    res hidden, (iy + celticFlags2)
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ret c
    set hidden, (iy + celticFlags2)
    ret

_moveDown: ; move down a row when drawing BufSprites
    ld a, (bufSpriteY)
    dec a
    ld (bufSpriteY), a
    ld bc, (bufSpriteXStart)
    dec bc
    ld (bufSpriteX), bc
    ld ix, 0
    ret

_convertTokenToColor: ; convert a token to an OS color number. 0 - 9, A - H
    cp a, $30
    jr c, .invalidColor
    cp a, $49
    jr nc, .invalidColor
    sub a, $30
    cp a, $0A
    ret c
    cp a, $11
    jr c, .invalidColor
    sub a, $07
    ret

.invalidColor:
    jp PrgmErr.INVALS

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
    cp a, ti.AppVarObj
    jr z, .appvar
    cp a, ti.GroupObj
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

.dispText: ; a = token value. convert chars for DispText command and similar ones
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
    jr c, .invalidHex
    cp a, $47
    jr nc, .invalidHex
    cp a, $3A
    ret c
    cp a, $40
    ret nc

.invalidHex:
    jp PrgmErr.INVALS

_convertTokenToHex: ; a = token. token being either 0 - 9 or A - F
    sub a, $30
    cp a, 10
    ret c
    sub a, 7
    ret

_setArchivedFlag:
    set archived, (iy + celticFlags2)
    call ti.Arc_Unarc
    call ti.OP6ToOP1
    call ti.ChkFindSym
    ret

_findNthItem: ; item number to find in ixl. finds the nth item out of programs and appvars in a group
    ld a, (de)
    cp a, ti.ProgObj
    jr z, .isCounted
    cp a, ti.ProtProgObj
    jr z, .isCounted
    cp a, ti.AppVarObj
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
    ld l, 3
    ld h, a
    mlt hl
    ld bc, .itemTypes
    add hl, bc
    ld hl, (hl)
    jp (hl)

.next:
    ex de, hl
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
    ret

.list:
    ld a, (de)
    or a, a
    sbc hl, hl
    ld l, a
    inc l
    add hl, de ; skip name
    ex de, hl
    or a, a
    sbc hl, hl
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
    ret

.matrix:
    inc de
    inc de
    inc de
    or a, a
    sbc hl, hl
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
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a 
    inc de
    ld a, (de)
    ld h, a
    inc de
    add hl, de
    ret

.program:
.appvar:
    or a, a
    sbc hl, hl
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
    ret

.complex:
    ld hl, 21
    add hl, de
    ret

.complexList:
    ld a, (de)
    or a, a
    sbc hl, hl
    ld l, a
    inc l
    add hl, de ; skip name
    ex de, hl
    or a, a
    sbc hl, hl
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
    dl return
    dl return
    dl return
    dl .complex
    dl .complexList
    dl return
    dl .window
    dl .zsto
    dl .tableRange
    dl return
    dl return
    dl return
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

_vramAddrShiftScrn:
    ld l, a
    ld h, ti.lcdWidth / 2
    mlt hl
    add hl, hl
    ld de, (ix)
    add hl, de
    add hl, hl
    ld de, ti.vRam
    add hl, de
    ret

_correctCoords: ; for when using os.FontDrawTransText
    pop de
    pop bc
    ex (sp), hl
    dec hl
    dec hl
    ex (sp), hl
    push bc
    push de
    ret

_getDataPtr: ; corrects data pointer if not in RAM
    call ti.ChkInRam
    ret z
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl
    ret

_findString: ; gets data pointer to a string
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ret

_checkValidOSColor: ; checks if a valid OS color was entered and returns the RGB565 color value
    cp a, 10
    jp c, PrgmErr.INVALA
    cp a, 25
    jp nc, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ret

_storeThetaA:
    push af
    ld hl, Theta
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    call ti.CreateReal
    pop af
    push de
    call ti.SetxxOP1
    pop de
    ld hl, ti.OP1
    ld bc, 9
    ldir
    ret

_storeThetaHL:
    push hl
    ld hl, Theta
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    call ti.CreateReal
    pop hl
    push de
    call ti.SetxxxxOP2
    pop de
    ld hl, ti.OP2
    ld bc, 9
    ldir
    ret
