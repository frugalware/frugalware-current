#!/bin/sh

###
# = wine.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# wine.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for wine stable & development packages.
#
# == EXAMPLE
# pkgname=wine
# pkgver=1.2.3
# pkgrel=3
# Finclude wine
###

url="http://www.winehq.org"
groups=('xapps-extra')
depends=('lcms2' 'openal' 'libglu' 'libldap' 'libpcap' 'libpulse' 'libmpg123' 'libgphoto2' 'gettext')
makedepends=('x11-protos' 'cups')
_F_cd_path="wine-$pkgver"
options=('genscriptlet')
archs=('i686' 'x86_64')

Fconfopts+="	--libdir=/usr/lib"

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="Flasttar https://dl.winehq.org/wine/source/1.8/"
	conflicts=('wine-devel')
	;;

wine-devel)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Development)"
	up2date="lynx -dump $url | sed -n 's|^.*Development:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
	conflicts=('wine')
	provides=('wine')
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac

if [[ "$CARCH" == "x86_64" ]]
then
	Fconfopts="--enable-win64"
	rodepends=('lib32-wine')
fi

source=(http://ftp.winehq.org/pub/wine/source/${pkgver%.*}/wine-$pkgver.tar.bz2)
signatures=("${source[@]}.sign")

build()
{
	Fcd
	Fsed 'lib64' 'lib' configure.ac
	Fautoreconf
	Fbuild
	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
}
