;--------------------------------------
;
; Celtic CE Source Code - main.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: January 17, 2023
;
;--------------------------------------

var0            equ ti.pixelShadow2 + 100 ; arguments from first to last (first argument is command number)
var1            equ ti.pixelShadow2 + 103 ; 
var2            equ ti.pixelShadow2 + 106 ; 
var3            equ ti.pixelShadow2 + 109 ; 
var4            equ ti.pixelShadow2 + 112 ; 
var5            equ ti.pixelShadow2 + 115 ; 
var6            equ ti.pixelShadow2 + 118 ; 
var7            equ ti.pixelShadow2 + 121 ; max of 8 arguments can be passed
noArgs          equ ti.pixelShadow2 + 124 ; number of arguments
ans             equ ti.pixelShadow2 + 127 ; temp storage for Ans
EOF             equ ti.pixelShadow2 + 130 ; end of file address
bufSpriteX      equ ti.pixelShadow2 + 133 ; reserved for BufSprite and BufSpriteSelect
bufSpriteY      equ ti.pixelShadow2 + 136 ; ""
bufSpriteXStart equ ti.pixelShadow2 + 137 ; ""
currentWidth    equ ti.pixelShadow2 + 140 ; ""
xtempName       equ ti.pixelShadow2 + 143 ; XTEMP000 name
prgmName        equ ti.pixelShadow2 + 153 ; Used to store a variable name
stackPtr        equ ti.pixelShadow2 + 164 ; used to preserve the stack pointer
execHexLoc      equ ti.pixelShadow2 + 167 ; Location for storing ExecHex code (max size of 4096 bytes) (used for undefined temp storage size in various commands)

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

if flag_prerelease

installPage:
    call ti.ClrScrn
    call ti.HomeUp
    ld hl, warningMsg
    call ti.PutS
    call ti.NewLine
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call ti.NewLine
    call ti.PutS
    call waitAnyKey

installPageSkipWarn:

else

installPage:

end if

    set ti.fracDrawLFont, (iy + ti.fontFlags)
    call ti.RunIndicOff
    call ti.DisableAPD
    ld hl, $4249
    push hl
    call FillScreen
    pop hl
    ld (ti.drawBGColor), hl
    ld hl, $FFFF
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
    jp z, installHook
    cp a, ti.sk2
    jp z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skChs
    jr z, testNumberHit
    cp a, ti.skClear
    jr z, exitCelticApp
    jr selectOption

exitCelticApp:
    res ti.fracDrawLFont, (iy + ti.fontFlags)
    ld hl, 0
    ld (ti.drawBGColor), hl
    call ti.ClrScrn
    call ti.DrawStatusBar
    call ti.HomeUp
    call ti.ApdSetup
    call ti.EnableAPD
    ld a, ti.kClear
    jp ti.JForceCmd

testNumberHit:
    call ti.GetCSC
    or a, a
    jr z, testNumberHit
    cp a, ti.sk0
    jr z, secret
    cp a, ti.sk1
    jp z, installHook
    cp a, ti.sk2
    jp z, aboutScrn
    cp a, ti.sk3
    jr z, exitCelticApp
    cp a, ti.skClear
    jr z, exitCelticApp
    jr selectOption

secret: ;)
    ld bc, (ti.lcdWidth * ti.lcdHeight) * 2

if flag_prerelease

    ld hl, installPageSkipWarn

else

    ld hl, installPage

end if

    ld de, ti.vRam
    ldir
    call waitAnyKey
    jp drawFullCredits

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
    ld hl, $4249
    call FillScreen
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
    ld hl, 71
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
    jp z, exitCelticApp

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

installHook:
    call ti.HomeUp
    ld hl, $4249
    call FillScreen
    ld hl, $FFFF
    ld de, $4249
    call ti.SetTextFGBGcolors_
    call uninstallChain ; reset all this hook stuff to be safe
    bit ti.parserHookActive, (iy + ti.hookflags4)
    jr nz, checkHook

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
    jr nz, finishInstall
    inc hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    jr finishInstall

uninstallHook:
    call ti.ClrParserHook
    call uninstallChain
    call ti.ClrCursorHook
    call ti.ClrRawKeyHook
    ld hl, celticUninstalledMsg
    jr displayInstallmsg

uninstallChain:
    or a, a
    sbc hl, hl
    ld (ti.helpHookPtr), hl
    res ti.helpHookActive, (iy + ti.hookflags4)
    ret

drawFullCredits:
    or a, a
    sbc hl, hl
    ld (ti.fillRectColor), hl
    ld hl, 80
    ld de, 239
    ld b, 0
    ld c, 239
    call ti.FillRect
    or a, a
    sbc hl, hl
    ld (ti.drawBGColor), hl
    ld hl, $FFFF
    ld (ti.drawFGColor), hl
    ld hl, 107
    ld (ti.penCol), hl
    ld a, 5
    ld (ti.penRow), a
    ld hl, aboutScrnLine1
    call ti.VPutS
    ld hl, 84
    ld (ti.penCol), hl
    ld a, 45
    ld (ti.penRow), a
    ld hl, creditsStr1
    call ti.VPutS
    ld hl, 119
    ld (ti.penCol), hl
    ld a, 75
    ld (ti.penRow), a
    ld hl, creditsStr2
    call ti.VPutS
    ld hl, 143
    ld (ti.penCol), hl
    ld a, 95
    ld (ti.penRow), a
    ld hl, creditsStr3
    call ti.VPutS
    ld hl, 89
    ld (ti.penCol), hl
    ld a, 115
    ld (ti.penRow), a
    ld hl, creditsStr4
    call ti.VPutS
    ld hl, 125
    ld (ti.penCol), hl
    ld a, 135
    ld (ti.penRow), a
    ld hl, creditsStr5
    call ti.VPutS
    ld hl, 119
    ld (ti.penCol), hl
    ld a, 155
    ld (ti.penRow), a
    ld hl, creditsStr6
    call ti.VPutS
    ld hl, 131
    ld (ti.penCol), hl
    ld a, 175
    ld (ti.penRow), a
    ld hl, creditsStr7
    call ti.VPutS
    ld hl, 125
    ld (ti.penCol), hl
    ld a, 195
    ld (ti.penRow), a
    ld hl, creditsStr8
    call ti.VPutS
    ld hl, appName
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    ld hl, easterEggLen - 1
    push hl
    call ti.CreateAppVar
    pop bc
    inc de
    inc de
    ld hl, easterEgg
    ldir
    call waitAnyKey
    cp a, ti.skClear
    jp z, exitCelticApp

