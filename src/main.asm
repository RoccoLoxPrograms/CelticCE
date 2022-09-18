;--------------------------------------
;
; Celtic CE Source Code - main.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022
; License: BSD 3-Clause License
; Last Built: September 17, 2022
;
;--------------------------------------

var0            equ ti.pixelShadow + 00 ; arguments from first to last (first argument is command number)
var1            equ ti.pixelShadow + 03 ; 
var2            equ ti.pixelShadow + 06 ; 
var3            equ ti.pixelShadow + 09 ; 
var4            equ ti.pixelShadow + 12 ; 
var5            equ ti.pixelShadow + 15 ; 
var6            equ ti.pixelShadow + 18 ; 
var7            equ ti.pixelShadow + 21 ; max of 8 arguments can be passed
noArgs          equ ti.pixelShadow + 24 ; number of arguments
ans             equ ti.pixelShadow + 27 ; temp storage for Ans
EOF             equ ti.pixelShadow + 30 ; end of file address
bufSpriteX      equ ti.pixelShadow + 33 ; reserved for BufSprite and BufSpriteSelect
bufSpriteY      equ ti.pixelShadow + 36 ; ""
bufSpriteXStart equ ti.pixelShadow + 37 ; ""
currentWidth    equ ti.pixelShadow + 40 ; ""
xtempName       equ ti.pixelShadow + 43 ; XTEMP000 name
prgmName        equ ti.pixelShadow + 53 ; Used to store a variable name
execHexLoc      equ ti.pixelShadow + 64 ; Location for storing ExecHex code (could be any size)

;------------------------------------------------------------------------------------

archived        := 0 ; Celtic flags
hidden          := 1
invalidArg      := 2
keyPressed      := 3
insertLastLine  := 4
replaceLineRun  := 5
tempNameNum     := xtempName + 7

;------------------------------------------------------------------------------------

if flag_prerelease

installPage:
    ld b, 255
    call ti.ClrScrn
    call ti.HomeUp
    ld hl, warningMsg
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS
    call waitAnyKey

installPageSkipWarn:

else

installPage:

end if

    set ti.fracDrawLFont, (iy + ti.fontFlags)
    call ti.RunIndicOff
    ld hl, $4249
    ld (ti.fillRectColor), hl
    ld hl, 0 ; top left x coord
    ld de, 319 ; bottom right x coord
    ld b, 0 ; top left y coord
    ld c, 239 ; bottom right y coord
    call ti.FillRect
    ld hl, $4249 ; dark grey
    ld (ti.drawBGColor), hl
    ld hl, $FFFF ; white
    ld (ti.drawFGColor), hl
    ld hl, 11
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, installScrnLine1
    call ti.VPutS
    ld hl, 65
    ld (ti.penCol), hl
    ld a, 25
    ld (ti.penRow), a
    ld hl, versionString
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 65
    ld (ti.penRow), a
    call loadInstallOption
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 85
    ld (ti.penRow), a
    ld hl, installScrnOption2
    call ti.VPutS
    ld hl, 5
    ld (ti.penCol), hl
    ld a, 105
    ld (ti.penRow), a
    ld hl, installScrnOption3
    call ti.VPutS

selectOption:
    call ti.GetCSC
    cp a, ti.sk1
    jr z, testOption
    cp a, ti.sk2
    jr z, testOption
    cp a, ti.sk3
    jr z, testOption
    cp a, ti.skClear
    jr z, exitCelticApp
    jr selectOption

testOption:
    cp a, ti.sk1
    jp z, installHook
    cp a, ti.sk2
    jr z, aboutScrn

exitCelticApp:
    res ti.fracDrawLFont, (iy + ti.fontFlags)
    ld hl, 0
    ld (ti.drawBGColor), hl
    call ti.ClrScrn
    call ti.DrawStatusBar
    call ti.HomeUp
    jp ti.JForceCmdNoChar

loadInstallOption:
    ld hl, installScrnOption1
    bit ti.parserHookActive, (iy + ti.hookflags4)
    ret z
    ld hl, (ti.parserHookPtr)
    ld de, celticStart
    or a, a
    sbc hl, de
    ld hl, installScrnOption1
    ret nz
    ld hl, installScrnOption1Alt
    ret

aboutScrn:
    ld hl, 0
    ld de, 319
    ld b, 0
    ld c, 239
    call ti.FillRect
    ld hl, 107
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, aboutScrnLine1
    call ti.VPutS
    ld hl, 65
    ld (ti.penCol), hl
    ld a, 25
    ld (ti.penRow), a
    ld hl, versionString
    call ti.VPutS
    ld hl, 41
    ld (ti.penCol), hl
    ld a, 105
    ld (ti.penRow), a
    ld hl, aboutScrnLine2
    call ti.VPutS
    ld hl, $000047
    ld (ti.penCol), hl
    ld a, 125
    ld (ti.penRow), a
    ld hl, aboutScrnLine3
    call ti.VPutS
    ld hl, 3
    ld (ti.penCol), hl
    ld a, 221
    ld (ti.penRow), a
    ld hl, copyright
    call ti.VPutS
    call waitAnyKey
    cp a, ti.skClear
    jq z, exitCelticApp

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

