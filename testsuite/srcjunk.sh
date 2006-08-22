#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "searches for old source files"
	echo "usage: $0 [--remove] <startdir>"
	exit 1
fi

# fake variable for fwmakepkg
CHROOT=1

. functions
. /usr/lib/frugalware/fwmakepkg

if [ "$1" == "--remove" ]; then
	remove="y"
	shift
fi
sdir=$1

newsrcs=`mktemp`
darcssrcs=`mktemp`
oldsrcs=`mktemp`
allsrcs=`mktemp`

cd $sdir

CWD=`pwd`
for i in `find source -name FrugalBuild`
do
	cd `dirname $i` || continue
	startdir=`pwd`
	unset nobuild options archs
	. FrugalBuild || echo "errors parsing the FrugalBuild"
	if [ ! -z "$pkgname" -a ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
		for j in ${archs[@]}
		do
			CARCH=$j
			unset source signatures
			for i in `set|grep ^_F_|sed 's/=.*//'`; do unset $i; done
			startdir=`pwd`
			. FrugalBuild || echo "errors parsing the FrugalBuild for $j"
			for k in "${source[@]}" "${signatures[@]}"
			do
				echo "`pwd|sed \"s|$CWD/||\"`/`strip_url $k`" >>$newsrcs
			done
		done
	fi
	cd - >/dev/null
done
cat $newsrcs |sort -u >$newsrcs.sorted
mv -f $newsrcs.sorted $newsrcs

find source ! -type d ! -name Changelog |sort >$allsrcs
find _darcs/current/source ! -name Changelog|sed 's|_darcs/current/||' |sort >$darcssrcs

diff -u $allsrcs $darcssrcs |grep ^-[^-] |sed 's/^-//' >$oldsrcs

for i in `diff -u $oldsrcs $newsrcs |grep ^-[^-] |sed 's/^-//'`
do
	[ -z "$remove" ] && echo $i || rm -v $i
done
rm -f $newsrcs $darcsscrs $oldsrcs $allsrcs
