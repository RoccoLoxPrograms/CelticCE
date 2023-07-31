;----------------------------------------
;
; Celtic CE Source Code - celtic2cse.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 31, 2023
;
;----------------------------------------

readLine: ; det(0)
    ld hl, Str0
    call _getProgFromStr
    push de
    call _getDataPtr
    push de
    call ti.OP1ToOP6
    pop de
    or a, a
    sbc hl, hl
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
    ld a, d
    or a, e
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
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
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
    call c, _checkHidden
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

.return:
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
    cp a, ti.tEnter
    jr nz, .createDataStr

.decrementLen:
    dec de
    jr .createDataStr

.readOneOrZero:
    ld a, b
    or a, c
    pop hl
    jp z, PrgmErr.NULLSTR
    ldi
    jr .return

.getNumOfLines:
    pop bc
    pop hl
    push bc
    pop de
    call _getEOF
    ld de, 1 ; line counter
    ld ix, _decBCretZ

.loopFindLines:
    call _checkEOF ; returns z if hit EOF
    jr z, .foundLines
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .oneByteTok
    inc bc

.oneByteTok:
    cp a, ti.tEnter
    jr nz, .skipIncLine
    inc de

.skipIncLine:
    inc bc
    jr .loopFindLines

.foundLines:
    ex de, hl
    call _storeThetaHL
    jp PrgmErr.NUMSTNG

replaceLine: ; det(1)
    ld hl, Str9
    call _findString
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    set replaceLineRun, (iy + celticFlags2)
    jp deleteLine

insertLine: ; det(2)
    res insertLastLine, (iy + celticFlags2)
    ld hl, Str9
    call _findString
    or a, a
    sbc hl, hl
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
    call _getProgFromStr
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    or a, a
    sbc hl, hl
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
    ld a, d
    or a, e
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
    bit insertLastLine, (iy + celticFlags2)
    jr nz, .insertLineBtm
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByte
    pop hl
    ldir
    ld a, ti.tEnter
    ld (de), a

.return:
    jp return

.insertOneByte:
    pop hl
    ldi
    ld a, ti.tEnter
    ld (de), a
    jr .return

.insertLineBtm:
    ld a, ti.tEnter
    ld (de), a
    inc de
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByteBtm
    pop hl
    ldir
    jr .return

.insertOneByteBtm:
    pop hl
    ldi
    jr .return

.hitEOF:
    set insertLastLine, (iy + celticFlags2)
    inc de
    dec bc
    ld hl, (ans)
    or a, a
    sbc hl, de
    ret z
    jp PrgmErr.LNTFN

specialChars: ; det(3)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, 9
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    ld (hl), ti.tStore
    inc hl
    ld (hl), ti.tString ; quotation mark
    jp return

createVar: ; det(4)
    ld hl, Str0
    call _findString
    ld a, (de)
    inc de
    inc de
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, ti.AppVarObj
    jr z, .createAppvar
    dec hl
    ld (hl), ti.ProgObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    or a, a
    sbc hl, hl
    call ti.CreateProg
    jr .return

.createAppvar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld a, (noArgs)
    dec a
    jr z, .createNormal
    ld a, (var1)
    or a, a
    jr z, .createNormal
    ld hl, 5
    call ti.CreateAppVar
    inc de
    inc de
    ex de, hl
    ld (hl), ti.tColon ; :
    inc hl
    ld (hl), ti.tC ; C
    inc hl
    ld (hl), ti.tE ; E
    inc hl
    ld (hl), ti.tL ; L
    inc hl
    ld (hl), ti.tEnter ; newline

.return:
    jp return

.createNormal:
    or a, a
    sbc hl, hl
    call ti.CreateAppVar
    jr .return

arcUnarcVar: ; det(5)
    ld hl, Str0
    call _getProgFromStr
    call ti.Arc_Unarc
    jr deleteVar + 12 ; use as a return

deleteVar: ; det(6)
    ld hl, Str0
    call _getProgFromStr
    call ti.DelVarArc
    jp return

