;----------------------------------------
;
; Celtic CE Source Code - macros.inc
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: September 9, 2026
;
;----------------------------------------

include 'ez80.inc'
include 'tiformat.inc'
format ti archived executable protected program 'CELTICCE'
include 'app.inc'
include 'ti84pceg.inc'

macro relocate? name, address* ; macro by MateoConLechuga
    name.source? := $
    name.destination? := address
    org name.destination?
    macro name.copy?
        ld hl, name.source?
        ld de, name.destination?
        ld bc, name.length?
        ldir
    end macro
    macro name.run
        name.copy
        jp name.destination?
    end macro
    macro name.call
        name.copy
        call name.destination?
        end macro
        macro end?.relocate?
        name.length? := $ - name.destination?
        org name.source? + name.length?
        purge end?.relocate?
        end macro
end macro

macro spi cmd, params& ; macro by jacobly
    ld a, cmd
    call _spiCmd
    match any, params
        iterate param, any
            ld a, param
            call _spiParam
        end iterate
    end match
end macro

spiValid := 8

macro iconData?
    db $10, $10
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $07, $25, $25, $07, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $07, $25, $8F, $8F, $25, $07, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $25, $8F, $07, $25, $8F, $25, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $25, $8F, $25, $8F, $8F, $25, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $8F, $8F, $25, $8F, $25, $25, $07, $07, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $8F, $25, $07, $25, $25, $25, $25, $25, $25, $8F, $FF, $FF, $FF
    db $FF, $FF, $07, $25, $8F, $25, $8F, $25, $25, $8F, $8F, $8F, $25, $07, $FF, $FF
    db $FF, $FF, $07, $25, $07, $25, $8F, $25, $25, $8F, $25, $07, $25, $07, $FF, $FF
    db $FF, $FF, $07, $25, $8F, $8F, $8F, $25, $8F, $8F, $25, $8F, $25, $07, $FF, $FF
    db $FF, $FF, $FF, $8F, $25, $25, $25, $8F, $FF, $8F, $07, $25, $8F, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $07, $07, $07, $FF, $FF, $FF, $8F, $8F, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
end macro

;------------------------------------------------------------------------------------

var0            equ ti.pixelShadow2 + 100 ; arguments from first to last (first argument is command number)
var1            equ ti.pixelShadow2 + 103 ; 
var2            equ ti.pixelShadow2 + 106 ; 
var3            equ ti.pixelShadow2 + 109 ; 
var4            equ ti.pixelShadow2 + 112 ; 
var5            equ ti.pixelShadow2 + 115 ; 
var6            equ ti.pixelShadow2 + 118 ; 
var7            equ ti.pixelShadow2 + 121 ;
var8            equ ti.pixelShadow2 + 124 ; 
var9            equ ti.pixelShadow2 + 127 ; max of 10 arguments can be passed
noArgs          equ ti.pixelShadow2 + 130 ; number of arguments
ans             equ ti.pixelShadow2 + 133 ; temp storage for Ans (and other 3 byte values)
EOF             equ ti.pixelShadow2 + 136 ; end of file address
bufSpriteX      equ ti.pixelShadow2 + 139 ; reserved for BufSprite, BufSpriteSelect, and PutSprite (and variants)
bufSpriteY      equ ti.pixelShadow2 + 142 ; ""
bufSpriteXStart equ ti.pixelShadow2 + 143 ; ""
currentWidth    equ ti.pixelShadow2 + 146 ; ""
xtempName       equ ti.pixelShadow2 + 149 ; XTEMP000 name
prgmName        equ ti.pixelShadow2 + 159 ; used to store a variable name
stackPtr        equ ti.pixelShadow2 + 170 ; used to preserve the stack pointer
xlibColorOffset equ ti.pixelShadow2 + 173 ; color offset stored for xlibc
currentGram     equ ti.pixelShadow2 + 174 ; current GRAM buffer to draw at
halfresOn       equ ti.pixelShadow2 + 175 ; 1 if half-res is turned on
invertOn        equ ti.pixelShadow2 + 176 ; 1 if screen is inverted
realBackup      equ ti.pixelShadow2 + 177 ; location for Real var backup
stringLen       equ ti.pixelShadow2 + 186 ; length byte for backup string
stringBackup    equ ti.pixelShadow2 + 187 ; loaction for string var backup (max of 256 bytes)
execHexLoc      equ ti.pixelShadow2 + 443 ; location for storing ExecHex code (max size of 4096 bytes) (used for undefined, temp storage size in various commands)

