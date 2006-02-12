#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kde.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for kde packages
url="http://www.kde.org"
kdever=3.5.1
pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$kdever/src"

# strip down the -docs suffix
kdename=`echo $pkgname|sed 's/-docs$//'`
up2date="lynx -dump http://www.kde.org/download/|grep $kdename|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$kdename-$pkgver.tar.bz2)
unset kdename

if [ "`cat /proc/meminfo |grep MemTotal|sed 's/.* \(.*\) kB/\1/'`" -ge 500000 ]; then
	Fconfopts="$Fconfopts --enable-final"
fi

build() 
{
	# we need that because KDE add some -O2' twice we already have it in our {$CXX,$C}{FLAGS}
	Fcd
	for i in `find . -iname configure`
	do
		Fsed '-O2' '' $i
	done
	
	Fbuild CXXFLAGS="$CXXFLAGS -Wno-deprecated" \
		--disable-dependency-tracking \
		--disable-debug \
		--with-gnu-ld \
		--enable-gcc-hidden-visibility \
		DO_NOT_COMPILE="doc"
}

