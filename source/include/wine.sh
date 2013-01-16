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
	_geckover=1.7
	conflicts=('wine')
	sha1sums=('a8c67336b4a0ca39a57e98fc67f89871484ab528')
	case "$CARCH" in
		"i686") sha1sums=("${sha1sums[@]}" 'efebc4ed7a86708e2dc8581033a3c5d6effe0b0b');;
		"x86_64") sha1sums=("${sha1sums[@]}" '2253e7ce3a699ddd110c6c9ce4c7ca7e6f7c02f5');;
	esac
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac

[ "$CARCH" == "x86_64" ] && Fconfopts="--enable-win64"

source=(http://downloads.sourceforge.net/wine/{wine-$pkgver.tar.bz2,wine_gecko-$_geckover-${CARCH/i686/x86}.msi})

build()
{
	Fbuild
	Ffile /usr/share/wine/gecko/`basename ${source[1]}`
	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
	[ "$CARCH" == "x86_64" ] && Fln wine64 /usr/bin/wine
}
