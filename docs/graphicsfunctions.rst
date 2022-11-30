Graphics Functions
==================

Overview
~~~~~~~~
These functions are related to graphical operations. This is not the only section containing graphical operations, as some are better categorized in other sections. 

Documentation
~~~~~~~~~~~~~

.. function:: FillScreen: det(16, LOW, HIGH)

    This function fills the screen with the color specified. It is faster than using TextRect to draw a rectangle over the entire screen.

    Parameters:
     * ``LOW``: Low byte of color.
     * ``HIGH``: High byte of color.

    Alternative method: ``det(16, OS_COLOR)``
     * ``OS_COLOR``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Fills the screen with the specified color.

------------

.. function:: DrawLine: det(17, LOW, HIGH, X1, Y1, X2, Y2)

    Draws a line of the specified color from (X1, Y1) to (X2, Y2).

    Parameters:
     * ``LOW``: Low byte of color.
     * ``HIGH``: High byte of color.
     * ``X1``: X location to begin drawing the line from, beginning from the top-left corner of the screen. X has a range of 0 - 319.
     * ``Y1``: Y location to begin drawing the line from, beginning from the top-left corner of the screen. Y has a range of 0 - 239
     * ``X2``: X location to finish drawing the line at, beginning from the top-left corner of the screen.
     * ``Y2``: Y location to finish drawing the line at, beginning from the top-left corner of the screen.

    Alternative method: ``det(17, OS_COLOR, X1, Y1, X2, Y2)``
     * ``OS_COLOR``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws a line of the specified color from (X1, Y1) to (X2, Y2).

------------

.. function:: SetPixel: det(18, LOW, HIGH, X, Y)

    Sets the pixel located at (X, Y) to the color specified.

    Parameters:
     * ``LOW``: Low byte of color.
     * ``HIGH``: High byte of color.
     * ``X``: X location of the pixel to set, beginning from the top-left corner of the screen.
     * ``Y``: Y location of the pixel to set, beginning from the top-left corner of the screen.

    Alternative method: ``det(17, OS_COLOR, X, Y)``
     * ``OS_COLOR``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    .. note::
        If you use the alternative method and use 0 for ``OS_COLOR``, it will invert the specified pixel instead of drawing a color.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Sets the pixel at (X, Y) to the color specified, or inverts it if using the alternative method with ``OS_COLOR`` being 0.

------------

.. function:: GetPixel: det(19, X, Y)

    Returns a LOW and HIGH byte representing the color of the pixel at (X, Y) in ``Ans`` and ``Theta`` respectively.

    Parameters:
     * ``X``: X location of the pixel to check, beginning from the top-left corner of the screen.
     * ``Y``: Y location of the pixel to check, beginning from the top-left corner of the screen.
    
    Returns:
     * ``Ans``: LOW byte of the color of the pixel checked
     * ``Theta``: HIGH byte of the color of the pixel checked

------------

.. function:: PixelTestColor: det(20, ROW, COLUMN)

    This function works just like OS function pxl-Test() does, however, it will return 0 if no pixel is present and the OS color of the pixel if one is present. This only applies to the graph screen, like pxl-Test().

    Parameters:
     * ``ROW``: Row of the graphscreen that contains the pixel to test.
     * ``COLUMN``: Column of the graphscreen that contains the pixel to test.

    .. tip::
        The arguments and functionality of this are identical to pxl-Test(), other than the fact that this returns the color of the pixel if one is present.

    Returns:
     * ``Theta``: 0 if no pixel was present, otherwise will contain the OS color of the pixel tested.

------------

.. function:: PutSprite: det(21, X, Y, WIDTH, HEIGHT), Str9 = sprite data

    This function draws a sprite at (X, Y) with a width of WIDTH and a height of HEIGHT. It is designed to be fast, and so it does not have as much error checking, meaning that it will display a sprite of the given width and height regardless of the length of the given sprite data. The sprite data is made up of hex values referring to xLIBC colors, which can be found `here <https://roccoloxprograms.github.io/XlibcColorPicker/>`__. The data is stored left to right and top to bottom. For example, take a sprite that looks like this:

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


    Parameters:
     * ``X``: X location to draw the sprite, beginning at the top-left corner of the screen.
     * ``Y``: Y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``WIDTH``: Width of the sprite in pixels.
     * ``HEIGHT``: Height of the sprite in pixels.
     * ``Str9``: Sprite data, as explained above.

    Colors:
     * Uses hex codes referring to the xLIBC colors. A good resource for the xLIBC palette can be found `here <https://roccoloxprograms.github.io/XlibcColorPicker/>`__.
    
    Returns:
     * Draws a sprite of the specified width and height at (X, Y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.
