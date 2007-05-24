#!/bin/sh

###
# = kde.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# kde.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for KDE packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=kdegames
# pkgver=3.5.6
# pkgrel=1
# pkgdesc="Games for KDE."
# groups=('kde')
# archs=('i686' 'x86_64')
# depends=('kdebase>=3.5.6' 'dbus>=0.93')
# makedepends=('doxygen' 'qt-docs')
# Finclude kde
# sha1sums=('1848b81f890180b130000dd6004009d4acc98f48')
# --------------------------------------------------
#
# == OPTIONS
# * _F_kde_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_kde_build_debug (default: 0): enable debug support
# * _F_kde_reconf (default: 0): run KDE's autoreconf
# * _F_kde_split_docs (default: 0) split documentation
# * _F_kde_defaults (default: 1): Don't overwrite url, up2date and source().
# They are for 'kde core' and conflicts with other schemas, so that this way
# you can disable them.
# * _F_kde_do_not_compile: don't compile some subdir
# * _F_kde_id: overwrite url and up2date for kde-apps.org
# * _F_kde_id2: overwrite url and up2date for kde-look.org
###

if [ -z "$_F_kde_name" ]; then
        _F_kde_name=$pkgname
fi
if [ -z "$_F_kde_build_debug" ]; then
        _F_kde_build_debug=0
fi
if [ -z "$_F_kde_reconf" ]; then
        _F_kde_reconf=0
fi
if [ -z "$_F_kde_split_docs" ]; then
        _F_kde_split_docs=0
fi
if [ -z "$_F_kde_defaults" ]; then
	_F_kde_defaults=1
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * _F_kde_ver
# * up2date
# * source
# * _F_cd_path (if not set)
###
## TODO: add mirror option
if [ "$_F_kde_defaults" -eq 1 ]; then
	url="http://www.kde.org"
	_F_kde_ver=3.5.7
	pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$_F_kde_ver/src"
	up2date="lynx -dump http://www.kde.org/download/|grep '$_F_kde_name'|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
	source=($pkgurl/$_F_kde_name-$pkgver.tar.bz2)
fi
if [ -z "$_F_cd_path" ]; then
        _F_cd_path=$_F_kde_name-$pkgver
fi

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
# qt's post_install is essential for kde pkgs
options=(${options[@]} 'scriptlet')
## If someone want to work on this /etc move here is a way to do it. Just add ${kde_config} to Fconfopts
## !!!BIG FAT WARNING!!!: THE WHOLE KDE AND _EVERY DAMN KDE_APP NEED BE REBUILD WITH THIS_.
##			  KDE{APPS} NEED BE FORCED TO USE THIS BY DEFAULT
## 			  !!! DO NOT EVER REMOVE THIS FROM DEFAULTS ONCE IS ADDED OR KDE BREAKS !!!

#kde_config="kde_confdir=/etc/kde3/config \
#            kde_kcfgdir=/etc/kde3/config.kcfg"

###
# * Fconfopts
###
Fconfopts="$Fconfopts \
                --disable-dependency-tracking \
                --with-gnu-ld \
                --enable-gcc-hidden-visibility \
                --enable-new-ldflags \
		--disable-final"

if [ "$_F_kde_build_debug" -eq 1 ]; then
        Fconfopts="$Fconfopts --enable-debug --with-debug"
else
        Fconfopts="$Fconfopts --disable-debug --without-debug"
fi

## Things for kde apps

if [ ! -z "$_F_kde_id" ]; then
        url="http://www.kde-apps.org/content/show.php?content=$_F_kde_id"
        up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi

if [ ! -z "$_F_kde_id2" ]; then
        url="http://www.kde-look.org/content/show.php?content=$_F_kde_id2"
        up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi

###
# == PROVIDED FUNCTIONS
# * Fbuild_kde_reconf(): run KDE's autoreconf
###
Fbuild_kde_reconf()
{
        if [ "$_F_kde_reconf" -eq 1 ]; then
                Fcd
                Fpatchall
                make -f admin/Makefile.common cvs || Fdie
        fi
}

###
# * Fbuild_kde_split_docs(): splits KDE documentation if requested
###
Fbuild_kde_split_docs()
{
        if [ "$_F_kde_split_docs" -eq 1 ]; then
                Fsplit $_F_kde_name-docs usr/share/doc
        fi
}


###
# * Fbuild_kde()
###
Fbuild_kde()
{

	if [  "$_F_kde_reconf" -eq 1 ]; then
		Fbuild_kde_reconf
		Fconf \
		DO_NOT_COMPILE="$_F_kde_do_not_compile"
		make || Fdie
		Fmakeinstall
	else
		Fbuild \
		DO_NOT_COMPILE="$_F_kde_do_not_compile"
	fi
	Fbuild_kde_split_docs
}


###
# * build(): just calls Fbuild_kde()
###
build()
{
        Fbuild_kde
}

