;----------------------------------------
;
; Celtic CE Source Code - celtic2cse.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

readLine: ; det(0)
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .read
    dec hl
    ld (hl), $05

.read:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    push de
    jr z, .inRAM
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push hl ; size of var
    push de ; beginning of data
    call ti.RclAns
    ld a, (ti.OP1)
    or a, a
    jp nz, PrgmErr.NTREAL
    call ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jp z, .getNumOfLines
    ld hl, 1
    or a, a
    sbc hl, de
    jr z, .readLineOne
    pop de
    pop hl
    call _getEOF
    push de
    pop bc
    ld de, 1
    ld ix, PrgmErr.LNTFN
    call _searchLine
    ld de, 0
    push bc
    pop hl
    call _getNextLine
    dec de
    inc hl

.createDataStr:
    push hl ; start of data
    push de ; bytes to read
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    pop hl
    pop ix
    push de ; start of string
    push hl ; start address to read from
    push ix ; start address of variable
    push bc
    call ti.OP6ToOP1
    call ti.ChkFindSym
    pop bc
    pop hl
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    or a, a
    sbc hl, de
    pop de
    push hl
    ld hl, 1
    or a, a
    sbc hl, bc
    jr nc, .readOneOrZero
    pop hl
    ldir
    jp return

.readLineOne:
    pop de
    pop hl
    call _getEOF
    push de
    pop bc
    ld de, 0
    or a, a
    sbc hl, de
    jp z, PrgmErr.NULLSTR
    push bc
    pop hl
    call _getNextLine
    ld a, (hl)
    cp a, $3F
    jr nz, .createDataStr

.decrementLen:
    dec de
    jr .createDataStr

.readOneOrZero:
    ld hl, 0
    or a, a
    sbc hl, bc
    pop hl
    jp z, PrgmErr.NULLSTR
    ldi
    jp return

.getNumOfLines:
    pop bc
    pop hl
    push bc
    pop de
    call _getEOF
    ld de, 1 ; line counter

.loopFindLines:
    ld ix, _decBCretZ
    call _checkEOF ; returns z if hit EOF
    jr z, .foundLines
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .oneByteTok
    inc bc

.oneByteTok:
    cp a, $3F
    jr nz, .skipIncLine
    inc de

.skipIncLine:
    inc bc
    jr .loopFindLines

.foundLines:
    push de
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
    pop hl
    jp PrgmErr.NUMSTNG

replaceLine: ; det(1)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    set replaceLineRun, (iy + ti.asm_Flag2)
    jp deleteLine

insertLine: ; det(2)
    res insertLastLine, (iy + ti.asm_Flag2)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push hl ; size of string
    push de ; start of string
    inc hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .continueInsert
    dec hl
    ld (hl), $05

.continueInsert:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    call _getEOF
    push de ; start of program
    call ti.RclAns
    ld a, (ti.OP1)
    or a, a
    jp nz, PrgmErr.NTREAL
    call ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jp z, PrgmErr.LNTFN
    pop bc
    push bc
    ld hl, 1
    or a, a
    sbc hl, de
    jr z, .insertMem
    ld de, 1
    ld ix, _decBCretNZ
    call _searchLine
    call nz, .hitEOF
    inc bc

.insertMem:
    pop ix
    pop de
    pop hl
    push hl ; size of string
    push de ; start of string
    push bc
    pop de
    push de ; location of line
    push ix ; start of program
    inc hl
    push hl
    call ti.InsertMem
    pop de
    pop hl
    dec hl
    dec hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    add hl, bc
    ex de, hl
    dec hl
    ld (hl), e
    inc hl
    ld (hl), d
    pop de
    pop hl
    push de
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ex de, hl
    inc hl
    inc hl
    pop de
    pop bc
    push hl
    bit insertLastLine, (iy + ti.asm_Flag2)
    jr nz, .insertLineBtm
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByte
    pop hl
    ldir
    ld a, $3F
    ld (de), a
    jp return

.insertOneByte:
    pop hl
    ldi
    ld a, $3F
    ld (de), a
    jp return

.insertLineBtm:
    ld a, $3F
    ld (de), a
    inc de
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByteBtm
    pop hl
    ldir
    jp return

