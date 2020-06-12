GEN_RULE
---------

.. toctree::
 :hidden:

 self


gen_rule is shell tool for generating rule access to user device.

Developed in bash code: 100%.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/gen_rule.svg
   :target: https://github.com/vroncevic/gen_rule/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/gen_rule.svg
   :target: https://github.com/vroncevic/gen_rule/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/gen_rule/badge/?version=latest
   :target: https://gen_rule.readthedocs.io/projects/gen_rule/en/latest/?badge=latest

INSTALLATION
-------------
Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/gen_rule/releases

To install this set of modules type the following:

.. code-block:: bash

   tar xvzf gen_rule-x.y.z.tar.gz
   cd gen_rule-x.y.z
   cp -R ~/sh_tool/bin/   /root/scripts/gen_rule/ver.1.0/
   cp -R ~/sh_tool/conf/  /root/scripts/gen_rule/ver.1.0/
   cp -R ~/sh_tool/log/   /root/scripts/gen_rule/ver.1.0/

DEPENDENCIES
-------------
This tool requires these other modules and libraries:

.. code-block:: bash

   sh_util https://github.com/vroncevic/sh_util

SHELL TOOL STRUCTURE
---------------------
gen_rule is based on MOP.

Shell tool structure:

.. code-block:: bash

   .
   ├── bin/
   │   ├── create_udev_file.sh
   │   ├── gen_rule.sh
   │   ├── list_udev_files.sh
   │   └── remove_udev_file.sh
   ├── conf/
   │   ├── gen_rule.cfg
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

COPYRIGHT AND LICENCE
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2018 by https://vroncevic.github.io/gen_rule

This tool is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

