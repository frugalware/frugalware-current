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
if [ "$xorgtag" == "1" ]; then
	up2date="lynx -dump $dlurl | grep ]$name|sed -n -e 's/.*$name-X11R$xorgver-\(.*\)\.tar\.bz2.*/\1/' -e '1 p'"
else
	up2date="lynx -dump $dlurl | grep ]$name|sed -n -e 's/.*$name-\(.*\)\.tar\.bz2.*/\1/' -e '1 p'"
fi
if [ "$xorgtag" == "1" ]; then
	source=($dlurl/$name-X11R$xorgver-$pkgver.tar.bz2)
else
	source=($dlurl/$name-$pkgver.tar.bz2)
fi
license="GPL2"
unset realname

Fcd() {
	if [ "$Fsrcdir" = `pwd` ]; then
		if [ "$#" -eq 1 ]; then
			Fmessage "Going to the source directory..."
			cd "$Fsrcdir/$1" || Fdie
		elif [ "$#" -eq 0 ]; then
			if [ "$xorgtag" == "1" ]; then
				Fcd "$name-X11R$xorgver-$pkgver$pkgextraver"
			else
				Fcd "$name-$pkgver$pkgextraver"
			fi
		fi
	fi
}
unset xorgtag
