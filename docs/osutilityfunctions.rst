OS Utility Functions
====================

Overview
~~~~~~~~
These functions perform various actions related to the OS and its various features.

Documentation
~~~~~~~~~~~~~

.. function:: GetMode: det(22, mode)

    Checks a specified mode, from 0 to 10. A table containing the information on the modes and possible outcomes is below.

    ===== =============== ===========================================================================
    Input Mode            Possible Returns
    0     Mathprint       0 if not enabled, 1 if enabled.
    1     Notation        0 for Normal, 1 for Scientific, 2 for Engineering.
    2     Trig Mode       0 for Radian, 1 for Degree.
    3     Graph Mode      0 for Function, 1 for Parametric, 2 for Polar, 3 for Sequence.
    4     Graph Equations 0 for Sequential, 1 for Simultaneous.
    5     Numeric Format  0 for Real, 1 for a + bi mode, 2 for re^(Thetai). Theta is the theta token.
    6     Window Mode     0 for Full, 1 for Horizontal, 2 for Graph-Table.
    7     Coordinate Mode 0 for Rectangular coordinates, 1 for Polar coordinates
    8     Grid Mode       0 if the grid is off, 1 if the grid is on.
    9     Axis Mode       0 if the axis is off, 1 if it is on.
    10    Axis Labels     0 if the axis labels are off, 1 if they are on.
    ===== =============== ===========================================================================

    Parameters:
     * ``mode``: Which mode to check. Refer to the table above. Must be between 0 and 10.

    Returns:
     * Varies based on the specified mode. See table above.

------------

.. function:: RenameVar: det(23); Str0 = variable to rename; Str9 = new name

    Renames the variable specified in ``Str0`` with a new name specified in ``Str9``. For appvars, the name in ``Str0`` must be preceeded with the ``rowSwap(`` token, however, the new name does not need the ``rowSwap(`` token. Renaming a program will result in the program being locked.

    Parameters:
     * ``Str0``: The name of the variable you wish to rename. If it is an appvar, it must be preceeded by the ``rowSwap(`` token.
     * ``Str9``: The new name that you wish to rename the specified file to. It does not need to be preceeded by the ``rowSwap(`` token, regardless of whether it is a program or appvar.

    Returns:
     * Renames the variable specified in ``Str0`` with the new name specified in ``Str9``.

    Errors:
     * ``..NT:EN:M`` depending on the amount of remaining memory and the size of the variable being renamed.
    
------------

.. function:: LockPrgm: det(24); Str0 = variable to lock

    Toggles the locked attribute of the program referenced by ``Str0``.

    .. warning::
        If you lock/unlock an archived program, Celtic un-archives it when running the function and then re-archives it when the function is complete. This means that it could result in a garbage collect.

    Parameters:
     * ``Str0``: The name of the program to toggle the locked attribute of.

    Returns:
     * Toggles whether or not the specified program is locked.

    Errors:
     * ``..SUPPORT`` if you attempt to use this function on an appvar.

------------

.. function:: HidePrgm: det(25); Str0 = variable to hide

    Toggles the hidden attribute of the program referenced by ``Str0``.

    .. warning::
        If you hide/unhide an archived program, Celtic un-archives it when running the function and then re-archives it when the function is complete. This means that it could result in a garbage collect.

    Parameters:
     * ``Str0``: The name of the program to toggle the hidden attribute of.

    Returns:
     * Toggles whether or not the specified program is hidden.

    Errors:
     * ``..SUPPORT`` if you attempt to use this function on an appvar.

------------

.. function:: PrgmToStr: det(26, string_number); Str0 = variable to read

    Copies the contents of a file specified in ``Str0`` to the string specified by ``string_number``. If you wish to read the contents of an appvar, you must preceed the name with the ``rowSwap(`` token in ``Str0``.

    Parameters:
     * ``string_number``: The number of the string to copy to. Can be from 0 to 9. 0 means ``Str0``, 1 means ``Str1`` and so on.
     * ``Str0``: Name of the variable to copy. The name must be preceeded by the ``rowSwap(`` token if you wish to read an appvar.

    Returns:
     * The contents of the specified variable in the string specified by ``string_number``.

    Errors:
     * ``..NT:EN:M`` if there is not enough memory to create the string with the contents of the specified variable.
     * ``..NULLVAR`` if the specified file contains no data.

------------

.. function:: GetPrgmType: det(27); Str0 = program to check

    Gets the type of program specified in ``Str0``. This is not the OS type, it is the actual program type (C, ASM, etc). A table with the return codes and filetypes they signify is below.

    ==== =============
    Code Filetype
    0    eZ80 Assembly
    1    C
    2    TI-BASIC
    3    ICE
    4    ICE Source
    ==== =============

    Parameters:
     * ``Str0``: Name of the program to check. It cannot be an appvar.

    Returns:
     * ``Theta``: Contains the number referencing the filetype. See the table above.

    Errors:
     * ``..INVAL:S`` if you attempt to use this function on an appvar.

------------

.. function:: GetBatteryStatus: det(28)

    Gets the current status of the battery, as a number between 0 and 4, 0 being no charge and 4 being fully charged. If the battery is charging, 10 will be added. For example, a battery that is partially charged and also actively charging would return 12.

    Returns:
     * ``Theta``: Current status of the battery.

------------

.. function:: SetBrightness: det(29, brightness)

    Sets the LCD to the specified ``brightness``. The brightness can be between 1 and 255, with 1 being the brightest and 255 being the darkest. If the brightness is set to 0, it will instead return the current brightness of the screen.
    
    .. note::
        The brightness will not persist after the calculator is turned off. Instead, it will go back to what it was previously.

    Parameters:
     * ``brightness``: The level of brightness to set the screen to, between 1 and 255. 0 will instead return the current level of brightness.

    Returns:
     * ``Theta``: If you attempt to set the brightness to 0, ``Theta`` will contain the current brightness.
     * If ``brightness`` is between 1 and 255 (Not 0), it will instead set the screen to the specified brightness, with 1 being the lightest and 255 the darkest.

------------

.. function:: SearchFile: det(52, offset); Str0 = file name, Str9 = search string

    Search a file specified by ``file name``, for a ``search string``, beginning at the user-specified (0-indexed) ``offset``.

    Parameters:
     * ``offset``: Byte offset in the program to start searching, with 0 being the first byte of the program
     * ``Str0``: Name of the file to search in
     * ``Str9``: String to search for

    Returns:
     * ``Theta``: The byte offset of the located string

    Errors:
     * ``..E:NT:FN`` if the string is not located
     * ``..INVAL:S`` if the string is bigger than the program to search for

------------

.. function:: CheckGC: det(53); Str0 = variable name

    Checks if the archiving of the file specified by ``variable name`` will trigger a Garbage Collect.

    .. note::
        If the file is already archived, the command will not say that archiving it will cause a Garbage Collect, regardless of size.

    Parameters:
     * ``Str0``: Name of variable to check for

    Returns:
     * ``Ans``: 0 if a Garbage Collect will not occur, and 1 if it will.
