;----------------------------------------
;
; Celtic CE Source Code - celtic3.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

getListElem: ; det(30)
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld bc, 1
    or a, a
    sbc hl, bc
    jp z, PrgmErr.INVALS
    add hl, bc
    ld a, (de)
    cp a, $EB
    jr z, .isAlist
    cp a, $5D
    jr z, .isAlist
    jp PrgmErr.NTALS

.isAlist:
    call .getListNameLen
    ld bc, ti.OP1
    ld a, ti.ListObj
    ld (bc), a
    inc bc
    ld a, ti.tVarLst
    ld (bc), a
    inc de
    inc bc
    dec hl
    push de
    push bc
    push hl
    pop bc
    pop de
    pop hl

.loopName:
    ldi
    ld a, b
    or a, c
    jr nz, .loopName
    xor a, a
    ld (de), a
    call ti.ChkFindSym
    jp c, PrgmErr.PNTFN
    res imaginaryList, (iy + ti.asm_Flag2)
    ld a, (hl)
    cp a, $0D
    jr nz, .chkLoc
    set imaginaryList, (iy + ti.asm_Flag2)

.chkLoc:
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
    inc de
    ld a, (var1)
    or a, a
    jp z, .showDim
    call ti.ChkHLIs0
    jp z, PrgmErr.ENTFN
    push de
    ld de, (var1)
    or a, a
    sbc hl, de
    pop hl
    jp c, PrgmErr.ENTFN
    ld de, 1
    ld bc, 9
    bit imaginaryList, (iy + ti.asm_Flag2)
    jr z, .loopFindOffset
    ld bc, 18

.loopFindOffset:
    push hl
    ld hl, (var1)
    or a, a
    sbc hl, de
    pop hl
    jr z, .foundOffset
    inc de
    add hl, bc
    jr .loopFindOffset

.foundOffset:
    push bc
    ld de, execHexLoc
    ldir
    ld hl, Theta
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    bit imaginaryList, (iy + ti.asm_Flag2)
    jr z, .createReal
    call ti.CreateCplx

.storeValue:
    ld hl, execHexLoc
    pop bc
    ldir
    jp return

.createReal:
    call ti.CreateReal
    jr .storeValue

.getListNameLen:
    ld bc, 7
    or a, a
    sbc hl, bc
    add hl, bc
    jr c, .validLen
    ld hl, 6

.validLen:
    ld a, (de)
    cp a, $5D
    ret nz
    ld bc, 2
    or a, a
    sbc hl, bc
    add hl, bc
    ret z
    pop bc
    jp PrgmErr.INVALS

.showDim:
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

getArgType: ; det(31)
    call ti.RclAns
    ld hl, 0
    ld a, (ti.OP1)
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

chkStats: ; det(32)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, 4
    jp z, .checkCalcVer
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld a, (var1)
    ld hl, return
    push hl
    or a, a
    jr z, .checkRAM
    dec a
    jr z, .checkROM
    dec a
    jp z, .checkBoot
    dec a
    jp z, .checkOS
    jp PrgmErr.INVALA

.checkRAM:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 6
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld (ans), sp ; use to preserve sp
    ld a, '0'
    ld bc, 6
    call ti.MemSet
    ld hl, -9 ; do this because the toolchain does
    call ti._frameset
    call ti.MemChk
    push hl ; copied from the toolchain
    pea ix - 9
    call ti.os.Int24ToReal
    ld sp, (ans) ; just restore sp because it's easier
    ld a, 6
    call ti.FormEReal
    ld hl, 6
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loadLoop:
    ld a, b
    or a, c
    ret z
    ldi
    jr .loadLoop

