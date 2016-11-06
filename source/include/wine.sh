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
depends=('lcms2' 'openal' 'libglu' 'libldap' 'libpcap' 'libpulse' 'libmpg123' 'libgphoto2' 'gettext' \
	'libxcursor' 'libxi' 'libxrandr' 'libxinerama' 'libxcomposite' 'sane-backends' 'v4l-utils' 'libxrender' 'libxslt')
#32 bit
depends+=('lib32-lcms2' 'lib32-libxcursor' 'lib32-libxi' 'lib32-libxrandr' 'lib32-libxinerama' 'lib32-libxcomposite' \
	'lib32-libxrender' 'lib32-libxslt' 'lib32-freetype2')
makedepends=('x11-protos' 'cups')
_F_cd_path="wine-$pkgver"
options=('genscriptlet' 'nostrip')
archs=('x86_64')
_F_conf_configure="../configure"

F32confopts+="	--libdir=/usr/lib32"

Finclude cross32

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="Flasttar https://dl.winehq.org/wine/source/1.8/"
	conflicts=('wine-devel' 'lib32-wine-devel')
	provides=('lib32-wine')
	replaces=('lib32-wine')
	;;

wine-devel)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Development)"
	_F_archive_name="wine"
	up2date="Flasttar https://dl.winehq.org/wine/source/1.9/"
	conflicts=('wine' 'lib32-wine-devel')
	provides=('wine' 'lib32-wine-devel')
	replaces=('lib32-wine-devel')
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac

source=(https://dl.winehq.org/wine/source/${pkgver%.*}/wine-$pkgver.tar.bz2)
signatures=("${source[@]}.sign")

build()
{
	
	Fcd
	Fsed 'lib64' 'lib' configure.ac
	Fautoreconf
	Fexec mkdir 64Bit_build || Fdie
	Fexec cd 64Bit_build || Fdie
	Fmake --enable-win64

	Fexec cd .. || Fdie
	Fexec mkdir 32Bit_build || Fdie
        Fexec cd 32Bit_build || Fdie
        Fcross32_prepare
        
        Fmake --libdir=/usr/lib32 --with-wine64="$Fsrcdir/${_F_cd_path}/64Bit_build" 
        Fmakeinstall  libdir="$Fpkgdir/usr/lib32" dlldir="$Fpkgdir/usr/lib32/wine"
        
        Fexec cd ../64Bit_build || Fdie
        Fmakeinstall  libdir="$Fpkgdir/usr/lib" dlldir="$Fpkgdir/usr/lib/wine"

	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
}
