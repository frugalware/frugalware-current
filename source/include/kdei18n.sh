#!/bin/sh

# (c) 2006 Craciunescu Gabriel <crazy@frugalware.org>
# kdei18n.sh for Frugalware
# distributed under GPL License

url="http://www.kde.org"
kdever=3.5.2
pkgurl="http://ftp.tu-chemnitz.de/pub/X11/kde/stable/$kdever/src/kde-i18n"
## we just need the right version 
up2date="lynx -dump http://www.kde.org/download/|grep 'kdelibs'|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$pkgname-$pkgver.tar.bz2)
depends=("kdelibs>=$kdever")
rodepends=("kdebase>=$kdever")
groups=('locale-extra')

build() 
{
 	Fbuild --disable-debug
}

