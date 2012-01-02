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
	'sane-backends' 'libcups'
	)
makedepends=('cups')
[ "$pkgname" == "wine" ] && install="$pkgname.install"
_F_cd_path="wine-$pkgver"
options=('genscriptlet')

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="lynx -dump $url | sed -n 's|^.*Stable:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
	_geckover=1.0.0
	_geckoext=cab
	archs=('i686' '!x86_64')
	conflicts=('wine-devel')
	sha1sums=('072184c492cc9d137138407732de3bb62ba6c091' 'afa22c52bca4ca77dcb9edb3c9936eb23793de01')
	;;

wine-devel)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Development)"
	up2date="lynx -dump $url | sed -n 's|^.*Development:.*Wine \([0-9a-zA-Z.]\+\).*\$|\1|p'"
	_geckover=1.4
	_geckoext=msi
	archs=('i686' 'x86_64')
	conflicts=('wine')
	depends=("${depends[@]}" 'gst-plugins-base')
	makedepends=("${makedepends[@]}" 'oss-libs')
	sha1sums=('6ad7d18063fea0fdeb2caf20a21ae53ffba13f24')
	case "$CARCH" in
		"i686") sha1sums=("${sha1sums[@]}" 'c30aa99621e98336eb4b7e2074118b8af8ea2ad5');;
		"x86_64") sha1sums=("${sha1sums[@]}" 'bf0aaf56a8cf9abd75be02b56b05e5c4e9a4df93');;
	esac
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac

[ "$CARCH" == "x86_64" ] && Fconfopts="--enable-win64"

source=(http://downloads.sourceforge.net/wine/{wine-$pkgver.tar.bz2,wine_gecko-$_geckover-${CARCH/i686/x86}.$_geckoext})

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
