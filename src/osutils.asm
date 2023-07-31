;----------------------------------------
;
; Celtic CE Source Code - osutils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 31, 2023
;
;----------------------------------------

getMode: ; det(22)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, (.modeListEnd - .modeListStart) / 3
    jp nc, PrgmErr.INVALA
    ld l, a
    ld h, 3
    mlt hl
    ld de, .storeTheta
    push de
    ld de, .modeListStart
    add hl, de
    xor a, a
    ld hl, (hl)
    jp (hl)

.modeListStart:
    dl .mathprint ; 0
    dl .numMode
    dl .trigMode
    dl .graphMode
    dl .graphSimul
    dl .realMode
    dl .graphWinMode
    dl .graphCoord
    dl .gridOn
    dl .axesOn
    dl .labelOn
    dl .detectAsymptotes
    dl .statWizards
    dl .mixedFractions
    dl .decimalAnswers ; 14
.modeListEnd:

.mathprint: ; 0
    bit ti.mathprintEnabled, (iy + ti.mathprintFlags)
    ret z
    inc a
    ret

.numMode: ; 1
    ld a, 2
    bit ti.fmtEng, (iy + ti.fmtFlags)
    ret nz
    dec a
    bit ti.fmtExponent, (iy + ti.fmtFlags)
    ret nz
    dec a
    ret

.trigMode: ; 2
    bit ti.trigDeg, (iy + ti.trigFlags)
    ret z
    inc a
    ret

.graphMode: ; 3
    bit ti.grfFuncM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    bit ti.grfParamM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    bit ti.grfPolarM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    ret

.graphSimul: ; 4
    bit ti.grfSimul, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.realMode: ; 5
    ld a, 2
    bit ti.polarMode, (iy + ti.numMode)
    ret nz
    dec a
    bit ti.rectMode, (iy + ti.numMode)
    ret nz
    dec a
    ret

.graphWinMode: ; 6
    ld a, 2
    bit ti.vertSplit, (iy + ti.sGrFlags)
    ret nz
    dec a
    bit ti.grfSplit, (iy + ti.sGrFlags)
    ret nz
    dec a
    ret

.graphCoord: ; 7
    bit ti.grfPolar, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.gridOn: ; 8
    bit ti.grfGrid, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.axesOn: ; 9
    bit ti.grfNoAxis, (iy + ti.grfDBFlags)
    ret nz
    inc a
    ret

.labelOn:; 10
    bit ti.grfLabel, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.detectAsymptotes: ; 11
    bit ti.detectAsymptotes, (iy + ti.asymptoteFlags)
    ret nz
    inc a
    ret

.statWizards: ; 12
    bit ti.statWizards, (iy + ti.InitialBootMenuFlags)
    ret nz
    inc a
    ret

.mixedFractions: ; 13
    bit ti.mixedFractions, (iy + ti.fracFlags)
    ret z
    inc a
    ret

.decimalAnswers: ; 14
    bit ti.answersAuto, (iy + ti.fracFlags)
    ret z
    inc a
    ret

.storeTheta:
    call _storeThetaA
    jp return

renameVar: ; det(23)
    res isProgram, (iy + celticFlags1)
    ld hl, Str0
    call _getProgFromStr
    ld a, (hl)
    cp a, ti.AppVarObj
    jr z, $ + 6
    set isProgram, (iy + celticFlags1)
    call _getDataPtr
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, Str9
    call _findString
    ld a, (de)
    inc de
    inc de
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    bit isProgram, (iy + celticFlags1)
    jr z, .createAppvar
    dec hl
    ld (hl), ti.ProgObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateProtProg
    jr .copyData

.createAppvar:
    dec hl
    ld (hl), ti.AppVarObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateAppVar

.copyData:
    push de
    ld hl, Str0
    call _getProgFromStr
    pop ix
    push hl
    push de
    push bc
    push ix
    call _getDataPtr
    ex de, hl ; hl = original program; de = new program
    pop de
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    inc de
    inc de
    ld a, b
    or a, c
    jr z, .deleteProg

.copyDataLoop:
    ldi
    ld a, b
    or a, c
    jr nz, .copyDataLoop

.deleteProg:
    pop bc
    pop de
    pop hl
    call ti.DelVarArc
    jp return

