# Change Log

All notable changes to the Celtic CE library will be documented in this file.

## [1.0.0-rc.1] - yyyy-mm-dd

### Added

- Graphics Functions:
    - PutChar
    - PutTransChar
    - HorizLine
    - VertLine
- OS Utility Functions:
    - RunAsmPrgm
    - LineToOffset
    - OffsetToLine
    - GetKey
    - TurnCalcOff
    - BackupString
    - RestoreString
    - BackupReal
    - RestoreReal
    - SetParseLine
    - SwapFileType
    - PrgmCleanUp
- AINSTALL program that can be called to install Celtic's hooks outside of the CelticCE app
- Hook which detects <kbd>2nd</kbd> + <kbd>enter</kbd> in the TI-OS editor and displays line number and file size information on the status bar
- Created COMMANDS.md which contains a simplified list of all commands in CelticCE

### Changed
- Graphics Functions:
    - ScrollScreen command renamed to ShiftScreen
    - ShiftScreen can now shift a user-specified region of the screen
- OS Utility Functions:
    - GetMode command can now also check the following modes:
        - DetectAsymptotes
        - StatWizards
        - MixedFractions
        - AnswersAuto
- Celtic III Functions:
    - ErrorHandle now has an option to return the offset in the program at which the error occurred
- Major optimizations to core functionalities, including both size and speed improvements
- Replaced all arbitrary numbers with equates for readability
- Changed flag equates for better readability
- UI overhaul to the CelticCE app
- Updated installer to display "Installing app..." and not display the run indicator so it doesn't appear frozen when installing the app

### Fixed

- Celtic 2 CSE Functions:
    - ReadLine correctly gets the data pointer of the program if it is hidden
    - ExecArcPrgm correctly gets the data pointer of the program if it is hidden
- OS Utility Functions:
    - LockPrgm now re-archives hidden programs correctly
    - HidePrgm now re-archives hidden programs correctly
- Celtic III Functions:
    - ErrorHandle now runs unsquished asm programs in the RAM
- Blocked user access to system programs (AKA `prgm!` and `prgm#`)

## [1.3.0-beta] - 2023-06-01

### Added

- Graphics Functions:
    - GetStringWidth
    - TransSprite
    - ScaleSprite
    - ScaleTSprite
    - ScrollScreen
    - RGBto565
    - DrawRect
    - DrawCircle
    - FillCircle
    - DrawArc
    - DispTransText
    - ChkRect
- OS Utility Functions:
    - SearchFile
    - CheckGC
- Celtic III Functions:
    - ErrorHandle
    - StringRead
    - HexToDec 
    - DecToHex
    - EditWord
    - BitOperate
    - GetProgList

### Changed

- Doors CE 9 Functions:
    - DispText command uses a 16-bit number to count the number of characters being displayed on the screen instead of an 8-bit one
    - TextRect command renamed to FillRect and no longer uses the TI-OS routine
- Graphics Functions:
    - DrawLine command no longer uses the TI-OS routine
    - Greatly optimized SetPixel command
    - PixelTestColor now returns in Ans
    - PutSprite can now read sprite data from a user-specified string variable
- Celtic III Functions:
    - FindProg command now returns a memory error if there isn't enough RAM to store the return string
- Split up files
- Better formatting consistency in CHANGELOG.md
- Allocated an extra 3 bytes for a 9th argument to be passed in Celtic commands
- Celtic now uses its own ConvOP1 routine (borrowed from Doors CS 7 and modified for eZ80) rather than the TI-OS one
- Some arbitrary numbers in the source code were changed to equates for better readability
- X and Y coordinates on the screen are now calculated in VRAM using a routine provided by [calc84maniac](https://github.com/calc84maniac)
- Status bar command preview in the TI-OS BASIC editor now says "NA" instead of "None" when there are no input arguments for a command
- Several minor optimizations

### Fixed
- Installer will automatically delete itself even if the program has been renamed
- Celtic will pop all remaining arguments off the FPS if it encounters an invalid argument
- Celtic correctly detects if not enough arguments have been passed for certain commands
- Longer variable names and groups are now properly detected

## [1.2.0-beta] - 2023-02-22

### Added

- Celtic III Functions:
    - UngroupFile
    - GetGroup
    - ExtGroup
    - GroupMem
    - BinRead
    - BinWrite
    - BinDelete
    - HexToBin
    - BinToHex
    - GraphCopy
    - Edit1Byte

### Changed

- OS Utility Functions:
    - PrgmToStr now returns an error if the specified file contains no data
- Jump table is now an LUT. Jumping code has also been reworked
- Optimized app UI code
- Zero out help hook pointer to be safe

### Fixed

- Fixed HidePrgm command to work with archived programs

## [1.1.0-beta] - 2022-11-29

### Added

- Graphics Functions:
    - FillScreen
    - DrawLine
    - SetPixel
    - GetPixel
    - PixelTestColor
    - PutSprite
- OS Utility Functions:
    - GetMode
    - RenameVar
    - LockPrgm
    - HidePrgm
    - PrgmToStr
    - GetPrgmType
    - GetBatteryStatus
    - SetBrightness
- Celtic III Functions:
    - GetListElem
    - GetArgType
    - ChkStats
    - FindProg
- E̴͎̓ä̵̯̩̪́s̸͕̜͌̂t̴̹̹̩͑e̵͍̭͊̄̑ṙ̴̝ ̶̨͚̯̎͌e̷̢̯̣͗̈́̆g̶̬̹͇̀ĝ̸̤͛

### Changed

- Temp storage now uses pixelShadow2 with an offset of 100 bytes instead of using pixelShadow
- ExecHex command no longer has a restriction of 255 characters, instead it is limited to 8192
- Preserve stack pointer when running a command and restore it when exiting to the OS

### Fixed

- Potential error with VarStatus command when a hidden program name starts with a 'T'

## [1.0.0-beta] - 2022-09-17

### Added

- Celtic 2 CSE Functions:
    - ReadLine
    - ReplaceLine
    - InsertLine
    - SpecialChars
    - CreateVar
    - ArcUnarcVar
    - DeleteVar
    - DeleteLine
    - VarStatus
    - BufSprite
    - BufSpriteSelect
    - ExecArcPrgm
    - DispColor
- Doors CE 9 Functions:
    - DispText
    - ExecHex
    - TextRect
- Hook chaining through help hook pointer
