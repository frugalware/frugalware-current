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
## :FIXME: do it better
_F_xorg_release_dir="X11R7.2/src"
_F_xorg_dir=`echo ${groups[$((${#groups[@]}-1))]}|sed 's/xorg-\(.*\)/\1/;s/s$//'`
_F_xorg_version="X11R7."
[ "$_F_xorg_name" = "xorg-server" ] && _F_xorg_dir="xserver"
dlurl="$url/releases/$_F_xorg_release_dir/$_F_xorg_dir/"

## this checks for 0 , 1 , 2 so on next Xorg release we need change to <= 3 and so on - crazy -
#for (( i=0; $i <= 2; i++ ))
#do
#      if lynx -dump $dlurl|grep -o "$_F_xorg_name-${_F_xorg_version}${i}-\(.*\).tar.bz2" >/dev/null; then
#        _F_xorg_nr=$i
#       fi
#done

up2date="lynx -dump $dlurl | grep '$_F_xorg_name-${_F_xorg_version}$_F_xorg_nr-\(.*\).tar.bz2'|sed -n 's/.*$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-\(.*\)\.t.*/\1/;$ p'"
source=($dlurl/$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-$pkgver.tar.bz2)
license="GPL2"

if [ -z "$_F_cd_path" ]; then
	_F_cd_path="$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-$pkgver"
fi
