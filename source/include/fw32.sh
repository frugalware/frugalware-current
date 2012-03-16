#!/bin/sh

###
# = skel.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# fw32.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for fw32 packages.
#
# == EXAMPLE
# _F_fw32_name=glibc
# pkgver=2.14.1
# pkgrel=2
# depends=()
# Finclude fw32
# sha1sums=('cc13a8bd231af3f9ef2baacee7751de9360bc755')
# == OPTIONS
# * _F_fw32_name (required): specify the pkgname of the i686 package to
# repackage
###
if [ -z "$_F_fw32_name" ]; then
	error "_F_fw32_name must be specified."
	Fdie
fi

###
# == OVERWRITTEN VARIABLES
# * pkgname
# * pkgdesc
# * groups()
# * archs()
# * url
# * up2date
# * source()
# * options()
###
_url="http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-i686"
_dir='/usr/lib/fw32-simple'
_fw32_up2date()
{
	local _ver
	_ver=$(curl -s "$_url/" | sed -n "s|^.*$_F_fw32_name-\([^-]\+\)-\([0-9]\+\)-.*\$|\1-\2|p" | tail -n 1)
	if [ "$_ver" == "$pkgver-$pkgrel" ]; then
		echo $pkgver
	else
		echo $_ver
	fi

}
pkgname="fw32-$_F_fw32_name"
pkgdesc="32 bit chroot package for $_F_fw32_name."
groups=('fw32-extra')
archs=('!i686' 'x86_64' '!arm')
url="http://frugalware.org"
up2date="eval _fw32_up2date"
source=($_url/$_F_fw32_name-$pkgver-$pkgrel-i686.fpm)
options=('nomirror' 'nostrip')

build()
{
	Fmkdir $_dir
	Fexec tar -xp -C $Fdestdir$_dir -f `basename ${source[0]}`
	# Remove headers, man, info, doc.
	# Also, remove KDE/GTK icon themes, GTK themes, and fonts.
	Frm $_dir/usr/{include,share/{doc,man,info,themes,fonts,icons,kde}}
	# Delete pkgconfig files.
	Frm /usr/lib/pkgconfig
	# Delete etc config
	Frm $_dir/etc
	# Remove pacman-g2 files.
	Frm "$_dir/.[A-Z]*"
	# Remove static libraries & libtool stuff.
	for i in `find $Fdestdir$_dir -name "*.a" -or -name "*.la"`; do
		Frm ${i/$Fdestdir/}
	done
}
