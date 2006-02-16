#!/bin/bash

# fake variable for fwmakepkg
CHROOT=1

. functions
. /etc/makepkg.conf
. /usr/lib/frugalware/fwmakepkg

if [ "$#" = 0 ]; then
	echo "$0: searches for missing source files"
	echo "usage: $0 [--download] <startdir>"
	exit 1
fi

if [ "$1" == "--download" ]; then
	download="y"
	shift
fi
startdir=$1

cd $startdir
for i in `find source extra -maxdepth 5 -name FrugalBuild`
do
	cd `dirname $i` || continue
	unset nobuild options archs
	. FrugalBuild || echo "errors parsing the FrugalBuild"
	if [ ! -z "$pkgname" -a ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
		for j in ${archs[@]}
		do
			export CARCH=$j
			unset source
			export startdir=`pwd`
			. FrugalBuild || echo "errors parsing the FrugalBuild for $j"
			for k in ${source[@]}
			do
				file=`strip_url $k`
				if [ ! -e "$file" ]; then
					echo "`dirname $i`: $file is missing"
					if [ ! -z "$download" ]; then
						echo "downloading $file..."
						$FTPAGENT $j
					fi
				fi
			done
		done
	fi
	cd - >/dev/null
done
