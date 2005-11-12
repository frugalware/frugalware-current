#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# xorg.sh for Frugalware
# distributed under GPL License

# common url, up2date, source() and license for xorg packages

xorgver="7.0-RC2"
url="http://xorg.freedesktop.org"
dlurl="http://xorg.freedesktop.org/releases/X11R$xorgver/everything/"
up2date="lynx -dump $dlurl | grep ]$pkgname|sed -n -e 's/.*$pkgname-\(.*\)\.tar\.bz2.*/\1/' -e '1 p'"
source=($dlurl/$pkgname-$pkgver.tar.bz2)
license="GPL2"