installHook:
    call ti.HomeUp
    ld hl, 0
    ld de, 319
    ld b, 0
    ld c, 239
    call ti.FillRect
    ld hl, $FFFF
    ld de, $4249
    call ti.SetTextFGBGcolors_
    bit ti.parserHookActive, (iy + ti.hookflags4)
    jq nz, checkHook

finishInstall:
    ld hl, celticStart
    call ti.SetParserHook
    ld hl, getkeyHook
    call ti.SetGetKeyHook
    ld hl, cursorHook
    call ti.SetCursorHook
    ld hl, celticInstalledMsg

displayInstallmsg:
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS
    call waitAnyKey

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

checkHook:
    ld hl, (ti.parserHookPtr)
    ld de, celticStart
    or a, a
    sbc hl, de
    jr z, uninstallHook
    add hl, de
    ld a, (hl)
    cp a, $83
    jq nz, finishInstall
    inc hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    jq finishInstall

uninstallHook:
    call ti.ClrParserHook
    call uninstallChain
    call ti.ClrCursorHook
    call ti.ClrGetKeyHook
    call ti.ClrRawKeyHook
    ld hl, celticUninstalledMsg
    jq displayInstallmsg

uninstallChain:
    ld hl, 0
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    ret

matrixType:
    push hl
    push bc
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
    jp return + 4

popReturnOS:
    pop bc
    pop hl
    jp returnOS

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
    cp a, 0
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

hookTriggered:
    pop af
    ld (noArgs), hl
    ld de, 8
    ex de, hl
    or a, a
    sbc hl, de
    jp c, PrgmErr.2MARG
    ld a, (ti.OP1)
    cp a, $02 ; matrix type
    jq z, matrixType
    ld a, l
    cp a, 0
    jp z, returnOS ; check if there are zero args
    di
    call ti.PushRealO1 ; push so all args are on FPS
    ld b, 2 ; for the djnz loop later
    ld a, (noArgs)
    sub a, 1
    ld h, a
    cp a, 0
    jr z, skipLoop ; skip if there is only one arg

mltLoop:
    add a, h ; figure out how much to add to var0 address to push the args backwards
    djnz mltLoop

skipLoop:
    ld hl, $000000
    ld l, a
    ex de, hl
    ld hl, var0
    add hl, de ; get address to start pushing args to
    ld a, (noArgs)
    ld b, a ; set for loop
    res invalidArg, (iy + ti.asm_Flag2)

popArgs: ; loopy thingy
    push bc
    push hl
    call ti.PopRealO1
    ld a, (ti.OP1)
    cp a, $00
    call nz, invalid
    call ti.TRunc
    call ti.ConvOP1
    pop hl
    ld (hl), de
    dec hl ; go down one var
    dec hl
    dec hl
    pop bc ; restore so djnz can use it
    djnz popArgs

hookTriggeredCont:
    bit invalidArg, (iy + ti.asm_Flag2)
    jp nz, PrgmErr.INVALA
    ld a, (var0)
    cp a, (celticTableEnd - celticTableBegin) / 4
    jp nc, PrgmErr.SUPPORT
    add a, a
    add a, a
    ld hl, celticTableBegin
    ld de, $000000
    ld e, a
    add hl, de
    res replaceLineRun, (iy + ti.asm_Flag2)
    jp (hl)

invalid:
    set invalidArg, (iy + ti.asm_Flag2)
    ret

celticTableBegin:
    jp readLine ; det(0)
    jp replaceLine ; det(1)
    jp insertLine ; and so on...
    jp specialChars
    jp createVar
    jp arcUnarcVar
    jp deleteVar
    jp deleteLine
    jp varStatus
    jp bufSprite
    jp bufSpriteSelect
    jp execArcPrgm
    jp dispColor
    jp dispText
    jp execHex
    jp textRect ; det(15)
celticTableEnd:

returnOS: ; return and let the OS handle the function
    ei
    cp a, a
    ret

return:
    call ti.RclAns
    ei
    or a, 1
    ret

readLine:
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
    jr z, .read
    dec hl
    ld (hl), $05

.read:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    push de
    jr z, .inRAM
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, $000000
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push hl ; size of var
    push de ; beginning of data
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $00
    jq nz, .errorNTREAL
    call ti.ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jq z, .getNumOfLines
    ld hl, 1
    or a, a
    sbc hl, de
    jq z, .readLineOne
    pop de
    pop hl
    call _getEOF
    push de
    pop bc
    ld de, 1
    ld ix, readLine.errorLNTFN
    call _searchLine
    ld de, 0
    push bc
    pop hl
    call _getNextLine
    dec de
    inc hl

