;----------------------------------------
;
; Celtic CE Source Code - error.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: July 24, 2023
;
;----------------------------------------

PrgmErr:
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, 9
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    pop hl
    ldir
    jp return

; Celtic error codes

.PISFN:
    call PrgmErr
    db "::P>IS>FN"

.NUMSTNG:
    call PrgmErr
    db "::NUMSTNG"

.NULLVAR:
    call PrgmErr
    db "::NULLVAR"

.LNTFN:
    call PrgmErr
    db "::L>NT>FN"

.SNTFN:
    call PrgmErr
    db "::S>NT>FN"

.SFLASH:
    call PrgmErr
    db "::S>FLASH"

.SNTST:
    call PrgmErr
    db "::S>NT>ST"

.NOMEM:
    call PrgmErr
    db "::NT>EN>M"

.PNTFN:
    call PrgmErr
    db "::P>NT>FN"

.PGMARC:
    call PrgmErr
    db "::PGM>ARC"

.INVALA:
    call PrgmErr
    db "::INVAL>A"

.NULLSTR:
    call PrgmErr
    db "::NULLSTR"

.NTREAL:
    call PrgmErr
    db "::NT>REAL"

.INVALS:
    call PrgmErr
    db "::INVAL>S"

.2MARG:
    call PrgmErr
    db "::2>M>ARG"

.NTALS:
    call PrgmErr
    db "::NT>A>LS"

.ENTFN:
    call PrgmErr
    db "::E>NT>FN"

.GNTFN:
    call PrgmErr
    db "::G>NT>FN"

.NTAGP:
    call PrgmErr
    db "::NT>A>GP"

.SUPPORT:
    call PrgmErr
    db "::SUPPORT"
