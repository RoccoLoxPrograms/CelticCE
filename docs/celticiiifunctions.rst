Celtic III Functions
======================

Overview
~~~~~~~~
Essentially all of the functions from Celtic III are included in Celtic CE.

Documentation
~~~~~~~~~~~~~

.. function:: GetListElem: det(30, list_element); Ans = list name

    Gets a value at ``list_element`` in the list specified. For example, with ``Ans`` equal to ":sub:`L`\FOO" (Where :sub:`L`\  is the list token found in :menuselection:`List --> OPS`). This is useful if the list being accessed is archived, for example.

    Parameters:
     * ``list_element``: Element of the list to access, beginning at 1. Accessing 0 will return the dimension of the list.
     * ``Ans``: Name of the list to access. The data in ``Ans`` must be a string beginning with the :sub:`L`\  token found in the :menuselection:`List --> OPS` (:kbd:`2nd` + :kbd:`stat` + :kbd:`left arrow` + :kbd:`alpha` + :kbd:`apps`), unless you are using a default OS list such as L :sub:`1`\. When using default OS lists, simply use the corresponding list name token, such as L :sub:`1`\ or L :sub:`2`\.

    Returns:
     * ``Theta``: The number at the element of the list accessed, or the dimension of the list if ``list_element`` was 0.

    Errors:
     * ``..NT:A:LS`` if the user did not specify a valid list.
     * ``..E:NT:FN`` if the entry was not found in the list specified.

------------

.. function:: GetArgType: det(31); Ans = argument to check

    Outputs a real number depicting the type of argument in ``Ans``.

    Parameters:
     * ``Ans``: Argument to check the type of.

    Returns:
     * ``Theta``: The number corresponding to the argument's type. A table with the possible types is below.
    
    ====== =========
    Number Type
    0      Real
    1      List
    2      Matrix
    4      String
    12     Complex
    13     Cplx List
    ====== =========

------------

.. function:: ChkStats: det(32, function)

    This is a multi-purpose command used to read various system statuses. The output will vary based on the specified function. A table with the possible functions and their resulting outputs is below.

    ======== ==============================================================================
    Function Output
    0        Total free RAM (In ``Str9``)
    1        Total free ROM (Also in ``Str9``)
    2        Bootcode (Also in ``Str9``)
    3        OS Version (Also in ``Str9``)
    4        Hardware version: 0 for 84 Plus CE, 1 for 83 Premium CE (Returns in ``Theta``)
    ======== ==============================================================================

    Parameters:
     * ``function``: Function to complete.

    Returns:
     * Varies based on input.

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

    Deletes ``number_of_bytes`` bytes from the file specified by ``Str0``, starting at ``byte_start``. ``byte_start`` is 0-indexed, meaning that the first byte of the program is 0, the second is 1, and so on.

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

------------

.. function:: ErrorHandle: det(45, get_offset); Ans = program to run

    Executes BASIC code with an error handler installed. That means the code you execute can do anything it wants including divide by zero, and it will simply end the execution but an obvious system error will not trigger. Instead, this command will return with a value that indicates the error condition. This command has two different modes. If ``Ans`` contains a program name (beginning with the ``prgm`` token), it will run that program. If ``Ans`` contains program code, it will execute that code instead. This will also work with programs beginning with the ``Asm84CEPrgm`` token.

    A list of return values and their corresponding errors can be found in the `error codes <errorcodes.html#ti-os-errors>`__ section, under TI-OS Errors.

    .. warning:: ErrorHandle cannot be used recursively. This means that if you attempt to run ErrorHandle on a program and then run ErrorHandle again inside that second program, the ErrorHandle command in that second program will be ignored.

    .. note:: When using ErrorHandle from the homescreen, it will not run BASIC programs, though it can still run programs beginning with the Asm84CEPrgm token.

    Parameters:
     * ``Ans``: The name of the program to run, or TI-BASIC code to be executed.
     * ``get_offset``: If ``get_offset`` is 1, ErrorHandle will return the byte offset the error occured at in ``Ans``. If it is 0, it will not. This only works with running programs, not strings.

    Returns:
     * ``Theta``: Contains the error code returned by the program, or 0 if no error occured.
     * ``Ans``: Contains the byte offset the error occured at, if ``get_offset`` 1 and an error occured. Otherwise ``Ans`` is not modified.

    Errors:
     * ``..NULLVAR`` if the program is empty.
     * ``..SUPPORT`` if the file is not a TI-BASIC program.

------------

