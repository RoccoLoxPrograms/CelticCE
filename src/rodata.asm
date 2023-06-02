;----------------------------------------
;
; Celtic CE Source Code - rodata.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

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
    db "Version BETA 1.3", 0

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
creditsStr9:    db "DJ_O", 0

easterEgg:
    db "EASTER", ti.tSpace, "EGG", ti.tFact
easterEggLen := $ - easterEgg
    db 0

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
C03:    db "SpecialChars() : NA : Str9", 0
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
C15:    db "FillRect(COLOR_L,COLOR_H,X,Y,WTH,HT)", 0
C16:    db "FillScreen(COLOR_L,COLOR_H)", 0
C17:    db "DrawLine(COLOR_L,COLOR_H,X1,Y1,X2,Y2)", 0
C18:    db "SetPixel(COLOR_L,COLOR_H,X,Y)", 0
C19:    db "GetPixel(X,Y) : NA : Ans, [", 0
C20:    db "PixelTestColor(ROW,COL) : NA : [", 0
C21:    db "PutSprite(X,Y,WIDTH,HEIGHT,STR#)", 0
C22:    db "GetMode(MODE) : NA : [", 0
C23:    db "RenameVar() : Str0, Str9", 0
C24:    db "LockPrgm() : Str0", 0
C25:    db "HidePrgm() : Str0", 0
C26:    db "PrgmToStr(STR_NUM) : Str0 : Str", $01, 0
C27:    db "GetPrgmType() : Str0 : [", 0
C28:    db "GetBatteryStatus() : NA : [", 0
C29:    db "SetBrightness(NUM) : NA : NA or [", 0
C30:    db "GetListElem(ELEM) : Ans : [", 0
C31:    db "GetArgType() : Ans : [", 0
C32:    db "ChkStats(FN) : NA : Str9 or [", 0
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
C45:    db "ErrorHandle() : Ans : [", 0
C46:    db "StringRead(STR#,START,BYTES) : NA : Str9", 0
C47:    db "HexToDec() : Ans : [", 0
C48:    db "DecToHex(NUMBER,OVERRIDE) : NA : Str9", 0
C49:    db "EditWord(STR_NUM,START,WORD)", 0
C50:    db "BitOperate(VAL1,VAL2,FN) : NA : [", 0
C51:    db "GetProgList(TYPE) : Ans : Str9", 0
C52:    db "SearchFile(OFFSET) : Str0, Str9 : [", 0
C53:    db "CheckGC() : Str0 : Ans", 0
C54:    db "GetStringWidth(LF) : Ans : [", 0
C55:    db "TransSprite(X,Y,WTH,HT,T_COLOR,STR#)", 0
C56:    db "ScaleSprite(X,Y,WTH,HT,SC_X,SC_Y,STR#)", 0
C57:    db "ScaleTSprite(X,Y,W,H,SC_X,SC_Y,TC,STR#)", 0
C58:    db "ScrollScreen(DIRECTION,AMOUNT)", 0
C59:    db "RGBto565(R,G,B) : NA : Ans, [", 0
C60:    db "DrawRect(COLOR_L,COLOR_H,X,Y,WTH,HT)", 0
C61:    db "DrawCircle(COLOR_L,COLOR_H,X,Y,RADIUS)", 0
C62:    db "FillCircle(COLOR_L,COLOR_H,X,Y,RADIUS)", 0
C63:    db "DrawArc(CLR_L,CLR_H,X,Y,R,STRT", $D4,",END", $D4,")", 0
C64:    db "DispTransText(LF,FG_LO,FG_HI,X,Y) : Str9", 0
C65:    db "ChkRect(X0,Y0,W0,H0,X1,Y1,W1,H1) : NA : Ans", 0

; additional rodata

celticCommandsPtrs:
    dl C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15
    dl C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, C31
    dl C32, C33, C34, C35, C36, C37, C38, C39, C40, C41, C42, C43, C44, C45, C46, C47
    dl C48, C49, C50, C51, C52, C53, C54, C55, C56, C57, C58, C59, C60, C61, C62, C63
    dl C64, C65

Str9:
    db ti.StrngObj, ti.tVarStrng, ti.tStr9, 0, 0

Str0:
    db ti.StrngObj, ti.tVarStrng, ti.tStr0, 0, 0

Theta:
    db ti.RealObj, ti.tTheta, 0, 0

tempPrgmName:
    db ti.ProtProgObj, "XTEMP000", 0

basicPrgmName:
    db ti.ProgObj, "celticex", 0

appName:
    db ti.AppVarObj, "CelticCE", 0
