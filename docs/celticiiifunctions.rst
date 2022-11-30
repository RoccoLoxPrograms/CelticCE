Celtic III Functions
======================

Overview
~~~~~~~~
Some (not all) of the functions from Celtic III are included in Celtic CE.

Documentation
~~~~~~~~~~~~~

.. function:: GetListElem: det(30, list_element), Ans = list name

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

.. function:: GetArgType: det(31), Ans = argument to check

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

.. function:: FindProg: det(33, type), Ans = search string

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