xlibc0          equ ti.pixelShadow2 + 500 ; start storing xlibc vars here
xlibc1          equ ti.pixelShadow2 + 509 ; 
xlibc2          equ ti.pixelShadow2 + 518 ; 
xlibc3          equ ti.pixelShadow2 + 527 ; 
xlibc4          equ ti.pixelShadow2 + 536 ; 
xlibc5          equ ti.pixelShadow2 + 545 ; 
xlibc6          equ ti.pixelShadow2 + 554 ; 
xlibc7          equ ti.pixelShadow2 + 563 ; 
xlibc8          equ ti.pixelShadow2 + 572 ; 
xlibc9          equ ti.pixelShadow2 + 581 ; 
xlibc10         equ ti.pixelShadow2 + 590 ; 
xlibc11         equ ti.pixelShadow2 + 599 ; 
xlibc12         equ ti.pixelShadow2 + 608 ; 
xlibc13         equ ti.pixelShadow2 + 617 ; 
xlibc14         equ ti.pixelShadow2 + 626 ; 
xlibc15         equ ti.pixelShadow2 + 635 ; 
xlibc16         equ ti.pixelShadow2 + 644 ; 
xlibc17         equ ti.pixelShadow2 + 653 ; 
xlibc18         equ ti.pixelShadow2 + 662 ; 
xlibc19         equ ti.pixelShadow2 + 671 ; max of 20 arguments can be passed
xlibcInt0       equ ti.pixelShadow2 + 680 ; integer values of commands
xlibcInt1       equ ti.pixelShadow2 + 683 ; 
xlibcInt2       equ ti.pixelShadow2 + 686 ; 
xlibcInt3       equ ti.pixelShadow2 + 689 ; 
xlibcInt4       equ ti.pixelShadow2 + 692 ; 
xlibcInt5       equ ti.pixelShadow2 + 695 ; 
xlibcInt6       equ ti.pixelShadow2 + 698 ; 
xlibcInt7       equ ti.pixelShadow2 + 701 ; 
xlibcInt8       equ ti.pixelShadow2 + 704 ; 
xlibcInt9       equ ti.pixelShadow2 + 707 ; 
xlibcInt10      equ ti.pixelShadow2 + 710 ; 
xlibcInt11      equ ti.pixelShadow2 + 713 ; 
xlibcInt12      equ ti.pixelShadow2 + 716 ; 
xlibcInt13      equ ti.pixelShadow2 + 719 ; 
xlibcInt14      equ ti.pixelShadow2 + 722 ; 
xlibcInt15      equ ti.pixelShadow2 + 725 ; 
xlibcInt16      equ ti.pixelShadow2 + 728 ; 
xlibcInt17      equ ti.pixelShadow2 + 731 ; 
xlibcInt18      equ ti.pixelShadow2 + 734 ; 
xlibcInt19      equ ti.pixelShadow2 + 737 ; max of 20 args
xlibcFont       equ ti.pixelShadow2 + 740 ; which font is selected
randSeed        equ ti.pixelShadow2 + 741 ; holds temp random seed
yShiftSPI       equ ti.pixelShadow2 + 741 ; 8-bit value for y-value for shifting
drawStringTemp  equ ti.pixelShadow2 + 745 ; temp storage for string conversion

;------------------------------------------------------------------------------------

tempNameNum     := xtempName + 7

x0 equ var1 ; used for the ChkRect command
y0 equ var2
w0 equ var3
h0 equ var4
x1 equ var5
y1 equ var6
w1 equ var7
h1 equ var8

XStart equ execHexLoc + 0 ; used for the DrawArc command
YStart equ execHexLoc + 3
XEnd   equ execHexLoc + 6
YEnd   equ execHexLoc + 9

; xlibce uservars
uservars equ ti.plotSScreen ; uservars start here. There are 256 of them, spaced out by 9 bytes
picSlot0 equ ti.plotSScreen + (9 * 256) ; sprite/map data starts here

; misc equates for commands
vBuffer equ ti.vRam + ti.lcdWidth

;------------------------------------------------------------------------------------

celticFlags1    := ti.asm_Flag1 ; Celtic flags
searchAppvars   := 0
largeFont       := 1
isProgram       := 2
showErrorOffset := 3
deleteLineOne   := 4
showLineNum     := 5 ; this flag is flipped, it will be set to not show the line number and reset to show it
negative        := 6

celticFlags2    := ti.asm_Flag2
archived        := 0
hidden          := 1
invalidArg      := 2
keyPressed      := 3
insertLastLine  := 4
replaceLineRun  := 5
invertPixel     := 6
imaginaryList   := 7

;------------------------------------------------------------------------------------
