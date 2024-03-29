Error Codes
===========

Overview
~~~~~~~~

Celtic does its best to prevent errors. However, if something goes wrong with running a function, Celtic will return an error code. This can be from lack of memory, an incorrect argument, or something else.
Keep in mind that Celtic might not always detect the exact error, or realize that there is one in the first place. You can use the error codes to help with the debugging process.
This page also contains TI-OS errors and the corresponding values returned in the ErrorHandle command.

Celtic Errors
~~~~~~~~~~~~~

========== ================================================================================================
Error Code Description
========== ================================================================================================
..P:IS:FN  A program already exists, and Celtic will not overwrite it.
..NUMSTNG  The specified line is past end of file. Used when getting the amount of lines in a program.
..NULLVAR  The specified variable did not contain useful data.
..L:NT:FN  The specified line in the program does not exist.
..S:NT:FN  The specified string was not found.
..S:FLASH  The specified string is archived.
..S:NT:ST  The input is not a string, but Celtic expects a string.
..NT:EN:M  There is not enough memory to complete the requested action.
..P:NT:FN  The specified program or appvar was not found.
..PGM:ARC  The specified program or appvar is archived, so it cannot be modified.
..NULLSTR  The specified line exists, but is empty.
..NT:REAL  The input was not a real number, but Celtic expects a real number.
..INVAL:A  An invalid argument was entered. This error code could refer to various issues.
..INVAL:S  An invalid string was entered.
..2:M:ARG  More arguments were entered than Celtic is able to handle.
..NT:A:LS  The argument was not a list, but Celtic expects a list.
..E:NT:FN  The entry was not found in the list specified.
..G:NT:FN  The specified group was not found.
..NT:A:GP  The file specified was not a group.
..SUPPORT  Whatever happened was not supported by Celtic.
========== ================================================================================================

TI-OS Errors
~~~~~~~~~~~~

===== ===========
Value Error
===== ===========
0     No Error
1     Overflow
2     DivBy0
3     SingularMat
4     Domain
5     Increment
6     Break
7     NonReal
8     Syntax
9     DataType
10    Argument
11    DimMismatch
12    Dimension
13    Undefined
14    Memory
15    Invalid
16    IllegalNest
17    Bound
18    GraphRange
19    Zoom
20    Label
21    Stat
22    Solver
23    Singularity
24    SignChange
25    Iterations
26    BadGuess
27    StatPlot
28    TolTooSmall
29    Reserved
30    Mode
31    LnkErr
32    LnkMemErr
33    LnkTransErr
34    LnkDupErr
35    LnkMemFull
36    Unknown
37    Scale
38    IdNotFound
39    NoMode
40    Validation
41    Length
42    Application
43    AppErr1
44    AppErr2
45    ExpiredApp
46    BadAddr
47    Archived
48    Version
49    ArchFull
50    Variable
51    Duplicate
52    Date
53    UnknownCmd
54    OverLimit
55    Disabled
56    Xmit
57    MemFull
===== ===========
