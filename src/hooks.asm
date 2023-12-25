;----------------------------------------
;
; Celtic CE Source Code - hooks.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: December 24, 2023
;
;----------------------------------------

hookCheckStr: ; can be used as a hook identifier
    db "[CelticCE]", 0

celticStart:
    db $83
    push af
    cp a, 1
    jr nz, chain
    ld a, ti.tDet ; det( token
    cp a, b
    jr nz, chain
    cp a, c
    jr z, hookTriggered

chain:
    ld a, (ti.helpHookPtr + 2)
    or a, a
    jr z, noChain
    ld ix, (ti.helpHookPtr)
    ld a, (ix - 1)
    cp a, $83 ; check for hook identifier
    jr nz, noChain
    pop af
    jp (ix)

noChain:
    pop af
    cp a, a
    ret

matrixType:
    push hl
    push bc
    bit ti.progExecuting, (iy + ti.newDispF)
    jr z, popReturnOS
    call ti.FindSym
    ld a, (de)
    dec a
    jr nz, popReturnOS
    inc de
    ld a, (de)
    dec a
    jr nz, popReturnOS
    inc de
    inc de
    inc de
    ld a, (de)
    cp a, $20
    jr nz, popReturnOS
    ld a, 90 ; Celtic version indentifier
    call ti.SetxxOP1
    pop bc
    pop hl
    or a, 1
    ret

popReturnOS:
    pop bc
    pop hl
    cp a, a
    ret

hookTriggered:
    pop af
    ld (stackPtr), sp
    ld (noArgs), hl
    ld a, h
    or a, a
    jr nz, $ + 5
    ld a, l
    cp a, 10
    jp nc, PrgmErr.2MARG
    ld a, (ti.OP1)
    cp a, ti.MatObj
    jr z, matrixType
    call ti.PushOP1 ; push so all args are on FPS
    ld a, (noArgs)
    push af
    dec a
    ld b, a
    add a, a
    add a, b
    ld de, 0
    ld e, a
    ld hl, var0
    add hl, de ; get address to start pushing args to
    pop bc

popArgs:
    push bc
    push hl
    call ti.PopOP1
    ld a, (ti.OP1)
    or a, a
    jr nz, removeAllArgs
    call ConvOP1
    jr nc, removeAllArgs
    pop hl
    ld (hl), de
    dec hl ; go down one var
    dec hl
    dec hl
    pop bc ; restore so djnz can use it
    djnz popArgs

hookTriggeredCont:
    ld a, (var0)
    cp a, (celticTableEnd - celticTableBegin) / 3
    jp nc, PrgmErr.SUPPORT
    ld l, a
    ld h, 3
    mlt hl
    ld de, celticTableBegin
    add hl, de
    res replaceLineRun, (iy + ti.asm_Flag2)
    ld hl, (hl)
    jp (hl)

removeAllArgs:
    pop hl
    pop bc
    dec b
    jr z, .argsPopped

.clearArgs:
    push bc
    call ti.PopOP1
    pop bc
    djnz .clearArgs

.argsPopped:
    jp PrgmErr.INVALA

celticTableBegin:
    dl readLine ; det(0)
    dl replaceLine ; det(1)
    dl insertLine ; and so on...
    dl specialChars
    dl createVar
    dl arcUnarcVar
    dl deleteVar
    dl deleteLine
    dl varStatus
    dl bufSprite
    dl bufSpriteSelect
    dl execArcPrgm
    dl dispColor
    dl dispText
    dl execHex
    dl fillRect ; det(15)
    dl fillScreen
    dl drawLine
    dl setPixel
    dl getPixel
    dl pixelTestColor
    dl putSprite
    dl getMode
    dl renameVar
    dl lockPrgm
    dl hidePrgm
    dl prgmToStr
    dl getPrgmType
    dl getBatteyStatus
    dl setBrightness
    dl getListElem
    dl getArgType
    dl chkStats
    dl findProg ; det(33)
    dl ungroupFile
    dl getGroup
    dl extGroup
    dl groupMem
    dl binRead
    dl binWrite
    dl binDelete
    dl hexToBin
    dl binToHex
    dl graphCopy
    dl edit1Byte ; det(44)
    dl errorHandle
    dl stringRead
    dl hexToDec
    dl decToHex
    dl editWord
    dl bitOperate
    dl getProgList
    dl searchFile
    dl checkGC
    dl getStringWidth
    dl transSprite
    dl scaleSprite
    dl scaleTSprite
    dl shiftScreen
    dl rgbto565
    dl drawRect
    dl drawCircle
    dl fillCircle
    dl drawArc
    dl dispTransText
    dl chkRect ; det(65)
    dl putChar
    dl putTransChar
    dl horizLine
    dl vertLine
    dl runAsmPrgm
    dl lineToOffset
    dl offsetToLine
    dl getKey
    dl turnCalcOff
    dl backupString
    dl restoreString
    dl backupReal
    dl restoreReal
    dl setParseLine
    dl setParseByte
    dl swapFileType
    dl resetScreen ; det(82)
celticTableEnd:

cursorHook:
    db $83
    cp a, $24
    jr nz, .continueHook
    inc a
    ld a, b
    ret

.continueHook:
    cp a, $22
    ret nz
    ld a, (ti.cxCurApp)
    cp a, ti.cxPrgmEdit
    ret nz
    bit keyPressed, (iy + celticFlags2)
    ret nz
    set keyPressed, (iy + celticFlags2)
    ld de, .displayProgInfo
    push de
    ld hl, (ti.editCursor)
    ld a, (hl)
    cp a, ti.tDet
    ret nz
    bit showLineNum, (iy + celticFlags1)
    ret z
    pop hl
    ld hl, (ti.editTail)
    inc hl
    ld a, (hl)
    sub a, ti.t0
    ret c
    cp a, ti.t9 - ti.t0 + 1
    jr c, .getNum

.return:
    or a, 1
    ret

.getNum:
    ld bc, (ti.editBtm)
    ld de, 0
    ld e, a

.loop:
    inc hl
    or a, a
    sbc hl, bc
    jr z, .endLoop
    add hl, bc
    ld a, (hl)
    sub a, ti.t0
    jr c, .endLoop
    cp a, ti.t9 - ti.t0 + 1
    jr nc, .endLoop
    push hl
    ex de, hl
    add hl, hl
    push hl
    pop de
    add hl, hl
    add hl, hl
    add hl, de
    ld de, 0
    ld e, a
    add hl, de
    ex de, hl
    pop hl
    jr .loop

.endLoop:
    ex de, hl
    ld de, (celticTableEnd - celticTableBegin) / 3
    ld bc, celticCommandsPtrs
    or a, a
    sbc hl, de
    jr nc, .return
    add hl, de
    ld h, 3
    mlt hl
    add hl, bc
    ld hl, (hl)

.drawText:
    push hl
    call ti.os.ClearStatusBarLow
    pop hl
    ld de, $E71C
    ld.sis (ti.drawFGColor and $FFFF), de
    ld.sis de, (ti.statusBarBGColor and $FFFF)
    ld.sis (ti.drawBGColor and $FFFF), de
    ld a, 14
    ld (ti.penRow), a
    ld de, 2
    ld.sis (ti.penCol and $FFFF), de
    call ti.VPutS
    ld de, $FFFF
    ld.sis (ti.drawBGColor and $FFFF), de
    inc a
    ret

.displayProgInfo:
    bit showLineNum, (iy + celticFlags1)
    ret nz
    push hl

    hookStrings.copy

    pop hl
    ld de, 1
    ld bc, (ti.editTop)

.loopFindLine:
    or a, a
    sbc hl, bc
    add hl, bc
    jr z, .lineFound
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .oneByteToken
    inc bc

.oneByteToken:
    inc bc
    cp a, ti.tEnter
    jr nz, .loopFindLine
    inc de
    jr .loopFindLine

.lineFound:
    ex de, hl
    ld de, numberText
    call .convertNumberToStr + 8
    ld hl, (ti.editCursor)
    inc hl
    ld bc, (ti.editTop)
    or a, a
    sbc hl, bc
    push hl
    dec hl
    ld de, byteNumber
    call .convertNumberToStr
    pop de
    ld hl, (ti.editBtm)
    ld bc, (ti.editTail)
    inc bc
    or a, a
    sbc hl, bc
    add hl, de
    ex de, hl
    ld hl, (ti.editSym)
    ld bc, -6
    add hl, bc
    ld a, (hl)
    add a, 9
    ld bc, 0
    ld c, a
    ex de, hl
    add hl, bc
    ld de, sizeNumText
    call .convertNumberToStr
    ld hl, programLineText
    jp .drawText

.convertNumberToStr: ; hl = number to convert; de = pointer to store text
    ld bc, -10000
    call .aqu
    ld bc, -1000
    call .aqu
    ld bc, -100
    call .aqu
    ld c, -10
    call .aqu
    ld c, b

.aqu:
    ld a, '0' - 1

.under:
    inc a
    add hl, bc
    jr c, .under
    sbc hl, bc
    ld (de), a
    inc de
    ret

getkeyHook:
    db $83
    or a, a
    ret z
    set showLineNum, (iy + celticFlags1)
    ld b, a
    ld a, (ti.cxCurApp)
    cp a, ti.cxPrgmEdit
    ld a, b
    ret nz
    ld a, (ti.menuCurrent)
    or a, a
    ld a, b
    ret nz
    res keyPressed, (iy + celticFlags2)
    cp a, ti.kLastEnt
    jr z, .setDrawLineNum
    push af
    call ti.os.ClearStatusBarLow
    pop af
    ret

.setDrawLineNum:
    res showLineNum, (iy + celticFlags1)
    xor a, a
    ret

stopTokenHook:
    db $83
    push af
    cp a, 2
    jr z, .maybeStop

.exitHook:
    pop af
    jp celticStart + 1

.maybeStop:
    ld a, $D9 - $CE ; stop token
    cp a, b
    jr nz, .exitHook
    xor a, a
    jp ti.JError
