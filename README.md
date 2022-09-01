# CelticCE
Celtic for the TI-84 Plus CE (finally).
You can view the online documentation [here](https://roccoloxprograms.github.io/CelticCE).

# Functions

### Completed
 * [Celtic 2 CSE](https://roccoloxprograms.github.io/CelticCE/csefunctions.html)
 * [Doors CE 9](https://roccoloxprograms.github.io/CelticCE/dcefunctions.html)

### In Progress
 * ToggleSet - `det(16,"FN",f#) 0=Arc;1=Lk;2=PA;3=Hid;4=Del;5=Crt;6=PS;7=Stat`
 * GetListElem - `det(17,"LN",elem) out:lNAME(elem) -> Real/Cpx`
 * GetArgType - `det(18,argofanytype) filetype code`
 * ChkStats - `det(19,f#) 0=RAM 1=ARC 2=ID 3=OSVER`
 * FindProg - `det(20,["SEARCH"])`
 * UngroupFile - `det(21,"GFN")`
 * GetGroup - `det(22,"GFN")`
 * ExtGroup - `det(23,"GFN",item#)`
 * GroupMem - `det(24,"GFN",item#)`
 * BinRead - `det(25,"FN",bytestart,#ofbytes)`
 * BinWrite - `det(26,"HEX","FN",bytestart)`
 * BinDelete - `det(27,"FN",bytestart,del#ofbytes)`
 * HexToBin - `det(28,"HEXSTRING")`
 * BinToHex - `det(29,"BIN")`
 * FastCopy - `det(30)`
 * Edit1Byte - `det(31,Str?,StartByte,ReplaceWithThisByte)`
 * IndexFile - `det(32,"FILENAME","NEWINDEXNAME")`
 * LookupIndex - `det(33,"FILENAME","INDEXNAME",line#,[#oflines])`
 * ErrorHandle - `det(34,function,string)`
 * StringRead - `det(35,"binstring",start,readThisMany)`
 * HexToDec - `det(36,"HEXSTRING")`
 * DecToHex - `det(37,SomeRealNumber,[autoOverride])`
 * EditWord - `det(38,start_byte,replace_with_this_word)`
 * BitOperate - `det(39,value1,value2,logic)`
 * GetProgList - `det(40,"SEARCHSTRING",[type])`
 * GetCalcVer - `det(41) Returns calcversion`
