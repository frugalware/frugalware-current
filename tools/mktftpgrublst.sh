#!/bin/bash
# 
#   mktftpgrublst.sh
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
	echo "mktftpgrublst.sh"
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
	volumes=`ls volumes.xml 2>/dev/null`
	if [ -n "$volumes" ]; then
	        echo $volumes
	else
	        echo "missing"
        	exit 1
	fi
fi

[ -z "$arch" ] && arch=`uname -m`

echo -n "searching for a kernel... "
kernel=`ls /tftpboot/vmlinuz*-$arch 2>/dev/null`
if [ -n "$kernel" ]; then
        echo $kernel
else
	kernel=`ls ../boot/vmlinuz*-$arch 2>/dev/null`
	if [ -n "$kernel" ]; then
        	echo $kernel
	else
        	echo "none found"
	        exit 1
	fi
fi

echo -n "searching for the initrd... "
initrd=`ls /tftpboot/initrd-$arch.img.gz 2>/dev/null`
if [ -n "$initrd" ]; then
        echo $initrd
else
	initrd=`ls ../boot/initrd-$arch.img.gz 2>/dev/null`
	if [ -n "$initrd" ]; then
	        echo $initrd
	else
	        echo "none found"
        	exit 1
	fi
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

ver=`grep '<version>' $toolsdir/$volumes |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$ver" ] && ver=`date +%Y%m%d`
rel=`grep '<codename>' $toolsdir/$volumes |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$rel" ] && rel="-current"
size=`echo "$(gzip --list $initrd|grep ${initrd/.gz/}|sed 's/.*[0-9]\+ \+\([0-9]\+\) .*/\1/')/1024"|bc`

echo -n "generating menu.lst... "

echo "default=0
timeout=10
$password

title Frugalware $ver ($rel) - ${kernel#*vmlinuz-}
	$password
	$bootcmd
	root (nd)
        kernel /`basename $kernel` initrd=initrd-$arch.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=791
        initrd /initrd-$arch.img.gz
title Frugalware $ver ($rel) - ${kernel#*vmlinuz-} (nofb)
	$password
	$bootcmd
	root (nd)
        kernel /`basename $kernel` initrd=initrd-$arch.img.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=$size rw root=/dev/ram quiet vga=normal
        initrd /initrd-$arch.img.gz" >menu.lst
echo "done"

