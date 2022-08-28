General Syntax
==============

Overview
~~~~~~~~

Celtic uses a parser hook to search for a token in your program and run its ASM code if it finds it.
When it encounters the ``det(`` token, Celtic will detect which function you are calling and any arguments with it.
The first argument after the ``det(`` token tells Celtic which function you wish to call.
If you have entered a valid argument, Celtic will tell you what function the argument is referencing in the status bar of the program editor when your cursor is over it.

.. note::
    In the event that you pass invalid arguments to Celtic, it will return an error. See the `Error Codes <errorcodes.html>`__ page for more information.

Argument Types
~~~~~~~~~~~~~~

Arguments are passed to Celtic in three different ways. They can be passed in the ``det(`` function, in the ``Ans`` variable, or in a string.
The method of passing arguments will differ, depending on the function and the type of argument that is being passed.
The specific syntax for each function is listed in the documentation.

Most often, numerical arguments are passed in the ``det(`` function. Variable names are put in ``Str0``, and strings arguments are put in ``Str9``. The exact usage will vary depending on the function.
Celtic only accepts positive real integers as arguments. If a decimal number is passed, Celtic will only take the integer part of it.

If a string is used, it must be in the RAM when the function is called.

Returns
~~~~~~~
Depending on the function, Celtic will return a value after it runs. For example, the ``SpecialChars`` function fills ``Str9`` with certain special characters.

String returns are most often in ``Str9``, while numerical returns are in the theta variable. All functions will return the initial contents of ``Ans`` (in order to preserve it).