.insertOneByteBtm:
    pop hl
    ldi
    jp return

.hitEOF:
    set insertLastLine, (iy + ti.asm_Flag2)
    inc de
    dec bc
    ld hl, (ans)
    or a, a
    sbc hl, de
    ret z
    pop hl
    jp PrgmErr.LNTFN

specialChars: ; det(3)
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    ld hl, 9
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    ld (hl), $04
    inc hl
    ld (hl), $2A
    jp return

createVar: ; det(4)
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .createAppvar
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 0
    call ti.CreateProg
    jp return

.createAppvar:
    ld a, (noArgs)
    dec a
    jr z, .createNormal
    ld a, (var1)
    or a, a
    jr z, .createNormal
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 5
    call ti.CreateAppVar
    inc de
    inc de
    ex de, hl
    ld (hl), $3E
    inc hl
    ld (hl), $43
    inc hl
    ld (hl), $45
    inc hl
    ld (hl), $4C
    inc hl
    ld (hl), $3F
    jp return

.createNormal:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 0
    call ti.CreateAppVar
    jp return

arcUnarcVar: ; det(5)
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .arcUnarc
    dec hl
    ld (hl), $05

.arcUnarc:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.Arc_Unarc
    jp return

deleteVar: ; det(6)
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .delVar
    dec hl
    ld (hl), $05

.delVar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.DelVarArc
    jp return

deleteLine: ; det(7)
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .remove
    dec hl
    ld (hl), $05

.remove:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    push de
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    pop de
    call _getEOF.deleteLine
    push de
    push hl
    inc de
    push de
    call ti.RclAns
    ld a, (ti.OP1)
    or a, a
    jp nz, PrgmErr.NTREAL
    call ConvOP1
    ld (ans), de
    or a, a
    ld hl, 0
    sbc hl, de
    jp z, PrgmErr.LNTFN
    or a, a
    ld hl, 1
    sbc hl, de
    jr z, .delLineOne
    pop bc
    ld de, 1
    ld ix, PrgmErr.LNTFN
    call _searchLine
    ld de, 0
    push bc
    pop hl
    call _getNextLine

.delete:
    push de
    call ti.DelMem
    pop de
    pop hl
    or a, a
    sbc hl, de
    pop ix
    ld (ix), l
    inc ix
    ld (ix), h
    bit replaceLineRun, (iy + ti.asm_Flag2)
    jp nz, insertLine
    jp return

.delLineOne:
    pop bc
    ld de, 0
    push bc
    pop hl
    call _getNextLine
    call z, _decDEretZ
    jr .delete

varStatus: ; det(8)
    xor a, a
    ld (prgmName), a
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .getStatus
    dec hl
    ld (hl), $05

.getStatus:
    res archived, (iy + ti.asm_Flag2)
    res hidden, (iy + ti.asm_Flag2)
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    ; in case someone checked with a name that would be hidden
    ld a, (ti.OP1 + 1)
    cp a, $41
    jr nc, .notHidden
    set hidden, (iy + ti.asm_Flag2)

.notHidden:
    push de
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    ld hl, 9
    call ti.CreateStrng
    inc de
    inc de
    push de
    ex de, hl
    ld bc, 9
    ld a, $30
    call ti.MemSet
    pop de
    pop bc
    push de
    push bc
    ex de, hl
    ld (hl), $52
    inc hl
    ld (hl), $56
    inc hl
    ld (hl), $4C
    pop de
    call ti.ChkInRam
    pop hl
    call nz, .archived
    inc hl
    bit hidden, (iy + ti.asm_Flag2)
    call nz, .hidden
    push hl
    ld hl, prgmName
    ld a, (hl)
    cp a, $05
    jr z, .notAppvar
    inc hl

.notAppvar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ld a, (hl)
    pop hl
    inc hl
    cp a, $05
    call z, .unlocked
    inc hl
    ld (hl), $29
    inc hl
    push hl
    bit archived, (iy + ti.asm_Flag2)
    call nz, .isArchived
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    ld a, 6
    call ti.FormEReal
    ld hl, ti.OP3
    call ti.StrLength
    ld a, c
    cp a, 1
    jr z, .lengthOne
    push bc
    pop de
    ld hl, 5
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3
    call ti.StrLength
    ldir
    jp return

