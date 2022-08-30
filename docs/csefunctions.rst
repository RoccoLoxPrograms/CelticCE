Celtic 2 CSE Functions
======================

Overview
~~~~~~~~
These functions are the same as those included in Doors CSE 8 for the TI-84 Plus CSE, unless noted otherwise. Most documentation is from the `DCS Wiki <https://dcs.cemetech.net/index.php?title=Third-Party_BASIC_Libraries_(Color)>`__.

Documentation
~~~~~~~~~~~~~

ReadLine: ``det(0)``, ``Str0`` = **variable name**, ``Ans`` = **line number**
    Reads a line from a program or AppVar. If ``Ans`` (line number) equals 0, then Theta will be overwritten with the number of lines in the program being read. Otherwise, ``Ans`` refers to the line being read.

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

ReplaceLine: ``det(1)``, ``Str0`` = **variable name**, ``Ans`` = **line number**, ``Str9`` = **replacement**
    Replaces (overwrites) a line in a program or AppVar. ``Ans`` refers to the line to replace.

    Parameters:
     * ``Str0``: Name of file to read from.
     * ``Ans``: Line number to replace, begins at 1.
     * ``Str9``: Contents to replace the line with.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.

    Errors:
     * ``..PGM:ARC`` if the file is archived.

InsertLine: ``det(2)``, ``Str0`` = **variable name**, ``Ans`` = **line number**, ``Str9`` = **contents**
    Insets a line into a program or AppVar. ``Ans`` refers to the line number to write to.

    Parameters:
     * ``Str0``: Name of file to write to.
     * ``Ans``: Line number to write to, begins at 1.
     * ``Str9``: Material to insert into a program. The line that was occupied is shifted down one line and this string is inserted into the resulting location.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.

    Errors:
     * ``..PGM:ARC`` if the file is archived.

SpecialChars: ``det(3)``
    Stores the ``->`` and ``"`` characters into ``Str9``.

    Returns:
     * ``Str9``: ``->`` and ``"``, respectively. You can use substrings to extract them. There are also 7 more characters in ``Str9``, which are junk.

CreateVar: ``det(4)``, ``Str0`` = **variable name**
    Create a program or AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to create.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.
     * ``Str0``: Intact with program's name to be created.

    Errors:
     * ``..P:IS:FN`` if the program already exists.

ArcUnarcVar: ``det(5)``, ``Str0`` = **variable name**
    Archive/unarchive a program or AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to move between Archive and RAM.

    Returns:
     * Moves a program or AppVar into RAM if it was in Archive, or into Archive if it was in RAM.

DeleteVar: ``det(6)``, ``Str0`` = **variable name**
    Delete a program variable or an AppVar given a name.

    Parameters:
     * ``Str0``: Name of program or AppVar to delete.

    Returns:
     * The indicated program or AppVar is deleted.

DeleteLine: ``det(7)``, ``Str0`` = **variable name**, ``Ans`` = **line number**
    Deletes a line from a program or AppVar. ``Ans`` is the line to delete.

    Parameters:
     * ``Str0``: Name of program or AppVar to delete from.
     * ``Ans``: Line number to delete from, begins at 1.

    Returns:
     * ``Str9``: Intact if no error occured; otherwise, contains an error code.

VarStatus: ``det(8)``, ``Str0`` = **variable name**
    Output status string describing a program or AppVar's current state, including size, visibility, and more.

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

