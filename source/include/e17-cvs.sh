#!/bin/sh

# (c) 2005-2006 Andras Voroskoi <voroskoi@frugalware.org>
# e17-cvs.sh for Frugalware
# distributed under GPL License

if [ -z "$_F_e17_name" ]; then
	_F_e17_name=$pkgname
fi

url="www.get-e.org/"
source=(http://ftp.frugalware.org/pub/other/e17/packages/$_F_e17_name/$_F_e17_name-$pkgver.tar.gz)
up2date="lynx -dump http://frugalware.org/~voroskoi/e17.up2date |sed -n '1 p'"

build() {
	Fcd $_F_e17_name
	export NOCONFIGURE="yes"
	./autogen.sh || Fdie
	Fbuild
}
