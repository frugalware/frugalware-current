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
# archs=('i686' 'x86_64')
# Finclude gnome
# sha1sums=('e40c337bc2afd2de4a6527bf333e9c8788c38668')
# Fconfopts="$Fconfopts --disable-examples --disable-demos"
# --------------------------------------------------
#
# == OPTIONS
# * _F_gnome_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_gnome_devel: if set, the unsable version will be used
# NOTE: this is currently enabled by default for -current
###

if [ -z "$_F_gnome_name" ]; then
	_F_gnome_name=$pkgname
fi

if [ -z "$_F_gnome_devel" ]; then
	_F_gnome_devel="n"
fi

# don't document this function, it's used only for source()
_F_gnome_getver()
{
	local tmpver count

	tmpver=`echo $pkgver | tr -d '[0-9][a-z]'`
	count=`expr length "$tmpver"`

	case $count in
	    1)
	    tmpver="$pkgver"
	    ;;
	    2)
	    tmpver="${pkgver%.*}"
	    ;;
	    3)
	    tmpver="${pkgver%.*.*}"
	    ;;
	esac
	echo $tmpver
}

###
# == OVERWRITTEN VARIABLES
# * _F_gnome_pygtkdefsdir
# * _F_gnome_pkgurl
# * up2date
# * source()
# * url
###
_F_gnome_pygtkdefsdir="usr/share/pygtk/2.0/defs"
_F_gnome_pkgurl="http://ftp.gnome.org/pub/GNOME/sources"
if [ "$_F_gnome_devel" != "n" ]; then
	up2date="lynx -dump $_F_gnome_pkgurl/$_F_gnome_name/\$(lynx -dump $_F_gnome_pkgurl/$_F_gnome_name/?C=N\;O=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
else
	up2date="lynx -dump $_F_gnome_pkgurl/$_F_gnome_name/\$(lynx -dump $_F_gnome_pkgurl/$_F_gnome_name/?C=N\;O=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
fi
source=(http://ftp.gnome.org/pub/gnome/sources/$_F_gnome_name/`_F_gnome_getver`/$_F_gnome_name-$pkgver.tar.bz2)
url="http://www.gnome.org/"

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
options=(${options[@]} 'scriptlet')