lockPrgm: ; det(24)
    res archived, (iy + celticFlags2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), ti.ProgObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    push hl
    push de
    call ti.OP1ToOP6
    pop de
    pop hl
    call ti.ChkInRam
    call nz, _setArchivedFlag
    call _checkSysVar
    inc de
    inc de
    ld a, (de)
    cp a, ti.tExtTok
    jr nz, .notASM
    inc de
    ld a, (de)
    cp a, ti.tAsm84CeCmp
    jp z, PrgmErr.SUPPORT

.notASM:
    ld a, (hl)
    xor a, 3
    ld (hl), a
    bit archived, (iy + celticFlags2)
    jr z, .return
    call ti.OP6ToOP1
    call ti.Arc_Unarc

.return:
    jp return

hidePrgm: ; det(25)
    res archived, (iy + celticFlags2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), ti.ProgObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    push hl
    push de
    call ti.OP1ToOP6
    pop de
    pop hl
    call ti.ChkInRam
    call nz, _setArchivedFlag
    call _checkSysVar
    ld bc, -7
    add hl, bc
    ld a, (hl)
    xor a, 64
    ld (hl), a
    ld (ti.OP6 + 1), a
    bit archived, (iy + celticFlags2)
    jr z, .return
    call ti.OP6ToOP1
    call ti.Arc_Unarc

.return:
    jp return

prgmToStr: ; det(26)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), ti.ProgObj

.continue:
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call _getDataPtr
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a 
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    ld a, h
    or a, l
    jp z, PrgmErr.NULLVAR
    call ti.CreateStrng
    inc de
    inc de
    pop hl
    push de
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    call _getDataPtr
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    ex de, hl
    pop de
    dec bc
    ld a, b
    or a, c
    jr z, .copyOneByte
    inc bc
    ldir

.return:
    jp return

.copyOneByte:
    inc bc
    ldi
    jr .return

getPrgmType: ; det(27)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), ti.ProgObj
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call _getDataPtr
    inc de
    inc de
    ld a, (de)
    cp a, ti.tii
    ld a, 4 ; ICE source
    jr z, .storeTheta
    ld a, (de)
    cp a, ti.tExtTok
    ld a, 2 ; BASIC indicator
    jr nz, .storeTheta
    inc de
    ld a, (de)
    cp a, ti.tAsm84CeCmp
    ld a, 2 ; BASIC indicator
    jr nz, .storeTheta
    inc de
    ld a, (de)
    ld c, a
    or a, a ; check for C
    ld a, 1 ; C indicator
    jr z, .storeTheta
    ld a, c
    cp a, $7F ; check for ICE
    ld a, 3 ; ICE indicator
    jr z, .storeTheta
    xor a, a ; plain ASM indicator

.storeTheta:
    call _storeThetaA
    jp return

getBatteyStatus: ; det(28)
    or a, a
    sbc hl, hl
    call ti.GetBatteryStatus
    ld l, a
    call ti.usb_IsBusPowered
    or a, a
    jr z, .notCharging
    ld a, l
    add a, 10
    ld l, a

.notCharging:
    call _storeThetaHL
    jr setBrightness.return

setBrightness: ; det(29)
    ld a, (noArgs)
    dec a
    jr z, .getBrightness
    ld a, (var1)
    ld (ti.mpBlLevel), a

.return:
    jp return

.getBrightness:
    ld a, (ti.mpBlLevel)
    or a, a
    sbc hl, hl
    ld l, a
    call _storeThetaHL
    jr .return

searchFile: ; det(52)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld hl, Str0
    call _getProgFromStr
    call _getDataPtr
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push de ; data for program
    push bc ; size of program
    push bc
    pop hl
    ld bc, (var1)
    or a, a
    sbc hl, bc
    jp c, PrgmErr.ENTFN
    ld hl, Str9
    call _findString
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    ex de, hl
    pop hl
    push hl
    push de ; data for string
    or a, a
    sbc hl, bc
    jp c, PrgmErr.INVALS
    add hl, bc
    pop ix
    pop hl
    pop de
    call _getEOF
    ld (ans), ix
    push de ; start of program
    push bc ; size of string
    ld de, (var1)
    pop hl
    pop bc
    push hl
    push bc
    pop hl
    add hl, de
    push hl
    pop bc
    pop hl

.loopFindString:
    push hl ; size of search string
    add hl, bc
    push bc ; start of reading address
    push hl
    pop bc
    ld ix, PrgmErr.ENTFN
    call _checkEOF
    push de
    pop ix
    pop de
    pop bc
    push bc
    push de
    ld hl, (ans)
    call findProg.loopStr
    pop bc
    pop hl
    lea de, ix
    jr z, .storeOffset
    inc de
    inc bc
    jr .loopFindString