.checkROM:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 7
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld (ans), sp ; use to preserve sp
    ld a, '0'
    ld bc, 7
    call ti.MemSet
    call ti.ArcChk
    ld hl, -9 ; do this because the toolchain does
    call ti._frameset
    ld hl, (ti.tempFreeArc)
    push hl ; copied from the toolchain
    pea ix - 9
    call ti.os.Int24ToReal
    ld sp, (ans) ; just restore sp because it's easier
    ld a, 7
    call ti.FormEReal
    ld hl, 7
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loop:
    ld a, b
    or a, c
    ret z
    ldi
    jr .loop

.checkBoot:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 10
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld a, '0'
    ld bc, 10
    call ti.MemSet
    pop hl
    push hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    call ti.os.GetSystemInfo
    ld bc, 12
    add hl, bc
    ld de, execHexLoc
    ld bc, 6
    ldir ; store in a safe location

.storeInfo:
    ld a, (execHexLoc)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld a, (execHexLoc + 1)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld a, (execHexLoc + 2)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld hl, (execHexLoc + 3)
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    ld a, 6
    call ti.FormEReal
    ld hl, 4
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loop2:
    ld a, b
    or a, c
    ret z
    ldi
    jr .loop2

.checkOS:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 10
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld a, '0'
    ld bc, 10
    call ti.MemSet
    pop hl
    push hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    call ti.os.GetSystemInfo
    ld bc, 6
    add hl, bc
    ld de, execHexLoc
    ld bc, 6
    ldir ; store in a safe location
    jp .storeInfo

.checkCalcVer:
    call ti.os.GetSystemInfo
    ld bc, 4
    add hl, bc
    ld a, (hl)
    push af
    ld hl, Theta
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    call ti.CreateReal
    pop af
    push de
    call ti.SetxxOP2
    pop de
    ld hl, ti.OP2
    ld bc, 9
    ldir
    jp return

findProg: ; det(33)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jr z, .programs
    dec a
    jr z, .appvars
    jp PrgmErr.INVALA

.programs:
    res randFlag, (iy + ti.asm_Flag2) ; reset since we're searching for programs
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, .setupFindAll
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    ld a, 5
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0
    jr .loopFindVars

.appvars:
    set randFlag, (iy + ti.asm_Flag2) ; set since we're searching for appvars
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, .setupFindAll
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    ld a, $15
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0

.loopFindVars: ; name in OP1; bc = size of string; de = ptr to search string
    push bc
    push de
    call ti.FindAlphaUp
    jr c, .exitLoop
    ld bc, -6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; use to preserve name length
    inc hl
    ld a, (hl)
    ld (ti.scrapMem + 2), a
    ld de, (ti.scrapMem)
    inc hl
    ld d, (hl)
    inc hl
    ld e, (hl)
    push de
    pop hl
    call ti.ChkInRam
    jr z, .inRam
    ld a, (bufSpriteY)
    add a, 10
    ld bc, 0
    ld c, a
    add hl, bc

.inRam:
    inc hl
    inc hl
    pop de
    push de
    call .checkString
    pop de
    pop bc
    call z, .storeName
    jr .loopFindVars

.exitLoop:
    pop de
    pop bc
    push bc
    call ti.ChkBCIs0
    jp z, PrgmErr.PNTFN
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    call ti.CreateStrng
    ld hl, execHexLoc
    inc de
    inc de
    pop bc
    ldir
    jp return

.setupFindAll:
    call ti.ZeroOP1
    ld a, 5
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0
    bit randFlag, (iy + ti.asm_Flag2)
    jr z, .findAllLoop
    ld a, $15
    ld (ti.OP1), a

.findAllLoop:
    push bc
    call ti.FindAlphaUp
    jr c, .exitLoop + 1
    ld bc, -6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; use to preserve name length
    pop bc
    call .storeName
    jr .findAllLoop

.checkString:
    ld bc, (ans)

.loopStr:
    ld a, (de)
    cpi
    inc de
    ret nz
    ld a, b
    or a, c
    ret z
    jr .loopStr

.storeName:
    ld hl, ti.OP1 + 1
    ld a, (bufSpriteY)
    bit randFlag, (iy + ti.asm_Flag2)
    jr z, .loopStoreName
    inc a
    dec hl

