;----------------------------------------
;
; Celtic CE Source Code - ainstall.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 31, 2023
;
;----------------------------------------

include 'include/ez80.inc'
include 'include/tiformat.inc'
format ti archived executable protected program 'AINSTALL'
include 'include/ti84pceg.inc'

beginAinstall:
    di
    ld hl, celticName
    call ti.FindAppStart
    jr c, return
    ld bc, $100
    add hl, bc
    push hl
    pop de
    ld bc, $1B
    add hl, bc
    ld hl, (hl)
    add hl, de
    push hl
    pop ix
    ld hl, (ix + 2)
    call ti.SetCursorHook
    ld hl, (ix + 5)
    call ti.SetGetKeyHook
    ld a, (ti.helpHookPtr + 2)
    or a, a
    jr nz, preserveChain
    sbc hl, hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)

preserveChain:
    bit ti.parserHookActive, (iy + ti.hookflags4)
    jr z, finishInstall
    ld de, (ti.parserHookPtr)
    ld hl, (ix + 8)
    or a, a
    sbc hl, de
    jr z, return
    ld a, (de)
    cp a, $83
    jr nz, finishInstall
    inc de
    ld (ti.helpHookPtr), de
    res ti.helpHookActive, (iy + ti.hookflags4)

finishInstall:
    ld hl, (ix + 8)
    call ti.SetParserHook

return:
    ei
    ret

celticName:
    db "CelticCE", 0
