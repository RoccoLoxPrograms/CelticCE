;----------------------------------------
;
; Celtic CE Source Code - macros.inc
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
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
		ld	hl, name.source?
		ld	de, name.destination?
		ld	bc, name.length?
		ldir
	end macro
	macro name.run
		name.copy
		jp	name.destination?
	end macro
	macro name.call
		name.copy
		call	name.destination?
	end macro
	macro end?.relocate?
		name.length? := $ - name.destination?
		org name.source? + name.length?
		purge end?.relocate?
	end macro
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
var8            equ ti.pixelShadow2 + 124 ; max of 9 arguments can be passed
noArgs          equ ti.pixelShadow2 + 127 ; number of arguments
ans             equ ti.pixelShadow2 + 130 ; temp storage for Ans (and other things)
EOF             equ ti.pixelShadow2 + 133 ; end of file address
bufSpriteX      equ ti.pixelShadow2 + 136 ; reserved for BufSprite, BufSpriteSelect, and PutSprite (and variants)
bufSpriteY      equ ti.pixelShadow2 + 139 ; ""
bufSpriteXStart equ ti.pixelShadow2 + 140 ; ""
currentWidth    equ ti.pixelShadow2 + 143 ; ""
xtempName       equ ti.pixelShadow2 + 146 ; XTEMP000 name
prgmName        equ ti.pixelShadow2 + 156 ; used to store a variable name
stackPtr        equ ti.pixelShadow2 + 167 ; used to preserve the stack pointer
execHexLoc      equ ti.pixelShadow2 + 170 ; location for storing ExecHex code (max size of 4096 bytes) (used for undefined, temp storage size in various commands)

;------------------------------------------------------------------------------------

x0 equ var1 ; used for the ChkRect command
y0 equ var2
w0 equ var3
h0 equ var4
x1 equ var5
y1 equ var6
w1 equ var7
h1 equ var8

XStart  equ execHexLoc + 0 ; used for the DrawArc command
YStart  equ execHexLoc + 3
XEnd    equ execHexLoc + 6
YEnd    equ execHexLoc + 9

;------------------------------------------------------------------------------------

archived        := 0 ; Celtic flags
hidden          := 1
invalidArg      := 2
keyPressed      := 3
insertLastLine  := 4
replaceLineRun  := 5
invertPixel     := 6
imaginaryList   := 7
randFlag        := 7 ; just so there's a flag without a specific purpose

tempNameNum     := xtempName + 7

;------------------------------------------------------------------------------------
