Celtic III Functions
======================

Overview
~~~~~~~~
Some (not all) of the functions from Celtic III are included in Celtic CE.

Documentation
~~~~~~~~~~~~~

.. function:: GetListElem: det(30, list_element); Ans = list name

    Gets a value at ``list_element`` in the list specified. For example, with ``Ans`` equal to ":sub:`L`\FOO" (Where :sub:`L`\  is the list token found in :menuselection:`List --> OPS`). This is useful if the list being accessed is archived, for example.

    Parameters:
     * ``list_element``: Element of the list to access, beginning at 1. Accessing 0 will return the dimension of the list.
     * ``Ans``: Name of the list to access. Begins with the :sub:`L`\  token found in the :menuselection:`List --> OPS`. (:kbd:`2nd` + :kbd:`stat` + :kbd:`left arrow` + :kbd:`alpha` + :kbd:`apps`).

    Returns:
     * ``Theta``: The number at the element of the list accessed, or the dimension of the list if ``list_element`` was 0.

    Errors:
     * ``..NT:A:LS`` if the user did not specify a valid list.
     * ``..E:NT:FN`` if the entry was not found in the list specified.

------------

.. function:: GetArgType: det(31); Ans = argument to check

    Outputs a real number depicting the type of argument in ``Ans``.

    Parameters:
     * ``Ans``: Argument to check the type of

    Returns:
     * ``Theta``: The number corresponding to the argument's type. A table with the possible types is below.
    
    ====== ========
    Number Type
    0      Real
    1      List
    2      Matrix
    4      String
    12     Complex
    13     Cpx List
    ====== ========

------------

.. function:: ChkStats: det(32, function)

    This is a multi-purpose command used to read various system statuses. The output will very based on the specified function. A table with the possible functions and their resulting outputs is below.

    ======== ==============================================================================
    Function Output
    0        Total free RAM (In ``Str9``)
    1        Total free ROM (Also in ``Str9``)
    2        Bootcode (Also in ``Str9``)
    3        OS Version (Also in ``Str9``)
    4        Hardware version: 0 for 84 Plus CE, 1 for 83 Premium CE (Returns in ``Theta``)
    ======== ==============================================================================

    Parameters:
     * ``function``: Function to complete

    Returns:
     * Varies based on input

------------

.. function:: FindProg: det(33, type); Ans = search string

    This does not search for file names, instead it searches for file contents. The search string checks for the beginning contents of a program. Type refers to the type of file to search, with 0 being programs and 1 being appvars. The function will return a string containing the names of the files containing the search phrase, with each name separated by a space.
    For example, to look for all the programs beginning with ":DCS", your code would look something like this::

        ":DCS
        det(33, 0)

    Parameters:
     * ``type``: Type of file to search. 0 for programs, 1 for appvars.
     * ``Ans``: Content string to search for. If ``Ans`` does not contain a string, it will return a complete list of all the files of the specified type.

    Returns:
     * ``Str9``: Contains a list with the names of files containing the search string, separated by spaces. If ``Ans`` was not a string, it returns a list of all files of the specified type.

    Errors:
     * ``..P:NT:FN`` if no files are found containing the specified search string.

------------

