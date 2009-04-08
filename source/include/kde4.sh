#!/bin/sh

Finclude cmake

###
# = kde4.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# kde4.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for KDE4 packages.
#
# == INFO
# * KDE4 is not ready until version 4.1.X , therefor 'current'
# * won't see any KDE4 packages till then.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=kdegames
# pkgver=3.95.2
# pkgrel=1
# pkgdesc="Games for KDE."
# groups=('kde')
# archs=('i686' 'x86_64')
# depends=('kdebase')
# Finclude kde4
# sha1sums=('1848b81f890180b130000dd6004009d4acc98f48')
# --------------------------------------------------
#
# == OPTIONS
# * _F_kde4_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_kde4_defaults (default: 1): Don't overwrite url, up2date and source().
# They are for 'kde core' and conflicts with other schemas, so that this way
# you can disable them.
# * _F_cmakekde_final (default: TRUE):
# * _F_kde4_subpkgs (no defaults): Special array for splitting packages automatically.
###

if [ -n "$_F_cmake_type" ] && [ "$_F_cmake_type" = "None" ]; then
	_F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -DNDEBUG -DQT_NO_DEBUG"
fi

if [ -n "$_F_cmake_type" ] && [ "$_F_cmake_type" = "Debug" ]; then
        _F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -ggdb3"
	options=("${options[@]}" "nostrip")
fi

if [ -z "$_F_cmakekde_final" ]; then
        _F_cmakekde_final="FALSE"
fi

if [ -z "$_F_kde4_name" ]; then
        _F_kde4_name=$pkgname
fi

if [ -z "$_F_kde4_defaults" ]; then
        _F_kde4_defaults=1
fi

if [ "$pkgname" = "kdelibs" ]; then
	makedepends=("${makedepends[@]}")
else
	makedepends=("${makedepends[@]}" 'kdelibs-compiletime')
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * _F_cd_path (if not set)
###

if [ -z "$_F_cd_path" ]; then
        _F_cd_path=$_F_kde4_name-$pkgver
fi

if [ "$_F_kde4_defaults" -eq 1 ]; then
        url="http://www.kde.org"
        _F_kde4_ver=4.2.2
        up2date="$pkgver"
fi

_F_cmake_confopts="$_F_cmake_confopts \
		-DCONFIG_INSTALL_DIR=/etc/kde4/config \
		-DKCFG_INSTALL_DIR=/etc/kde4/config.kcfg \
		-DICON_INSTALL_DIR=/usr/share/kde4/icons \
		-DKDE4_USE_ALWAYS_FULL_RPATH=ON \
		-DKDE4_ENABLE_FINAL=$_F_cmakekde_final \
		-DKDE_DISTRIBUTION_TEXT='Frugalware Linux'"

kde4_install()
{
	## What is that ?
	## - usually an 'normal' named 'project' looks like this:
	## - 'foo' , 'doc/foo' and maybe 'doc/kcontrol/foo'
	## These can be installed auto magically.

	# figure whatever it has docs
	# TODO: add 'kcontrol' check ?!
	if [ -d "doc" ]; then # does a doc folder exists ?
		if [ -d "doc/$1" ]; then #  does the package has docs ?
			Fmessage "Installing docs for $1."
			## install docs
			make -C "doc/$1" DESTDIR=$Fdestdir  install || Fdie
		fi
	fi
	## install the package
	make -C "$1" DESTDIR=$Fdestdir  install || Fdie
}

kde4_split()
{
	kde4_install "$1"
	## figure whatever we have /etc
	if [ -d "$startdir/pkg/etc" ]; then
		Fsplit "$2" /usr /etc
	else
		Fsplit "$2" /usr
	fi
}


CMakeKDE_split()
{

	local i
	local clean

	## let's try that way
	for i in ${_F_kde4_subpkgs[@]}
	do
		## we use for weird or not logical names
		## $pkgname-<the_weird_name>
		clean=$(echo $i|sed 's/.*-//1') # foo-blah -> blah

		## check whatever that project exists
		if [ -d "$clean" ]; then
			## split it
			kde4_split "$clean" "$i"
		else
			Fmessage "Aieee project $clean does NOT exists, don't know how to install and split :/ ( Typo? )"
			Fdie
		fi

	done
}

CMakeKDE_export_flags()
{
	export CFLAGS="$CFLAGS -fno-strict-aliasing $_F_KDE_CXX_FLAGS"
        export CXXFLAGS="$CXXFLAGS -fno-strict-aliasing $_F_KDE_CXX_FLAGS"
}


CMakeKDE_make()
{
	CMakeKDE_export_flags
	CMake_prepare_build
	CMake_conf
	## do _not_ use any F* stuff here , cmake does not like it
	make || Fdie
}

CMakeKDE_build()
{

	CMakeKDE_make
	make DESTDIR=$Fdestdir install || Fdie
}


build()
{
	CMakeKDE_build
}