.loopStoreName:
    push af
    ld a, (hl)
    call .convertLetter
    ld (ix), a
    inc bc
    inc ix
    inc hl
    pop af
    dec a
    jr nz, .loopStoreName
    ld (ix), ti.tSpace
    inc ix
    inc bc
    ret

.convertLetter: ; fix lowercase letters
    cp a, $61
    ret c
    cp a, $7B
    ret nc
    ld (ix), $BB
    inc ix
    inc bc
    add a, $4F
    cp a, $BB
    ret c
    inc a
    ret

ungroupFile: ; det(34)
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
    cp a, $17
    jp nz, PrgmErr.NTAGP
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.GNTFN
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
    inc de
    call _getEOF

.loop:
    ld a, (de)
    cp a, $05
    jr z, .extract
    cp a, $06
    jr z, .extract
    cp a, $15
    jr nz, .advance

.extract:
    push af
    push de
    ld (ti.OP1), a
    ld hl, 6
    add hl, de
    ld c, (hl)
    inc hl
    ld de, ti.OP1 + 1

.load:
    ldi
    inc c
    dec c
    jr nz, .load
    xor a, a
    ld (de), a
    push hl
    call ti.ChkFindSym
    jr c, .create
    ld a, (var1)
    or a, a
    push hl
    pop ix
    pop hl
    jr z, .writeEnd
    push hl
    push ix
    pop hl ; get VAT pointer
    call ti.DelVarArc

.create:
    pop hl
    ld de, 0
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    ex de, hl
    ld a, (ti.OP1)
    push hl
    inc hl
    inc hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    call ti.CreateVar
    inc de
    inc de
    pop bc
    pop hl

.write:
    ld a, b
    or a, c
    jr z, .writeEnd
    ldi
    jr .write

.writeEnd:
    pop de
    pop af

.advance:
    ld hl, .next
    push hl
    ld hl, 6
    add hl, de
    ex de, hl
    ld hl, 3
    ld h, a
    mlt hl
    ld bc, _findNthItem.itemTypes
    add hl, bc
    ld hl, (hl)
    jp (hl)

.next:
    push de
    pop bc
    ld ix, _decBCretZ
    call _checkEOF
    jp z, return
    jp .loop

getGroup: ; det(35)
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
    cp a, $17
    jp nz, PrgmErr.NTAGP
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.GNTFN
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
    inc de
    call _getEOF
    ex de, hl
    ld ix, execHexLoc
    ld bc, 0

.findAllLoop:
    push bc
    push hl
    push hl
    pop bc
    push ix
    ld ix, _decBCretZ
    call _checkEOF
    pop ix
    pop hl
    jr z, .exit
    ld a, (hl)
    cp a, $05
    jr z, .isValid
    cp a, $06
    jr z, .isValid
    cp a, $15
    jr nz, .advance
    pop bc
    inc bc
    push bc
    ld (ix), a
    inc ix

.isValid:
    ld bc, 6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; preserve name length
    pop bc
    push hl
    call .storeName
    pop hl
    push bc
    ld bc, -6
    add hl, bc

.advance:
    ex de, hl
    ld a, (de)
    ld hl, .next
    push hl
    ld hl, 6
    add hl, de
    ex de, hl
    ld hl, 3
    ld h, a
    mlt hl
    ld bc, _findNthItem.itemTypes
    add hl, bc
    ld hl, (hl)
    jp (hl)

.next:
    ex de, hl
    pop bc
    jr .findAllLoop

.exit:
    pop bc
    push bc
    call ti.ChkBCIs0
    jp z, PrgmErr.PNTFN
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
    ld hl, execHexLoc
    inc de
    inc de
    pop bc
    ldir
    jp return

.storeName:
    ld a, (bufSpriteY)
    inc hl

