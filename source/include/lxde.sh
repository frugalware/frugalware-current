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
# pkgdesc="library creating and utilizing caches to speed up the manipulation for freedesktop.org defined application menus"
# depends=('glib2')
# makedepends=('intltool')
# options=('scriptlet')
# groups=('xlib-extra')
# archs=('i686' 'x86_64' 'ppc')
# Finclude lxde
# sha1sums=('1c92ae19326a18ca9ce588704a5d8e746a8ec244')
# --------------------------------------------------
#
# == OPTIONS
# * _Fuse_gtk3 build package with gtk3 support
# _Fuse_gtk3="n" for disable gtk3 support
###

if [ -z "$_Fuse_gtk3" ]; then
	Fconfopts="${Fconfopts[@]} --enable-gtk3"
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
# * url
###

_F_sourceforge_dirname="lxde"
_F_sourceforge_rss_limit=300
Finclude sourceforge
url="http://lxde.org/"

###
# == APPENDED VARIABLES
# * lxde-desktop to groups()
###
groups=(${groups[@]} 'lxde-desktop')
archs=('i686' 'x86_64' 'ppc')
pkgrel=1
