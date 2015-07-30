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
depends=(
	'libgl' 'gnutls' 'libtiff' 'libjpeg' 'libpng' 'libxinerama'
	'libxrandr' 'libxcursor' 'libxcomposite' 'libmpg123' 'libglu'
	'lcms' 'fontconfig' 'openal' 'libldap' 'v4l-utils'
	'sane-backends' 'libcups' 'libxi' 'samba'
	)
makedepends=('cups')
_F_cd_path="wine-$pkgver"
options=('genscriptlet')
archs=('i686' 'x86_64')

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="lynx -dump $url | sed -n 's|^.*Stable:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
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

[ "$CARCH" == "x86_64" ] && Fconfopts="--enable-win64"

source=(http://ftp.winehq.org/pub/wine/source/1.7/wine-$pkgver.tar.bz2)
signatures=("${source[@]}.sign")

build()
{
	Fbuild
	[ "$CARCH" == "x86_64" ] && Fln wine64 /usr/bin/wine
	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
}