deleteLine: ; det(7)
    ld hl, Str0
    call _getProgFromStr
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    push de
    or a, a
    sbc hl, hl
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
    ld a, d
    or a, e
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
    ld (ix + 1), h
    bit replaceLineRun, (iy + celticFlags2)
    jp nz, insertLine
    jp return

.delLineOne:
    pop bc
    ld de, 0
    push bc
    pop hl
    call _getNextLine
    jr nz, .delete
    dec de
    jr .delete

varStatus: ; det(8)
    xor a, a
    ld (prgmName), a
    ld hl, Str0
    call _getProgFromStr
    res archived, (iy + celticFlags2)
    res hidden, (iy + celticFlags2)
    ; in case someone checked with a name that would be hidden
    ld a, (ti.OP1 + 1)
    cp a, ti.tA
    jr nc, .notHidden
    set hidden, (iy + celticFlags2)

.notHidden:
    push de
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, 9
    push hl
    call ti.CreateStrng
    pop bc
    inc de
    inc de
    push de
    ex de, hl
    ld a, ti.t0
    call ti.MemSet
    pop de
    pop bc
    push de
    push bc
    ex de, hl
    ld (hl), ti.tR
    inc hl
    ld (hl), ti.tV
    inc hl
    ld (hl), ti.tL
    pop de
    call ti.ChkInRam
    pop hl
    jr z, .inRam
    set archived, (iy + celticFlags2)
    ld (hl), ti.tA

.inRam:
    inc hl
    bit hidden, (iy + celticFlags2)
    jr z, $ + 4
    ld (hl), ti.tH
    push hl
    ld hl, prgmName
    ld a, (hl)
    cp a, ti.ProgObj
    jr z, .notAppvar
    inc hl

.notAppvar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ld a, (hl)
    pop hl
    inc hl
    cp a, ti.ProgObj
    jr nz, $ + 4
    ld (hl), ti.tW
    inc hl
    ld (hl), ti.tSpace
    inc hl
    push hl
    bit archived, (iy + celticFlags2)
    call nz, _getDataPtr + 5
    or a, a
    sbc hl, hl
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

.return:
    jp return

.lengthOne:
    pop hl
    ld de, 4
    add hl, de
    ex de, hl
    ld hl, ti.OP3
    ld a, (hl)
    ex de, hl
    ld (hl), a
    jr .return

bufSprite: ; det(9)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
    ld hl, Str9
    call _findString
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
    ld a, b
    or a, c
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
    ld (ti.drawFGColor), de
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
    call _findString
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
    ld a, b
    or a, c
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
    ld (ti.drawFGColor), de
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
    tempPrgmName.copy

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
    jr nc, $ + 8
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
    dec a
    jr nz, .createTempPrgm
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    jp return

.createTempPrgm:
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, ti.StrngObj
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    call _getProgFromStr + 4
    call _getDataPtr
    push de
    call ti.OP1ToOP6
    pop de
    or a, a
    sbc hl, hl
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
    call c, _checkHidden
    call _getDataPtr
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

.return:
    jp return

.zeroOrOneByte:
    ld a, b
    or a, c
    pop hl
    jr z, .return
    ex de, hl
    ldi
    jr .return

dispColor: ; det(12)
    ld a, (noArgs)
    cp a, 5
    jr z, .fiveArgs
    cp a, 2
    jr z, .twoArgs
    jp c, PrgmErr.INVALA
    ld a, (var1)
    call _checkValidOSColor
    push de
    ld a, (var2)
    call _checkValidOSColor
    pop hl
    jr .setColors

.fiveArgs:
    or a, a
    sbc hl, hl
    push hl
    pop de
    ld a, (var1)
    ld l, a
    ld a, (var2)
    ld h, a
    ld a, (var3)
    ld e, a
    ld a, (var4)
    ld d, a

.setColors:
    call ti.SetTextFGBGcolors_
    set ti.textEraseBelow, (iy + ti.textFlags)

.return:
    jp return

.twoArgs:
    ; see if the program wants to disable text color
    ld hl, (var1)
    ld de, 300
    or a, a
    sbc hl, de
    jr nz, .return
    res ti.putMapUseColor, (iy + ti.putMapFlags)
    jr .return
