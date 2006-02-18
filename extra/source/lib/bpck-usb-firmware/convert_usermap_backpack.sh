#!/bin/bash
#
# This script converts the usb.usermap file for the Micro Solutions 
# Backpack drives to an udev rules file
#
# Copyright 2006 by Rob Kennedy <archpackages@gmail.com>
# Licence for this script:  GPL2
#

cat "$1" | { while read map; do

     if $(echo "$map" | grep -q ^# > /dev/null); then
          echo $map >> backpack-usb.rules

     else

          if [ -n "$map" ]; then 

               set $map

               vid=$(echo $3 | cut -b3-)
               pid=$(echo $4 | cut -b3-)

               echo -e "SYSFS{idVendor}==\"$vid\", SYSFS{idProduct}==\"$pid\", RUN+=\"/lib/udev/backpack-usb.sh\"" >> backpack-usb.rules

          fi

     fi

done }

exit 0
