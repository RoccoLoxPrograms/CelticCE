Celtic 2 CSE Functions
======================

Overview
~~~~~~~~
These functions are the same as those included in Doors CSE 8 for the TI-84 Plus CSE, unless noted otherwise. Most documentation is from the `DCS Wiki <https://dcs.cemetech.net/index.php?title=Third-Party_BASIC_Libraries_(Color)>`__.

Documentation
~~~~~~~~~~~~~

.. function:: ReadLine: det(0); Str0 = variable name; Ans = line number

    Reads a line from a program or AppVar. If ``Ans`` (line number) equals 0, then Theta will be overwritten with the number of lines in the program being read, though it will still return the ``..NUMSTNG`` error, like the original Celtic 2 CSE. Otherwise, ``Ans`` refers to the line being read.

    .. warning::
        If you attempt to read the line of an assembly program, there is a risk of a reset. If Celtic passes an invalid token to ``Str9``, it could cause a RAM clear.

    Parameters:
     * ``Str0``: Name of program to read from.
     * ``Ans``: Line number to read from, begins at 1.

    Returns:
     * ``Str9``: Contents of the line read.
     * ``Theta``: Number of lines if ``Ans`` was 0.

    Errors:
     * ``..NULLSTR`` if the line is empty.

------------

.. function:: ReplaceLine: det(1); Str0 = variable name; Ans = line number; Str9 = replacement

    Replaces (overwrites) a line in a program or AppVar. ``Ans`` refers to the line to replace.

    Parameters:
     * ``Str0``: Name of file to read from.
     * ``Ans``: Line number to replace, begins at 1.
     * ``Str9``: Contents to replace the line with.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.

    Errors:
     * ``..PGM:ARC`` if the file is archived.

------------

.. function:: InsertLine: det(2); Str0 = variable name; Ans = line number; Str9 = contents

    Insets a line into a program or AppVar. ``Ans`` refers to the line number to write to.

    Parameters:
     * ``Str0``: Name of file to write to.
     * ``Ans``: Line number to write to, begins at 1.
     * ``Str9``: Material to insert into a program. The line that was occupied is shifted down one line and this string is inserted into the resulting location.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.

    Errors:
     * ``..PGM:ARC`` if the file is archived.
     * ``..NT:EN:M`` if there is not enough memory to complete the action.

.. note::
    If your usage of InsertLine results in the program exceeding 65535 bytes (the maximum size of a file), it will result in loss of memory. Celtic does not check if you exceed this filesize, as there should be no reason anyone would do this in the first place.

------------

.. function:: SpecialChars: det(3)

    Stores the ``->`` and ``"`` characters into ``Str9``.

    Returns:
     * ``Str9``: ``->`` and ``"``, respectively. you can use substrings to extract them. There are also 7 more characters in ``Str9``, which are junk.

------------

.. function:: CreateVar: det(4); Str0 = variable name

    Create a program or AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to create.

    Alternative method for appvars: ``det(4, HEADER), Str0 = variable name``
     * ``HEADER``: whether or not to include a header which allows `CEaShell <https://github.com/roccoloxprograms/shell>`__ to edit the appvar. This extra argument is optional. 1 to include the header, and 0 to not.

    Returns:
     * Creates the program or AppVar.

    Errors:
     * ``..P:IS:FN`` if the program already exists.

------------

.. function:: ArcUnarcVar: det(5); Str0 = variable name

    Archive/unarchive a program or AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to move between Archive and RAM.

    Returns:
     * Moves a program or AppVar into RAM if it was in Archive, or into Archive if it was in RAM.

------------

.. function:: DeleteVar: det(6); Str0 = variable name

    Delete a program variable or an AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to delete.

    Returns:
     * The indicated program or AppVar is deleted.

------------

.. function:: DeleteLine: det(7); Str0 = variable name; Ans = line number

    Deletes a line from a program or AppVar. ``Ans`` is the line to delete.

    Parameters:
     * ``Str0``: Name of program or AppVar to delete from.
     * ``Ans``: Line number to delete from, begins at 1.

    Returns:
     * Deletes the specified line from the program or AppVar.

------------

.. function:: VarStatus: det(8); Str0 = variable name

    Output a status string describing a program or AppVar's current state, including size, visibility, and more.

    Parameters:
     * ``Str0``: Name of program or AppVar to examine.

    Returns:
     * ``Str9``: Contains a 9 byte output code.
         * 1st character: ``A`` = Archived, ``R`` = RAM
         * 2nd character: ``V`` = Visible, ``H`` = Hidden
         * 3rd character: ``L`` = Locked, ``W`` = Writable
         * 4th character: ``_`` (Space character)
         * 5th - 9th character: Size, in bytes
     * Example: ``AVL 01337`` = Archived, visible, locked, 1337 bytes.