if flag_prerelease

    jp installPageSkipWarn

else

    jp installPage

end if

FillScreen:
    ld a, l
    ld b, h
    ld hl, ti.vRam
    ld (hl), a
    inc hl
    ld (hl), b
    ld bc, ((ti.lcdWidth * ti.lcdHeight) * 2) - 2
    push hl
    pop de
    inc de
    dec hl
    ldir
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

hookCheckStr: ; this might be used at a later date
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

hookTriggered:
    di
    ld (stackPtr), sp
    ld (noArgs), hl
    push hl
    ld de, 8
    ex de, hl
    or a, a
    sbc hl, de
    pop hl
    jp c, PrgmErr.2MARG
    ld a, (ti.OP1)
    cp a, $02 ; matrix type
    jp z, matrixType
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
    res invalidArg, (iy + ti.asm_Flag2)

popArgs:
    push bc
    push hl
    call ti.PopRealO1
    ld a, (ti.OP1)
    or a, a
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

invalid:
    set invalidArg, (iy + ti.asm_Flag2)
    ret

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
    dl textRect ; det(15)
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
celticTableEnd:

returnOS: ; return and let the OS handle the function
    ei
    cp a, a
    ret

return:
    call ti.RclAns
    ld sp, (stackPtr)
    ei
    or a, 1
    ret

readLine: ; det(0)
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
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, 0
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
    or a, a
    jp nz, PrgmErr.NTREAL
    call ti.ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jp z, .getNumOfLines
    ld hl, 1
    or a, a
    sbc hl, de
    jr z, .readLineOne
    pop de
    pop hl
    call _getEOF
    push de
    pop bc
    ld de, 1
    ld ix, PrgmErr.LNTFN
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
    call nc, ti.DelVarArc
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
    jr nc, .readOneOrZero
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
    jp z, PrgmErr.NULLSTR
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

replaceLine: ; det(1)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    set replaceLineRun, (iy + ti.asm_Flag2)
    jp deleteLine

insertLine: ; det(2)
    res insertLastLine, (iy + ti.asm_Flag2)
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    push hl ; size of string
    push de ; start of string
    inc hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
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
    jr z, .continueInsert
    dec hl
    ld (hl), $05

.continueInsert:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld hl, 0
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
    or a, a
    jp nz, PrgmErr.NTREAL
    call ti.ConvOP1
    ld (ans), de
    ld hl, 0
    or a, a
    sbc hl, de
    jp z, PrgmErr.LNTFN
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
    ld bc, 0
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
    jp PrgmErr.LNTFN

_decBCretNZ:
    pop hl
    dec bc
    or a, 1
    ret

specialChars: ; det(3)
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

createVar: ; det(4)
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
    jr z, .createAppvar
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 0
    call ti.CreateProg
    jp return

.createAppvar:
    ld a, (noArgs)
    cp a, 1
    jr z, .createNormal
    ld a, (var1)
    or a, a
    jr z, .createNormal
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp nc, PrgmErr.PISFN
    ld hl, 5
    call ti.CreateAppVar
    inc de
    inc de
    ex de, hl
    ld (hl), $3E
    inc hl
    ld (hl), $43
    inc hl
    ld (hl), $45
    inc hl
    ld (hl), $4C
    inc hl
    ld (hl), $3F
    jp return

.createNormal:
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

arcUnarcVar: ; det(5)
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

deleteVar: ; det(6)
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

deleteLine: ; det(7)
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
    ld hl, 0
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
    or a, a
    jp nz, PrgmErr.NTREAL
    call ti.ConvOP1
    ld (ans), de
    or a, a
    ld hl, 0
    sbc hl, de
    jp z, PrgmErr.LNTFN
    or a, a
    ld hl, 1
    sbc hl, de
    jr z, .delLineOne
    pop bc
    ld de, 1
    ld ix, PrgmErr.LNTFN
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

varStatus: ; det(8)
    xor a, a
    ld (prgmName), a
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
    call nc, ti.DelVarArc
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
    ld hl, prgmName
    ld a, (hl)
    cp a, $05
    jr z, .notAppvar
    inc hl

.notAppvar:
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
    ld hl, 0
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
    ld bc, 0
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

bufSprite: ; det(9)
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
    ld de, 0
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    push de
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
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
    or a, a
    jr z, .checkLoop
    cp a, $11
    jr z, .restoreColor
    cp a, $10
    jr z, .isG
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
    xor a, a
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

bufSpriteSelect: ; det(10)
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
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
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
    or a, a
    jr z, .checkLoop
    cp a, $11
    jr z, .restoreColor
    cp a, $10
    jr z, .isG
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
    xor a, a
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

execArcPrgm: ; det(11)
    ld hl, tempPrgmName
    ld de, xtempName
    ld bc, 10
    ldir
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    cp a, 3
    jr z, .normalFunc
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
    jr z, .deletePrgms
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
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRAM:
    push de
    call ti.OP1ToOP6
    pop de
    ld hl, 0
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
    ld bc, 0
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

dispColor: ; det(12)
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
    ld a, (var2)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    push de
    call ti.GetColorValue
    pop hl
    call ti.SetTextFGBGcolors_
    set ti.textEraseBelow, (iy + ti.textFlags)
    jp return

