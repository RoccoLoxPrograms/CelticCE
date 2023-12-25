; Copyright (c) 2016, Christopher Mitchell
; All rights reserved.
; 
; Redistribution and use in source and binary forms, with or without modification,
; are permitted under the following conditions:
; 1. Redistributions of a substantial percentage of the source code (defined as 400
;    or more lines of the original source) or that source code in binary form require
;    express written permission from Christopher Mitchell, and must reproduce the
;    above copyright notice, this list of conditions and the following disclaimer in
;    the documentation and/or other materials provided with the distribution.
; 2. Redistributions of fewer than 400 lines of source must attribute the original
;    project by name and author in source and (if applicable) in documentation, but
;    may be redistributed under any BSD 3-clause-compatible, GPL-compatible, or All
;    Rights Reserved license, except where exempted by written permission from
;    Christopher Mitchell. Redistribution of a binary containing fewer than 400
;    lines of source also requires only attribution.
; 3. The name of the copyright holder, the names of its contributors, and the
;    name(s) under which the copyright holder(s) released this work may not be used
;    to endorse or promote products derived from this software without specific
;    prior written permission.
; 
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
; IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
; INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
; OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
; OF THE POSSIBILITY OF SUCH DAMAGE.
;
; ----------------------------------------------------------------------------------
;
; Modified for Celtic CE by RoccoLox Programs.
; This will only convert positive, real integers.
; Returns with the carry flag reset if an invalid number was passed.
; Else returns with the carry flag set and the converted number in de.

ConvOP1:
    call ti.TRunc
    di
    ld hl, ti.OP1 + 1
    ld de, 0
    ld a, -$7F
    add a, (hl)
    ret nc
    inc hl
    cp a, 6
    ret nc
    ld (ans), sp
    ex de, hl
    ld b, a
    cpl
    add a, 6
    ld c, a
    add a, a
    add a, c
    ld l, a
    ld sp, ConvOp1CT
    add hl, sp
    ld sp, hl
    or a, a
    sbc hl, hl
    ld a, b

ConvOp1CL:
    ex af, af'
    pop bc
    ld a, (de)
    and a, $F0
    rrca
    rrca
    rrca
    rrca
    sub a, 1
    jr c, $ + 5
    add hl, bc
    jr $ - 5
    ex af, af'
    dec a
    jr z, ConvOp1CE
    ex af, af'
    pop bc
    ld a, (de)
    and a, $0F
    sub a, 1
    jr c, $ + 5
    add hl, bc
    jr $ - 5
    inc de
    ex af, af'
    dec a
    jr nz, ConvOp1CL

ConvOp1CE:
    ex de, hl
    ld sp, (ans)
    call ti.SetAToDEU
    or a, a
    ret nz
    scf
    ret

ConvOp1CT:
    dl 10000
    dl 1000
    dl 100
    dl 10
    dl 1
