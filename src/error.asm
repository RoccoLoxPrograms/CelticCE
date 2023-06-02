;----------------------------------------
;
; Celtic CE Source Code - error.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

PrgmErr:
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
    pop hl
    ld bc, 9
    ldir
    jp return

; Celtic error codes

.PISFN:
    call PrgmErr
    db "::P>IS>FN", 0

.NUMSTNG:
    call PrgmErr
    db "::NUMSTNG", 0

.NULLVAR:
    call PrgmErr
    db "::NULLVAR", 0

.LNTFN:
    call PrgmErr
    db "::L>NT>FN", 0

.SNTFN:
    call PrgmErr
    db "::S>NT>FN", 0

.SFLASH:
    call PrgmErr
    db "::S>FLASH", 0

.SNTST:
    call PrgmErr
    db "::S>NT>ST", 0

.NOMEM:
    call PrgmErr
    db "::NT>EN>M", 0

.PNTFN:
    call PrgmErr
    db "::P>NT>FN", 0

.PGMARC:
    call PrgmErr
    db "::PGM>ARC", 0

.INVALA:
    call PrgmErr
    db "::INVAL>A", 0

.NULLSTR:
    call PrgmErr
    db "::NULLSTR", 0

.NTREAL:
    call PrgmErr
    db "::NT>REAL", 0

.INVALS:
    call PrgmErr
    db "::INVAL>S", 0

.2MARG:
    call PrgmErr
    db "::2>M>ARG", 0

.NTALS:
    call PrgmErr
    db "::NT>A>LS", 0

.ENTFN:
    call PrgmErr
    db "::E>NT>FN", 0

.GNTFN:
    call PrgmErr
    db "::G>NT>FN", 0

.NTAGP:
    call PrgmErr
    db "::NT>A>GP", 0

.SUPPORT:
    call PrgmErr
    db "::SUPPORT", 0
