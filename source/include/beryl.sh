#!/bin/sh

###
# = beryl.sh(3)
# AlexExtreme <alex@alex-smith.me.uk>
#
# == NAME
# beryl.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for beryl packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=beryl-plugins-unsupported
# pkgrel=2
# groups=('x11-extra')
# archs=('i686' 'x86_64')
# Finclude beryl
# depends=("beryl-plugins=$pkgver" 'gtk+2' 'librsvg' 'dbus-glib>=0.71-2')
# makedepends=('intltool' 'perl-xml')
# sha1sums=('7552df78bdeaee2fd601f2b22f21ec34d778113d')
# --------------------------------------------------
#
# == OPTIONS
# * _F_beryl_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
###
if [ -z "$_F_beryl_name" ]; then
	_F_beryl_name=$pkgname
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
pkgver=0.2.1
pkgdesc="Beryl is a compositing window manager which provides lots of fancy effects on your desktop"
url="http://www.beryl-project.org/"
up2date="lynx -dump http://releases.beryl-project.org/current/ | grep $_F_beryl_name | Flasttarbz2"
source=(http://releases.beryl-project.org/$pkgver/$_F_beryl_name-$pkgver.tar.bz2)
_F_cd_path="$_F_beryl_name-$pkgver"

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