BufSprite: ``det(9, width, X, Y)``, ``Str9`` = **sprite data**
    Draws indexed (palette-based) sprite onto the LCD and into the graph buffer. Copies the contents of the graph buffer under the sprite back into Str9, so that you can "erase" the sprite back to the original background. Good for moving player characters, cursors, and the like. Interacts politely with Pic variables and OS drawing commands like ``Line(``, ``Circle(``, ``Text(``, and so on. If you want to draw a lot of different sprites to the screen and won't need to erase them back to the background, then use BufSpriteSelect instead.

    Parameters:
     * ``Str9`` = Sprite data as ASCII hex, one nibble per byte. The digits 1-F are valid colors (1 = blue, 2 = red, 3 = black, etc), while G will cause the routine to skip to the next line. 0 is normal transparency, and lets the background show through. H is a special kind of transparency that erases back to transparency instead of leaving the background color intact.
     * ``X`` = X coordinate to the top-left corner of the sprite.
     * ``Y`` = Y coordinate to the top-left corner of the sprite.
     *  ``width`` = Sprite width (height is computed).

    Returns:
     * ``Str9``: Same length as input, contains the previous contents of the graph buffer where the sprite was drawn. You can call ``det(9...)`` again without changing Str9 to effectively undo the first sprite draw.

    Errors:
     * ``..INVAL:S`` if the string contains invalid characters.

BufSpriteSelect: ``det(10, width, X, Y, start, length)``, ``Str9`` = **sprite data**
    Draws indexed (palette-based) sprite onto the LCD and into the graph buffer. Good for drawing tilemaps, backgrounds, and other sprites that you won't want to individually erase. If you want to be able to erase the sprite drawn and restore the background, you should consider BufSprite instead. This routine takes an offset into Str9 and a sprite length as arguments, so that you can pack multiple sprites of different lengths into Str9.

    Parameters:
     * ``Str9`` = Sprite data as ASCII hex, one nibble per byte. The digits 1-F are valid colors (1 = blue, 2 = red, 3 = black, etc), while G will cause the routine to skip to the next line. 0 is normal transparency, and lets the background show through. H is a special kind of transparency that erases back to transparency instead of leaving the background color intact.
     * ``X`` = X coordinate to the top-left corner of the sprite.
     * ``Y`` = Y coordinate to the top-left corner of the sprite.
     *  ``width`` = Sprite width (height is computed).
     *  ``start`` = Offset into ``Str9`` of the start of pixel data, begins at 0.
     *  ``length`` = Length of sprite data in characters.

    Returns:
     * Sprite drawn to LCD and stored to graph buffer.

    Errors:
     * ``..INVAL:S`` if the string contains invalid characters.

ExecArcPrgm: ``det(11, function, temp_prog_number)``, ``Ans`` = **program name**
    ``Ans`` contains the name of the program you want to use in a string, then you use the ``function``, then you run the generated temporary program file according to ``temp_prog_number``. But, you'll need to know the function codes to further explain how this works:

         * 0: Copy file to a file numbered by ``temp_prog_number``.
         * 1: Delete a temporary file numbered by ``temp_prog_number``.
         * 2: Delete all temporary files.

    For example, say you wanted to copy an archived program ``FOO`` to ``prgmXTEMP002``, do the following::

        "FOO":det(11,0,2):prgmXTEMP002
    
    If you wanted to do this to an ASM program ``BAR`` and have it copied to the 12th temporary file, do the following::

        "BAR":det(11,0,12):Asm(prgmXTEMP012)
    
    If you decided you are done with the copy of ``FOO`` from the first example and you wanted to delete it, do this::

        det(11,1,2)
    
    That will delete ``prgmXTEMP002`` but will not touch the original file.

    If you want to clean up (get rid of all temp files), you can do the following::

        det(11,2
    
    Files will not be overwritten if you attempt to copy to a preexisting temp file.

    Parameters:
     * ``function`` = action to complete.
     * ``temp_prog_number`` = number of temporary program to use.

    You can run the resultant temporary program via one of the following, depending on format::
    
        prgmXTEMP0XX  or  :Asm(prgmXTEMP0XX)

    Note that only prgmXTEMP000 to prgmXTEMP015 are valid; anything above prgmXTEMP015 will return Undefined.

    Returns:
     * See description.

    Errors:
     * ``..NO:MEM`` if there is not enough memory to complete the action.

DispColor: ``det(12, FG_LO, FG_HI, BG_LO, BG_HI)``
    Changes the foreground and background color for ``Output(``, ``Disp``, and ``Pause`` to arbitrary 16-bit colors, or disables this feature. Due to technical limitations, the foreground and background for ``Text()`` cannot be changed to arbitrary colors.

    Parameters:
     * ``FG_LO`` = low byte of foreground color.
     * ``FG_HI`` = high byte of foreground color.
     * ``BG_LO`` = low byte of background color.
     * ``BG_HI`` = high byte of background color.

    Because of TI-OS argument-parsing limitations, foreground and background colors must be provided as a sequence of two numbers in the range 0-255. Sample low and high bytes are below.
    Alternative method: ``det(12,FG_OS,BG_OS``
    
     * ``FG_OS``: Foreground color from TI-OS Colors menu, like RED or BLUE or NAVY.
     * ``BG_OS``: Background color from TI-OS Colors menu, like RED or BLUE or NAVY.

    To disable this mode, you should call ``det(12,300)`` before exiting your program.

    Colors:
    A list of colors can be found `here <colors.html>`__.

    Returns:
     * See description.
