gen_rule
---------

**gen_rule** is shell tool for generating rule access to user device.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

|GitHub shell checker|

.. |GitHub shell checker| image:: https://github.com/vroncevic/gen_rule/actions/workflows/gen_rule_shell_checker.yml/badge.svg
   :target: https://github.com/vroncevic/gen_rule/actions/workflows/gen_rule_shell_checker.yml

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/gen_rule.svg
   :target: https://github.com/vroncevic/gen_rule/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/gen_rule.svg
   :target: https://github.com/vroncevic/gen_rule/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/gen_rule/badge/?version=latest
   :target: https://gen-rule.readthedocs.io/projects/gen_rule/en/latest/?badge=latest

.. toctree::
    :hidden:

    self

Installation
-------------

|Debian Linux OS|

.. |Debian Linux OS| image:: https://raw.githubusercontent.com/vroncevic/gen_rule/dev/docs/debtux.png
   :target: https://www.debian.org

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/gen_rule/releases

To install **gen_rule** type the following

.. code-block:: bash

   tar xvzf gen_rule-x.y.tar.gz
   cd gen_rule-x.y
   cp -R ~/sh_tool/bin/   /root/scripts/gen_rule/ver.x.y/
   cp -R ~/sh_tool/conf/  /root/scripts/gen_rule/ver.x.y/
   cp -R ~/sh_tool/log/   /root/scripts/gen_rule/ver.x.y/

Or You can use Docker to create image/container.

Dependencies
-------------

**gen_rule** requires next modules and libraries

* sh_util `https://github.com/vroncevic/sh_util <https://github.com/vroncevic/sh_util>`_

Shell tool structure
---------------------

**gen_rule** is based on MOP.

Shell tool structure

.. code-block:: bash

   sh_tool/
   ├── bin/
   │   ├── center.sh
   │   ├── create_udev_file.sh
   │   ├── display_logo.sh
   │   ├── gen_rule.sh
   │   ├── list_udev_files.sh
   │   └── remove_udev_file.sh
   ├── conf/
   │   ├── gen_rule.cfg
   │   ├── gen_rule.logo
   │   ├── gen_rule_util.cfg
   │   ├── template/
   │   │   ├── avr_dragon_isp.template
   │   │   ├── avr_jtag_ice.template
   │   │   ├── avr_silabs.template
   │   │   ├── avr_usb_asp.template
   │   │   ├── avr_usb_mkii.template
   │   │   ├── avr_usb_tiny.template
   │   │   └── msp430uif.template
   │   ├── udev_rule_names.cfg
   │   └── udev_templates.cfg
   └── log/
       └── gen_rule.log

Copyright and licence
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2016 - 2024 by `vroncevic.github.io/gen_rule <https://vroncevic.github.io/gen_rule>`_

**gen_rule** is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

|Free Software Foundation|

.. |Free Software Foundation| image:: https://raw.githubusercontent.com/vroncevic/gen_rule/dev/docs/fsf-logo_1.png
   :target: https://my.fsf.org/

|Donate|

.. |Donate| image:: https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif
   :target: https://my.fsf.org/donate/

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