.archived:
    set archived, (iy + ti.asm_Flag2)
    ld (hl), $41
    ret

.hidden:
    ld (hl), $48
    ret

.unlocked:
    ld (hl), $57
    ret

.lengthOne:
    pop hl
    ld de, 4
    add hl, de
    ex de, hl
    ld hl, ti.OP3
    ld a, (hl)
    ex de, hl
    ld (hl), a
    jp return

.isArchived:
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl
    ret

bufSprite: ; det(9)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld de, 0
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    push de
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
    res ti.graphDraw, (iy + ti.graphFlags)
    res ti.plotLoc, (iy + ti.plotFlags)
    ld hl, (var2)
    ld (bufSpriteX), hl
    ld (bufSpriteXStart), hl
    ld a, (var3)
    ld c, a
    ld a, 164
    sub a, c
    ld (bufSpriteY), a
    ld bc, 1
    ld (currentWidth), bc
    ld bc, (var1)
    ld hl, 0
    or a, a
    sbc hl, bc
    jp z, PrgmErr.INVALA
    pop hl
    pop de
    ld ix, 1

.loopSprite: ;  hl = size of string; de = address of string; ix = width counter
    ld a, (de)
    call _convertTokenToColor
    or a, a
    jr z, .checkLoop
    cp a, $11
    jr z, .restoreColor
    cp a, $10
    jr z, .isG
    push hl
    push de
    push af
    call _getGrphColor
    ex af, af'
    pop af
    pop de
    push af
    ex af, af'
    call _storeColorToStr9
    pop af
    push de
    call ti.GetColorValue
    call ti.SetDEUToA
    ld.sis (ti.drawFGColor and $FFFF), de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 1
    call ti.IPoint
    pop de
    pop hl

.checkLoop:
    push hl
    push ix
    pop hl
    ld bc, (var1)
    or a, a
    sbc hl, bc
    call z, _moveDown

.checkLoopTwo:
    pop bc
    ld hl, (currentWidth)
    or a, a
    sbc hl, bc
    jp z, return
    push bc
    pop hl
    ld bc, (currentWidth)
    inc bc
    ld (currentWidth), bc
    ld bc, (bufSpriteX)
    inc bc
    ld (bufSpriteX), bc
    inc de
    inc ix
    jr .loopSprite

.isG:
    push hl
    call _moveDown
    jr .checkLoopTwo

.restoreColor:
    push hl
    push de
    call _getGrphColor
    pop de
    call _storeColorToStr9
    push de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    xor a, a
    call ti.IPoint
    ld a, 4
    call ti.IPoint
    pop de
    pop hl
    jr .checkLoop

bufSpriteSelect: ; det(10)
    ld a, (noArgs)
    cp a, 6
    jp c, PrgmErr.INVALA
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    inc hl
    inc hl
    ld de, (var4)
    add hl, de
    push hl
    ld de, (var5)
    push de
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
    res ti.graphDraw, (iy + ti.graphFlags)
    res ti.plotLoc, (iy + ti.plotFlags)
    ld hl, (var2)
    ld (bufSpriteX), hl
    ld (bufSpriteXStart), hl
    ld a, (var3)
    ld c, a
    ld a, 164
    sub a, c
    ld (bufSpriteY), a
    ld bc, 1
    ld (currentWidth), bc
    ld bc, (var1)
    ld hl, 0
    or a, a
    sbc hl, bc
    jp z, PrgmErr.INVALA
    pop hl
    pop de
    ld ix, 1

.loopSprite: ; hl = size; de = address of string; ix = width counter
    ld a, (de)
    call _convertTokenToColor
    or a, a
    jr z, .checkLoop
    cp a, $11
    jr z, .restoreColor
    cp a, $10
    jr z, .isG
    push hl
    push de
    call ti.GetColorValue
    call ti.SetDEUToA
    ld.sis (ti.drawFGColor and $FFFF), de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 1
    call ti.IPoint
    pop de
    pop hl

