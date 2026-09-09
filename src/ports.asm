;----------------------------------------
;
; Celtic CE Source Code - ports.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: September 9, 2026
;
;----------------------------------------

portSetup:
    di
    ld hl, ($000008 + 5)
    ld a, (hl)
    cp a, $CD
    ret nz
    inc hl
    ld de, (hl)
    ld hl, (ti.CheckIfEmulated + 1)
    sbc hl, de
    ret nz
    ld hl, (ti.KeypadScanFull + 1)
    ld bc, 10
    add hl, bc
    push hl
    ld b, portPattern.size
    ld de, portPattern
    call ti.StrCmpre
    pop hl
    ret nz
    ld (portUnlock.target), hl
    xor a, a
    ret

portPattern:
    db $ED, $79, $78, $FE, $A0, $28, $01, $CF
.size := $-.

portUnlock:
    push iy, de, bc, hl
    call ti._frameset0
    ld iy, .unlockFinish
    ld sp, ti._indcall + 7
    ld bc, $22
    xor a, a

.target := $ + 1
    jp 0

.unlockFinish:
    ld sp, ix
    pop ix
    ld a, $8C
    out0 ($24), a
    in0 a, ($06)
    or a, 4
    out0 ($06), a
    jr portLock.pop

portLock:
    push iy, de, bc, hl
    xor a, a
    out0 ($28), a
    in0 a, ($06)
    res 2, a
    out0 ($06), a
    ld a, $88
    out0 ($24), a
    ld a, $D1
    out0 ($22), a

.pop:
    pop hl, bc, de, iy
    ret

portWrite:
    ld de, $C979ED
    ld hl, ti.heapBot - 3
    ld (hl), de
    jp (hl)

portRead:
    ld de, $C978ED
    ld hl, ti.heapBot - 3
    ld (hl), de
    jp (hl)
