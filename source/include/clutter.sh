#!/bin/sh

###
# = clutter.sh(3)
# bouleetbil <bouleetbil@frogdev.info>
#
# == NAME
# clutter.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for CLUTTER packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=clutter
# pkgver=1.0.4
# pkgrel=1
# pkgdesc="A GObject based library for creating fast, visually rich graphical user interfaces."
# depends=('libxdamage' 'libxcomposite' 'libgl' 'freetype2' 'libxau>=1.0.4' 'libxdmcp' \
#	'gtk+2>=2.16.2-2' 'libxml2')
# sha1sums=('91476f5c3089bab35dfb1c3a0bc18c44f161b6f0')
# Finclude clutter
# --------------------------------------------------
#
# == OPTIONS
# * _F_clutter_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_clutter_devel: if set, the <number>.<odd> versions will not be ignored.
###

if [ -z "$_F_clutter_name" ]; then
	_F_clutter_name=$pkgname
fi

if [ -z "$_F_clutter_devel" ]; then
	_F_clutter_devel="n"
fi

# don't document this function, it's used only for source()
_F_clutter_getver()
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
# * _F_clutter_pkgurl
# * up2date
# * source()
# * url
# * groups
# * archs
###

_F_clutter_pkgurl="http://www.clutter-project.org/sources/"
if [ "$_F_clutter_devel" != "n" ]; then
	up2date="lynx -dump $_F_clutter_pkgurl/$_F_clutter_name/\$(lynx -dump $_F_clutter_pkgurl/$_F_clutter_name/?M=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
else
	up2date="lynx -dump $_F_clutter_pkgurl/$_F_clutter_name/\$(lynx -dump $_F_clutter_pkgurl/$_F_clutter_name/?M=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
fi
source=(http://www.clutter-project.org/sources/$_F_clutter_name/`_F_clutter_getver`/$_F_clutter_name-$pkgver.tar.bz2)
url="http://www.clutter-project.org/"
groups=('xlib-extra')
archs=('i686' 'x86_64' 'ppc')

###
# == APPENDED VARIABLES
# * scriptlet to options()
# * glproto to makedepends
###
options=(${options[@]} 'scriptlet')
makedepends=(${makedepends[@]} 'glproto')

