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
	'sane-backends' 'libcups' 'libxi'
	)
makedepends=('cups' 'oss-libs')
[ "$pkgname" == "wine" ] && install="$Fincdir/$pkgname.install"
_F_cd_path="wine-$pkgver"
options=('genscriptlet')
archs=('i686' 'x86_64')

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="lynx -dump $url | sed -n 's|^.*Stable:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
	_geckover=1.4
	conflicts=('wine-devel')
	sha1sums=('cb79601ca92e8ecb8a5b6b64edc45fd366c3e579')
	case "$CARCH" in
		"i686") sha1sums=("${sha1sums[@]}" 'c30aa99621e98336eb4b7e2074118b8af8ea2ad5');;
		"x86_64") sha1sums=("${sha1sums[@]}" 'bf0aaf56a8cf9abd75be02b56b05e5c4e9a4df93');;
	esac
	;;

wine-devel)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Development)"
	up2date="lynx -dump $url | sed -n 's|^.*Development:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
	_geckover=1.6
	conflicts=('wine')
	sha1sums=('941fd13262e498e8825c14e2347762d2bd7211ac')
	case "$CARCH" in
		"i686") sha1sums=("${sha1sums[@]}" '41167632dbc30f32dce7dca43c2a0487aa7cac04');;
		"x86_64") sha1sums=("${sha1sums[@]}" 'edc626480024f58e294447573c7ab94606e8d610');;
	esac
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac

[ "$CARCH" == "x86_64" ] && Fconfopts="--enable-win64"

source=(http://downloads.sourceforge.net/wine/{wine-$pkgver.tar.bz2,wine_gecko-$_geckover-${CARCH/i686/x86}.msi})

###
# == PROVIDED FUNCTIONS
# * Fwinercd()
###
Fwinercd()
{
	[ "$pkgname" != "wine" ] && return
	Fexec cp $Fincdir/wine.install $Fsrcdir
	Fexec cp $Fincdir/rc.wine $Fsrcdir
	Frcd2
}

build()
{
	Fbuild
	Ffile /usr/share/wine/gecko/`basename ${source[1]}`
	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
	[ "$CARCH" == "x86_64" ] && Fln wine64 /usr/bin/wine
	Fwinercd
}
