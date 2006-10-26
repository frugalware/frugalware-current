#!/bin/sh

# (c) 2003-2006 AlexExtreme <alex@alex-smith.me.uk>
# beryl.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for beryl packages

pkgver=0.1.1
pkgdesc="Beryl is a compositing window manager which provides lots of fancy effects on your desktop"
url="http://forum.beryl-project.org/"
up2date="$pkgver"
srcurl="http://ftp.frugalware.org/pub/other/sources/beryl"
source=($srcurl/$pkgname-$pkgver.tar.bz2 $srcurl/beryl-VERSION-$pkgver)
signatures=($srcurl/$pkgname-$pkgver.tar.bz2.asc $srcurl/beryl-VERSION-$pkgver.asc)
options=(${options[@]} 'force')

Fbuild_beryl() {
	cd $Fsrcdir || Fdie
	cp beryl-VERSION-$pkgver VERSION || Fdie
	Fcd
	./autogen.sh || Fdie
	Fbuild
}

build() {
	Fbuild_beryl
}

unset MAKEFLAGS

# optimization OK