.. function:: UngroupFile: det(34, overwrite); Str0 = group name
    
    This function ungroups the programs and AppVars from a group file specified in ``Str0``. It will only apply to files that are programs and AppVars, not other types like lists. If ``overwrite`` is true (not 0), files which already exist will be overwritten. If it is false (0), files will be preserved.
    The group name (in ``Str0``) must be preceded by the ``*row(`` token, as specified in `General Syntax <gensyntax.html#argument-types>`__.

    Parameters:
     * ``overwrite``: Whether or not to overwrite files that already exist when extracting.
     * ``Str0``: Contains the name of the specified group. The name must be preceded by the ``*row(`` token.

    Returns:
     * Ungroups all programs and AppVars from the specified group.

    Errors:
     * ``..G:NT:FN`` if the group specified does not exist.
     * ``..P:NT:FN`` if no files in the group are able to be ungrouped (no programs or AppVars).

------------

.. function:: GetGroup: det(35); Str0 = group name

    Puts the names of all program and AppVar files present in the specified group into ``Str9``, separated by spaces. The names will be in the same order in the string as they are found in the group.
    The group name (in ``Str0``) must be preceded by the ``*row(`` token, as specified in `General Syntax <gensyntax.html#argument-types>`__.

    Parameters:
     * ``Str0``: Contains the name of the specified group. The name must be preceded by the ``*row(`` token.

    Returns:
     * ``Str9``: Contains a list of the names of all programs and AppVars in the group, separated by spaces.
    
    Errors:
     * ``..G:NT:FN`` if the group specified does not exist.
     * ``..P:NT:FN`` if no files in the group are valid (no programs or AppVars).

------------

.. function:: ExtGroup: det(36, item); Str0 = group name

    Extracts the program or AppVar specified by ``item`` from the group specified in ``Str0``. If ``item`` is 1, it extracts the first program or AppVar, 2 extracts the second, and so on. This can be useful paired with ``GetGroup`` to figure out the order of the files in the group. If the file already exists with the same name, it will not be overwritten.
    The group name (in ``Str0``) must be preceded by the ``*row(`` token, as specified in `General Syntax <gensyntax.html#argument-types>`__.

    .. warning::
        ``item`` only counts programs and AppVars, and ignores other types, like lists. If ``item`` is 2, it refers to the second **valid** file, not necessarily the second file including all types.

    Parameters:
     * ``item``: The item in the group to extract. Only applies to programs and AppVars, and begins at 1.

    Returns:
     * Extracts the specified program or AppVar from the group.

    Errors:
     * ``..G:NT:FN`` if the group specified does not exist.
     * ``..E:NT:FN`` if the specified item did not exist.
     * ``..P:IS:FN`` if the program already exists.

------------

.. function:: GroupMem: det(37, item); Str0 = group name

    Returns the size of the program or AppVar specfied by ``item`` from the group specified in ``Str0``. ``item`` behaves the same way as in ``ExtGroup``.
    The group name (in ``Str0``) must be preceded by the ``*row(`` token, as specified in `General Syntax <gensyntax.html#argument-types>`__.

    Parameters:
     * ``item``: The item in the group to extract. Only applies to programs and AppVars, and begins at 1.

    Returns:
     * ``theta``: The size of the specified program or AppVar from the group.

    Errors:
     * ``..G:NT:FN`` if the group specified does not exist.
     * ``..E:NT:FN`` if the specified item did not exist.

------------

.. function:: BinRead: det(38, byte_start, number_of_bytes); Str0 = file name

    Reads the contents of a file starting at ``byte_start`` for ``number_of_bytes`` bytes. ``byte_start`` is 0-indexed, meaning that the first byte of the program is 0, the second is 1, and so on. The output will be a hex string representing the bytes. For example, if the following bytes were in memory:

    ==== == == == == ==
    Byte 0  1  2  3  4
    Data EF 7B 66 6F 6F
    ==== == == == == ==

    ``Str9`` would contain this::

        EF7B666F6F

    Parameters:
     * ``byte_start``: The byte of the file to start reading from. It is 0-indexed, so the first byte of the file is 0, the second is 1, and so on.
     * ``number_of_bytes``: The number of bytes to read, starting at ``byte_start``. You can also read past the end of the file.
     * ``Str0``: The name of the file to read from. For AppVars, the name should be preceded by the ``rowSwap(`` token.

    Returns:
     * ``Str9``: Contains a text string of hex representing the bytes read.

------------

.. function:: BinWrite: det(39, byte_start); Str9 = hex string to write; Str0 = file name

    Writes the hex bytes represented in ``Str9`` to the file specified by ``Str0``, starting at ``byte_start``. ``byte_start`` is 0-indexed, meaning that the first byte of the program is 0, the second is 1, and so on.

    Parameters:
     * ``byte_start``: The byte of the file to start writing to. It is 0-indexed, so the first byte of the file is 0, the second is 1, and so on.
     * ``Str9``: Contains a text string of hex representing the bytes to write.
     * ``Str0``: The name of the file to write to. For AppVars, the name should be preceded by the ``rowSwap(`` token.

    Returns:
     * Writes the bytes specified in ``Str9`` to the specified file.

    Errors:
     * ``..E:NT:FN`` if ``byte_start`` is past the end of the file.
     * ``..INVAL:S`` if there is not an even number of characters in the string or an invalid hex character is present.
     * ``..NT:EN:M`` if there is not enough memory to complete the write.

------------

.. function:: BinDelete: det(40, byte_start, number_of_bytes); Str0 = file name

    Deletes the ``number_of_bytes`` bytes from the file specified by ``Str0``, starting at ``byte_start``. ``byte_start`` is 0-indexed, meaning that the first byte of the program is 0, the second is 1, and so on.

    Parameters:
     * ``byte_start``: The byte of the file to start deleting from. It is 0-indexed, so the first byte of the file is 0, the second is 1, and so on.
     * ``number_of_bytes``: The number of bytes to delete.
     * ``Str0``: The name of the file to delete from. For AppVars, the name should be preceded by the ``rowSwap(`` token.

    Returns:
     * Deletes the specified number of bytes from the specified file.

    Errors:
     * ``..E:NT:FN`` if ``byte_start`` is past the end of the file, or the number of bytes deleted would exceed the end of the file.

------------

.. function:: HexToBin: det(41); Ans = hex string

    Outputs the binary equivalent of the input string in ``Ans``. For example, if you did this::

        :"464F4F424152
        :det(41)

    The result would be ``"FOOBAR"``.

    Parameters:
     * ``Ans``: Hex string to convert.

    Returns:
     * ``Str9``: The converted string.
    
    Errors:
     * ``..INVAL:S`` if there is not an even number of characters in the string or an invalid hex character is present.

------------

.. function:: BinToHex: det(42); Ans = token string

    Outputs the hex equivalent of the input string in ``Ans``. For example, if you did this::

        :"FOOBAR
        :det(42)

    The result would be ``"464F4F424152"``.

    Parameters:
     * ``Ans``: Binary string to convert.
    
    Returns:
     * ``Str9``: The converted string.

------------

.. function:: GraphCopy: det(43)

    Copies the graph buffer to the screen.

------------

.. function:: Edit1Byte: det(44, string_number, target_byte, replace_byte)

    Replaces the byte at ``target_byte`` of the specified string with the byte specified by ``replace_byte``. ``target_byte`` is 0-indexed, meaning that the first byte of the program is 0, the second is 1, and so on. For example::

        :det(44, 0, 0, 255)

    This code will replace byte 0 of ``Str0`` with the byte 255 in decimal, or 0xFF in hex.

    Parameters:
     * ``string_number``: The string to modify. 0 is ``Str0``, 1 is ``Str1``, and so on.
     * ``target_byte``: The byte of the string to modify. It is 0-indexed, so the first byte of the file is 0, the second is 1, and so on.
     * ``replace_byte``: The byte to replace the target byte with, in decimal format. Can be 0 - 255 (0x00 - 0xFF).
    
    Returns:
     * Replaces the target byte of a string with the specified replacement byte.
    
    Errors:
     * ``..E:NT:FN`` if the target byte does not exist in the string.