.loopStoreName:
    push af
    ld a, (hl)
    call findProg.convertLetter
    ld (ix), a
    inc bc
    inc ix
    inc hl
    pop af
    dec a
    jr nz, .loopStoreName
    ld (ix), ti.tSpace
    inc ix
    inc bc
    ret

extGroup: ; det(36)
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
    cp a, $17
    jp nz, PrgmErr.NTAGP
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.GNTFN
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
    inc de
    call _getEOF
    ld a, (var1)
    ld ixl, a
    call _findNthItem
    jp z, PrgmErr.ENTFN
    ld a, (de)
    ld (ti.OP1), a
    ld hl, 6
    add hl, de
    ld c, (hl)
    inc hl
    ld de, ti.OP1 + 1

.load:
    ldi
    inc c
    dec c
    jr nz, .load
    xor a, a
    ld (de), a
    ld de, 0
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    push de
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld a, (ti.OP1)
    pop hl
    push hl
    inc hl
    inc hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    call ti.CreateVar
    inc de
    inc de
    pop bc
    pop hl

.write:
    ld a, b
    or a, c
    jp z, return
    ldi
    jr .write

groupMem: ; det(37)
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
    cp a, $17
    jp nz, PrgmErr.NTAGP
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.GNTFN
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
    inc de
    call _getEOF
    ld a, (var1)
    ld ixl, a
    call _findNthItem
    jp z, PrgmErr.ENTFN
    ld hl, 6
    add hl, de
    ld de, 0
    ld e, (hl)
    add hl, de
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
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

binRead: ; det(38)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
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
    ld hl, (var1)
    add hl, de
    push hl
    ld hl, (var2)
    call ti.ChkHLIs0
    jp z, PrgmErr.INVALA
    add hl, hl
    push hl
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
    ex de, hl
    pop bc
    pop de

.loop:
    ld a, (de)
    push bc
    call _byteToToken
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    inc de
    pop bc
    dec bc
    dec bc
    ld a, b
    or a, c
    jp z, return
    jr .loop

binWrite: ; det(39)
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
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push de
    push bc
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push de
    push bc
    push bc
    pop hl
    srl h
    rr l
    jp c, PrgmErr.INVALS
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop bc
    pop de
    pop hl
    push bc
    ld bc, (var1)
    or a, a
    sbc hl, bc
    jp c, PrgmErr.ENTFN
    pop bc
    srl b
    rr c
    ex de, hl
    ld de, execHexLoc
    push bc
    push de

.loop:
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    inc hl
    ld e, a
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, e
    pop de
    ld (de), a
    inc hl
    inc de
    push de
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
    pop hl
    pop bc
    pop hl
    ld de, (var1)
    push hl
    add hl, de
    ex de, hl
    push bc
    push bc
    pop hl
    push de
    call ti.InsertMem
    pop de
    ld hl, execHexLoc
    pop bc
    push bc

.writeLoop:
    ld a, b
    or a, c
    jr z, .changeSize
    ldi
    jr .writeLoop

.changeSize:
    pop bc
    pop de
    dec de
    ld hl, 0
    ld a, (de)
    ld h, a
    dec de
    ld a, (de)
    ld l, a
    add hl, bc
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    jp return

binDelete: ; det(40)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
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
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    call ti.ChkBCIs0
    jp z, return
    push de
    push bc
    ld hl, (var2)
    call ti.ChkHLIs0
    jp z, PrgmErr.INVALA
    ld hl, (var1)
    add hl, de
    push hl
    push bc
    pop hl
    call _getEOF
    pop hl
    push hl
    ld de, (EOF)
    ex de, hl
    or a, a
    sbc hl, de
    jp c, PrgmErr.ENTFN
    ld hl, (var2)
    push hl
    add hl, de
    dec hl
    ld de, (EOF)
    ex de, hl
    or a, a
    sbc hl, de
    jp c, PrgmErr.ENTFN
    pop de
    pop hl
    push de
    call ti.DelMem
    pop de
    pop hl
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    dec hl
    ld (hl), d
    dec hl
    ld (hl), e
    jp return

