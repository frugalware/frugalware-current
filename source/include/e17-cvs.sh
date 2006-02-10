#!/bin/sh

# (c) 2005 Andras Voroskoi <voroskoi@frugalware.org>
# e17-cvs.sh for Frugalware
# distributed under GPL License

url="www.get-e.org/"
source=($pkgname-$pkgver.tar.gz)
up2date="lynx -dump http://frugalware.org/~voroskoi/e17.up2date |sed -n '1 p'"

build() {
	Fcd $pkgname
	export NOCONFIGURE="yes"
	./autogen.sh || Fdie
	Fbuild
}
