Graphics Functions
==================

Overview
~~~~~~~~
These functions are related to graphical operations. This is not the only section containing graphical operations, as some are better categorized in other sections. 

Documentation
~~~~~~~~~~~~~

.. function:: FillScreen: det(16, low, high)

    This function fills the screen with the color specified. It is faster than using TextRect to draw a rectangle over the entire screen.

    Parameters:
     * ``low``: Low byte of color.
     * ``high``: High byte of color.

    Alternative method: ``det(16, os_color)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Fills the screen with the specified color.

------------

.. function:: DrawLine: det(17, low, high, x1, y1, x2, y2)

    Draws a line of the specified color from (x1, y1) to (x2, y2).

    Parameters:
     * ``low``: Low byte of color.
     * ``high``: High byte of color.
     * ``x1``: x location to begin drawing the line from, beginning from the top-left corner of the screen. x has a range of 0 - 319.
     * ``y1``: y location to begin drawing the line from, beginning from the top-left corner of the screen. y has a range of 0 - 239
     * ``x2``: x location to finish drawing the line at, beginning from the top-left corner of the screen.
     * ``y2``: y location to finish drawing the line at, beginning from the top-left corner of the screen.

    Alternative method: ``det(17, os_color, x1, y1, x2, y2)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws a line of the specified color from (x1, y1) to (x2, y2).

------------

.. function:: SetPixel: det(18, low, high, x, y)

    Sets the pixel located at (x, y) to the color specified.

    Parameters:
     * ``low``: Low byte of color.
     * ``high``: High byte of color.
     * ``x``: x location of the pixel to set, beginning from the top-left corner of the screen.
     * ``y``: y location of the pixel to set, beginning from the top-left corner of the screen.

    Alternative method: ``det(17, os_color, x, y)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    .. note::
        If you use the alternative method and use 0 for ``os_color``, it will invert the specified pixel instead of drawing a color.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Sets the pixel at (x, y) to the color specified, or inverts it if using the alternative method with ``os_color`` being 0.

------------

.. function:: GetPixel: det(19, x, y)

    Returns a low and high byte representing the color of the pixel at (x, y) in ``Ans`` and ``Theta`` respectively.

    Parameters:
     * ``x``: x location of the pixel to check, beginning from the top-left corner of the screen.
     * ``y``: y location of the pixel to check, beginning from the top-left corner of the screen.
    
    Returns:
     * ``Ans``: low byte of the color of the pixel checked
     * ``Theta``: high byte of the color of the pixel checked

------------

.. function:: PixelTestColor: det(20, row, column)

    This function works just like OS function pxl-Test() does, however, it will return 0 if no pixel is present and the OS color of the pixel if one is present. This only applies to the graph screen, like pxl-Test().

    Parameters:
     * ``row``: Row of the graphscreen that contains the pixel to test.
     * ``column``: Column of the graphscreen that contains the pixel to test.

    .. tip::
        The arguments and functionality of this are identical to pxl-Test(), other than the fact that this returns the color of the pixel if one is present.

    Returns:
     * ``Theta``: 0 if no pixel was present, otherwise will contain the OS color of the pixel tested.

------------

.. function:: PutSprite: det(21, x, y, width, height); Str9 = sprite data

    This function draws a sprite at (x, y) with a width of width and a height of height. It is designed to be fast, and so it does not have as much error checking, meaning that it will display a sprite of the given width and height regardless of the length of the given sprite data. The sprite data is made up of hex values referring to xLIBC colors, which can be found `here <https://roccoloxprograms.github.io/xlibcColorPicker/>`__. The data is stored left to right and top to bottom. For example, take a sprite that looks like this:

    .. figure:: images/sampleSprite.png
        :alt: A sample sprite, being a basic face. Nobody knows what expression the face is making, since there weren't enough pixels in an 8x8 square to convey emotion.
        :align: center

        A sample sprite.

    We'll convert it into a a matrix, where each pixel is replaced with the hex equivalent of its xLIBC color::

        [FF, FF, 00, 00, 00, 00, FF, FF
         FF, 00, E6, E6, E6, E6, 00, FF
         00, E6, 00, E6, E6, 00, E6, 00
         00, E6, 00, E5, E5, 00, E6, 00
         00, E5, E5, E5, E5, E5, E5, 00
         00, E5, E5, 00, 00, E5, E5, 00
         FF, 00, E5, E5, E5, E5, 00, FF
         FF, FF, 00, 00, 00, 00, FF, FF]

    Then, to make it a string, we'll take remove the newlines and commas, like this::

    .. only:: html

        .. code-block::
    
            "FFFF00000000FFFFFF00E6E6E6E600FF00E600E6E600E60000E600E5E500E60000E5E5E5E5E5E50000E5E500FF00E5E5E5E500FFFFFF00000000FFFF" -> Str9

    .. only:: latex

        .. code-block:: txt
    
            "FFFF00000000FFFFFF00E6E6E6E600FF00E600E6E600E60000E600E5E500E600
            00E5E5E5E5E5E50000E5E500FF00E5E5E5E500FFFFFF00000000FFFF" -> Str9

    More detailed instructions on converting sprites can be found `here <convertsprites.html>`__.

    Parameters:
     * ``x``: x location to draw the sprite, beginning at the top-left corner of the screen.
     * ``y``: y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``width``: Width of the sprite in pixels.
     * ``height``: Height of the sprite in pixels.
     * ``Str9``: Sprite data, as explained above.

    Colors:
     * Uses hex codes referring to the xLIBC colors. A good resource for the xLIBC palette can be found `here <https://roccoloxprograms.github.io/xlibcColorPicker/>`__.
    
    Returns:
     * Draws a sprite of the specified width and height at (x, y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.