.fiveArgs:
    ld hl, 0
    ld de, 0
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
    set ti.textEraseBelow, (iy + ti.textFlags)
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

dispText: ; det(13)
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
    ld hl, 0
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
    or a, a
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
    ld hl, $FFFF
    ld (ti.drawBGColor), hl
    ld hl, 0
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

execHex: ; det(14)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    push hl
    ld hl, $2000
    or a, a
    sbc hl, bc
    pop hl
    jp c, PrgmErr.INVALS
    srl b
    rr c
    jp c, PrgmErr.INVALS
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
    add a, e
    pop de
    pop hl
    ld (hl), a
    inc hl
    push hl
    inc de
    ex de, hl
    dec bc
    call ti.ChkBCIs0
    jr nz, .loop
    pop hl
    ld a, $C9
    ld (hl), a
    call execHexLoc
    jp return

_checkValidHex:
    cp a, $30
    jr nc, .checkTwo
    jp PrgmErr.INVALS

.checkTwo:
    cp a, $47
    jr c, .continue
    jp PrgmErr.INVALS

.continue:
    cp a, $3A
    ret c
    cp a, $40
    ret nc
    jp PrgmErr.INVALS

textRect: ; det(15)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    or a, a
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
    or a, a
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

fillScreen: ; det(16)
    ld a, (noArgs)
    cp a, 2
    jp c, PrgmErr.INVALA
    cp a, 2
    jr z, .osColor
    ld a, (var1)
    ld e, a
    ld a, (var2)
    ld d, a

.fillScrn:
    ld hl, ti.vRam
    ld (hl), e
    inc hl
    ld (hl), d
    push hl
    pop de
    dec hl
    inc de
    ld bc, ((ti.lcdWidth * ti.lcdHeight) * 2) - 2
    ldir
    jp return

.osColor:
    ld a, (var1)
    cp a, 10
    jp c, PrgmErr.INVALA
    cp a, 25
    jp nc, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    jr .fillScrn

drawLine: ; det(17)
    set ti.fullScrnDraw, (iy + ti.apiFlg4)
    set ti.plotLoc, (iy + ti.plotFlags)
    ld a, (noArgs)
    cp a, 7
    jr z, .sevenArgs
    cp a, 6
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9
    call ti.GetColorValue
    ld (ti.drawFGColor), de
    ld a, (var3)
    ld c, a
    ld a, 239
    sub a, c
    ld c, a
    ld a, (var5)
    ld b, a
    ld a, 239
    sub a, b
    ld b, a
    ld de, (var2)
    ld hl, (var4)
    jr .drawLine

.sevenArgs:
    ld a, (var1)
    ld (ti.drawFGColor), a
    ld a, (var2)
    ld (ti.drawFGColor + 1), a
    ld a, (var4)
    ld c, a
    ld a, 239
    sub a, c
    ld c, a
    ld a, (var6)
    ld b, a
    ld a, 239
    sub a, b
    ld b, a
    ld de, (var3)
    ld hl, (var5)

.drawLine:
    ld a, 1
    call ti.ILine
    jp return

setPixel: ; det(18)
    res invertPixel, (iy + ti.asm_Flag2)
    ld a, (noArgs)
    cp a, 5
    jr z, .fiveArgs
    cp a, 4
    jp c, PrgmErr.INVALA
    ld a, (var1)
    cp a, 25
    jp nc, PrgmErr.INVALA
    or a, a
    jr z, .skipSub
    cp a, 10
    jp c, PrgmErr.INVALA
    sub a, 9

.skipSub:
    call ti.GetColorValue
    push de
    ld ix, var2
    ld a, (var1)
    or a, a
    jr nz, .getCoord
    set invertPixel, (iy + ti.asm_Flag2)
    jr .getCoord

.fiveArgs:
    ld a, (var1)
    ld de, 0
    ld e, a
    ld a, (var2)
    ld d, a
    push de
    ld ix, var3

.getCoord:
    ld a, (ix + 3)
    ld hl, $D40000
    ld de, 640
    ld b, a
    xor a, a
    cp a, b
    jr z, .foundCoord

.loopCoord:
    add hl, de
    djnz .loopCoord

.foundCoord:
    ex de, hl
    ld hl, (ix)
    add hl, hl
    add hl, de
    bit invertPixel, (iy + ti.asm_Flag2)
    push hl
    call nz, .invertColor
    pop hl
    pop de
    ld (hl), e
    inc hl
    ld (hl), d
    jp return

.invertColor:
    pop bc
    pop hl
    pop de
    ld a, (hl)
    ld de, 0
    ld e, a
    ld a, 255
    sub a, e
    ld e, a
    inc hl
    ld a, (hl)
    ld d, a
    ld a, 255
    sub a, d
    ld d, a
    dec hl
    push de
    push hl
    push bc
    ret

getPixel: ; det(19)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld hl, $D40000
    ld de, 640
    ld b, a
    xor a, a
    cp a, b
    jr z, .foundCoord

.loopCoord:
    add hl, de
    djnz .loopCoord

.foundCoord:
    ex de, hl
    ld hl, (var1)
    add hl, hl
    add hl, de
    ld a, (hl)
    ld de, 0
    ld e, a
    push de
    inc hl
    ld a, (hl)
    ld de, 0
    ld e, a
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
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    call ti.StoAns
    jp return

pixelTestColor: ; det(20)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
    res ti.fullScrnDraw, (iy + ti.apiFlg4)
    ld a, (var1)
    cp a, 165
    jp nc, PrgmErr.INVALA
    ld c, a
    ld a, 164
    sub a, c
    ld c, a
    ld de, (var2)
    ld hl, 264
    or a, a
    sbc hl, de
    jp c, PrgmErr.INVALA
    ld a, 3
    call ti.IPoint
    or a, a
    jr z, .skipAdd
    add a, 9