.createDataStr:
    push hl ; start of data
    push de ; bytes to read
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    pop hl
    pop ix
    push de ; start of string
    push hl ; start address to read from
    push ix ; start address of variable
    push bc
    call ti.OP6ToOP1
    call ti.ChkFindSym
    pop bc
    pop hl
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    or a, a
    sbc hl, de
    pop de
    push hl
    ld hl, 1
    or a, a
    sbc hl, bc
    jq nc, .readOneOrZero
    pop hl
    ldir
    jp return

.readLineOne:
    pop de
    pop hl
    call _getEOF
    push de
    pop bc
    ld de, 0
    or a, a
    sbc hl, de
    jr z, .errorNULL
    push bc
    pop hl
    call _getNextLine
    ld a, (hl)
    cp a, $3F
    jr nz, .createDataStr

.decrementLen:
    dec de
    jr .createDataStr

.readOneOrZero:
    ld hl, 0
    or a, a
    sbc hl, bc
    pop hl
    jp z, PrgmErr.NULLSTR
    ldi
    jp return

.errorLNTFN:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.LNTFN

.errorNTREAL:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.NTREAL

.errorNULL:
    pop hl
    jp PrgmErr.NULLSTR

.getNumOfLines:
    pop bc
    pop hl
    push bc
    pop de
    call _getEOF
    ld de, 1 ; line counter

.loopFindLines:
    ld ix, _decBCretZ
    call _checkEOF ; returns z if hit EOF
    jr z, .foundLines
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .oneByteTok
    inc bc

.oneByteTok:
    cp a, $3F
    jr nz, .skipIncLine
    inc de

.skipIncLine:
    inc bc
    jr .loopFindLines

.foundLines:
    push de
    ld hl, Theta
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    pop hl
    call ti.CreateReal
    pop hl
    push de
    call ti.SetxxxxOP2
    pop de
    ld hl, ti.OP2
    ld bc, 9
    ldir
    pop hl
    jp PrgmErr.NUMSTNG

replaceLine:
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    set replaceLineRun, (iy + ti.asm_Flag2)
    jp deleteLine

insertLine:
    res insertLastLine, (iy + ti.asm_Flag2)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push hl ; size of string
    push de ; start of string
    call ti.EnoughMem
    jq c, .errorNOMEM
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jq c, .errorSNTFN
    call ti.ChkInRam
    jq nz, .errorSFLASH
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .continueInsert
    dec hl
    ld (hl), $05

.continueInsert:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jq c, .errorPNTFN
    call ti.ChkInRam
    jq nz, .errorPGMARC
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    call _getEOF
    push de ; start of program
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $00
    jq nz, .errorNTREAL
    call ti.ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jq z, .errorLNTFN
    pop bc
    push bc
    ld hl, 1
    or a, a
    sbc hl, de
    jr z, .insertMem
    ld de, 1
    ld ix, _decBCretNZ
    call _searchLine
    call nz, .hitEOF
    inc bc

.insertMem:
    pop ix
    pop de
    pop hl
    push hl ; size of string
    push de ; start of string
    push bc
    pop de
    push de ; location of line
    push ix ; start of program
    inc hl
    push hl
    call ti.InsertMem
    pop de
    pop hl
    dec hl
    dec hl
    ld bc, $000000
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    add hl, bc
    ex de, hl
    dec hl
    ld (hl), e
    inc hl
    ld (hl), d
    pop de
    pop hl
    push de
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ex de, hl
    inc hl
    inc hl
    pop de
    pop bc
    push hl
    bit insertLastLine, (iy + ti.asm_Flag2)
    jr nz, .insertLineBtm
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByte
    pop hl
    ldir
    ld a, $3F
    ld (de), a
    jp return

.insertOneByte:
    pop hl
    ldi
    ld a, $3F
    ld (de), a
    jp return

.insertLineBtm:
    ld a, $3F
    ld (de), a
    inc de
    ld hl, 1
    or a, a
    sbc hl, bc
    jr z, .insertOneByteBtm
    pop hl
    ldir
    jp return

.insertOneByteBtm:
    pop hl
    ldi
    jp return

.hitEOF:
    set insertLastLine, (iy + ti.asm_Flag2)
    inc de
    dec bc
    ld hl, (ans)
    or a, a
    sbc hl, de
    ret z
    pop hl
    jq .errorLNTFN

.errorNOMEM:
    pop hl
    pop hl
    jp PrgmErr.NOMEM

.errorPNTFN:
    pop hl
    pop hl
    jp PrgmErr.PNTFN

.errorNTREAL:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.NTREAL

.errorLNTFN:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.LNTFN

.errorPGMARC:
    pop hl
    pop hl
    jp PrgmErr.PGMARC

.errorSFLASH:
    pop hl
    pop hl
    jp PrgmErr.SFLASH

