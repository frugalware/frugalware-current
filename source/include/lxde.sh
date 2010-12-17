#!/bin/sh

###
# = lxde.sh(3)
# bouleetbil <bouleetbil@frogdev.info>
#
# == NAME
# lxde.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for LXDE packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=menu-cache
# pkgver=0.3.2
# pkgrel=1
# pkgdesc="library creating and utilizing caches to speed up the manipulation for freedesktop.org defined application menus"
# depends=('glib2')
# makedepends=('intltool')
# options=('scriptlet')
# groups=('xlib-extra')
# archs=('i686' 'x86_64' 'ppc')
# _F_lxde_sep="%20"
# Finclude lxde
# sha1sums=('1c92ae19326a18ca9ce588704a5d8e746a8ec244')
# --------------------------------------------------
#
# == OPTIONS
# * _F_lxde_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
###

#only use by up2date
if [ -z "$_F_lxde_name" ]; then
	_F_lxde_name=$pkgname
fi
if [ -z "$_F_lxde_dir" ]; then
	_F_lxde_dir=$_F_lxde_name
fi
if [ -z "$_F_lxde_sep" ]; then
	_F_lxde_sep="-"
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
# * url
###

_F_sourceforge_dirname="lxde"
Finclude sourceforge
url="http://lxde.org/"
up2date="lynx -dump http://sourceforge.net/projects/lxde/files/$_F_lxde_dir/ | grep 'http.*lxde/.*$_F_lxde_dir/.*/$' |sed 's|.*/\(.*\)/|\1|;q' | sed 's|${_F_lxde_name}${_F_lxde_sep}||'"

###
# == APPENDED VARIABLES
# * lxde-desktop to groups()
###
groups=(${groups[@]} 'lxde-desktop')
archs=('i686' 'x86_64' 'ppc')
pkgrel=1
