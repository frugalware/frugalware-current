#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# xorg.sh for Frugalware
# distributed under GPL License

# common url, up2date, source() and license for xorg packages

if ! [ -z "$realname" ]; then
    name=$realname
else
    name=$pkgname
fi

xorgver="7.0"
url="http://xorg.freedesktop.org"
dlurl="http://xorg.freedesktop.org/releases/X11R$xorgver/src/everything/"
up2date="lynx -dump $dlurl | grep $name-[0-9].*bz2$|sed 's/.*$name-\(.*\)\.t.*/\1/'"
source=($dlurl/$name-$pkgver.tar.bz2)
license="GPL2"
unset realname
