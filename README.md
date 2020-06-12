# UDEV rules setup for interface boards.

***gen_rule*** is shell tool for generating rule access to user device.

Developed in bash code: ***100%***.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/gen_rule.svg)](https://github.com/vroncevic/gen_rule/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/gen_rule.svg)](https://github.com/vroncevic/gen_rule/graphs/contributors)

<!-- START doctoc -->
**Table of Contents**

- [Installation](https://github.com/vroncevic/gen_rule#installation)
- [Usage](https://github.com/vroncevic/gen_rule#usage)
- [Dependencies](https://github.com/vroncevic/gen_rule#dependencies)
- [Shell tool structure](https://github.com/vroncevic/gen_rule#shell-tool-structure)
- [Docs](https://github.com/vroncevic/gen_rule#docs)
- [Copyright and Licence](https://github.com/vroncevic/gen_rule#copyright-and-licence)
<!-- END doctoc -->

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/gen_rule/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf gen_rule-x.y.z.tar.gz
cd gen_rule-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/gen_rule/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/gen_rule/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/gen_rule/ver.1.0/
```

![alt tag](https://raw.githubusercontent.com/vroncevic/gen_rule/dev/docs/setup_tree.png)

Or You can use docker to create image/container.

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/gen_rule/ver.1.0/bin/gen_rule.sh /root/bin/gen_rule

# Setting PATH
export PATH=${PATH}:/root/bin/

# Generating user device rule
gen_rule install avr_dragon
```

### DEPENDENCIES

This tool requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

***gen_rule*** is based on MOP.

Shell tool structure:
```
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
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/gen_rule/badge/?version=latest)](https://gen_rule.readthedocs.io/projects/gen_rule/en/latest/?badge=latest)

More documentation and info at:

* https://gen_rule.readthedocs.io/en/latest/

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2018 by https://vroncevic.github.io/gen_rule

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

