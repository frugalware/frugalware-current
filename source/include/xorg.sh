#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# xorg.sh for Frugalware
# distributed under GPL License

# common url, up2date, source() and license for xorg packages

if ! [ -z "$realname" ]; then
	_F_xorg_name=$realname
else
	_F_xorg_name=$pkgname
fi

xorgver="7.0"
url="http://xorg.freedesktop.org"
_F_xorg_dir=`echo ${groups[$((${#groups[@]}-1))]}|sed 's/xorg-\(.*\)/\1/;s/s$//'`
[ "$pkgname" = "xorg-server" ] && _F_xorg_dir="xserver"
dlurl="$url/releases/individual/$_F_xorg_dir/"
up2date="lynx -dump $dlurl | grep $_F_xorg_name-[0-9].*bz2$|sed -n 's/.*$_F_xorg_name-\(.*\)\.t.*/\1/;$ p'"
source=($dlurl/$_F_xorg_name-$pkgver.tar.bz2)
license="GPL2"
unset realname _F_xorg_dir _F_xorg_name
