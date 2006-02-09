#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kde.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for kde packages
url="http://www.kde.org"
kdever=3.5.1
pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$kdever/src"
up2date="lynx -dump http://www.kde.org/download/|grep $pkgname|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$pkgname-$pkgver.tar.bz2)

# crazy says this is still experimental to enable by default for all pkgs
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
