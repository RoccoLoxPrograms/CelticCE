;----------------------------------------
;
; Celtic CE Source Code - osutils.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
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
    dl .labelOn ; 10
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

.storeTheta:
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
    jp return

renameVar: ; det(23)
    res archived, (iy + ti.asm_Flag2) ; use archived flag to remember file type
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
    jr z, .rename
    set archived, (iy + ti.asm_Flag2)
    dec hl
    ld (hl), $05

.rename:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    push hl
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    bit archived, (iy + ti.asm_Flag2)
    jr z, .createAppvar
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateProtProg
    jr .copyData

.createAppvar:
    dec hl
    ld (hl), $15
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateAppVar

.copyData:
    push de
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .rename2
    dec hl
    ld (hl), $05

.rename2:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    pop ix
    push hl
    push de
    push bc
    push ix
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
    ex de, hl
    pop de
    ; hl = original program; de = new program
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    inc de
    inc de
    call ti.ChkBCIs0
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
    res archived, (iy + ti.asm_Flag2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.OP1ToOP6
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    call nz, _setArchivedFlag
    inc de
    inc de
    push hl
    ld hl, 0
    ld a, (de)
    ld h, a
    inc de
    ld a, (de)
    ld l, a
    ld de, $EF7B
    or a, a
    sbc hl, de
    pop hl
    jp z, PrgmErr.SUPPORT
    ld a, (hl)
    xor a, 00000011b
    ld (hl), a
    bit archived, (iy + ti.asm_Flag2)
    call nz, _re_archive
    jp return

hidePrgm: ; det(25)
    res archived, (iy + ti.asm_Flag2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.OP1ToOP6
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    call nz, _setArchivedFlag
    ld bc, -7
    add hl, bc
    ld a, (hl)
    xor a, 01000000b
    ld (hl), a
    ld (ti.OP6 + 1), a
    bit archived, (iy + ti.asm_Flag2)
    call nz, _re_archive
    jp return

prgmToStr: ; det(26)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    pop hl
    jp c, PrgmErr.PNTFN
    push hl
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    ld hl, 0
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
    push af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    pop hl
    call ti.ChkHLIs0
    jp z, PrgmErr.NULLVAR
    call ti.CreateStrng
    inc de
    inc de
    pop hl
    push de
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
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
    call ti.ChkBCIs0
    jr z, .copyOneByte
    inc bc
    ldir
    jp return

.copyOneByte:
    inc bc
    ldi
    jp return

getPrgmType: ; det(27)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    inc de
    inc de
    ld a, (de)
    cp a, $2C
    ld a, 4 ; ICE source
    jr z, .storeTheta
    ; check for ASM
    ex de, hl
    ld de, (hl)
    ex de, hl
    or a, a
    ld bc, $007BEF ; check for C
    sbc hl, bc
    ld a, 1
    jr z, .storeTheta
    add hl, bc
    ld bc, $7F7BEF ; check for ICE
    or a, a
    sbc hl, bc
    ld a, 3
    jr z, .storeTheta
    ld a, (de)
    ld hl, 0
    ld h, a
    inc de
    ld a, (de)
    ld l, a
    ld bc, $EF7B ; check for plain ASM
    or a, a
    sbc hl, bc
    ld a, 0
    jr z, .storeTheta
    ld a, 2

.storeTheta:
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
    jp return

getBatteyStatus: ; det(28)
    ld hl, 0
    call ti.GetBatteryStatus
    ld l, a
    call ti.usb_IsBusPowered
    or a, a
    jr z, .notCharging
    ld a, l
    add a, 10
    ld l, a

.notCharging:
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
    jp return

setBrightness: ; det(29)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jr z, .getBrightness
    ld ($F60024), a ; ti.mpBlLevel
    jp return

.getBrightness:
    ld a, ($F60024)
    ld hl, 0
    ld l, a
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
    jp return

searchFile: ; det(52)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
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
    jr z, .getFile
    dec hl
    ld (hl), $05

.getFile:
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
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
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
    jp return

checkGC: ; det(53)
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
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
