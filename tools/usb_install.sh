#!/bin/bash
# 
#   usb_install.sh
#  
#   Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
#  
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
# 
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#  
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, 
#   USA.
#

offer()
{
	[ "$noconfirm" ] && return
	echo -n "$1 [${!2}]?"
	read ret
	[ -n "$ret" ] && eval $2=$ret
}

if [ "$1" == "--noconfirm" ]; then
	noconfirm=1
fi

echo -n "checking if we are root... "
if [ "`id -u`" == "0" ]; then
	echo "yes"
else
	echo "no"
	exit 1
fi

echo -n "searching for volumes.xml... "
if [ -e volumes.xml ]; then
	echo "done"
else
	echo "missing"
	exit 1
fi

echo -n "searching for message... "
if [ -e message ]; then
	echo "done"
else
	echo "missing"
	exit 1
fi

echo -n "searching for a kernel... "
kernel=`ls vmlinuz*-$(uname -m) 2>/dev/null`
if [ -n "$kernel" ]; then
	echo $kernel
else
	echo "none found"
	exit 1
fi

echo -n "searching for the initrd... "
initrd=`ls initrd-$(uname -m).img.gz 2>/dev/null`
if [ -n "$initrd" ]; then
	echo $initrd
else
	echo "none found"
	exit 1
fi

echo -n "searching for the stage{1,2} of grub... "
if ls /usr/lib/grub/i386-pc/stage{1,2} &>/dev/null; then
	echo "found"
else
	echo "not found"
	exit 1
fi

echo -n "searching for usb sticks... "
for i in /sys/block/sd*
do
	if [ "`cat $i/removable`" == "1" ]; then
		stick=/dev/${i##*/}
		break
	fi
done
if [ -n "$stick" ]; then
	echo "done"
else
	echo "none found"
	exit 1
fi

offer "what is the name of the target device" stick

echo -n "checking if $stick is a valid block device... "
if [ -b "$stick" ]; then
	echo "yes"
else
	echo "no"
	exit 1
fi

while true
do
	echo -n "check if /boot/grub/device.map contains $stick... "
	if grep -q $stick /boot/grub/device.map 2>/dev/null; then
		echo "yes"
		break
	else
		echo "no"
		regen_devmap="y"
		offer "should we update /boot/grub/device.map" regen_devmap
		if [ "$regen_devmap" = "n" ]; then
			echo "okay, then please update it manually"
			exit 1
		else
			echo -n "updating /boot/grub/device.map... "
			rm -f /boot/grub/device.map
			echo "quit" | grub --batch --device-map=/boot/grub/device.map >/dev/null 2>&1
			echo "done."
		fi
	fi
done

echo -n "checking for the grub name of $stick... "
grubdev=`grep $stick /boot/grub/device.map|sed 's/(\(.*\)).*/\1/'`
echo "$grubdev"

echo -n "checking if '$stick' has at least one partition... "
stick="${stick}1"
if [ -b "$stick" ]; then
	echo "yes"
else
	echo "no, please create one"
	exit 1
fi

mntpoint=`mktemp -d`
echo -n "mounting $stick to $mntpoint... "
mount $stick $mntpoint
if [ $? == 0 ]; then
	echo "done"
else
	echo "failed"
	exit 1
fi

echo -n "copying the installer to $stick... "
mkdir -p $mntpoint/boot/grub
cp $kernel $mntpoint/boot/
cp $initrd $mntpoint/boot/
cp /usr/lib/grub/i386-pc/stage{1,2} $mntpoint/boot/grub/
cp message $mntpoint/boot/grub/
sync
echo "done"

echo -n "generating menu.lst... "
ver=`grep '<version>' volumes.xml |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$ver" ] && ver=`date +%Y%m%d`
rel=`grep '<codename>' volumes.xml |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$rel" ] && rel="-current"
size=`echo "$(gzip --list initrd-$(uname -m).img.gz|grep initrd-$(uname -m).img|sed 's/.*[0-9]\+ \+\([0-9]\+\) .*/\1/')/1024"|bc`
echo "default=0
timeout=10
gfxmenu /boot/grub/message

title Frugalware $ver ($rel) - ${kernel#vmlinuz-}
	kernel /boot/$kernel initrd=initrd-`uname -m`.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=791
	initrd /boot/initrd-`uname -m`.img.gz
title Frugalware $ver ($rel) - ${kernel#vmlinuz-} (nofb)
	kernel /boot/$kernel initrd=initrd-`uname -m`.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=normal
	initrd /boot/initrd-`uname -m`.img.gz" >$mntpoint/boot/grub/menu.lst
echo "done"

echo -n "umounting $stick... "
umount $stick
echo "done."
echo -n "installing grub to $stick ($grubdev)... "
echo "root ($grubdev,0)
setup ($grubdev)
quit" | grub --batch >/dev/null 2>&1
echo "done"
rmdir $mntpoint
