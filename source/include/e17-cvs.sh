#!/bin/sh

# (c) 2005-2006 Andras Voroskoi <voroskoi@frugalware.org>
# e17-cvs.sh for Frugalware
# distributed under GPL License

if ! [ -z "$realname" ]; then
	name=$realname
else
	name=$pkgname
fi

url="www.get-e.org/"
source=(ftp://ftp.frugalware.org/pub/other/e17/packages/$name/$name-$pkgver.tar.gz)
up2date="lynx -dump http://frugalware.org/~voroskoi/e17.up2date |sed -n '1 p'"

build() {
	Fcd $name
	export NOCONFIGURE="yes"
	./autogen.sh || Fdie
	Fbuild
}
