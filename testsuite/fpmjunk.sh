#!/bin/bash

if [ "$#" != 3 ]; then
	echo "searches for old fpm files"
	echo "note: this is not yet finished, not well-tested!"
	echo "usage: $0 <startdir> <repomane> <arch>"
	exit 1
fi

# fake variable for fwmakepkg
CHROOT=1

. functions
. /usr/lib/frugalware/fwmakepkg

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
		if [ ! -z "$subpkgs" ] && [ ! "$nobuild" -a ! "`check_option NOBUILD`" ]; then
			i=0
			for subpkg in "${subpkgs[@]}"
			do
				unset archs
				archs="${subarchs[$i]}"
				if in_array $arch ${archs[@]}; then
					echo "$pkgname-$pkgver-$pkgrel-$arch.fpm" >>$newfpms
				fi
			done
		fi
	fi
	cd - >/dev/null
done

cat $newfpms |sort >$newfpms.sorted
mv -f $newfpms.sorted $newfpms
cd frugalware-$arch
ls >$allfpms
diff -u $allfpms $newfpms
rm -f $allfpms $newfpms
