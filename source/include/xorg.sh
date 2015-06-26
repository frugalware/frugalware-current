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
# Finclude xorg
# sha1sums=('349572d92ca6cd2c8f370105c4bffc70b7034bf3')
# --------------------------------------------------
#
# == OPTIONS
# * _F_xorg_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_xorg_ind (defaults to ""): if set, use the individual folder, not the
# release one
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
	depends=('xorg-server>=1.17.1')
fi
url="http://xorg.freedesktop.org"

# set individual to be 1 , released xorg is crap at the moment , no way to get something
# usable from there.
_F_xorg_ind=1

if [ "$_F_xorg_ind" -eq 1 ]; then
	_F_xorg_release_dir="individual"
else
	_F_xorg_release_dir="X11R7.3/src"
fi

_F_xorg_dir=`echo ${groups[$((${#groups[@]}-1))]}|sed 's/xorg-\(.*\)/\1/;s/s$//'`
_F_xorg_version="X11R7."
[ "$_F_xorg_name" = "xorg-server" ] && _F_xorg_dir="xserver"
_F_xorg_url="$url/releases/$_F_xorg_release_dir/$_F_xorg_dir/"
license="GPL2"
_F_archive_name="$_F_xorg_name"
up2date="Flasttar $_F_xorg_url"
source=($_F_xorg_url/$_F_xorg_name-$pkgver.tar.bz2)
if [ -z "$_F_cd_path" ]; then
	_F_cd_path="$_F_xorg_name-$pkgver"
fi
