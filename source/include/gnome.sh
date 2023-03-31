#!/bin/sh

###
# = gnome.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# gnome.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for GNOME packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=gtkmm
# pkgver=2.10.7
# pkgrel=1
# pkgdesc="C++ interface for GTK+2"
# url="http://www.gnome.org/"
# depends=('glibmm>=2.13.1' 'gtk+2' 'cairomm>=1.2.2')
# groups=('gnome')
# archs=('x86_64')
# Finclude gnome
# sha1sums=('e40c337bc2afd2de4a6527bf333e9c8788c38668')
# Fconfopts+=" --disable-examples --disable-demos"
# --------------------------------------------------
#
# == OPTIONS
# * _F_gnome_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_gnome_devel: if set, the <number>.<odd> versions will not be ignored.
# This is something you want for packages which are not part of GNOME releases
# (like intltool) and where the <odd> number does not mean instability.
# * _F_gnome_ext (defaults to .tar.bz2): extension of the source tarball
###

if [ -z "$_F_gnome_name" ]; then
	_F_gnome_name=$pkgname
fi

if [ -z "$_F_gnome_devel" ]; then
	_F_gnome_devel="n"
fi

if [ -z "$_F_gnome_git" ]; then
	_F_gnome_git="n"
fi

if [ -z "$_F_gnome_ext" ]; then
	_F_gnome_ext=.tar.bz2
fi

###
# == OVERWRITTEN VARIABLES
# * _F_gnome_pygtkdefsdir
# * _F_gnome_pkgurl
# * up2date
# * source()
# * url
###
_F_gnome_pygtkdefsdir="usr/share/pygtk/2.0/defs"
#_F_gnome_pkgurl="https://download.gnome.org/sources"
_F_gnome_pkgurl="https://ftp.gnome.org/pub/GNOME/sources"
_F_archive_name="$_F_gnome_name"

up2date="Flasttar $_F_gnome_pkgurl/$_F_gnome_name/\$(Flastverdir $_F_gnome_pkgurl/$_F_gnome_name )"

if [ "$_F_gnome_git" != "n" ]; then
	makedepends+=('git')
	Finclude scm
	_F_scm_type="git"
	_F_scm_url="git://git.gnome.org/$_F_gnome_name"
else
	source=(https://download.gnome.org/sources/$_F_gnome_name/${pkgver%.*}/$_F_gnome_name-$pkgver$_F_gnome_ext)
fi
url="http://www.gnome.org/"
_F_cd_path=$_F_gnome_name-$pkgver
makedepends+=('x11-protos' 'python3')
# really no worth to pull per package all are full with warnings
CFLAGS+=" -Wno-deprecated -Wno-deprecated-declarations"
CXXFLAGS+=" -Wno-deprecated -Wno-deprecated-declarations"

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
options+=('scriptlet')
