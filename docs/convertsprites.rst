Converting Sprites
==================

Overview
~~~~~~~~

Converting sprites by hand can be a pain, but thankfully it is possible to automate the process using a tool called `convimg <https://github.com/mateoconlechuga/convimg>`__ created by `MateoConLechuga <https://github.com/mateoconlechuga/>`__.

Setup
~~~~~

First you'll need to download the latest version of convimg from the `GitHub releases page <https://github.com/mateoconlechuga/convimg/releases/latest>`__. You should choose the zip for your platform. Next you'll need to add convimg to your Path. To do this follow the instructions for your OS below:

.. note::

    If you already have the CE C toolchain installed, chances are that convimg has already been installed and is in your Path. You can check this by opening a terminal and running `convimg --version`.

On Windows:
    * Extract the zip to a file path without spaces.
    * Open the start menu, then search and choose :guilabel:`Edit the system environment variables`.
    * Click :guilabel:`Enviro&nment Variables` and select :guilabel:`Path` under :guilabel:`&System variables`. Then press the :guilabel:`Ed&it` button.
    * Click :guilabel:`&New` and enter the path to convimg.
    * Click :guilabel:`OK` and exit the editor. You may need to restart your apps (Terminals, IDEs) for the changes to take effect.

On Linux/macOS:
    * Extract the zip to a file path without spaces.
    * Open your system's rc file to add convimg to the path. This might be called :file:`.bashrc`, :file:`.zshrc`, or something else depending on your system.
    * On macOS you might add something like this:

    .. code-block:: bash

        export PATH=$PATH:/path/to/convimg

    * On Linux it might be something like this:

    .. code-block:: bash

        export PATH=/path/to/convimg:$PATH

    * You may need to restart your apps (Terminals, IDEs) for the changes to take effect.

Once you've added convimg to your path, open a new terminal window and type :code:`convimg --version` to ensure it been added correctly. If everything worked, you should see something like this::

    tiny@tinyUbuntu:~$ convimg --version
    convimg v9.0 by mateoconlechuga

Conversion
~~~~~~~~~~

In order to convert your sprites, you should first create a folder with all the sprites for your project, to keep it organized. Having different sprites all over the place gets very confusing and is not a good habit to have.
Once you have your sprites in a directory, you'll need to create a :file:`convimg.yaml` file in that directory as well. This file has configuration options and information for convimg to convert your sprites. You can start out with a template file like this:

.. code-block:: yaml

        converts:
          - name: images
            palette: xlibc
            width-and-height: false
            images:
              - image.png

        outputs:
          - type: basic
            include-file: images.txt
            converts:
              - images

.. warning::

    If you are using an older version of convimg you may need to specify the type as "ice" instead of "basic". You can also pick up the latest non-release build of convimg by going to the `GitHub Actions <https://github.com/mateoconlechuga/convimg/actions>`__ tab of the repo, selecting the most recent run, and downloading the version for your OS under "Artifacts".

If you want to convert file names which follow specific patterns, you can use glob patterns. For example, to convert all png files in a directory, you can do something like this:

    .. code-block:: yaml
        
        images:
            - "*.png"

.. note::

    It is necessary for the pattern to be in quotes, even though that is not necessary for image names to be in quotes.

Once you have completed your yaml, navigate to the directory with the sprites and the yaml in a terminal and run :code:`convimg`. If all goes well you should have a text file as specified in your yaml (In the example it is :file:`images.txt`) containing the converted sprites. It will look something like this:

.. only:: html

        .. code-block:: txt

            image | 256 bytes
            "FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFF0000E6E6E6E6E6E6E6E60000FFFFFFFF0000E6E6E6E6E6E6E6E60000FFFF0000E6E60000E6E6E6E60000E6E600000000E6E60000E6E6E6E60000E6E600000000E6E60000E5E5E5E50000E6E600000000E6E60000E5E5E5E50000E6E600000000E5E5E5E5E5E5E5E5E5E5E5E500000000E5E5E5E5E5E5E5E5E5E5E5E500000000E5E5E5E500000000E5E5E5E500000000E5E5E5E500000000E5E5E5E50000FFFF0000E5E5E5E5E5E5E5E50000FFFFFFFF0000E5E5E5E5E5E5E5E50000FFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF"

.. only:: latex

        .. code-block:: txt
    
            image | 256 bytes
            "FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000... (Data continues)

You can then use the data in your programs by copying it into the source code or pasting it into a TI-BASIC IDE like SourceCoder.

For more documentation on convimg, check out the README `here <https://github.com/mateoconlechuga/convimg/blob/master/README.md>`__. For more info on glob patterns, look `here <https://en.wikipedia.org/wiki/Glob_(programming)>`__.