.errorSNTFN:
    pop hl
    pop hl
    jp PrgmErr.SNTFN

_decBCretNZ:
    pop hl
    dec bc
    or a, 1
    ret

specialChars:
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
    ex de, hl
    ld (hl), $04
    inc hl
    ld (hl), $2A
    jp return

createVar:
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
    jr z, _createAppvar

_createProgram:
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 0
    call ti.CreateProg
    jp return

_createAppvar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 0
    call ti.CreateAppVar
    jp return

_getProgNameLen:
    ld a, (de)
    inc de
    inc de
    ret

arcUnarcVar:
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
    jr z, .arcUnarc
    dec hl
    ld (hl), $05

.arcUnarc:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.Arc_Unarc
    jp return

deleteVar:
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
    jr z, .delVar
    dec hl
    ld (hl), $05

.delVar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.DelVarArc
    jp return

deleteLine:
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
    jr z, .remove
    dec hl
    ld (hl), $05

.remove:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    push de
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    pop de
    call _getEOF.deleteLine
    push de
    push hl
    inc de
    push de
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $00
    jr nz, .errorNTREAL
    call ti.ConvOP1
    ld (ans), de
    or a, a
    ld hl, 0
    sbc hl, de
    jr z, .errorLNTFN2
    or a, a
    ld hl, 1
    sbc hl, de
    jr z, .delLineOne
    pop bc
    ld de, 1
    ld ix, deleteLine.errorLNTFN
    call _searchLine
    ld de, 0
    push bc
    pop hl
    call _getNextLine

.delete:
    push de
    call ti.DelMem
    pop de
    pop hl
    or a, a
    sbc hl, de
    pop ix
    ld (ix), l
    inc ix
    ld (ix), h
    bit replaceLineRun, (iy + ti.asm_Flag2)
    jp nz, insertLine
    jp return

.delLineOne:
    pop bc
    ld de, 0
    push bc
    pop hl
    call _getNextLine
    call z, _decDEretZ
    jr .delete

.errorLNTFN:
    pop hl

.errorLNTFN2:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.LNTFN

.errorNTREAL:
    pop hl
    pop hl
    pop hl
    jp PrgmErr.NTREAL

_searchLine: ; bc = address being read; de = line counter; ix = where to jump at EOF; hl is destroyed
    call _checkEOF
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .not2byte
    inc bc
    inc bc
    jr _searchLine

.not2byte:
    inc bc
    cp a, $3F
    jr nz, _searchLine
    inc de
    ld hl, (ans)
    or a, a
    sbc hl, de
    jr z, _decBCretZ
    jr _searchLine

_decBCretZ:
    dec bc
    cp a, a
    ret

_decDEretZ:
    dec de
    cp a, a
    ret

_checkEOF: ; bc = current address being read; ix = where to jump back to; destroys hl and a
    ld hl, (EOF)
    inc hl
    or a, a
    sbc hl, bc
    ret nc
    jp (ix)

_getEOF: ; args: hl = size of var; de = start of variable; preserves both registers
    push hl
    dec hl
    add hl, de
    ld (EOF), hl
    pop hl
    ret

.deleteLine:
    push hl
    inc hl
    add hl, de
    ld (EOF), hl
    pop hl
    ret

_getNextLine: ; bc = address being read; de = byte counter; preserves hl (starting address)
    inc bc
    inc de
    ld ix, _decBCretZ
    push hl
    call _checkEOF
    pop hl
    ret z
    ld a, (bc)
    call ti.Isa2ByteTok
    jr nz, .not2byteTok
    inc bc
    inc de
    jr _getNextLine

.not2byteTok:
    cp a, $3F
    jr nz, _getNextLine
    or a, 1 ; return nz
    ret

varStatus:
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
    jr z, .getStatus
    dec hl
    ld (hl), $05

.getStatus:
    res archived, (iy + ti.asm_Flag2)
    res hidden, (iy + ti.asm_Flag2)
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    ; in case someone checked with a name that would be hidden
    ld a, (ti.OP1 + 1)
    cp a, $41
    jr nc, .notHidden
    set hidden, (iy + ti.asm_Flag2)

.notHidden:
    push de
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    pop hl
    call ti.Mov9ToOP1
    ld hl, 9
    call ti.CreateStrng
    inc de
    inc de
    push de
    ex de, hl
    ld bc, 9
    ld a, $30
    call ti.MemSet
    pop de
    pop bc
    push de
    push bc
    ex de, hl
    ld (hl), $52
    inc hl
    ld (hl), $56
    inc hl
    ld (hl), $4C
    pop de
    call ti.ChkInRam
    pop hl
    call nz, .archived
    inc hl
    bit hidden, (iy + ti.asm_Flag2)
    call nz, .hidden
    push hl
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .appvar
    dec hl

