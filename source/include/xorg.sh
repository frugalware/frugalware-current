#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# xorg.sh for Frugalware
# distributed under GPL License

# common url, up2date, source() and license for xorg packages
# also sets some defaults for input packages

if [ -z "$_F_xorg_name" ]; then
	_F_xorg_name=$pkgname
fi

if [[ $pkgname =~ ^xf86-input- ]]; then
	[ -z "$pkgrel" ] && pkgrel=1
	pkgdesc="X.Org driver for ${pkgname#xf86-input-} input devices"
	url="http://xorg.freedesktop.org"
	groups=('x11' 'xorg-core' 'xorg-drivers')
	archs=('i686' 'x86_64')
	depends=('xorg-server')
	makedepends=('inputproto' 'randrproto')
fi

url="http://xorg.freedesktop.org"
_F_xorg_dir=`echo ${groups[$((${#groups[@]}-1))]}|sed 's/xorg-\(.*\)/\1/;s/s$//'`
[ "$_F_xorg_name" = "xorg-server" ] && _F_xorg_dir="xserver"
#dlurl="$url/releases/individual/$_F_xorg_dir/"
dlurl="http://xorg.freedesktop.org/archive/development/X11R7.2-RC3/everything/"
up2date="lynx -dump $dlurl | grep $_F_xorg_name-[0-9].*bz2$|sed -n 's/.*$_F_xorg_name-\(.*\)\.t.*/\1/;$ p'"
source=($dlurl/$_F_xorg_name-$pkgver.tar.bz2)
license="GPL2"
