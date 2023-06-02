Doors CE 9 Functions
====================

Overview
~~~~~~~~

These functions are roughly based/related to some of the functions made for Doors CE 9.

Documentation
~~~~~~~~~~~~~

.. function:: DispText: det(13, large_font, fg_low, fg_high, bg_low, bg_high, x, y); Str9 = text

    Displays colored text from ``Str9`` at ``x`` and ``y`` on the screen, using the OS large or small font.

    Parameters:
     * ``large_font`` = whether to use OS large or small font. 0 means to use the OS small font, and 1 means to use the large font.
     * ``fg_low``: low byte of foreground color.
     * ``fg_high``: high byte of foreground color.
     * ``bg_low``: low byte of background color.
     * ``bg_high``: high byte of background color.
     * ``x``: x location to display the text, starting from the top-left corner.
     * ``y``: y location to display the text, starting from the top-left corner.
     * ``Str9``: Text to display.

    Alternative method: ``det(13, large_font, fg_os, bg_os, x, y)``
     * ``fg_os``: Foreground color from TI-OS Colors menu, like RED or BLUE or NAVY.
     * ``bg_os``: Background color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Displays the specified text.

------------

.. function:: ExecHex: det(14); Ans = hex code

    Executes the string of ASCII-encoded hexadecimal in Ans. Although a ``C9`` (ret) at the end of your hex string is highly encouraged, Celtic will automatically put one at the end for safety regardless. For a list of useful hex codes, refer to `this page <hexcodes.html>`__.

    .. warning::
        ``Ans`` must be under (not including) 8192 characters. It also must be an even number of characters.

    Parameters:
     * ``Ans``: hex code to execute.

    Returns:
     * Runs the specified hex code.

    Errors:
     * ``..INVAL:S`` if there is an invalid hex digit or an odd number of characters in the string.

------------

.. function:: FillRect: det(15, low, high, x, y, width, height)

    Draw a filled, colored rectangle on the screen. This command can also be used to draw an individual pixel by setting the width and height to 1, or a line by setting either the width or height to 1.

    Parameters:
     * ``low``: low byte of color.
     * ``high``: high byte of color.
     * ``x``: x location to draw the rectangle, beginning at the top-left corner.
     * ``y``: y location to draw the rectangle, beginning at the top-left corner.
     * ``width``: Width of rectangle.
     * ``height``: Height of rectangle.

    Alternative method: ``det(15, os_color, x, y, width, height)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    .. note::
        If you use the alternative method and use 0 for ``os_color``, it will invert the section of the screen covered by the rectangle instead of drawing a color. This can be useful for blinking cursors, etc.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the colored rectangle.
