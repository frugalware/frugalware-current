#!/bin/sh

# (c) 2003-2006 AlexExtreme <alex@alex-smith.me.uk>
# beryl.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for beryl packages

pkgver=20061003
pkgdesc="Beryl is a compositing window manager which provides lots of fancy effects on your desktop"
url="http://forum.beryl-project.org/"
up2date="$pkgver"
srcurl="http://ftp.frugalware.org/pub/other/sources/beryl"
source=($srcurl/$pkgname-$pkgver.tar.bz2 $srcurl/beryl-VERSION-$pkgver)
srcsha1=`lynx -dump $srcurl/$pkgname-$pkgver.tar.bz2.sha1sum | sed 's/ .*//g'`
versha1=`lynx -dump $srcurl/beryl-VERSION-$pkgver.sha1sum | sed 's/ .*//g'`
sha1sums=($srcsha1 $versha1)

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

# optimization OK
