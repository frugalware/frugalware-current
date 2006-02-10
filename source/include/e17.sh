#!/bin/sh

# (c) 2006 Andras Voroskoi <voroskoi@frugalware.org>
# e17.sh for Frugalware
# distributed under GPL License

url="http://enlightenment.freedesktop.org/"
source=($url/files/$pkgname-$pkgver.tar.gz)
up2date="lynx -dump $url |grep =$pkgname |sed 's/.*-\(.*\).tar.*/\1/'"
