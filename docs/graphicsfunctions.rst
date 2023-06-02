Graphics Functions
==================

Overview
~~~~~~~~
These functions are related to graphical operations. This is not the only section containing graphical operations, as some are better categorized in other sections. 

Documentation
~~~~~~~~~~~~~

.. function:: FillScreen: det(16, low, high)

    This function fills the screen with the color specified. It is faster than using FillRect to draw a rectangle over the entire screen.

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
     * ``Ans``: Low byte of the color of the pixel checked.
     * ``Theta``: High byte of the color of the pixel checked.

------------

.. function:: PixelTestColor: det(20, row, column)

    This function works just like OS function pxl-Test() does, however, it will return 0 if no pixel is present and the OS color of the pixel if one is present. This only applies to the graph screen, like pxl-Test().

    Parameters:
     * ``row``: Row of the graphscreen that contains the pixel to test.
     * ``column``: Column of the graphscreen that contains the pixel to test.

    .. tip::
        The arguments and functionality of this are identical to pxl-Test(), other than the fact that this returns the color of the pixel if one is present.

    Returns:
     * ``Ans``: 0 if no pixel was present, otherwise will contain the OS color of the pixel tested.

------------

.. function:: PutSprite: det(21, x, y, width, height, string)

    This function draws a sprite at (x, y) with a width of width and a height of height, using data specified by string. For example, if the user specifies the string as 0, it will read the data from Str0. It is designed to be fast, and so it does not have as much error checking, meaning that it will display a sprite of the given width and height regardless of the length of the given sprite data. The sprite data is made up of hex values referring to xLIBC colors, which can be found `here <https://roccoloxprograms.github.io/XlibcColorPicker/>`__. The data is stored left to right and top to bottom. For example, take a sprite that looks like this:

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

    Then, to make it a string, we'll take remove the newlines and commas, like this:

    .. only:: html

        .. code-block::
    
            "FFFF00000000FFFFFF00E6E6E6E600FF00E600E6E600E60000E600E5E500E60000E5E5E5E5E5E50000E5E50000E5E500FF00E5E5E5E500FFFFFF00000000FFFF" -> Str9

    .. only:: latex

        .. code-block:: txt
    
            "FFFF00000000FFFFFF00E6E6E6E600FF00E600E6E600E60000E600E5E500E600
            00E5E5E5E5E5E50000E5E50000E5E500FF00E5E5E5E500FFFFFF00000000FFFF" -> Str9

    More detailed instructions on converting sprites can be found `here <convertsprites.html>`__.

    Parameters:
     * ``x``: x location to draw the sprite, beginning at the top-left corner of the screen.
     * ``y``: y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``width``: Width of the sprite in pixels.
     * ``height``: Height of the sprite in pixels.
     * ``string``: Which string variable to read the data from, 0-9.

    Colors:
     * Uses hex codes referring to the xLIBC colors. A good resource for the xLIBC palette can be found `here <https://roccoloxprograms.github.io/XlibcColorPicker/>`__.
    
    Returns:
     * Draws a sprite of the specified width and height at (x, y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.

------------

.. function:: GetStringWidth: det(54, font); Ans = string

    Gets the width of a string in pixels. This command works with both the OS large and small fonts.

    Parameters:
     * ``font``: Whether to use the OS large or small font. 0 for small font, 1 for large font.
     * ``Ans``: Contains the string to be checked.

    Returns:
     * ``Theta``: Contains the width of the string in pixels.

    Errors:
     * ``..S:NT:ST`` if ``Ans`` is not a string

------------

.. function:: TransSprite: det(55, x, y, width, height, transparency, string)

    Draws a sprite where the user specifies the color to be interpreted as transparency. The rest of the functionality is identical to the PutSprite command.

    Parameters:
     * ``x``: x location to draw the sprite, beginning at the top-left corner of the screen.
     * ``y``: y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``width``: Width of the sprite in pixels.
     * ``height``: Height of the sprite in pixels.
     * ``transparency``: Color in the sprite to be interpreted as transparency (0-255).
     * ``string``: Which string variable to read the data from, 0-9.

    Returns:
     * Draws a sprite with transparency of the specified width and height at (x, y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.

------------

.. function:: ScaleSprite: det(56, x, y, width, height, scale_x, scale_y, string)

    Draws a scaled sprite where the user can specify the scale value of both X and Y. The rest of the functionality is identical to the PutSprite command.

    Parameters:
     * ``x``: x location to draw the sprite, beginning at the top-left corner of the screen.
     * ``y``: y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``width``: Unscaled width of the sprite in pixels.
     * ``height``: Unscaled height of the sprite in pixels.
     * ``scale_x``: Width scaling value.
     * ``scale_y``: Height scaling value.
     * ``string``: Which string variable to read the data from, 0-9.

    Returns:
     * Draws a scaled sprite of the specified (scaled) width and height at (x, y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.

------------

.. function:: ScaleTSprite: det(57, x, y, width, height, scale_x, scale_y, transparency, string)

    Draws a scaled sprite where the user specifies the color to be interpreted as transparency. The rest of the functionality is identical to the PutSprite command.

    Parameters:
     * ``x``: x location to draw the sprite, beginning at the top-left corner of the screen.
     * ``y``: y location to draw the sprite, beginning at the top-left corner of the screen.
     * ``width``: Unscaled width of the sprite in pixels.
     * ``height``: Unscaled height of the sprite in pixels.
     * ``scale_x``: Width scaling value.
     * ``scale_y``: Height scaling value.
     * ``transparency``: Color in the sprite to be interpreted as transparency (0-255).
     * ``string``: Which string variable to read the data from, 0-9.

    Returns:
     * Draws a scaled sprite with transparency of the specified (scaled) width and height at (x, y).

    .. warning::
        Keep in mind that the function will not check if your string is long enough for the provided width and height. If your string is an incorrect size, it will still draw a sprite of the specified width and height, though parts of the drawn sprite could be garbage.

------------

.. function:: ScrollScreen: det(58, direction, amount)

    Moves the screen a specified amount of pixels in a specified direction. The following directions and corresponding values are below:

    ===== =========
    Value Direction
    ===== =========
    0     Up
    1     Down
    2     Left
    3     Right
    ===== =========

    Parameters:
     * ``direction``: Direction to move the screen in, as seen in the table above.
     * ``amount``: The amount of pixels to move the screen.

    Returns:
     * Moves the screen in the specified direction.

------------

.. function:: RGBto565: det(59, r, g, b)

    Converts an RGB color to a high and low byte that can be used in other Celtic functions.

    Parameters:
     * ``r``: Red color value
     * ``g``: Green color value
     * ``b``: Blue color value

    Returns:
     * ``Ans``: Low byte of the color.
     * ``Theta``: High byte of the color.

------------

.. function:: DrawRect: det(60, low, high, x, y, width, height)

    Draws an unfilled rectangle of user-specified color, location, and size.

    Parameters:
     * ``low``: Low byte of color
     * ``high``: High byte of color
     * ``x``: x location to begin drawing the rectangle, starting at the top-left corner of the screen
     * ``y``: y location to begin drawing the rectangle, starting at the top-left corner of the screen
     * ``width``: Width of the rectangle to draw
     * ``height``: Height of the rectangle to draw

    Alternative method: ``det(60, os_color, x, y, width, height)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the unfilled rectangle.

------------

.. function:: DrawCircle: det(61, low, high, x, y, radius)

    Draws an unfilled circle with the user specified color. The ``x`` and ``y`` arguments refer to the center point of the circle.

    Parameters:
     * ``low``: Low byte of color
     * ``high``: High byte of color
     * ``x``: x location of the center of the circle, starting at the top-left corner of the screen
     * ``y``: y location of the center of the circle, starting at the top-left corner of the screen
     * ``radius``: Radius of the circle

    Alternative method: ``det(61, os_color, x, y, radius)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the unfilled circle.

------------

.. function:: FillCircle: det(62, low, high, x, y, radius)

    Draws a filled circle with the user specified color. The ``x`` and ``y`` arguments refer to the center point of the circle.

    Parameters:
     * ``low``: Low byte of color
     * ``high``: High byte of color
     * ``x``: x location of the center of the circle, starting at the top-left corner of the screen
     * ``y``: y location of the center of the circle, starting at the top-left corner of the screen
     * ``radius``: Radius of the circle

    Alternative method: ``det(62, os_color, x, y, radius)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the filled circle.

------------

.. function:: DrawArc: det(63, low, high, x, y, radius, start_angle, end_angle)

    Draws the outline of a circular arc. The ``x`` and ``y`` arguments refer to the center of the arc, which begins at ``start_angle`` and ends at ``end_angle``. Angle values go from 0-360, and the end angle must be greater than the start angle. 0 degrees is the right most part of the circle, and goes counter-clockwise.

    .. figure:: images/circlePoints.png
        :alt: A diagram showing various points along the circle.
        :align: center

        A diagram showing various points along the circle.

    Parameters:
     * ``low``: Low byte of color
     * ``high``: High byte of color
     * ``x``: x location of the center of the arc, starting at the top-left corner of the screen
     * ``y``: y location of the center of the arc, starting at the top-left corner of the screen
     * ``radius``: Radius of the arc
     * ``start_angle``: Angle to begin drawing the arc at
     * ``end_angle``: Angle to finish drawing the arc at

    Alternative method: ``det(63, os_color, x, y, radius, start_angle, end_angle)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

    Returns:
     * Draws the user-specified arc.

------------

.. function:: DispTransText: det(64, font, low, high, x, y); Str9 = string to display

    Draws colored text with a transparent background in either the OS large or small font.

    Parameters:
     * ``font``: Whether to use the OS large or small font. 0 for small font, 1 for large font.
     * ``low``: Low byte of color
     * ``high``: High byte of color
     * ``x``: x location to begin drawing the text at, starting at the top-left corner of the screen
     * ``y``: y location to begin drawing the text at, starting at the top-left corner of the screen
     * ``Str9``: String to display

    Alternative method: ``det(64, font, os_color, x, y)``
     * ``os_color``: Color from TI-OS Colors menu, like RED or BLUE or NAVY.

    Colors:
     * A list of colors can be found `here <colors.html>`__.

------------

.. function:: ChkRect: det(65, x0, y0, width0, height0, x1, y1, width1, height1)

    Checks if a rectangle intersects with another rectangle.

    Parameters:
     * ``x0``: x coordinate of rectangle 0, starting at the top left corner of the screen
     * ``y0``: y coordinate of rectangle 0, starting at the top left corner of the screen
     * ``width0``: Width of rectangle 0
     * ``height0``: Height of rectangle 0
     * ``x1``: x coordinate of rectangle 1, starting at the top left corner of the screen
     * ``y1``: y coordinate of rectangle 1, starting at the top left corner of the screen
     * ``width1``: Width of rectangle 1
     * ``height1``: Height of rectangle 1

    Returns:
     * ``Ans``: 0 if the rectangles do not intersect, and 1 if they do.
