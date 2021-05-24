# CelticCE
Celtic for the TI-84 Plus CE (finally).

# Features
- ReadLine - det(0), Str0=program name, Ans=line number
- ReplaceLine - det(1), Str0=program name, Ans=line number, Str9=replacement
- InsertLine - det(2), Str0=program name, Ans=line number, Str9=contents
- SpecialChars - det(3)
- CreateVar - det(4), Str0=program/AppVar name
- ArcUnarcVar - det(5), Str0=program/AppVar name
- DeleteVar - det(6), Str0=program/AppVar name
- DeleteLine - det(7), Str0=program name, Ans=line number
- VarStatus - det(8), Str0=program name
- BufSprite - det(9,width,X,Y), Str9=sprite data
- BufSpriteSelect - det(10,width,X,Y,start,length), Str9=sprite data
- ExecArcPrgm - det(11,FN,NUMBER)
- DispColor - det(12,FG_LO,FG_HI,BG_LO,BG_HI)
- [det(13) This might be what det(41) is.]
- ExecHex - det(14), Ans=Hex code to execute
- TextRect - det(15,FG_LO,FG_HI,ROW,COL,HEIGHT,WIDTH)
- ToggleSet - det(16,"FN",f#) 0=Arc;1=Lk;2=PA;3=Hid;4=Del;5=Crt;6=PS;7=Stat
- GetListElem - det(17,"LN",elem) out:lNAME(elem) -> Real/Cpx
- GetArgType - det(18,argofanytype) filetype code
- ChkStats - det(19,f#) 0=RAM 1=ARC 2=ID 3=OSVER
- FindProg - det(20,["SEARCH"])
- UngroupFile - det(21,"GFN")
- GetGroup - det(22,"GFN")
- ExtGroup - det(23,"GFN",item#)
- GroupMem - det(24,"GFN",item#)
- BinRead - det(25,"FN",bytestart,#ofbytes)
- BinWrite - det(26,"HEX","FN",bytestart)
- BinDelete - det(27,"FN",bytestart,del#ofbytes)
- HexToBin - det(28,"484558")
- BinToHex - det(29,"BIN")
- FastCopy - det(30)
- Edit1Byte - det(31,Str?,StartByte,ReplaceWithThisByte)
- IndexFile - det(32,"FILENAME","NEWINDEXNAME")
- LookupIndex - det(33,"FILENAME","INDEXNAME",line#,[#oflines])
- ErrorHandle - det(34,function,string)
- StringRead - det(35,"binstring",start,readThisMany)
- HexToDec - det(36,"HEXSTRING")
- DecToHex - det(37,SomeRealNumber,[autoOverride])
- EditWord - det(38,start_byte,replace_with_this_word)
- BitOperate - det(39,value1,value2,logic)
- GetProgList - det(40,"SEARCHSTRING",[type])
- GetCalcVer - det(41) Returns calcversion (This might be changed to det(13) )