.storeOffset:
    ex de, hl
    call _storeThetaHL
    jp return

checkGC: ; det(53)
    ld hl, Str0
    call _getProgFromStr
    ex de, hl
    push hl
    add hl, hl
    pop hl
    ld a, 0
    jr nc, .storeAns
    ld hl, (hl)
    ld a, c
    add a, 12
    ld c, a
    ld b, 0
    add.s hl, bc
    ld a, 1
    jr c, .storeAns
    push hl
    pop bc
    call ti.FindFreeArcSpot
    ld a, 0
    jr nz, .storeAns
    inc a

.storeAns:
    call ti.SetxxOP1
    call ti.StoAns
    jp return

runAsmPrgm: ; det(70)
    ld iy, ti.flags
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, ti.StrngObj
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    call _getProgFromStr + 4
    call _getDataPtr
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    ld a, (hl)
    cp a, ti.tExtTok
    jp nz, PrgmErr.SUPPORT
    inc hl
    ld a, (hl)
    cp a, ti.tAsm84CeCmp
    jp nz, PrgmErr.SUPPORT
    push bc
    push bc
    pop hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    ld (ti.asm_prgm_size), hl
    ld de, ti.userMem
    call ti.InsertMem
    call ti.ChkFindSym
    call _getDataPtr
    ex de, hl
    inc hl
    inc hl
    inc hl ; skip $EF7B
    inc hl
    pop bc
    ld de, ti.userMem

.load:
    ld a, b
    or a, c
    jp z, errorHandle.runHex
    ldi
    jr .load

lineToOffset: ; det(71)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld hl, Str0
    call _getProgFromStr
    call _getDataPtr
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push bc
    pop hl
    call _getEOF
    push de
    push de
    pop bc
    ld hl, (var1)
    ld a, h
    or a, l
    jp z, PrgmErr.LNTFN
    ld (ans), hl
    ld de, 1 ; line counter
    or a, a
    sbc hl, de
    jr z, .lineFound
    ld ix, PrgmErr.LNTFN
    call _searchLine

.lineFound:
    push bc
    pop hl
    pop bc
    or a, a
    sbc hl, bc
    call _storeThetaHL
    jp return

offsetToLine: ; det(72)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld hl, Str0
    call _getProgFromStr
    call _getDataPtr
    or a, a
    sbc hl, hl
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld bc, (var1)
    or a, a
    sbc hl, bc
    jp c, PrgmErr.ENTFN
    ex de, hl
    ld de, 1 ; line counter
    ld a, b
    or a, c
    jr z, .offsetFound
    inc bc

.loop:
    ld a, (hl)
    call ti.Isa2ByteTok
    jr nz, .oneByteToken
    inc hl
    dec bc

.oneByteToken:
    cp a, ti.tEnter
    jr nz, .notNewline
    inc de

.notNewline:
    inc hl
    dec bc
    ld a, b
    or a, c
    jr nz, .loop

.offsetFound:
    ex de, hl
    call _storeThetaHL
    jp return

getKey: ; det(73)
    ld hl, $F50200
    ld (hl), h
    xor a, a

.loop:
    cp a, (hl)
    jr nz, .loop
    ld hl, ti.mpKeyRange + ti.keyData
    ld b, 56
    ld c, 0

.getKeyLoop:
    ld a, b
    cp a, 4
    jr z, .checkArrowKeys
    and a, 7
    jr nz, .sameGroup
    inc hl
    inc hl
    ld e, (hl)

.sameGroup:
    sla e
    jr nc, .loopCode
    xor a, a
    cp a, c
    jr nz, .return
    ld c, b

.loopCode:
    djnz .getKeyLoop

.checkArrowKeys:
    ld a, c
    or a, a
    jr nz, .return
    ld a, (hl)
    and a, $0F
    or a, a
    sbc hl, hl
    ld l, a
    ld bc, arrowKeysLUT
    add hl, bc
    ld a, (hl)

.return:
    call ti.SetxxOP1
    call ti.StoAns
    jp return

turnCalcOff: ; det(74)
    di
    call ti.EnableAPD
    ld a, 1
    ld hl, ti.apdSubTimer
    ld (hl), a
    inc hl
    ld (hl), a
    set ti.apdRunning, (iy + ti.apdFlags)
    ei
    xor a, a
    inc a
    dec a
    jr getKey.return + 8