.. function:: StringRead: det(46, string, start, bytes);

    Works almost identically to BASIC's sub() command, except that the output will be in hexadecimal and two-byte tokens will read as two instead of one byte. It is particularly useful for extracting data from a string that may contain nonsensical data that simply needs to be manipulated. If you allow the start point to be zero, the size of the string in bytes is returned instead. For data manipulation, you should use the Edit1Byte command.

    Parameters:
     * ``string``: Which string variable to read from, where 0 = Str0, 9 = Str9, and so on.
     * ``start``: The byte of the string to begin reading at.
     * ``bytes``: How many bytes to read.

    Returns:
     * ``Str9``: The extracted substring.
     * ``Theta``: The size of the string in bytes, if ``start`` was 0.

------------

.. function:: HexToDec: det(47); Ans = hex

    Converts up to 4 hex digits back to decimal. If you pass a string longer than 4 digits, only the first four are read.

    Parameters:
     * ``Ans``: Hex string to convert.

    Returns:
     * ``Theta``: Decimal integer converted from hex string.

    Errors:
     * ``..INVAL:S`` if an invalid hex digit is passed.

------------

.. function:: DecToHex: det(48, number, override)

    Converts a number between 0 and 65535 to its hexadecimal equivalent. The number of hexadecimal output to the string will have its leading zeroes stripped so inputting 15 will result in “F” and 16 will result in “10”. If override is 1, it will output all leading zeroes, which may be useful for routines that require four hex digits at all times but cannot spend the memory/time whipping up a BASIC solution to fill the missing zeroes.

    Parameters:
     * ``number``: Decimal integer to convert.
     * ``override``: 1 to output all leading zeroes, or 0 to not.

    Returns:
     * ``Str9``: Hex string converted from decimal integer.

------------

.. function:: EditWord: det(49, string, start, word)

    This command, otherwise, works just like Edit1Byte. Its documentation is rewritten here for convenience. Replaces a word in some string variable, Str0 to Str9, with a replacement value 0 through 65535 starting at some specified byte (start is at 0). The string supplied is edited directly so there's no output. See Edit1Byte for more details.

    The replacement is written in little-endian form and if the number is between 0 and 255, the second byte is written in as a zero.

    .. note:: Note: A “word” in this sense is two bytes. Useful for editing a binary string which entries are all two bytes in length, such as a special string tilemap. You’re required, however, to specify offset in bytes. Also know that all words are stored little-endian. That means that the least significant byte is stored before the most significant byte is.

    Parameters:
     * ``string``: Which string variable to read from, where 0 = Str0, 9 = Str9, and so on.
     * ``start``: The byte to start editing in the string.
     * ``word``: The two bytes to rewrite.

    Returns:
     * Modifies the string with the specified word.

    Errors:
     * ``..E:NT:FN`` If the offset is past the end of the string.

------------

.. function:: BitOperate: det(50, value1, value2, function)

    Performs a bitwise operation between value1 and value2 using a supplied function value. It will only work with up to 16-bit numbers.

    The different functions are below:

    ===== ===========
    Value Operation
    ===== ===========
    0     NONE
    1     AND
    2     OR
    3     XOR
    4     Left Shift
    5     Right Shift
    ===== ===========

    This command really helps mask out hex digits but if you use strings to store those digits, you'll need to use the HexToDec command for each value you need.

    Parameters:
     * ``value1``: First value to perform bit operation with.
     * ``value2``: Second value to perform bit operation with.
     * ``function``: Which operation to perform, as seen in the table above.

    Returns:
     * ``Theta``: Result of the bit operation.

------------

.. function:: GetProgList: det(51, type); Ans = search string

    This function will return a space-delimited string consisting of the names of programs, appvars, or groups whose names partially match the search string. Which is to say::

        "TEMP
        det(51, 0) 

    would return all program names that start with the characters “TEMP”, which may be something like “TEMP001 " or “TEMP001 TEMP002 TEMP003 “, etc.

    ===== =========
    Value File Type
    ===== =========
    0     Programs
    1     AppVars
    2     Groups
    ===== =========

    .. note:: 
        This command is NOT to be confused with FindProg, which outputs a string consisting of files whose CONTENTS starts with the specified string. Also use the fact that the final name in the list is terminated with a space to make extracting names from the list easier. It also will not find hidden variables.

    Parameters:
     * ``type``: The type of file to search for, as seen above.
     * ``Ans``: String to find in file names.

    Returns:
     * ``Str9``: Filtered list of files.

    Errors:
     * ``..S:NT:FN`` if ``Ans`` is not a string.
     * ``..P:NT:FN`` if no files were found containing the search string.