hexToBin: ; det(41)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    srl b
    rr c
    jp c, PrgmErr.INVALS
    ld de, execHexLoc
    push bc
    push de

.loop:
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    inc hl
    ld e, a
    ld a, (hl)
    call _checkValidHex
    call _convertTokenToHex
    add a, e
    pop de
    ld (de), a
    inc hl
    inc de
    push de
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
    pop hl
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
    ld hl, execHexLoc

.storeLoop:
    ld a, b
    or a, c
    jp z, return
    ldi
    jr .storeLoop

binToHex: ; det(42)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop de
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    add hl, hl
    push hl
    push hl
    pop bc
    ex de, hl
    ld ix, execHexLoc

.loop:
    ld a, (hl)
    push bc
    call _byteToToken
    ld (ix), b
    inc ix
    ld (ix), c
    inc ix
    inc hl
    pop bc
    dec bc
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
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
    ld hl, execHexLoc
    ldir
    jp return

graphCopy: ; det(43)
    call ti.GrBufCpy
    jp return

edit1Byte: ; det(44)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
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
    ld hl, (var2)
    or a, a
    sbc hl, bc
    jp nc, PrgmErr.ENTFN
    ex de, hl
    ld bc, (var2)
    add hl, bc
    ld a, (var3)
    ld (hl), a
    jp return

errorHandle: ; det(45)
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, .return
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, 4
    jp nz, PrgmErr.SNTST
    call _getProgNameLen
    ex de, hl
    ld b, a
    ld a, (hl)
    cp a, ti.tProg
    jp nz, .string
    inc hl
    dec b
    ld a, b
    call _convertChars.varName
    ld hl, prgmName
    ld (hl), 5
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
    ld bc, 0
    ex de, hl
    ld c, (hl)
    inc hl
    ld b, (hl)
    push bc
    push bc
    pop hl
    ld bc, 128 ; for safety
    add hl, bc
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateProtProg
    inc de
    inc de
    push de
    ld hl, prgmName
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
    inc de
    inc de
    ld a, (de)
    cp a, ti.tExtTok
    jr nz, .noSquish
    inc de
    ld a, (de)
    cp a, ti.tAsm84CePrgm
    jp z, .squish
    cp a, ti.tAsm84CeCmp
    jp z, PrgmErr.SUPPORT ; compiled assembly
    dec de

.noSquish:
    ex de, hl
    pop de
    pop bc

.load:
    ld a, b
    or a, c
    jr z, .loadComplete
    ldi
    jr .load

.loadComplete:
    ld de, (ti.begPC)
    ld hl, (ti.curPC)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ti.endPC)
    or a, a
    sbc hl, de
    push hl
    ld hl, (ti.parserHookPtr)
    push hl
    ld hl, stopTokenHook
    call ti.SetParserHook
    ld hl, ti.basic_prog
    call ti.Mov9ToOP1
    call ti.PushOP1
    ld hl, .endQuit
    call ti.PushErrorHandler
    ld hl, .endProg
    push hl
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    jp ti.ParseInp

.endProg:
    call ti.PopErrorHandler
    xor a, a

.endQuit:
    cp a, ti.E_AppErr1
    jr nz, $ + 3
    xor a, a
    and a, $7F ; start error codes at 1
    pop hl
    call ti.SetParserHook
    push af
    call ti.PopOP1
    ld hl, ti.OP1
    ld de, ti.basic_prog
    call ti.Mov9b
    call ti.ChkFindSym
    call c, _checkHidden
    call ti.ChkInRam
    jr z, .inRam3
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam3:
    inc de
    inc de
    ld (ti.begPC), de
    pop af
    pop hl
    add hl, de
    ld (ti.endPC), hl
    pop hl
    add hl, de
    ld (ti.curPC), hl
    push af
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc

.loadTheta:
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

.return:
    ld (stackPtr), sp
    jp return