backupString: ; det(75)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    call _findString + 4
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    or a, c
    jp z, PrgmErr.INVALS
    inc de
    ld hl, 256
    or a, a
    sbc hl, bc
    jr nc, $ + 6
    ld bc, 256
    dec bc
    ld a, c
    inc bc
    ld (stringLen), a
    ex de, hl
    ld de, stringBackup

.storeLoop:
    ld a, b
    or a, c
    jp z, return
    ldi
    jr .storeLoop

restoreString: ; det(76)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    or a, a
    sbc hl, hl
    ld a, (stringLen)
    ld l, a
    inc hl
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    ld hl, stringBackup

.storeLoop:
    ld a, b
    or a, c
    jp z, return
    ldi
    jr .storeLoop

backupReal: ; det(77)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jp z, PrgmErr.INVALA
    cp a, 28
    jp nc, PrgmErr.INVALA
    add a, ti.tA - 1
    call ti.RealName
    call ti.ChkFindSym
    jr c, .storeZero
    call ti.RclVarSym

.storeBackup:
    ld hl, ti.OP1
    ld a, (hl)
    or a, a
    jr z, .isReal
    cp a, $80
    jp nz, PrgmErr.NTREAL

.isReal:
    ld de, realBackup
    ld bc, 9
    ldir
    jp return

.storeZero:
    xor a, a
    call ti.SetxxOP1
    jr .storeBackup

restoreReal: ; det(78)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jp z, PrgmErr.INVALA
    cp a, 28
    jp nc, PrgmErr.INVALA
    add a, ti.tA - 1
    call ti.RealName
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    call ti.CreateReal
    ld hl, realBackup
    ld a, (hl)
    or a, a
    jr z, .isReal
    cp a, $80
    jp nz, PrgmErr.NTREAL

.isReal:
    ld bc, 9
    ldir
    jp return

setParseLine: ; det(79)
    ld de, (ti.begPC)
    ld hl, (ti.curPC)
    or a, a
    sbc hl, de
    ex de, hl
    push de
    pop bc
    dec bc
    ld de, 1

.getCurrentLine:
    ld a, b
    or a, c
    jr z, .lineFound
    ld a, (hl)
    call ti.Isa2ByteTok
    jr nz, .oneByteToken
    inc hl
    dec bc

.oneByteToken:
    cp a, ti.tEnter
    jr nz, .notNewline
    inc de

.notNewline:
    inc hl
    dec bc
    jr .getCurrentLine

.lineFound:
    ex de, hl
    call _storeThetaHL
    ld a, (noArgs)
    dec a
    jr z, .return
    ld hl, (var1)
    ld a, h
    or a, l
    jr z, .return
    ld (ans), hl
    push hl
    ld bc, (ti.begPC)
    push bc
    pop de
    or a, a
    sbc hl, hl
    dec de
    dec de
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    call _getEOF
    pop hl
    ld de, 1
    or a, a
    sbc hl, de
    jr z, .jumpToLine
    ld ix, PrgmErr.LNTFN
    call _searchLine
    inc bc

.jumpToLine:
    dec bc
    ld (ti.curPC), bc

.return:
    jp return

setParseByte: ; det(80)
    ld de, (ti.begPC)
    ld hl, (ti.curPC)
    dec hl
    or a, a
    sbc hl, de
    call _storeThetaHL
    ld a, (noArgs)
    dec a
    jr z, .return
    ld de, (ti.begPC)
    ld hl, (var1)
    add hl, de
    push hl
    ld de, (ti.endPC)
    inc de
    or a, a
    sbc hl, de
    pop hl
    jr nc, $ + 5
    dec hl
    jr $ + 4
    dec de
    ex de, hl
    ld (ti.curPC), hl

.return:
    jp return

swapFileType: ; det(81)
    res archived, (iy + celticFlags2)
    ld hl, Str0
    call _getProgFromStr
    ld a, (hl)
    cp a, ti.AppVarObj
    jr nz, .isProgram
    ld a, ti.ProtProgObj
    jr $ + 4

.isProgram:
    ld a, ti.AppVarObj
    push af
    push hl
    push de
    call ti.OP1ToOP6
    pop de
    pop hl
    call ti.ChkInRam
    call nz, _setArchivedFlag
    pop af
    ld (hl), a
    ld (ti.OP6), a
    bit archived, (iy + celticFlags2)
    jr z, resetScreen + 12 ; use as return label
    call ti.OP6ToOP1
    call ti.Arc_Unarc
    jr resetScreen + 12

resetScreen: ; det(82)
    call ti.ClrLCDFull
    call ti.HomeUp
    call ti.DrawStatusBar
    jp return
