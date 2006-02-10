#!/bin/bash

if [ "$#" -lt 3 ]; then
	echo "searches for old fpm files"
	echo "usage: $0 [--remove] <startdir> <repomane> <arch>"
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
startdir=$1
reponame=$2
arch=$3

newfpms=`mktemp`
allfpms=`mktemp`

echo $reponame.fdb >$newfpms
cd $startdir
for i in `find source -maxdepth 5 -name FrugalBuild`
do
	cd `dirname $i` || continue
	unset pkgname pkgver pkgrel nobuild options archs
	unset subpkgs suboptions subarchs
	source FrugalBuild || echo "errors parsing the FrugalBuild"
	if [ ! -z "$pkgname" -a ! -z "$pkgver" -a ! -z "$pkgrel" ]; then
		if in_array $arch ${archs[@]} && [ ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
			echo "$pkgname-$pkgver-$pkgrel-$arch.fpm" >>$newfpms
		fi
	fi
	if [ ! -z "$pkgver" -a ! -z "$pkgrel" -a ! -z "$subpkgs" ] && [ ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
		j=0
		for subpkg in "${subpkgs[@]}"
		do
			unset archs
			archs="${subarchs[$j]}"
			if in_array $arch ${archs[@]}; then
				echo "$subpkg-$pkgver-$pkgrel-$arch.fpm" >>$newfpms
			fi
			j=$(($j+1))
		done
	fi
	cd - >/dev/null
done

cat $newfpms |sort >$newfpms.sorted
mv -f $newfpms.sorted $newfpms
cd frugalware-$arch
ls >$allfpms
for i in `diff -u $allfpms $newfpms |grep ^-[^-] |sed 's/^-//'`
do
	[ -z "$remove" ] && echo $i || rm -v $i
done
rm -f $allfpms $newfpms