.appvar:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ld a, (hl)
    pop hl
    inc hl
    cp a, $05
    call z, .unlocked
    inc hl
    ld (hl), $29
    inc hl
    push hl
    bit archived, (iy + ti.asm_Flag2)
    call nz, .isArchived
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    ld a, 6
    call ti.FormEReal
    ld hl, ti.OP3
    call ti.StrLength
    ld a, c
    cp a, 1
    jr z, .lengthOne
    push bc
    pop de
    ld hl, 5
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3
    call ti.StrLength
    ldir
    jp return

.archived:
    set archived, (iy + ti.asm_Flag2)
    ld (hl), $41
    ret

.hidden:
    ld (hl), $48
    ret

.unlocked:
    ld (hl), $57
    ret

.lengthOne:
    pop hl
    ld de, 4
    add hl, de
    ex de, hl
    ld hl, ti.OP3
    ld a, (hl)
    ex de, hl
    ld (hl), a
    jp return

.isArchived:
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, $000000
    ld c, a
    add hl, bc
    ex de, hl
    ret

_checkHidden:
    ld hl, prgmName + 1
    ld a, (ti.OP1)
    cp a, $15
    jr nz, .check
    inc hl

.check:
    ld a, (hl)
    sub a, 64
    ld (hl), a
    dec hl
    res hidden, (iy + ti.asm_Flag2)
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    ret c
    set hidden, (iy + ti.asm_Flag2)
    ret

bufSprite:
    ld a, (noArgs)
    cp a, 5
    jp nc, PrgmErr.INVALA
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld de, $000000
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    push de
    res ti.graphDraw, (iy + ti.graphFlags)
    res ti.plotLoc, (iy + ti.plotFlags)
    ld hl, (var2)
    ld (bufSpriteX), hl
    ld (bufSpriteXStart), hl
    ld a, (var3)
    ld c, a
    ld a, 164
    sub a, c
    ld (bufSpriteY), a
    ld bc, 1
    ld (currentWidth), bc
    ld bc, (var1)
    ld hl, 0
    or a, a
    sbc hl, bc
    jp z, _popReturn
    pop hl
    pop de
    ld ix, 1

.loopSprite: ;  hl = size of string; de = address of string; ix = width counter
    ld a, (de)
    call _convertTokenToColor
    cp a, 0
    jr z, .checkLoop
    cp a, $11
    jq z, .restoreColor
    cp a, $10
    jq z, .isG
    push hl
    push de
    push af
    call _getGrphColor
    ex af, af'
    pop af
    pop de
    push af
    ex af, af'
    call _storeColorToStr9
    pop af
    push de
    call ti.GetColorValue
    call ti.SetDEUToA
    ld (ti.drawFGColor), de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 1
    call ti.IPoint
    pop de
    pop hl

.checkLoop:
    push hl
    push ix
    pop hl
    ld bc, (var1)
    or a, a
    sbc hl, bc
    call z, _moveDown

.checkLoopTwo:
    pop bc
    ld hl, (currentWidth)
    or a, a
    sbc hl, bc
    jp z, return
    push bc
    pop hl
    ld bc, (currentWidth)
    inc bc
    ld (currentWidth), bc
    ld bc, (bufSpriteX)
    inc bc
    ld (bufSpriteX), bc
    inc de
    inc ix
    jr .loopSprite

.isG:
    push hl
    call _moveDown
    jr .checkLoopTwo

.restoreColor:
    push hl
    push de
    call _getGrphColor
    pop de
    call _storeColorToStr9
    push de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 0
    call ti.IPoint
    ld a, 4
    call ti.IPoint
    pop de
    pop hl
    jr .checkLoop

_moveDown:
    ld a, (bufSpriteY)
    dec a
    ld (bufSpriteY), a
    ld bc, (bufSpriteXStart)
    dec bc
    ld (bufSpriteX), bc
    ld ix, 0
    ret

_convertTokenToColor:
    cp a, $30
    jr nc, .checkTwo
    pop hl
    jp PrgmErr.INVALA

.checkTwo:
    cp a, $49
    jr c, .continue
    pop hl
    jp PrgmErr.INVALA

.continue:
    sub a, $30
    cp a, $0A
    ret c
    cp a, $11
    jr nc, .subA
    pop hl
    jp PrgmErr.INVALA

.subA:
    sub a, $07
    ret

_getGrphColor:
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 3
    call ti.IPoint
    ret

_storeColorToStr9:
    add a, $30
    cp a, $3A
    jr c, .skipAdd
    add a, 7

.skipAdd:
    cp a, $30
    jr z, .isH
    ld (de), a
    ret

.isH:
    ld a, $48
    ld (de), a
    ret

