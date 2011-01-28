#!/bin/bash
# 
#   missing-clean.sh: checks for removed packages which should be
#   removed from the fdb as well
#  
#   Copyright (c) 2008 by Miklos Vajna <vmiklos@frugalware.org>
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

. functions.sh
. /etc/makepkg.conf
. /usr/lib/frugalware/fwmakepkg

if [ "$1" == "--help" ]; then
	echo "missing package removes (use 'arch=$2 repoman clean group/pkgname' to fix)"
	exit 1
fi

startdir=..

fb_sources=`mktemp`
fdb_sources=`mktemp`
fdb_tmp=`mktemp -d`

cd $startdir
for i in `git ls-files source |grep FrugalBuild`
do
	cd `dirname $i` || continue
	unset pkgname subpkgs pkgver pkgextraver pkgrel nobuild options archs install
	export startdir=`pwd`
	. ./FrugalBuild || echo "errors while parsing the `pwd`/FrugalBuild"
	if [ ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
		for j in ${archs[@]}
		do
			[[ "$j" != "$1" ]] && continue
			export CARCH=$j
			unset pkgname subpkgs pkgver pkgrel pkgextraver source install
			for k in `set|egrep '^(_F_|USE_)'|sed 's/\(=.*\| ()\)//'`; do unset $k; done
			export startdir=`pwd`
			. ./FrugalBuild || echo "errors parsing `pwd`/FrugalBuild for $j"
			for k in $pkgname ${subpkgs[@]}
			do
				echo $k
			done
		done
	fi
	cd - >/dev/null
done |sort -u > $fb_sources 2>/dev/null

for i in frugalware-$1
do
	cd $i
	bsdtar xf frugalware-current.fdb -C $fdb_tmp
	ls $fdb_tmp |sed 's/-[^-]\+-[^-]\+$//'
	rm -rf $fdb_tmp
	mkdir -p $fdb_tmp
	cd ..
done |sort -u > $fdb_sources 2>/dev/null

diff -u $fdb_sources $fb_sources |grep ^-[^-] |sed 's/^-//'

rm -rf $fb_sources $fdb_sources $fdb_tmp
