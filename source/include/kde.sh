#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kde.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for kde packages
url="http://www.kde.org"
_F_kde_ver=3.5.5
pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$_F_kde_ver/src"
#pkgurl="ftp://ftp.tu-chemnitz.de/pub/X11/kde/stable/$_F_kde_ver/src"
#pkgurl="ftp://ftp-stud.fht-esslingen.de/pub/Mirrors/ftp.kde.org/pub/kde/stable/$_F_kde_ver/src"

# strip down the -docs suffix
_F_kde_name=`echo $pkgname|sed 's/-docs$//'`
up2date="lynx -dump http://www.kde.org/download/|grep $_F_kde_name|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$_F_kde_name-$pkgver.tar.bz2)
# qt's post_install is essential for kde pkgs
options=(${options[@]} 'scriptlet')

#if [ "`cat /proc/meminfo |grep MemTotal|sed 's/.* \(.*\) kB/\1/'`" -ge 500000 ]; then
#	Fconfopts="$Fconfopts --enable-final"
#fi

build() 
{
     Fbuild CXXFLAGS="$CXXFLAGS -Wno-deprecated" \
		--disable-dependency-tracking \
		--disable-debug --without-debug \
		--with-gnu-ld --enable-gcc-hidden-visibility
}

