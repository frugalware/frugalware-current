#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kde.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for kde packages
url="http://www.kde.org"
kdever=3.5
pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$kdever/src"
up2date="lynx -dump http://www.kde.org/download/|grep $pkgname|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$pkgname-$pkgver.tar.bz2)
build() 
{
	Fbuild CXXFLAGS="$CXXFLAGS -Wno-deprecated" \
		--disable-dependency-tracking \
		--disable-debug \
		--with-gnu-ld \
		DO_NOT_COMPILE="doc"
}