------------

.. function:: BufSprite: det(9, width, x, y); Str9 = sprite data

    Draws indexed (palette-based) sprite onto the LCD and into the graph buffer. Copies the contents of the graph buffer under the sprite back into Str9, so that you can "erase" the sprite back to the original background. Good for moving player characters, cursors, and the like. Interacts politely with Pic variables and OS drawing commands like ``Line(``, ``Circle(``, ``Text(``, and so on. If you want to draw a lot of different sprites to the screen and won't need to erase them back to the background, then use BufSpriteSelect instead.

    Parameters:
     * ``Str9``: Sprite data as ASCII hex, one nibble per byte. The digits 1-F are valid colors (1 = blue, 2 = red, 3 = black, etc), while G will cause the routine to skip to the next line. 0 is normal transparency, and lets the background show through. H is a special kind of transparency that erases back to transparency instead of leaving the background color intact.
     * ``x``: x coordinate to the top-left corner of the sprite.
     * ``y``: y coordinate to the top-left corner of the sprite.
     *  ``width``: Sprite width (height is computed).

    Returns:
     * ``Str9``: Same length as input, contains the previous contents of the graph buffer where the sprite was drawn. you can call ``det(9...)`` again without changing Str9 to effectively undo the first sprite draw.

    Errors:
     * ``..INVAL:S`` if the string contains invalid characters.

------------

.. function:: BufSpriteSelect: det(10, width, x, y, start, length); Str9 = sprite data

    Draws indexed (palette-based) sprite onto the LCD and into the graph buffer. Good for drawing tilemaps, backgrounds, and other sprites that you won't want to individually erase. If you want to be able to erase the sprite drawn and restore the background, you should consider BufSprite instead. This routine takes an offset into Str9 and a sprite length as arguments, so that you can pack multiple sprites of different lengths into Str9.

    Parameters:
     * ``Str9``: Sprite data as ASCII hex, one nibble per byte. The digits 1-F are valid colors (1 = blue, 2 = red, 3 = black, etc), while G will cause the routine to skip to the next line. 0 is normal transparency, and lets the background show through. H is a special kind of transparency that erases back to transparency instead of leaving the background color intact.
     * ``x``: x coordinate to the top-left corner of the sprite.
     * ``y``: y coordinate to the top-left corner of the sprite.
     *  ``width``: Sprite width (height is computed).
     *  ``start``: Offset into ``Str9`` of the start of pixel data, begins at 0.
     *  ``length``: Length of sprite data in characters.

    Returns:
     * Sprite drawn to LCD and stored to graph buffer.

    Errors:
     * ``..INVAL:S`` if the string contains invalid characters.

------------

.. function:: ExecArcPrgm: det(11, function, temp_prog_number); Ans = program name

    Copies a program to the ``XTEMP`` program of the specified ``temp_prog_number``. ``temp_prog_number`` can only be 0 - 15. ``Ans`` is the name of the program to copy. ``function`` refers to the behavior of the ``ExecArcPrgm`` command, as seen in the table below:

    ==== ================================================================
    Code Function
    ==== ================================================================
    0    Copies the program in ``Ans`` to the ``XTEMP`` program specified.
    1    Deletes the ``XTEMP`` program with the specified number.
    2    Deletes all ``XTEMP`` programs.
    ==== ================================================================

    Parameters:
     * ``function``: The requested behavior of the function. Can be 0, 1, or 2.
     * ``temp_prog_number``: The number of the ``XTEMP`` program to create/delete. This must be within 0 - 15.
     * ``Ans``: Name of program to copy from.

    Returns:
     * Completes the specified function.

    Errors:
     * ``..NT:EN:M`` if there is not enough memory to complete the action.

------------

.. function:: DispColor: det(12, fg_low, fg_high, bg_low, bg_high)

    Changes the foreground and background color for ``Output(``, ``Disp``, and ``Pause`` to arbitrary 16-bit colors, or disables this feature. Due to technical limitations, the foreground and background for ``Text()`` cannot be changed to arbitrary colors. To disable this mode, you should call ``det(12, 300)`` before exiting your program.

    Parameters:
     * ``fg_low``: low byte of foreground color.
     * ``fg_high``: high byte of foreground color.
     * ``bg_low``: low byte of background color.
     * ``bg_high``: high byte of background color.

    Alternative method: ``det(12, fg_os, bg_os)``
     * ``fg_os``: Foreground color from TI-OS Colors menu, like RED or BLUE or NAVY.
     * ``bg_os``: Background color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * See description.
