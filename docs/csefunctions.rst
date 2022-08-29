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