bufSpriteSelect:
    ld a, (noArgs)
    cp a, 7
    jp nc, PrgmErr.INVALA
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    inc hl
    inc hl
    ld de, (var4)
    add hl, de
    push hl
    ld de, (var5)
    push de
    res ti.graphDraw, (iy + ti.graphFlags)
    res ti.plotLoc, (iy + ti.plotFlags)
    ld hl, (var2)
    ld (bufSpriteX), hl
    ld (bufSpriteXStart), hl
    ld a, (var3)
    ld c, a
    ld a, 164
    sub a, c
    ld (bufSpriteY), a
    ld bc, 1
    ld (currentWidth), bc
    ld bc, (var1)
    ld hl, 0
    or a, a
    sbc hl, bc
    jp z, _popReturn
    pop hl
    pop de
    ld ix, 1

.loopSprite: ; hl = size; de = address of string; ix = width counter
    ld a, (de)
    call _convertTokenToColor
    cp a, 0
    jr z, .checkLoop
    cp a, $11
    jq z, .restoreColor
    cp a, $10
    jq z, .isG
    push hl
    push de
    call ti.GetColorValue
    call ti.SetDEUToA
    ld (ti.drawFGColor), de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 1
    call ti.IPoint
    pop de
    pop hl

.checkLoop:
    push hl
    push ix
    pop hl
    ld bc, (var1)
    or a, a
    sbc hl, bc
    call z, _moveDown

.checkLoopTwo:
    pop bc
    ld hl, (currentWidth)
    or a, a
    sbc hl, bc
    jp z, return
    push bc
    pop hl
    ld bc, (currentWidth)
    inc bc
    ld (currentWidth), bc
    ld bc, (bufSpriteX)
    inc bc
    ld (bufSpriteX), bc
    inc de
    inc ix
    jr .loopSprite

.isG:
    push hl
    call _moveDown
    jr .checkLoopTwo

.restoreColor:
    push hl
    push de
    ld de, (bufSpriteX)
    ld a, (bufSpriteY)
    ld c, a
    ld a, 0
    call ti.IPoint
    ld a, 4
    call ti.IPoint
    pop de
    pop hl
    jr .checkLoop

_popReturn:
    pop hl
    pop hl
    jp PrgmErr.INVALA

execArcPrgm:
    ld hl, tempPrgmName
    ld de, xtempName
    ld bc, 10
    ldir
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    cp a, 3
    jq z, .normalFunc
    ld a, (var1)
    cp a, 2
    jp nz, PrgmErr.INVALA

.deletePrgms:
    ld bc, $1030
    ld hl, xtempName
    push hl

.loopDelete:
    pop hl
    push hl
    push bc
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop bc
    ld hl, tempNameNum + 1
    inc c
    ld a, $3A
    cp a, c
    jr nz, .not10
    dec hl
    ld a, '1'
    ld (hl), a
    ld a, c
    sub a, 10
    ld c, a
    inc hl

.not10:
    ld a, c
    ld (hl), a
    djnz .loopDelete
    pop hl
    jp return

.normalFunc:
    ld a, (var1)
    cp a, 2
    jq z, .deletePrgms
    cp a, 3
    jp nc, PrgmErr.INVALA
    ld a, (var2)
    cp a, 16
    jp nc, PrgmErr.INVALA
    ld b, a
    ld hl, tempNameNum
    cp a, 10
    jr c, .lessThan10
    ld a, '1'
    ld (hl), a
    ld a, b
    sub a, 10
    ld b, a

.lessThan10:
    inc hl
    ld a, '0'
    add a, b
    ld (hl), a
    ld hl, xtempName
    call ti.Mov9ToOP1
    ld a, (var1)
    cp a, 1
    jr nz, .createTempPrgm
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    jp return

.createTempPrgm:
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    call ti.AnsName
    call ti.ChkFindSym
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .getData
    dec hl
    ld (hl), $05

.getData:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRAM
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, $000000
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, $000000
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl ; size of program
    call ti.EnoughMem
    pop hl
    jp c, PrgmErr.NOMEM
    push hl
    ld hl, xtempName
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateProtProg
    inc de
    inc de
    push de
    call ti.OP6ToOP1
    call ti.ChkFindSym
    call ti.ChkInRam
    jr z, .inRam2
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, $000000
    ld c, a
    add hl, bc
    ex de, hl

.inRam2:
    inc de
    inc de
    pop hl
    pop bc
    push hl
    ld hl, 1
    or a, a
    sbc hl, bc
    jr nc, .zeroOrOneByte
    pop hl
    ex de, hl
    ldir
    jp return

.zeroOrOneByte:
    ld hl, 0
    or a, a
    sbc hl, bc
    pop hl
    jp z, return
    ex de, hl
    ldi
    jp return

dispColor:
    ld a, (noArgs)
    cp a, 5
    jr z, .fiveArgs
    cp a, 2
    jr z, .twoArgs
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    push de
    ld a, (var2)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    pop hl
    call ti.SetTextFGBGcolors_
    jp return

