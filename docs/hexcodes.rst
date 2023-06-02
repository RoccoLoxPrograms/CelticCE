TI-84 Plus CE Hex Codes
=======================

Overview
~~~~~~~~
This page contains a list of useful hex codes to be used with ExecHex. To use them, follow the ExecHex documentation with the preferred hex string. Some of these may perform similar utilities to pre-existing Celtic functions. A good number of these were taken/adapted from the TI-BASIC Developer `84 Plus CE Hexcodes page <http://tibasicdev.wikidot.com/84ce:hexcodes>`__.

Documentation
~~~~~~~~~~~~~

.. function:: Turn Off LCD

    Turns off the calculator's LCD::

        "3E01321900E3C9"

.. function:: Turn On LCD

    Turns on the calculator's LCD::

        "3E09321900E3C9"

.. function:: Decrease Brightness
    
    Decrease the LCD brightness by 1::

        "3A2400F63C322400F6C9"

.. function:: Increase Brightness
    
    Increase the LCD brightness by 1::

        "3A2400F63D322400F6C9"

.. function:: Invert LCD (High contrast mode/Dark mode)
    
    Inverts the colors of the LCD. Also sometimes referred to as "High contrast mode" or "Dark mode"::

        "211808F874364436216C3601C9"

    Credit: MateoConLechuga

.. function:: Toggle Program mode
    
    When used in a program, it allows you to use ``Archive`` and ``UnArchive`` on other programs::

        "FD7E08EE02FD7708C9"
    
    .. warning::
        Make sure to switch back to "program mode" when you're done by running the program again.

.. function:: Quick Key
    
    Loads the most recent keycode into ``Ans``::

        "3A8705D0CD080B02CD300F02C9"

.. function:: Text Inverse
    
    This will switch from normal text mode to inverse (white text on black background) and vice versa::

        "FD7E05EE08FD7705C9"

.. function:: Enable Lowercase
    
    Enables lowercase letters in TI-OS::

        "FDCB24DEC9"

.. function:: Disable Lowercase
    
    Disables lowercase letters in TI-OS (default)::

        "FDCB249EC9"

.. function:: Toggle Lowercase
    
    Toggles lowercase letters on/off in TI-OS::

        "FD7E24EE08FD7724C9"

.. function:: Clear LCD
    
    Clears the LCD::

        "CD101A02C9"

.. function:: Clear LCD and Redraw Status Bar
    
    Same as Clear LCD, but redraws the Status Bar as well::

        "CD101A02CD3C1A02C9"

.. function:: Fill Screen with White
    
    Fills the screen with white::

        "210000D436FFE5D11301FF5702EDB0C9"

.. function:: Fill Screen with Black
    
    Fills the screen with black::

        "210000D43600E5D11301FF5702EDB0C9"

.. function:: Run Indicator Off
    
    Turns off the run indicator::

        "CD480802C9"

.. function:: Run Indicator On
    
    Turns on the run indicator::

        "CD440802C9"

.. function:: Toggle Run Indicator
    
    Toggles the run indicator on/off::

        "FD7E12EE01FD7712C9"

.. function:: Disable APD
    
    Disables Automatic Power Down (APD)::

        "CD341102C9"

.. function:: Enable APD
    
    Enables Automatic Power Down::

        "CD381102C9"

.. function:: Turn Off Cursor

    This is harmless, but it stops displaying that blinking cursor :D Just press [2nd][MODE] to put it back to normal. What, jokes are allowed, right?

    -- TI-BASIC Developer

    .. code-block::

        "FDCB0CE6C9"

.. function:: Turn On Cursor
    
    Turns on the cursor::

        "FDCB0CA6C9"

.. function:: Draw TI Logo
    
    This is a strange function that draws the TI Logo. (Yes, there is a built in ASM call to do that) While there is no real reason you would probably want to do this, it's still interesting::

        "CD001B02C9"