.string:
    dec hl
    dec hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    push bc
    push bc
    pop hl
    ld bc, 128 ; for safety
    add hl, bc
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateProtProg
    inc de
    inc de
    push de
    call ti.AnsName
    call ti.ChkFindSym
    jp .inRam2

.squish:
    inc de
    push de
    ld hl, basicPrgmName
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call ti.DelVarArc
    pop hl ; start of program data
    pop bc
    pop bc ; size of data
    dec bc
    dec bc ; remove Asm84CEPrgm from un-squished size
    push hl
    push bc
    push bc

.loopNewlines:
    ld a, (hl)
    cp a, $3F
    jr nz, .notNewline
    pop de
    dec de
    push de

.notNewline:
    inc hl
    dec bc
    ld a, b
    or a, c
    jr nz, .loopNewlines
    pop hl ; un-squished size minus newlines
    ld a, h
    or a, l
    jp z, PrgmErr.NULLVAR
    bit 0, l
    jp nz, PrgmErr.INVALS
    srl l
	rr h
    ld (ti.asm_prgm_size), hl
    push hl
    ld de, ti.userMem
    call ti.InsertMem
    pop bc
    xor a, a
    ld hl, ti.userMem
    push hl
    call ti.MemSet
    pop de ; userMem
    pop bc ; original (un-squished) size
    pop hl ; start of program data

.loopLoad:
    ld a, b
    or a, c
    jr z, .runHex
    ld a, (hl)
    inc hl
    dec bc
    cp a, $3F
    jr z, .loopLoad
    push de
    call _checkValidHex
    call _convertTokenToHex
    add a, a
    add a, a
    add a, a
    add a, a
    ld e, a
    ld a, (hl)
    inc hl
    dec bc
    call _checkValidHex
    call _convertTokenToHex
    add a, e
    pop de
    ld (de), a
    inc de
    jr .loopLoad

.runHex:
    ld hl, .endHexQuit
    call ti.PushErrorHandler
    ld hl, .endHex
    push hl
    jp ti.userMem

.endHex:
    call ti.PopErrorHandler
    xor a, a

.endHexQuit:
    and a, $7F ; start error codes at 1
    push af
    ld de, (ti.asm_prgm_size)
    or a, a
    sbc hl, hl
    ld (ti.asm_prgm_size), hl
    ld hl, ti.userMem
    call ti.DelMem
    jp .loadTheta

stringRead: ; det(46)
    ld a, (noArgs)
    cp a, 3
    jp z, .getSize
    cp a, 4
    jp c, PrgmErr.INVALA
    ld hl, (var2)
    call ti.ChkHLIs0
    jp z, .getSize
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
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    inc hl
    ld de, (var2)
    add hl, de
    ex de, hl
    ld bc, (var3)
    call ti.ChkBCIs0
    jp z, PrgmErr.INVALA
    ld hl, execHexLoc
    push bc

.loop:
    ld a, (de)
    push bc
    call _byteToToken
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    inc de
    pop bc
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
    pop hl
    add hl, hl
    push hl
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
    ld hl, execHexLoc
    pop bc
    ldir
    jp return

.getSize:
    ld hl, (var2)
    call ti.ChkHLIs0
    jp nz, PrgmErr.INVALA
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0b
    ld a, 10

.notStr0b:
    dec a
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    push bc
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

hexToDec: ; det(47)
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    ex de, hl
    ld hl, 0
    ld ixl, 4

.loop:
    ld a, (de)
    call _checkValidHex
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    sub a, $30
    cp a, 10
    jr c, .skipDec
    sub a, 7

.skipDec:
    or a, l
    ld l, a
    inc de
    dec ixl
    jr z, .storeTheta
    dec bc
    ld a, b
    or a, c
    jr nz, .loop

.storeTheta:
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