.fiveArgs:
    ld hl, $000000
    ld de, $000000
    ld a, (var1) ; low byte color
    ld l, a
    ld a, (var2) ; high byte of color
    ld h, a
    ; repeat process
    ld a, (var3)
    ld e, a
    ld a, (var4)
    ld d, a
    call ti.SetTextFGBGcolors_
    jp return

.twoArgs:
    ; see if the program wants to disable text color
    ld hl, (var1)
    ld de, 300
    or a, a
    sbc hl, de
    jp nz, return
    res ti.putMapUseColor, (iy + ti.putMapFlags)
    jp return

dispText:
    ld a, (noArgs)
    cp a, 8
    jr z, .eightArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var3)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld (ti.drawBGColor), de
    ld a, (var2)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld (ti.drawFGColor), de
    ; store x, y values to draw text
    ld hl, (var4)
    ld (ti.penCol), hl
    ld a, (var5)
    ld (ti.penRow), a
    jr .drawText

.eightArgs:
    ld hl, $000000
    ld a, (var4) ; low byte color
    ld l, a
    ld a, (var5) ; high byte of color
    ld h, a
    ld (ti.drawBGColor), hl
    ; repeat process
    ld a, (var2)
    ld l, a
    ld a, (var3)
    ld h, a
    ld (ti.drawFGColor), hl
    ; store x, y values to draw text
    ld hl, (var6)
    ld (ti.penCol), hl
    ld a, (var7)
    ld (ti.penRow), a

.drawText:
    ld a, (var1)
    cp a, 0
    call nz, .setLargeFont
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld b, (hl)
    inc hl
    inc hl
    ld de, execHexLoc

.storeText:
    ld a, (hl)
    call _convertChars.dispText
    inc hl
    djnz .storeText
    xor a, a
    ld (de), a
    ld hl, execHexLoc
    call ti.VPutS
    res ti.fracDrawLFont, (iy + ti.fontFlags) ; in case the flag was set earlier, just always reset it
    ; reset text color
    ld hl, $00ffff
    ld (ti.drawBGColor), hl
    ld hl, $000000
    ld (ti.drawFGColor), hl
    jp return

.setLargeFont:
    set ti.fracDrawLFont, (iy + ti.fontFlags)
    ret

_convertChars: ; a = token value
.varName:
    ld de, prgmName + 1
    ld b, a
    ld c, 8
    ld a, (hl)
    cp a, $15
    jr nz, .loop
    ld (de), a
    inc hl
    inc de
    dec b

.loop:
    ld a, (hl)
    call ti.Isa2ByteTok
    call z, .lowercase
    ld (de), a
    inc de
    inc hl
    dec c
    xor a, a
    cp a, c
    jr z, .endLoop
    djnz .loop

.endLoop:
    ex de, hl
    ld (hl), 0
    ret

.lowercase:
    inc hl
    ld a, (hl)
    cp a, $CB
    ret nc
    cp a, $B0
    ret c
    cp a, $BB
    jr c, .skipDec
    dec a

.skipDec:
    sub a, $4f
    dec b
    ret

.dispText:
    push de
    push bc
    push hl
    push af
    call ti.Get_Tok_Strng
    pop af
    pop hl
    ld e, c
    pop bc
    call ti.Isa2ByteTok
    jr nz, .dispText2
    inc hl
    dec b

.dispText2:
    ld a, e
    pop de
    push bc
    push hl
    ld b, a
    ld hl, ti.OP3

.loopDispText:
    ld a, (hl)
    ld (de), a
    inc de
    inc hl
    djnz .loopDispText
    pop hl
    pop bc
    ret

execHex:
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld b, (hl)
    srl b
    jp c, PrgmErr.INVALS
    inc hl
    inc hl
    ld de, execHexLoc
    push de

.loop:
    ld a, (hl)
    call _checkValidHex
    push hl
    cp a, $3A
    jr c, .numbers
    sub a, 7

.numbers:
    sub a, $30
    sla a
    sla a
    sla a
    sla a
    pop hl
    inc hl
    ld e, a
    ld a, (hl)
    call _checkValidHex
    push hl
    cp a, $3A
    jr c, .numbers2
    sub a, 7

.numbers2:
    sub a, $30
    ld l, a
    ld a, e
    add a, l
    pop de
    pop hl
    ld (hl), a
    inc hl
    push hl
    inc de
    ex de, hl
    djnz .loop
    pop hl
    ld a, $C9
    ld (hl), a
    call execHexLoc
    jp return

_checkValidHex:
    cp a, $30
    jr nc, .checkTwo
    pop hl
    pop hl
    jp PrgmErr.INVALS

.checkTwo:
    cp a, $47
    jr c, .continue
    pop hl
    pop hl
    jp PrgmErr.INVALS

.continue:
    cp a, $3A
    ret c
    cp a, $40
    ret nc
    pop hl
    pop hl
    jp PrgmErr.INVALS

