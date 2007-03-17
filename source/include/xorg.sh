#!/bin/sh

###
# = xorg.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# xorg.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for X.Org packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=xf86-video-ark
# pkgver=0.6.0
# pkgrel=1
# pkgdesc="X.Org driver for ark cards"
# url="http://xorg.freedesktop.org"
# groups=('x11' 'xorg-core' 'xorg-drivers')
# archs=('i686' 'x86_64')
# depends=('xorg-server')
# makedepends=('xproto' 'randrproto' 'renderproto')
# _F_xorg_nr=1
# Finclude xorg
# sha1sums=('349572d92ca6cd2c8f370105c4bffc70b7034bf3')
# --------------------------------------------------
#
# == OPTIONS
# * _F_xorg_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_xorg_nr: X, where the xorg version of the package is 7.X (choose the
# largest possible, sometimes packages are not available in the latest
# directory)
###
if [ -z "$_F_xorg_name" ]; then
	_F_xorg_name=$pkgname
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
# * license()
# * _F_cd_path (if not set)
#
# Additionally, if the pkgname starts with xf86-input-, then
# * pkgrel (if not set)
# * pkgdesc
# * groups()
# * archs()
# * depends()
# * makedepends()
###
if [[ $pkgname =~ ^xf86-input- ]]; then
	[ -z "$pkgrel" ] && pkgrel=1
	pkgdesc="X.Org driver for ${pkgname#xf86-input-} input devices"
	groups=('x11' 'xorg-core' 'xorg-drivers')
	archs=('i686' 'x86_64')
	depends=('xorg-server')
	makedepends=('inputproto' 'randrproto')
fi
url="http://xorg.freedesktop.org"
if [ -n "$_F_xorg_nr" ]; then
	_F_xorg_release_dir="X11R7.2/src"
else
	_F_xorg_release_dir="individual"
fi
_F_xorg_dir=`echo ${groups[$((${#groups[@]}-1))]}|sed 's/xorg-\(.*\)/\1/;s/s$//'`
_F_xorg_version="X11R7."
[ "$_F_xorg_name" = "xorg-server" ] && _F_xorg_dir="xserver"
_F_xorg_url="$url/releases/$_F_xorg_release_dir/$_F_xorg_dir/"
license="GPL2"
if [ -n "$_F_xorg_nr" ]; then
	up2date="lynx -dump $_F_xorg_url | grep '$_F_xorg_name-${_F_xorg_version}$_F_xorg_nr-\(.*\).tar.bz2'|sed -n 's/.*$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-\(.*\)\.t.*/\1/;$ p'"
	source=($_F_xorg_url/$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-$pkgver.tar.bz2)
	if [ -z "$_F_cd_path" ]; then
		_F_cd_path="$_F_xorg_name-$_F_xorg_version$_F_xorg_nr-$pkgver"
	fi
else
	up2date="lynx -dump $_F_xorg_url | grep '$_F_xorg_name-\(.*\).tar.bz2'|sed -n 's/.*$_F_xorg_name-\(.*\)\.t.*/\1/;$ p'"
	source=($_F_xorg_url/$_F_xorg_name-$pkgver.tar.bz2)
	if [ -z "$_F_cd_path" ]; then
		_F_cd_path="$_F_xorg_name-$pkgver"
	fi
fi