.checkLoop:
    push hl
    push ix
    pop hl
    ld bc, (var1)
    or a, a
    sbc hl, bc
    call z, _moveDown

.checkLoopTwo:
    pop bc
    ld hl, (currentWidth)
    or a, a
    sbc hl, bc
    jp z, return
    push bc
    pop hl
    ld bc, (currentWidth)
    inc bc
    ld (currentWidth), bc
    ld bc, (bufSpriteX)
    inc bc
    ld (bufSpriteX), bc
    inc de
    inc ix
    jr .loopSprite

.isG:
    push hl
    call _moveDown
    jr .checkLoopTwo

.restoreColor:
    push hl
    push de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    xor a, a
    call ti.IPoint
    ld a, 4
    call ti.IPoint
    pop de
    pop hl
    jr .checkLoop

execArcPrgm: ; det(11)
    ld hl, tempPrgmName
    ld de, xtempName
    ld bc, 10
    ldir
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    cp a, 3
    jr z, .normalFunc
    ld a, (var1)
    cp a, 2
    jp nz, PrgmErr.INVALA

.deletePrgms:
    ld bc, $1030
    ld hl, xtempName
    push hl

.loopDelete:
    pop hl
    push hl
    push bc
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop bc
    ld hl, tempNameNum + 1
    inc c
    ld a, $3A
    cp a, c
    jr nz, .not10
    dec hl
    ld a, '1'
    ld (hl), a
    ld a, c
    sub a, 10
    ld c, a
    inc hl

.not10:
    ld a, c
    ld (hl), a
    djnz .loopDelete
    pop hl
    jp return

.normalFunc:
    ld a, (var1)
    cp a, 2
    jr z, .deletePrgms
    cp a, 3
    jp nc, PrgmErr.INVALA
    ld a, (var2)
    cp a, 16
    jp nc, PrgmErr.INVALA
    ld b, a
    ld hl, tempNameNum
    cp a, 10
    jr c, .lessThan10
    ld a, '1'
    ld (hl), a
    ld a, b
    sub a, 10
    ld b, a

.lessThan10:
    inc hl
    ld a, '0'
    add a, b
    ld (hl), a
    ld hl, xtempName
    call ti.Mov9ToOP1
    ld a, (var1)
    cp a, 1
    jr nz, .createTempPrgm
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    jp return

.createTempPrgm:
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .getData
    dec hl
    ld (hl), $05

.getData:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRAM
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl ; size of program
    call ti.EnoughMem
    pop hl
    jp c, PrgmErr.NOMEM
    push hl
    ld hl, xtempName
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateProtProg
    inc de
    inc de
    push de
    call ti.OP6ToOP1
    call ti.ChkFindSym
    call ti.ChkInRam
    jr z, .inRam2
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam2:
    inc de
    inc de
    pop hl
    pop bc
    push hl
    ld hl, 1
    or a, a
    sbc hl, bc
    jr nc, .zeroOrOneByte
    pop hl
    ex de, hl
    ldir
    jp return

.zeroOrOneByte:
    ld hl, 0
    or a, a
    sbc hl, bc
    pop hl
    jp z, return
    ex de, hl
    ldi
    jp return

dispColor: ; det(12)
    ld a, (noArgs)
    cp a, 5
    jr z, .fiveArgs
    cp a, 2
    jr z, .twoArgs
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld a, (var2)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    push de
    call ti.GetColorValue
    pop hl
    call ti.SetTextFGBGcolors_
    set ti.textEraseBelow, (iy + ti.textFlags)
    jp return

.fiveArgs:
    ld hl, 0
    ld de, 0
    ld a, (var1) ; low byte color
    ld l, a
    ld a, (var2) ; high byte of color
    ld h, a
    ; repeat process
    ld a, (var3)
    ld e, a
    ld a, (var4)
    ld d, a
    call ti.SetTextFGBGcolors_
    set ti.textEraseBelow, (iy + ti.textFlags)
    jp return

.twoArgs:
    ; see if the program wants to disable text color
    ld hl, (var1)
    ld de, 300
    or a, a
    sbc hl, de
    jp nz, return
    res ti.putMapUseColor, (iy + ti.putMapFlags)
    jp return
