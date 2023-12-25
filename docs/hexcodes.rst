TI-84 Plus CE Hex Codes
=======================

Overview
~~~~~~~~
This page contains a list of useful hex codes to be used with ExecHex. To use them, follow the ExecHex documentation with the preferred hex string. Some of these may perform similar utilities to pre-existing Celtic functions. A good number of these were taken/adapted from the TI-BASIC Developer `84 Plus CE Hexcodes page <http://tibasicdev.wikidot.com/84ce:hexcodes>`__.

Documentation
~~~~~~~~~~~~~

.. function:: Invert LCD (High contrast mode/Dark mode)
    
    Inverts the colors of the LCD. Also sometimes referred to as "High contrast mode" or "Dark mode"::

        "211808F874364436216C3601C9"

    Credit: MateoConLechuga

.. function:: Toggle Program mode
    
    When used in a program, it allows you to use ``Archive`` and ``UnArchive`` on other programs::

        "FD7E08EE02FD7708C9"
    
    .. warning::
        Make sure to switch back to "program mode" when you're done by running the program again.

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
