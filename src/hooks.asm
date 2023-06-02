;----------------------------------------
;
; Celtic CE Source Code - hooks.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

hookCheckStr: ; can be used as a hook identifier
    db "[CelticCE]", 0

celticStart:
    db $83
    push af
    or a, a
    jr z, chain
    ld a, $B3 ; det( token
    cp a, b
    jr z, hookTriggered

chain:
    ld a, (ti.helpHookPtr + 2)
    or a, a
    jr z, noChain
    ld ix, (ti.helpHookPtr)
    ld a, (ix - 1)
    cp a, $83
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
    ex de, hl
    ld a, (hl)
    dec a
    jr nz, popReturnOS
    inc hl
    ld a, (hl)
    dec a
    jr nz, popReturnOS
    inc hl
    inc hl
    inc hl
    ld a, (hl)
    cp a, $20
    jr nz, popReturnOS
    ld de, 90
    ex de, hl
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    pop bc
    pop hl
    ei
    or a, 1
    ret

popReturnOS:
    pop bc
    pop hl
    jp returnOS

hookTriggered:
    pop af
    di
    ld (stackPtr), sp
    ld (noArgs), hl
    push hl
    ld de, 9
    ex de, hl
    or a, a
    sbc hl, de
    pop hl
    jp c, PrgmErr.2MARG
    ld a, (ti.OP1)
    cp a, $02 ; matrix type
    jr z, matrixType
    ld a, l
    or a, a
    jp z, returnOS ; check if there are zero args
    call ti.PushRealO1 ; push so all args are on FPS
    ld a, (noArgs)
    dec a
    ld b, a
    add a, a
    add a, b
    ld de, 0
    ld e, a
    ld hl, var0
    add hl, de ; get address to start pushing args to
    ld a, (noArgs)
    ld b, a ; set for loop

popArgs:
    push bc
    push hl
    call ti.PopRealO1
    ld a, (ti.OP1)
    or a, a
    jr nz, removeAllArgs
    call ti.TRunc
    call ConvOP1
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

.clearArgs:
    push bc
    call ti.PopRealO1
    pop bc
    djnz .clearArgs
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
    dl scrollScreen
    dl rgbto565
    dl drawRect
    dl drawCircle
    dl fillCircle
    dl drawArc
    dl dispTransText
    dl chkRect ; det(65)
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
    ld hl, (ti.editCursor)
    ld a, (hl)
    cp a, $B3
    ret nz
    bit keyPressed, (iy + ti.asm_Flag2)
    ret nz
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
    push hl
    call ti.os.ClearStatusBarLow
    pop hl
    ld hl, (hl)
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
    set keyPressed, (iy + ti.asm_Flag2)
    inc a
    ret

getkeyHook:
    db $83
    or a, a
    ret z
    ld b, a
    ld a, (ti.cxCurApp)
    cp a, ti.cxPrgmEdit
    ld a, b
    ret nz
    ld a, (ti.menuCurrent)
    or a, a
    ld a, b
    ret nz
    push af
    call ti.os.ClearStatusBarLow
    res keyPressed, (iy + ti.asm_Flag2)
    pop af
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
    ld a, $D9 - $CE
    cp a, b
    jr nz, .exitHook
    ld a, ti.E_AppErr1
    jp ti.JError
