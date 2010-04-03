#!/bin/sh

###
# = compiz.sh(3)
# Priyank Gosalia <priyankmg@gmail.com>
#
# == NAME
# compiz.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for compiz fusion packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=compiz-plugins-extra
# pkgrel=1
# groups=('x11-extra')
# archs=('i686' 'x86_64')
# Finclude compiz
# depends=("compiz-plugins-main=$pkgver" 'gtk+2' 'librsvg' 'dbus-glib>=0.71-2')
# makedepends=('intltool' 'perl-xml-parser')
# sha1sums=('7552df78bdeaee2fd601f2b22f21ec34d778113d')
# --------------------------------------------------
#
# == OPTIONS
# * _F_compiz_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
#
# * _F_compiz_version (defaults to $pkgver): if you want to use a custom version
# number (for example the upstream package version is 0.1.2) then use this
# to declare the real version
###

compizver=0.8.6

if [ -z "$_F_compiz_name" ]; then
	_F_compiz_name=$pkgname
else # -n $_F_compiz_name
	_F_archive_name=$_F_compiz_name
fi

if [ -z "$_F_compiz_version" ]; then
	_F_compiz_version=$compizver
fi

###
# == OVERWRITTEN VARIABLES
# * pkgver
# * pkgdesc
# * url
# * up2date
# * source()
# * _F_cd_path
###
pkgver=$_F_compiz_version
pkgdesc="Compiz is a compositing window manager using GLX_EXT_texture_from_pixmap"
url="http://www.compiz-fusion.org/"
up2date="lynx -dump http://releases.compiz-fusion.org/$_F_compiz_version/ | grep $_F_compiz_name | Flasttarbz2"
if [ $_F_compiz_name == "compiz" ]; then
	source=(http://releases.compiz-fusion.org/$_F_compiz_version/$_F_compiz_name-$pkgver.tar.bz2)
else
	source=(http://releases.compiz-fusion.org/$_F_compiz_version/$_F_compiz_name-$pkgver.tar.bz2)
fi
_F_cd_path="$_F_compiz_name-$_F_compiz_version"

###
# == APPENDED VARIABLES
# * force to options()
###
options=(${options[@]} 'force')

###
# == UNSET VARIABLES
# * MAKEFLAGS
###
unset MAKEFLAGS
