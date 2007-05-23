# small helper to upload all packages of a given release to the sql db

# fake variable for fwmakepkg
CHROOT=1
. /usr/lib/frugalware/fwmakepkg

sqlarchs=('i686' 'x86_64')
cd ..
CWD=`pwd`
for i in `find source -name FrugalBuild`
do
	cd `dirname $i` || continue
	startdir=`pwd`
	unset pkgname pkgver pkgrel archs subpkgs groups nobuild options
	for j in `set|grep ^_F_|sed 's/=.*//'`; do unset $j; done
	. FrugalBuild || echo "errors parsing the FrugalBuild"
	for j in ${archs[@]}
	do
		echo ${sqlarchs[@]} |grep -q $j || continue
		cd $CWD/frugalware-$j
		if [ ! "`check_option NOBUILD`" ]; then
			echo ../tools/fpm2db -f $pkgname-$pkgver-$pkgrel-$j.fpm
			../tools/fpm2db -f $pkgname-$pkgver-$pkgrel-$j.fpm || exit 1
		else
			echo ../tools/fpm2db -f $pkgname-$pkgver-$pkgrel-$j.fpm -g $groups
			../tools/fpm2db -f $pkgname-$pkgver-$pkgrel-$j.fpm -g $groups || exit 1
		fi
		if [ ! -z "$subpkgs" ]; then
			for k in "${subpkgs[@]}"
			do
				echo ../tools/fpm2db -f $k-$pkgver-$pkgrel-$j.fpm -m $pkgname -g $groups
				../tools/fpm2db -f $k-$pkgver-$pkgrel-$j.fpm -m $pkgname -g $groups || exit 1
			done
		fi
		cd - >/dev/null
	done
	cd $CWD
done