.skipAdd:
    ld hl, 0
    ld l, a
    push hl
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
    jp return

putSprite: ; det(21)
    ld a, (noArgs)
    cp a, 5
    jp c, PrgmErr.INVALA
    ld a, (var2)
    ld hl, $D40000 ; ti.vRam
    ld de, 640 ; ti.lcdWidth * 2
    ld b, a
    xor a, a
    cp a, b
    jr z, .foundCoord

.loopCoord:
    add hl, de
    djnz .loopCoord

.foundCoord:
    ex de, hl
    ld hl, (var1)
    add hl, hl
    add hl, de
    push hl
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    inc de
    inc de
    ex de, hl
    ld bc, (var4)
    call ti.ChkBCIs0
    jp z, PrgmErr.INVALA
    ld bc, 0
    ld (currentWidth), bc
    ld bc, (var3)
    call ti.ChkBCIs0
    jp z, PrgmErr.INVALA
    pop de
    ld (bufSpriteXStart), de
    ld ix, 0

.loopSprite: ; hl = string location; de = vram location; ix = height counter
    push bc
    ld a, (hl)
    call .convertTokenToHex
    sla a
    sla a
    sla a
    sla a
    ld b, a
    inc hl
    ld a, (hl)
    call .convertTokenToHex
    add a, b
    ld (de), a
    inc de
    ld (de), a
    inc de
    inc hl
    pop bc
    push hl
    ld hl, (currentWidth)
    inc hl
    push hl
    or a, a
    sbc hl, bc
    pop hl
    call z, .moveDown
    ld (currentWidth), hl
    pop hl
    jr .loopSprite

.moveDown:
    inc ix
    ld hl, (var4)
    push bc
    push ix
    pop bc
    or a, a
    sbc hl, bc
    jp z, return
    pop bc
    ld hl, (bufSpriteXStart)
    ld de, 640
    add hl, de
    ld (bufSpriteXStart), hl
    ex de, hl
    ld hl, 0
    ret

.convertTokenToHex:
    sub a, $30
    cp a, 10
    ret c
    sub a, 7
    ret

getMode: ; det(22)
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, (.modeListEnd - .modeListStart) / 4
    jp nc, PrgmErr.INVALA
    ld l, a
    ld h, 3
    mlt hl
    ld de, .storeTheta
    push de
    ld de, .modeListStart
    add hl, de
    xor a, a
    ld hl, (hl)
    jp (hl)

.modeListStart:
    dl .mathprint ; 0
    dl .numMode
    dl .trigMode
    dl .graphMode
    dl .graphSimul
    dl .realMode
    dl .graphWinMode
    dl .graphCoord
    dl .gridOn
    dl .axesOn
    dl .labelOn ; 10
.modeListEnd:

.mathprint: ; 0
    bit ti.mathprintEnabled, (iy + ti.mathprintFlags)
    ret z
    inc a
    ret

.numMode: ; 1
    ld a, 2
    bit ti.fmtEng, (iy + ti.fmtFlags)
    ret nz
    dec a
    bit ti.fmtExponent, (iy + ti.fmtFlags)
    ret nz
    dec a
    ret

.trigMode: ; 2
    bit ti.trigDeg, (iy + ti.trigFlags)
    ret z
    inc a
    ret

.graphMode: ; 3
    bit ti.grfFuncM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    bit ti.grfParamM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    bit ti.grfPolarM, (iy + ti.grfModeFlags)
    ret nz
    inc a
    ret

.graphSimul: ; 4
    bit ti.grfSimul, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.realMode: ; 5
    ld a, 2
    bit ti.polarMode, (iy + ti.numMode)
    ret nz
    dec a
    bit ti.rectMode, (iy + ti.numMode)
    ret nz
    dec a
    ret

.graphWinMode: ; 6
    ld a, 2
    bit ti.vertSplit, (iy + ti.sGrFlags)
    ret nz
    dec a
    bit ti.grfSplit, (iy + ti.sGrFlags)
    ret nz
    dec a
    ret

.graphCoord: ; 7
    bit ti.grfPolar, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.gridOn: ; 8
    bit ti.grfGrid, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.axesOn: ; 9
    bit ti.grfNoAxis, (iy + ti.grfDBFlags)
    ret nz
    inc a
    ret

.labelOn:; 10
    bit ti.grfLabel, (iy + ti.grfDBFlags)
    ret z
    inc a
    ret

.storeTheta:
    ld hl, 0
    ld l, a
    push hl
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
    jp return

renameVar: ; det(23)
    res archived, (iy + ti.asm_Flag2) ; use archived flag to remember file type
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
    jr z, .rename
    set archived, (iy + ti.asm_Flag2)
    dec hl
    ld (hl), $05

.rename:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    push hl
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    bit archived, (iy + ti.asm_Flag2)
    jr z, .createAppvar
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateProtProg
    jr .copyData

.createAppvar:
    dec hl
    ld (hl), $15
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    pop hl
    jp nc, PrgmErr.PISFN
    call ti.CreateAppVar

.copyData:
    push de
    ld hl, Str0
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call _getProgNameLen
    ex de, hl
    call _convertChars.varName
    ld hl, prgmName + 1
    ld a, (hl)
    cp a, $15
    jr z, .rename2
    dec hl
    ld (hl), $05

.rename2:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    pop ix
    push hl
    push de
    push bc
    push ix
    call ti.ChkInRam
    jr z, .inRam2
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam2:
    ex de, hl
    pop de
    ; hl = original program; de = new program
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    inc de
    inc de
    call ti.ChkBCIs0
    jr z, .deleteProg

.copyDataLoop:
    ldi
    call ti.ChkBCIs0
    jr nz, .copyDataLoop

.deleteProg:
    pop bc
    pop de
    pop hl
    call ti.DelVarArc
    jp return

