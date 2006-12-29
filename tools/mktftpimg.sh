#!/bin/bash
# 
#   mktftpimg.sh
#  
#   Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
#   Copyright (c) 2006 by Alex Smith <alex@alex-smith.me.uk>
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

bootcmd="bootp"

usage() {
	echo "mktftpimg.sh"
	echo
	echo "Usage: $0 [options]"
	echo
	echo "Options:"
	echo "  -p, --password Set the GRUB password to this."
	echo "  -d, --dhcp Use dhcp rather than bootp"
	echo
	echo "Example:"
	echo "  $0 --password \"mypassword\" - this sets the password to mypassword"
	echo "  $0 --password \"mypassword\" --dhcp - this sets the password to mypassword and uses dhcp rather than bootp"
	echo
}

# Check options
while [ "$#" -ne "0" ]; do
	case $1 in
		--password)       password="$2" ;;
		--dhcp)           bootcmd="dhcp" ;;
		--help)
			usage
			exit 0
			;;
		--*)
			usage
			exit 1
			;;
		-*)
			while getopts "dp:" opt; do
				case $opt in
					d) bootcmd="dhcp" ;;
					p) password="$OPTARG" ;;
					*)
						usage
						exit 1
						;;
				esac
			done
			;;
		*)
			true
			;;
	esac
	shift
done

echo -n "checking if we are root... "
if [ "`id -u`" == "0" ]; then
        echo "yes"
else
        echo "no"
        exit 1
fi

echo -n "searching for volumes.xml... "
volumes=`ls ../docs/xml/volumes.xml 2>/dev/null`
if [ -n "$volumes" ]; then
        echo $volumes
else
        echo "missing"
        exit 1
fi

[ -z "$arch" ] && arch=`uname -m`

echo -n "searching for a kernel... "
kernel=`ls ../boot/vmlinuz*-$arch 2>/dev/null`
if [ -n "$kernel" ]; then
        echo $kernel
else
        echo "none found"
        exit 1
fi

echo -n "searching for the initrd... "
initrd=`ls ../boot/initrd-$arch.img.gz 2>/dev/null`
if [ -n "$initrd" ]; then
        echo $initrd
else
        echo "none found"
        exit 1
fi

echo -n "searching for the stage{1,2.netboot} of grub... "
if ls /usr/lib/grub/i386-pc/stage{1,2.netboot} &>/dev/null; then
        echo "found"
else
        echo "not found"
        exit 1
fi

if [ ! -z "$password" ]; then
	password=$(/sbin/grub --batch --device-map=/dev/null <<EOF | grep "^Encrypted: " | sed 's/^Encrypted: //'
md5crypt
$password
quit
EOF
)
	password="password --md5 $password"
fi

toolsdir=`pwd`
imgdir=`mktemp -d`

ver=`grep '<version>' $toolsdir/$volumes |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$ver" ] && ver=`date +%Y%m%d`
rel=`grep '<codename>' $toolsdir/$volumes |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$rel" ] && rel="-current"
img="frugalware-$ver-$arch-tftp.img"
size=`echo "$(gzip --list $toolsdir/$initrd|grep $toolsdir/${initrd/.gz/}|sed 's/.*[0-9]\+ \+\([0-9]\+\) .*/\1/')/1024"|bc`

dd if=/dev/zero of=$img bs=1k count=1440
/sbin/mke2fs -F $img
grep -q loop /proc/modules || /sbin/modprobe loop
mount -o loop $img $imgdir

cd $imgdir
mkdir -p boot/grub
cp /usr/lib/grub/i386-pc/stage1 boot/grub/
cp /usr/lib/grub/i386-pc/stage2.netboot boot/grub/stage2

echo -n "generating menu.lst... "

echo "default=0
timeout=10
$password

title Frugalware $ver ($rel) - ${kernel#*vmlinuz-}
	$bootcmd
	root (nd)
        kernel /`basename $kernel` initrd=initrd-$arch.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=791
        initrd /initrd-$arch.img.gz
	$password
title Frugalware $ver ($rel) - ${kernel#*vmlinuz-} (nofb)
	$bootcmd
	root (nd)
        kernel /`basename $kernel` initrd=initrd-$arch.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=normal
        initrd /initrd-$arch.img.gz
	$password" >boot/grub/menu.lst
echo "done"

cd $toolsdir
umount $imgdir

echo "device (fd0) $img
root (fd0)
setup (fd0)
quit" | grub --batch --device-map=/dev/null

rm -rf $imgdir
