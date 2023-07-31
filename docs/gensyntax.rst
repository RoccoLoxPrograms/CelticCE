General Syntax
==============

Overview
~~~~~~~~

Celtic uses a parser hook to search for a token in your program and run its ASM code if it finds it.
When it encounters the ``det(`` token, Celtic will detect which function you are calling and any arguments with it.
The first argument after the ``det(`` token tells Celtic which function you wish to call.
If you have entered a valid argument, Celtic will tell you what function the argument is referencing in the status bar of the program editor when your cursor is over it.

.. figure:: images/functionPreview.png
    :alt: Celtic's function preview feature
    :align: center

    Celtic's function preview feature.

The function preview follows a general syntax: "``CommandName(Arguments)``: ``Input Vars`` (if any): ``Output Vars`` (if any)". As you can see in the example above, ReadLine is listed with no arguments, ``Str0`` and ``Ans`` as the input variables, and ``Str9`` or ``theta`` as the output variables. If no input variables are necessary (though there are still output variables), it will say "NA" instead. Nothing will be listed if there are no input and output variables.

.. note::
    In the event that you pass invalid arguments to Celtic, it will return an error. All errors are returned in ``Str9``. See the `Error Codes <errorcodes.html>`__ page for more information.

Check if Celtic is Installed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If your program uses Celtic, it is recommended that it makes sure Celtic is installed when ran. To check if Celtic is installed, it is recommended you put something like this at the beginning of your program::

    ::DCS
    :"Icon data...
    :If 90>det([[20
    :Then
    :Disp "Get Celtic CE to run this:","bit.ly/CelticCE
    :Return
    :End

``det([[20]])`` will equal 90 if Celtic CE is installed. If the program aims to be compatible with Celtic 2 CSE, you may wish to refer to the `list of version codes <https://dcs.cemetech.net/index.php?title=Third-Party_BASIC_Libraries_(Color)>`__ on the DCS Wiki as well.

prgmAINSTALL
~~~~~~~~~~~~

You'll notice that along with the CelticCE installer binary, Celtic also comes with a program called **AINSTALL**. This program can be used to install CelticCE's hooks (The part of the installation done after the app has been installed) by running it instead of needing to open the app. Like the **AINSTALL** program in Celtic III, this can be used if you wish to install CelticCE from a TI-BASIC program, by simply running **prgmAINSTALL** in it. Keep in mind that **prgmAINSTALL** will only work if the CelticCE app is present and installed on your calculator.

Argument Types
~~~~~~~~~~~~~~

Arguments are passed to Celtic in three different ways. They can be passed in the ``det(`` function, in the ``Ans`` variable, or in a string.
The method of passing arguments will differ, depending on the function and the type of argument that is being passed.
The specific syntax for each function is listed in the documentation.

Most often, numerical arguments are passed in the ``det(`` function. Variable names are put in ``Str0``, and strings arguments are put in ``Str9``. The exact usage will vary depending on the function.
Celtic only accepts positive real integers as arguments. If a decimal number is passed, Celtic will only take the integer part of it.

When using ``Str0`` as a program name, simply store the name of the program into ``Str0``. When storing an AppVar, begin the string with the ``rowSwap(`` token. When storing a group, begin the string with the ``*row(`` For example::
    
    :"FOO" -> Str0              //program FOO
    :"rowSwap(FOO" -> Str0      //AppVar FOO
    :"*row(FOO" ->              //group FOO

The system programs ``prgm#`` and ``prgm!`` are not supported, so if you attempt to use a Celtic command on them, the command will simply exit.

If a string is used, it must be in the RAM when the function is called.

.. warning:: In almost all cases, Celtic will detect if you passed invalid arguments and return an error instead. However, in the (extremely) rare case that you tried to pass a string with the length of 0, it will not handle this. Don't worry, there shouldn't be any reason this would happen without you trying to make it happen.

Returns
~~~~~~~
Depending on the function, Celtic will return a value after it runs. For example, the ``SpecialChars`` command fills ``Str9`` with certain special characters.

String returns (including errors) are most often in ``Str9``, while numerical returns are in the ``Theta`` variable. Almost all functions will return the initial contents of ``Ans`` (in order to preserve it).