textRect:
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 5
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 0
    jr z, .skipColor
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld (ti.fillRectColor), de

.skipColor:
    ld hl, (var2) ; x coord
    ld de, (var4) ; width value
    ; calculate bottom right x coord
    add hl, de
    dec hl
    ex de, hl
    ld hl, (var2)
    ld a, (var5) ; height value
    ; calculate bottom right y coord
    ld c, a
    ld a, (var3)
    add a, c
    dec a
    ld c, a
    ld a, (var3)
    ld b, a
    ld a, (var1)
    cp a, 0
    jr nz, .fillRect
    call ti.InvertRect
    jp return

.sevenArgs:
    ld a, (var1)
    ld (ti.fillRectColor), a
    ld a, (var2)
    ld (ti.fillRectColor + 1), a
    ; calculate second x and y values for ti.FillRect like above
    ld hl, (var3)
    ld de, (var5)
    add hl, de
    dec hl
    ex de, hl
    ld hl, (var3)
    ld a, (var6)
    ld c, a
    ld a, (var4)
    add a, c
    dec a
    ld c, a
    ld a, (var4)
    ld b, a

.fillRect:
    call ti.FillRect
    jp return

waitAnyKey:
    call ti.GetCSC
    cp a, 0
    jr z, waitAnyKey
    ret

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
    ld de, $000000
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
    ld de, $000000
    ld e, a
    add hl, de
    ex de, hl
    pop hl
    jr .loop

.endLoop:
    ex de, hl
    ld de, 16
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

PrgmErr:
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
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

.LNTFN:
    call PrgmErr
    db "::L>NT>FN", 0

.SNTFN:
    call PrgmErr
    db "::S>NT>FN", 0

.SFLASH:
    call PrgmErr
    db "::S>FLASH",0

.SNTST:
    call PrgmErr
    db "::S>NT>ST", 0

.NOMEM:
    call PrgmErr
    db "::NT>EN>M", 0

;.E2LNG:
;    call PrgmErr
;    db "::E>2>LNG", 0

;.S2LNG:
;    call PrgmErr
;    db "::S>2>LNG", 0

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

.SUPPORT:
    call PrgmErr
    db "::SUPPORT", 0

; string data

celticInstalledMsg:
    db "Celtic CE installation", 0
    db "successful.", 0
    db "Press any key.", 0

celticUninstalledMsg:
    db "Celtic CE has been", 0
    db "uninstalled.", 0
    db "Press any key.", 0

installScrnLine1:
    db "--------Celtic CE--------", 0

installScrnOption1:
    db "1: Install Celtic", 0

installScrnOption1Alt:
    db "1: Uninstall Celtic", 0

installScrnOption2:
    db "2: About", 0

installScrnOption3:
    db "3: Quit", 0

aboutScrnLine1:
    db "Celtic CE", 0

aboutScrnLine2:
    db "By RoccoLox Programs", 0

aboutScrnLine3:
    db "and TIny_Hacker", 0

versionString:
    db "Version BETA 1.0", 0

copyright:
    db "(c) 2022", 0

if flag_prerelease

warningMsg:
    db "WARNING!", 0
    db "This program is still in", 0
    db "development. Proceed with", 0
    db "caution.", 0
    db "Please do not distribute.", 0

end if

celticCommands:
C00:    db "ReadLine() : Str0, Ans : Str9 or [", 0
C01:    db "ReplaceLine() : Str0, Str9, Ans", 0
C02:    db "InsertLine() : Str0, Str9, Ans", 0
C03:    db "SpecialChars() : NONE : Str9", 0
C04:    db "CreateVar() : Str0", 0
C05:    db "Arc/UnarcVar() : Str0", 0
C06:    db "DeleteVar() : Str0", 0
C07:    db "DeleteLine() : Str0, Ans", 0
C08:    db "VarStatus() : Str0 : Str9 ", 0
C09:    db "BufSprite(WIDTH,X,Y) : Str9 : Str9", 0
C10:    db "BufSpriteSelect(WTH,X,Y,STRT,LEN) : Str9", 0
C11:    db "ExecArcPrgm(FN,NUM) : Ans", 0
C12:    db "DispColor(F_L,F_H,B_L,B_H)", 0
C13:    db "DispText(LF,F_L,F_H,B_L,B_H,X,Y) : Str9", 0
C14:    db "ExecHex() : Ans", 0
C15:    db "TextRect(COLOR_L,COLOR_H,X,Y,WTH,HT)", 0

; additional rodata

celticCommandsPtrs:
    dl C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15
    dl C15

Str9:
    db ti.StrngObj, ti.tVarStrng, ti.tStr9, 0, 0

Str0:
    db ti.StrngObj, ti.tVarStrng, ti.tStr0, 0, 0

Theta:
    db ti.RealObj, ti.tTheta, 0, 0

tempPrgmName:
    db ti.ProtProgObj, "XTEMP000", 0
