# Change Log

All notable changes to the Celtic CE library will be documented in this file.

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

### Fixed

- Fixed HidePrgm function to work with archived programs

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

### Changed

- Temp storage now uses pixelShadow2 with an offset of 100 bytes instead of using pixelShadow
- ExecHex function no longer has a restriction of 255 characters, instead it is limited to 8192

### Fixed

- Potential error with VarStatus function when a hidden program name starts with a 'T'

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
