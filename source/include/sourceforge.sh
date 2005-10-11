#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# sourceforge.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical sf project

url="http://sourceforge.net/projects/$pkgname"
up2date="lynx -dump $url |grep -1 Version|sed -n -e 's/.*]\([0-9\.]*\) [A-Z].*/\1/' -e '3 p'"
source=(http://dl.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.gz)