decToHex: ; det(48)
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    ld hl, execHexLoc
    ld de, (var1)
    ld a, d
    call _byteToToken
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    ld a, e
    call _byteToToken
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    ld (hl), 0
    ld hl, execHexLoc
    ld a, (noArgs)
    cp a, 2
    ld a, '0'
    ld b, 3
    jr z, .noAutoOverride
    ld a, (var2)
    or a, a
    jr nz, .storeHex
    ld a, '0'

.noAutoOverride:
    cp a, (hl)
    jr nz, .storeHex
    inc hl
    djnz .noAutoOverride

.storeHex:
    push hl
    call ti.StrLength
    push bc
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

.storeString:
    ldi
    xor a, a
    or a, c
    jr nz, .storeString
    jp return

editWord: ; det(49)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
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
    ld hl, (var2)
    inc hl
    or a, a
    sbc hl, bc
    jp nc, PrgmErr.ENTFN
    ex de, hl
    ld bc, (var2)
    add hl, bc
    ld de, var3
    ex de, hl
    ldi
    ldi
    jp return

bitOperate: ; det(50)
    ld a, (noArgs)
    cp a, 4
    jp c, PrgmErr.INVALA
    ld a, (var3)
    or a, a
    jr z, .none
    dec a ; 1
    jr z, .and
    dec a ; 2
    jr z, .or
    dec a ; 3
    jr z, .xor
    dec a ; 4
    jr z, .leftShift
    dec a ; 5
    jp nz, PrgmErr.INVALA
    ; right shifting
    ld a, (var2)
    ld b, a
    ld hl, (var1)

.rightShiftLoop:
    srl h
    rr l
    djnz .rightShiftLoop
    jr .storeTheta

.leftShift:
    ld a, (var2)
    ld b, a
    ld hl, (var1)

.leftShiftLoop:
    add hl, hl
    djnz .leftShiftLoop
    jr .storeTheta

.xor:
    ld hl, (var1)
    ld bc, (var2)
    ld a, l
    xor a, c
    ld l, a
    ld a, h
    xor a, b
    ld h, a
    jr .storeTheta

.or:
    ld hl, (var1)
    ld bc, (var2)
    ld a, l
    or a, c
    ld l, a
    ld a, h
    or a, b
    ld h, a
    jr .storeTheta

.and:
    ld hl, (var1)
    ld bc, (var2)
    ld a, l
    and a, c
    ld l, a
    ld a, h
    and a, b
    ld h, a
    jr .storeTheta

.none:
    ld hl, (var1)

.storeTheta:
    call ti.SetHLUTo0
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

getProgList: ; det(51)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jr z, .programs
    dec a
    jr z, .appvars
    dec a
    jr z, .groups
    jp PrgmErr.INVALA

.programs:
    res randFlag, (iy + ti.asm_Flag2) ; reset since we're searching for programs
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    ld a, 5
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0
    jr .loopFindVars

.groups:
    ld c, 2
    jr .appvars + 2

.appvars:
    ld c, 0
    push bc
    set randFlag, (iy + ti.asm_Flag2) ; set since we're searching for appvars or groups
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    pop bc
    ld a, $15
    add a, c
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0

.loopFindVars: ; name in OP1; bc = size of string; de = ptr to search string
    push bc
    push de
    call ti.FindAlphaUp
    jr c, .exitLoop
    ld bc, -6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; use to preserve name length

.inRam:
    dec hl
    pop de
    push de
    call .checkString
    pop de
    pop bc
    call z, findProg.storeName
    jr .loopFindVars

.exitLoop:
    pop de
    pop bc
    push bc
    call ti.ChkBCIs0
    jp z, PrgmErr.PNTFN
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop hl
    push hl
    call ti.CreateStrng
    ld hl, execHexLoc
    inc de
    inc de
    pop bc
    ldir
    jp return

.checkString:
    ld bc, (ans)

.loopStr:
    ld a, (de)
    cpd
    inc de
    ret nz
    ld a, b
    or a, c
    ret z
    jr .loopStr
