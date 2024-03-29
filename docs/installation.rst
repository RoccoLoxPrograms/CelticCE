Installation
============
Downloading the Installer
~~~~~~~~~~~~~~~~~~~~~~~~~

* Download the latest release of Celtic CE from the `GitHub releases page <https://github.com/RoccoLoxPrograms/CelticCE/releases/latest>`__.
* Transfer :file:`CelticCE.8xp` to your calculator using :program:`TI-Connect CE` or :program:`TiLP`.

Installing the App
~~~~~~~~~~~~~~~~~~

* Open the programs menu and select :program:`CELTICCE`.
* Run :program:`CELTICCE` and follow through the installation process.

.. figure:: images/appInstaller.png
    :alt: Celtic installer menu
    :align: center

    The Celtic installer menu.

.. note::
    If you delete the installer, you'll need to send it to the calculator again, should the app ever get deleted.
    However, you can still uninstall and re-install the Celtic CE library using the app. The program is only used for installing the app onto the calculator.

* Open the apps menu and select :program:`CelticCE`.
* Press :kbd:`1` to install. You can now exit the app by pressing :kbd:`3` or :kbd:`clear`.

.. figure:: images/app.png
    :alt: Celtic app
    :align: center

    The Celtic app.

.. note::
    If you install Celtic CE when another parser hook (:program:`ASMHOOK`, for example) is installed, it will chain with it in order to preserve it.
    This means that both hooks will be able to run in tandem. However, if Celtic gets uninstalled, you will need to re-install the second hook again.
