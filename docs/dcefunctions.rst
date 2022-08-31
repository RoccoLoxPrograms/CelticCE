Doors CE 9 Functions
====================

Overview
~~~~~~~~

These functions are roughly based/related to some of the functions made for Doors CE 9.

Documentation
~~~~~~~~~~~~~

DispText: ``det(13, LargeFont, FG_LO, FG_HI, BG_LO, BG_HI, X, Y)``, ``Str9`` = **text**
    Displays colored text from ``Str9`` at ``X`` and ``Y`` on the screen, using the OS large or small font.

    .. warning::
        You can only use a maximum of 128 characters in ``Str9`` at a time with this command. However, this should be pleanty, since the text does not wrap.

    Parameters:
     * ``LargeFont`` = whether to use OS large or small font. 0 means to use the OS small font, and 1 means to use the large font.
     * ``FG_LO`` = low byte of foreground color.
     * ``FG_HI`` = high byte of foreground color.
     * ``BG_LO`` = low byte of background color.
     * ``BG_HI`` = high byte of background color.
     * ``X`` = X location to display the text, starting from the top-left corner.
     * ``Y`` = Y location to display the text, starting from the top-left corner.
     * ``Str9`` = Text to display.

    Alternative method: ``det(13, LargeFont, FG_OS, BG_OS, X, Y)``
    
     * ``FG_OS``: Foreground color from TI-OS Colors menu, like RED or BLUE or NAVY.
     * ``BG_OS``: Background color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Displays the specified text.

ExecHex: ``det(14)``, ``Ans`` = **hex code**
    Executes the string of ASCII-encoded hexadecimal in Ans. Although a C9 (ret) at the end of your hex string is highly encouraged, Celtic will automatically put one at the end for safety regardless.

    .. warning::
        ``Ans`` must be under (not including) 255 characters. It also must be an even number of characters.

    Parameters:
     * ``Ans`` = hex code to execute.

    Returns:
     * Runs the specified hex code.

    Errors:
     * ``..INVAL:S`` if there is an invalid hex digit or an odd number of characters in the string.

TextRect: ``det(15, LOW, HIGH, X, Y, WIDTH, HEIGHT)``
    Draw a filled, colored rectangle on the screen. This command can also be used to draw an individual pixel by setting the width and height to 1, or a line by setting either the width or height to 1.

    Parameters:
     * ``LOW`` = low byte of color.
     * ``HIGH`` = high byte of color.
     * ``X`` = X location to draw the rectangle, beginning at the top-left corner.
     * ``Y`` = Y location to draw the rectangle, beginning at the top-left corner.
     * ``WIDTH`` = Width of rectangle.
     * ``HEIGHT`` = Height of rectangle.

    Alternative method: ``det(15, OS_COLOR, X, Y, WIDTH, HEIGHT)``
    
     * ``OS_COLOR``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    .. note::
        If you use the alternative method and use 0 for ``OS_COLOR``, it will invert the section of the screen covered by the rectangle instead of drawing a color. This can be useful for blinking cursors, etc.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the colored rectangle.