lockPrgm: ; det(24)
    res archived, (iy + ti.asm_Flag2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.OP1ToOP6
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    call nz, _setArchivedFlag
    inc de
    inc de
    push hl
    ld hl, 0
    ld a, (de)
    ld h, a
    inc de
    ld a, (de)
    ld l, a
    ld de, $EF7B
    or a, a
    sbc hl, de
    pop hl
    jp z, PrgmErr.SUPPORT
    ld a, (hl)
    xor a, 00000011b
    ld (hl), a
    bit archived, (iy + ti.asm_Flag2)
    call nz, _re_archive
    jp return

_setArchivedFlag:
    set archived, (iy + ti.asm_Flag2)
    call ti.Arc_Unarc
    call ti.OP6ToOP1
    call ti.ChkFindSym
    ret

_re_archive:
    call ti.OP6ToOP1
    call ti.Arc_Unarc
    ret

hidePrgm: ; det(25)
    res archived, (iy + ti.asm_Flag2)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.OP1ToOP6
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    call nz, _setArchivedFlag
    ld bc, -7
    add hl, bc
    ld a, (hl)
    xor a, 01000000b
    ld (hl), a
    ld (ti.OP6 + 1), a
    bit archived, (iy + ti.asm_Flag2)
    call nz, _re_archive
    jp return
    
prgmToStr: ; det(26)
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    pop hl
    jp c, PrgmErr.PNTFN
    push hl
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    push hl
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a 
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    push af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    pop hl
    call ti.ChkHLIs0
    jp z, PrgmErr.NULLVAR
    call ti.CreateStrng
    inc de
    inc de
    pop hl
    push de
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    call ti.ChkInRam
    jr z, .inRam2
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam2:
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    ex de, hl
    pop de
    dec bc
    call ti.ChkBCIs0
    jr z, .copyOneByte
    inc bc
    ldir
    jp return

.copyOneByte:
    inc bc
    ldi
    jp return

getPrgmType: ; det(27)
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
    jp z, PrgmErr.INVALS
    dec hl
    ld (hl), $05
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    inc de
    inc de
    ld a, (de)
    cp a, $2c
    ld a, 4 ; ICE source
    jr z, .storeTheta
    ; check for ASM
    ex de, hl
    ld de, (hl)
    ex de, hl
    or a, a
    ld bc, $007BEF ; check for C
    sbc hl, bc
    ld a, 1
    jr z, .storeTheta
    add hl, bc
    ld bc, $7F7BEF ; check for ICE
    or a, a
    sbc hl, bc
    ld a, 3
    jr z, .storeTheta
    ld a, (de)
    ld hl, $00
    ld h, a
    inc de
    ld a, (de)
    ld l, a
    ld bc, $EF7B ; check for plain ASM
    or a, a
    sbc hl, bc
    ld a, 0
    jr z, .storeTheta
    ld a, 2

.storeTheta:
    ld hl, 0
    ld l, a
    push hl
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
    jp return

getBatteyStatus: ; det(28)
    ld hl, 0
    call ti.GetBatteryStatus
    ld l, a
    call ti.usb_IsBusPowered
    or a, a
    jr z, .notCharging
    ld a, l
    add a, 10
    ld l, a

.notCharging:
    push hl
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
    jp return

setBrightness: ; det(29)
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jr z, .getBrightness
    ld ($F60024), a ; ti.mpBlLevel
    jp return

.getBrightness:
    ld a, ($F60024)
    ld hl, 0
    ld l, a
    push hl
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
    jp return

getListElem: ; det(30)
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld bc, 1
    or a, a
    sbc hl, bc
    jp z, PrgmErr.INVALS
    add hl, bc
    ld a, (de)
    cp a, $EB
    jr z, .isAlist
    cp a, $5D
    jr z, .isAlist
    jp PrgmErr.NTALS

.isAlist:
    call .getListNameLen
    ld bc, ti.OP1
    ld a, ti.ListObj
    ld (bc), a
    inc bc
    ld a, ti.tVarLst
    ld (bc), a
    inc de
    inc bc
    dec hl
    push de
    push bc
    push hl
    pop bc
    pop de
    pop hl

.loopName:
    ldi
    call ti.ChkBCIs0
    jr nz, .loopName
    xor a, a
    ld (de), a
    call ti.ChkFindSym
    jp c, PrgmErr.PNTFN
    res imaginaryList, (iy + ti.asm_Flag2)
    ld a, (hl)
    cp a, $0D
    jr nz, .chkLoc
    set imaginaryList, (iy + ti.asm_Flag2)

.chkLoc:
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld a, (var1)
    or a, a
    jp z, .showDim
    call ti.ChkHLIs0
    jp z, PrgmErr.ENTFN
    push de
    ld de, (var1)
    or a, a
    sbc hl, de
    pop hl
    jp c, PrgmErr.ENTFN
    ld de, 1
    ld bc, 9
    bit imaginaryList, (iy + ti.asm_Flag2)
    jr z, .loopFindOffset
    ld bc, 18

.loopFindOffset:
    push hl
    ld hl, (var1)
    or a, a
    sbc hl, de
    pop hl
    jr z, .foundOffset
    inc de
    add hl, bc
    jr .loopFindOffset

.foundOffset:
    push bc
    ld de, execHexLoc
    ldir
    ld hl, Theta
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    pop hl
    bit imaginaryList, (iy + ti.asm_Flag2)
    jr z, .createReal
    call ti.CreateCplx

.storeValue:
    ld hl, execHexLoc
    pop bc
    ldir
    jp return

.createReal:
    call ti.CreateReal
    jr .storeValue

.getListNameLen:
    ld bc, 7
    or a, a
    sbc hl, bc
    add hl, bc
    jr c, .validLen
    ld hl, 6

.validLen:
    ld a, (de)
    cp a, $5D
    ret nz
    ld bc, 2
    or a, a
    sbc hl, bc
    add hl, bc
    ret z
    pop bc
    jp PrgmErr.INVALS

.showDim:
    push hl
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
    jp return

getArgType: ; det(31)
    call ti.RclAns
    ld hl, 0
    ld a, (ti.OP1)
    ld l, a
    push hl
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
    jp return

chkStats: ; det(32)
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
    ld a, (var1)
    cp a, 4
    jp z, .checkCalcVer
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    ld a, (var1)
    ld hl, return
    push hl
    or a, a
    jr z, .checkRAM
    cp a, 1
    jr z, .checkROM
    cp a, 2
    jp z, .checkBoot
    cp a, 3
    jp z, .checkOS
    jp PrgmErr.INVALA

.checkRAM:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 6
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld (ans), sp ; use to preserve sp
    ld a, '0'
    ld bc, 6
    call ti.MemSet
    ld hl, -9 ; do this because the toolchain does
    call ti._frameset
    call ti.MemChk
    push hl ; copied from the toolchain
    pea ix - 9
    call ti.os.Int24ToReal
    ld sp, (ans) ; just restore sp because it's easier
    ld a, 6
    call ti.FormEReal
    ld hl, 6
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loadLoop:
    call ti.ChkBCIs0
    ret z
    ldi
    jr .loadLoop

.checkROM:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 7
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld (ans), sp ; use to preserve sp
    ld a, '0'
    ld bc, 7
    call ti.MemSet
    call ti.ArcChk
    ld hl, -9 ; do this because the toolchain does
    call ti._frameset
    ld hl, (ti.tempFreeArc)
    push hl ; copied from the toolchain
    pea ix - 9
    call ti.os.Int24ToReal
    ld sp, (ans) ; just restore sp because it's easier
    ld a, 7
    call ti.FormEReal
    ld hl, 7
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loop:
    call ti.ChkBCIs0
    ret z
    ldi
    jr .loop

.checkBoot:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 10
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld a, '0'
    ld bc, 10
    call ti.MemSet
    pop hl
    push hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    call ti.os.GetSystemInfo
    ld bc, 12
    add hl, bc
    ld de, execHexLoc
    ld bc, 6
    ldir ; store in a safe location

.storeInfo:
    ld a, (execHexLoc)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld a, (execHexLoc + 1)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld a, (execHexLoc + 2)
    call ti.SetxxOP1
    ld a, 6
    call ti.FormEReal
    pop de
    ld hl, ti.OP3
    ldi
    inc de
    push de
    ld hl, (execHexLoc + 3)
    call ti.SetxxxxOP2
    call ti.OP2ToOP1
    ld a, 6
    call ti.FormEReal
    ld hl, 4
    or a, a
    sbc hl, bc
    ex de, hl
    pop hl
    add hl, de
    ex de, hl
    ld hl, ti.OP3

.loop2:
    call ti.ChkBCIs0
    ret z
    ldi
    jr .loop2

.checkOS:
    ld hl, Str9
    call ti.Mov9ToOP1
    ld hl, 10
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    push hl
    ld a, '0'
    ld bc, 10
    call ti.MemSet
    pop hl
    push hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    inc hl
    inc hl
    ld (hl), $3A
    call ti.os.GetSystemInfo
    ld bc, 6
    add hl, bc
    ld de, execHexLoc
    ld bc, 6
    ldir ; store in a safe location
    jp .storeInfo

.checkCalcVer:
    call ti.os.GetSystemInfo
    ld bc, 4
    add hl, bc
    ld a, (hl)
    push af
    ld hl, Theta
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVar
    pop hl
    call ti.CreateReal
    pop af
    push de
    call ti.SetxxOP2
    pop de
    ld hl, ti.OP2
    ld bc, 9
    ldir
    jp return

findProg: ; det(33)
    ld a, (noArgs)
    cp a, 1
    jp z, PrgmErr.INVALA
    ld a, (var1)
    or a, a
    jr z, .programs
    cp a, 1
    jr z, .appvars
    jp PrgmErr.INVALA

.programs:
    res randFlag, (iy + ti.asm_Flag2) ; reset since we're searching for programs
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, .setupFindAll
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    ld a, 5
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0
    jr .loopFindVars

.appvars:
    set randFlag, (iy + ti.asm_Flag2) ; set since we're searching for appvars
    call ti.RclAns
    ld a, (ti.OP1)
    cp a, 4
    jp nz, .setupFindAll
    call ti.AnsName
    call ti.ChkFindSym
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    ld (ans), hl ; preserve the length of the string
    push de
    call ti.ZeroOP1
    pop de
    ld a, $15
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0

.loopFindVars: ; name in OP1; bc = size of string; de = ptr to search string
    push bc
    push de
    call ti.FindAlphaUp
    jr c, .exitLoop
    ld bc, -6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; use to preserve name length
    inc hl
    ld a, (hl)
    ld (ti.scrapMem + 2), a
    ld de, (ti.scrapMem)
    inc hl
    ld d, (hl)
    inc hl
    ld e, (hl)
    push de
    pop hl
    call ti.ChkInRam
    jr z, .inRam
    ld a, (bufSpriteY)
    add a, 10
    ld bc, 0
    ld c, a
    add hl, bc

.inRam:
    inc hl
    inc hl
    pop de
    push de
    call .checkString
    pop de
    pop bc
    call z, .storeName
    jr .loopFindVars

.exitLoop:
    pop de
    pop bc
    push bc
    call ti.ChkBCIs0
    jp z, PrgmErr.PNTFN
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    ld hl, execHexLoc
    inc de
    inc de
    pop bc
    ldir
    jp return

.setupFindAll:
    call ti.ZeroOP1
    ld a, 5
    ld (ti.OP1), a
    ld ix, execHexLoc
    ld bc, 0
    bit randFlag, (iy + ti.asm_Flag2)
    jr z, .findAllLoop
    ld a, $15
    ld (ti.OP1), a

.findAllLoop:
    push bc
    call ti.FindAlphaUp
    jr c, .exitLoop + 1
    ld bc, -6
    add hl, bc
    ld a, (hl)
    ld (bufSpriteY), a ; use to preserve name length
    pop bc
    call .storeName
    jr .findAllLoop

.checkString:
    ld bc, (ans)

.loopStr:
    ld a, (de)
    cpi
    inc de
    ret nz
    call ti.ChkBCIs0
    ret z
    jr .loopStr

.storeName:
    ld hl, ti.OP1 + 1
    ld a, (bufSpriteY)
    bit randFlag, (iy + ti.asm_Flag2)
    jr z, .loopStoreName
    inc a
    dec hl

.loopStoreName:
    push af
    ld a, (hl)
    call .convertLetter
    ld (ix), a
    inc bc
    inc ix
    inc hl
    pop af
    dec a
    jr nz, .loopStoreName
    ld (ix), ti.tSpace
    inc ix
    inc bc
    ret

.convertLetter: ; fix lowercase letters
    cp a, $61
    ret c
    cp a, $7B
    ret nc
    ld (ix), $BB
    inc ix
    inc bc
    add a, $4F
    cp a, $BB
    ret c
    inc a
    ret

ungroupFile: ; det(34)
    jp return

getGroup: ; det(35)
    jp return

extGroup: ; det(36)
    jp return

groupMem: ; det(37)
    jp return

binRead: ; det(38)
    ld a, (noArgs)
    cp a, 4
    jp nc, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jr z, .inRam
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl

.inRam:
    inc de
    inc de
    ld hl, (var1)
    add hl, de
    push hl
    ld hl, (var2)
    call ti.ChkHLIs0
    jp z, PrgmErr.INVALA
    add hl, hl
    push hl
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    ex de, hl
    pop bc
    pop de

.loop:
    ld a, (de)
    push bc
    call _byteToToken
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    inc de
    pop bc
    dec bc
    dec bc
    call ti.ChkBCIs0
    jp z, return
    jr .loop

binWrite: ; det(39)
    ld a, (noArgs)
    dec a
    jp z, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push de
    push bc
    ld hl, Str9
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    push de
    push bc
    push bc
    pop hl
    srl h
    rr l
    jp c, PrgmErr.INVALS
    call ti.EnoughMem
    jp c, PrgmErr.NOMEM
    pop bc
    pop de
    pop hl
    push bc
    ld bc, (var1)
    or a, a
    sbc hl, bc
    jp c, PrgmErr.ENTFN
    pop bc
    srl b
    rr c
    ex de, hl
    ld de, execHexLoc
    push bc
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
    add a, e
    pop de
    pop hl
    ld (hl), a
    inc hl
    push hl
    inc de
    ex de, hl
    dec bc
    call ti.ChkBCIs0
    jr nz, .loop
    pop hl
    pop bc
    pop hl
    ld de, (var1)
    push hl
    add hl, de
    ex de, hl
    push bc
    push bc
    pop hl
    push de
    call ti.InsertMem
    pop de
    ld hl, execHexLoc
    pop bc
    push bc

.writeLoop:
    call ti.ChkBCIs0
    jr z, .changeSize
    ldi
    jr .writeLoop

.changeSize:
    pop bc
    pop de
    dec de
    ld hl, 0
    ld a, (de)
    ld h, a
    dec de
    ld a, (de)
    ld l, a
    add hl, bc
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    jp return

binDelete: ; det(40)
    ld a, (noArgs)
    cp a, 3
    jp c, PrgmErr.INVALA
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
    jr z, .continue
    dec hl
    ld (hl), $05

.continue:
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call c, _checkHidden
    jp c, PrgmErr.PNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.PGMARC
    ld bc, 0
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld b, a
    inc de
    call ti.ChkBCIs0
    jp z, return
    push de
    push bc
    ld hl, (var2)
    call ti.ChkHLIs0
    jp z, PrgmErr.INVALA
    ld hl, (var1)
    add hl, de
    push hl
    push bc
    pop hl
    call _getEOF
    pop hl
    push hl
    ld de, (EOF)
    ex de, hl
    or a, a
    sbc hl, de
    jp c, PrgmErr.ENTFN
    ld hl, (var2)
    push hl
    add hl, de
    dec hl
    ld de, (EOF)
    ex de, hl
    or a, a
    sbc hl, de
    jp c, PrgmErr.ENTFN
    pop de
    pop hl
    push de
    call ti.DelMem
    pop de
    pop hl
    or a, a
    sbc hl, de
    ex de, hl
    pop hl
    dec hl
    ld (hl), d
    dec hl
    ld (hl), e
    jp return

hexToBin: ; det(41)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop hl
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    srl b
    rr c
    jp c, PrgmErr.INVALS
    ld de, execHexLoc
    push bc
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
    add a, e
    pop de
    pop hl
    ld (hl), a
    inc hl
    push hl
    inc de
    ex de, hl
    dec bc
    call ti.ChkBCIs0
    jr nz, .loop
    pop hl
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    ld hl, execHexLoc

.storeLoop:
    call ti.ChkBCIs0
    jp z, return
    ldi
    jr .storeLoop

binToHex: ; det(42)
    call ti.AnsName
    call ti.ChkFindSym
    push de
    call ti.RclAns
    pop de
    ld a, (ti.OP1)
    cp a, $04
    jp nz, PrgmErr.SNTST
    ld hl, 0
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    inc de
    add hl, hl
    push hl
    push hl
    pop bc
    ex de, hl
    ld ix, execHexLoc

.loop:
    ld a, (hl)
    push bc
    call _byteToToken
    ld (ix), b
    inc ix
    ld (ix), c
    inc ix
    inc hl
    pop bc
    dec bc
    dec bc
    call ti.ChkBCIs0
    jr nz, .loop
    ld hl, Str9
    push hl
    call ti.Mov9ToOP1
    call ti.ChkFindSym
    call nc, ti.DelVarArc
    pop hl
    call ti.Mov9ToOP1
    pop hl
    push hl
    call ti.CreateStrng
    inc de
    inc de
    pop bc
    ld hl, execHexLoc
    ldir
    jp return

_byteToToken:
    ld b, a
    and a, $0F
    add a, $30
    cp a, $3A
    jr c, .notLetter
    add a, 7

.notLetter:
    ld c, a
    ld a, b
    and a, $F0
    srl a
    srl a
    srl a
    srl a
    add a, $30
    cp a, $3A
    jr c, .notLetter2
    add a, 7

.notLetter2:
    ld b, a
    ret

graphCopy: ; det(43)
    call ti.GrBufCpy
    jp return

edit1Byte: ; det(44)
    ld a, (noArgs)
    cp a, 5
    jp nc, PrgmErr.INVALA
    ld a, (var1)
    cp a, 10
    jp nc, PrgmErr.INVALA
    or a, a
    jr nz, .notStr0
    ld a, 10

.notStr0:
    dec a
    push af
    ld hl, Str0
    call ti.Mov9ToOP1
    pop af
    ld (ti.OP1 + 2), a
    call ti.ChkFindSym
    jp c, PrgmErr.SNTFN
    call ti.ChkInRam
    jp nz, PrgmErr.SFLASH
    ex de, hl
    ld bc, 0
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl
    ex de, hl
    ld hl, (var2)
    or a, a
    sbc hl, bc
    jp nc, PrgmErr.ENTFN
    ex de, hl
    ld bc, (var2)
    add hl, bc
    ld a, (var3)
    ld (hl), a
    jp return

waitAnyKey:
    call ti.GetCSC
    or a, a
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
    db "::S>FLASH",0

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
    db "Version BETA 1.2", 0

copyright:
    db "(c) 2022-2023", 0

creditsStr1:    db "Thank you to:", 0
creditsStr2:    db "Iambian", 0
creditsStr3:    db "PT_", 0
creditsStr4:    db "Kerm Martian", 0
creditsStr5:    db "MateoC", 0
creditsStr6:    db "jacobly", 0
creditsStr7:    db "NoahK", 0
creditsStr8:    db "Oxiti8", 0

easterEgg:
    db "EASTER", ti.tSpace, "EGG", ti.tFact, 0
easterEggLen := $ - easterEgg

if flag_prerelease

warningMsg:
    db "WARNING!", 0
    db "This program is still in", 0
    db "development. Please", 0
    db "proceed with caution.", 0

end if

celticCommands:
C00:    db "ReadLine() : Str0, Ans : Str9 or [", 0
C01:    db "ReplaceLine() : Str0, Str9, Ans", 0
C02:    db "InsertLine() : Str0, Str9, Ans", 0
C03:    db "SpecialChars() : NONE : Str9", 0
C04:    db "CreateVar(AV_HEADER) : Str0", 0
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
C16:    db "FillScreen(COLOR_L,COLOR_H)", 0
C17:    db "DrawLine(COLOR_L,COLOR_H,X1,Y1,X2,Y2)", 0
C18:    db "SetPixel(COLOR_L,COLOR_H,X,Y)", 0
C19:    db "GetPixel(X,Y) : NONE : Ans and [", 0
C20:    db "PixelTestColor(ROW,COL) : NONE : [", 0
C21:    db "PutSprite(X,Y,WIDTH,HEIGHT) : Str9", 0
C22:    db "GetMode(MODE) : NONE : [", 0
C23:    db "RenameVar() : Str0, Str9", 0
C24:    db "LockPrgm() : Str0", 0
C25:    db "HidePrgm() : Str0", 0
C26:    db "PrgmToStr(STR_NUM) : Str0 : StrX", 0
C27:    db "GetPrgmType() : Str0 : [", 0
C28:    db "GetBatteryStatus() : NONE : [", 0
C29:    db "SetBrightness(NUM) : NONE : NONE or [", 0
C30:    db "GetListElem(ELEM) : Ans : [", 0
C31:    db "GetArgType() : Ans : [", 0
C32:    db "ChkStats(FN) : NONE : Str9 or [", 0
C33:    db "FindProg(TYPE) : Ans : Str9", 0
C34:    db "UngroupFile(REPLACE) : Str0", 0
C35:    db "GetGroup() : Str0 : Str9", 0
C36:    db "ExtGroup(ITEM_NUM) : Str0", 0
C37:    db "GroupMem(ITEM_NUM) : Str0 : [", 0
C38:    db "BinRead(START,NUM_BYTES) : Str0 : Str9", 0
C39:    db "BinWrite(START_BYTE) : Str0, Str9", 0
C40:    db "BinDelete(START,NUM_BYTES) : Str0", 0
C41:    db "HexToBin() : Ans : Str9", 0
C42:    db "BinToHex() : Ans : Str9", 0
C43:    db "GraphCopy()", 0
C44:    db "Edit1Byte(STR_NUM,START,BYTE)", 0

; additional rodata

celticCommandsPtrs:
    dl C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15
    dl C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, C31
    dl C32, C33, C34, C35, C36, C37, C38, C39, C40, C41, C42, C43, C44

Str9:
    db ti.StrngObj, ti.tVarStrng, ti.tStr9, 0, 0

Str0:
    db ti.StrngObj, ti.tVarStrng, ti.tStr0, 0, 0

Theta:
    db ti.RealObj, ti.tTheta, 0, 0

tempPrgmName:
    db ti.ProtProgObj, "XTEMP000", 0

appName:
    db ti.AppVarObj, "CelticCE", 0
