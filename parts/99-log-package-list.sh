#!/bin/sh -e

# Log installed packages
/usr/bin/sva_manually_installed_packages_list > /root/package-list-after-install.dpkg.log
/usr/bin/pip list > /root/package-list-after-install.pip.log
/usr/bin/pip3 list > /root/package-list-after-install.pip3.log
