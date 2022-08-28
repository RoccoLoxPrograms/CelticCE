Error Codes
===========

Overview
~~~~~~~~

Celtic does its best to prevent errors. However, if something goes wrong with running a function, Celtic will return an error code. This can be from lack of memory, an incorrect argument, or something else.
Keep in mind that Celtic might not always detect the exact error, or realize that there is one in the first place. You can use the error codes to help with the debugging process.

Documentation
~~~~~~~~~~~~~

========== ================================================================================================
Error Code Description
========== ================================================================================================
..P:IS:FN  A program already exists, and Celtic will not overwrite it.
..NUMSTNG  The specified line is past end of file. Used when getting the amount of lines in a program.
..L:NT:FN  The specified line in the program does not exist.
..S:NT:FN  The specified string was not found.
..S:FLASH  The specified string is archived.
..S:NT:ST  The input is not a string, but Celtic expects a string.
..NO:MEM   There is not enough memory to complete the requested action.
..P:NT:FN  The specified program or appvar was not found.
..PGM:ARC  The specified program or appvar is archived, so it cannot be modified.
..NULLSTR  The specified line exists, but is empty.
..NT:REAL  The input was not a real number, but Celtic expects a real number.
..INVAL:A  An invalid argument was entered. This error code could refer to various issues.
..INVAL:S  An invalid string was entered.
..SUPPORT  Whatever happened was not supported by Celtic.
========== ================================================================================================