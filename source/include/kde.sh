#!/bin/sh

Finclude cmake

###
# = kde.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
# Michel Hermier <hermier@frugalware.org>
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
# pkgver=3.95.2
# pkgrel=1
# pkgdesc="Games for KDE."
# groups=('kde')
# archs=('i686' 'x86_64')
# depends=('kdebase')
# Finclude kde
# sha1sums=('1848b81f890180b130000dd6004009d4acc98f48')
# --------------------------------------------------
#
# == OPTIONS
# * _F_kde_ver (defaults to the current KDE version)
# * _F_kde_qtver (defaults to the qt version required to build the current version)
# * _F_kde_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_kde_pkgver (defaults to $pkgver or to $_F_kde_ver if empty): the version of the package
# used to construct the source.
# * _F_kde_subpkgs (no defaults): Special array for splitting packages automatically.
# * _F_kde_final (no defaults): Enable finalisation of binaries (Optimize more)
# Use project default since it is an optimisation not allways tested/available by upstream.
###

if [ -z "$_F_kde_ver" ]; then
	_F_kde_ver=4.3.5
fi

if [ -z "$_F_kde_qtver" ]; then
	_F_kde_qtver=4.6.0
fi

if [ -z "$_F_kde_name" ]; then
        _F_kde_name=$pkgname
fi

if [ -z "$_F_kde_pkgver" ]; then
	if [ -z "$pkgver" ]; then
		_F_kde_pkgver="$_F_kde_ver"
	else
		_F_kde_pkgver="$pkgver"
	fi
fi

if [ -z "$_F_kde_mirror" ]; then
	# set our preferred mirror
	#_F_kde_mirror="http://kde-mirror.freenux.org"
	_F_kde_mirror="ftp://ftp.kde.org/pub/kde"
fi

if [ -z "$_F_kde_dirname" ]; then
	_F_kde_dirname="stable/$_F_kde_ver/src"
fi

if [ -n "$_F_kde_final" ]; then
	_F_cmake_confopts="$_F_cmake_confopts -DKDE4_ENABLE_FINAL=$_F_kde_final"
fi

###
# == OVERWRITTEN VARIABLES
# * _F_archive_name (default to $_F_kde_name if not set)
# * pkgver (default to $_F_kde_ver if not set)
# * url (if not set)
# * up2date (if not set)
# * source (if empty)
# * _F_cd_path (if not set)
# * makedepends (if not set)
###

if [ -z "$_F_archive_name" ]; then
	_F_archive_name="$_F_kde_name"
fi

if [ -z "$pkgver" ]; then
	pkgver="$_F_kde_ver"
fi

if [ -z "$url" ]; then
	url="http://www.kde.org"
fi

if [ -z "$up2date" ]; then
	up2date="Flasttar http://kde.org/download/"
fi

if [ ${#source[@]} -eq 0 ]; then
	source=("$_F_kde_mirror/$_F_kde_dirname/$_F_kde_name-$_F_kde_pkgver.tar.bz2")
fi

if [ -z "$_F_cd_path" ]; then
        _F_cd_path=$_F_kde_name-$_F_kde_pkgver
fi

###
# == APPENDED VARIABLES
# makedepends: append automoc4 unless building it.
# _F_cmake_confopts: append some kde specific options.
###
if [ "$_F_kde_name" != 'automoc4' ]; then
	makedepends=("${makedepends[@]}" 'automoc4')
fi

case "$_F_cmake_type" in
None)	_F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -DNDEBUG -DQT_NO_DEBUG";;
Debug*)	_F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -ggdb3";;
esac

## REMOVE: KDE4_USE_ALWAYS... option changed since 4.2*
## think about CMAKE_SKIP_RPATH for 4.4
_F_cmake_confopts="$_F_cmake_confopts \
		-DCONFIG_INSTALL_DIR=/etc/kde/config \
		-DKCFG_INSTALL_DIR=/etc/kde/config.kcfg \
		-DICON_INSTALL_DIR=/usr/share/kde/icons \
		-DKDE_DISTRIBUTION_TEXT='Frugalware Linux'"


###
# == PROVIDED FUNCTIONS
# * KDE_project_install: Install a specific package. Parameters: 1) Name of the
# project (Must also be the name of a directory).
###
KDE_project_install()
{
	## What is that ?
	## - usually an 'normal' named 'project' looks like this:
	## - 'foo' , 'doc/foo' and maybe 'doc/kcontrol/foo'
	## These can be installed auto magically.

	# figure whatever it has docs
	# TODO: add 'kcontrol' check ?!
	if [ -d "doc" ]; then # does a doc folder exists ?
		if [ -d "doc/$1" ]; then #  does the package has docs ?
			Fmessage "Installing docs from TOP_SRC dir for $1."
			## install docs
			make -C "doc/$1" DESTDIR="$Fdestdir" install || Fdie
		fi
	elif [ -d "apps/doc" ]; then ## kdebase
		if [ -d "apps/doc/$1" ]; then #  does the package has docs ?
			Fmessage "Installing docs from apps/ dir for $1."
			make -C "apps/doc/$1" DESTDIR="$Fdestdir" install || Fdie
		fi
	fi

	if [ -d "filters" ]; then # Koffice
		if [ -d "filters/$1" ]; then
			Fmessage "Installing filters from filters/ dir for $1."
			make -C "filters/$1" DESTDIR="$Fdestdir" install || Fdie
		fi
	fi
	## install the package
	make -C "$1" DESTDIR="$Fdestdir" install || Fdie
}

###
# * KDE_project_split(): Moves a KDE project to a subpackage. Parameters:
# 1) name of the subpackage 2) Name of the project (see KDE_project_install).
# Example: KDE_project_split kopete-irc kopete/protocols/irc
###

KDE_project_split()
{
	KDE_project_install "$2"
	Fsplit "$1" /\*
}

###
# * KDE_split(): Moves the _F_kde_subpkgs name list to subpackages. Parameters:
# None. To find the projects dir, front "$pkgname-" and '-' are changed in '/'
# to _F_kde_subpkgs names. That way one can produce subpackage for a
# subdirectory project. Example: "kdelibs-kioslave-ftp" would search for
# kioslave/ftp project subdir.
###



__KDE_split() # internal and should be extended to handle all kind paths
{
	## we use for weird or not logical names
        ## $pkgname-<the_weird_name>
	clean=$(eval "echo \"\${i/#$pkgname-/}\"") # Remove front "$pkgname-"
	if [ ! -d "$clean" ]; then
		clean="${clean//-//}" # Transform "-" into "/"
	fi


	## we have such packages should be called lib<something> but upstream
	## has the name without the lib .. try to figure that ..

	if [ "`echo $clean | grep ^lib`" ]; then ## just lib<something> and not something<lib>
		cleanlib=$(echo $clean | sed 's/lib//g')
	fi
        ## check whatever that project exists
	if [ -d "$clean" ]; then
		## split it
		Fmessage "Found Kde-Project "$clean" in TOP_SRC dir.. Splitting.."
		KDE_project_split "$i" "$clean"
	elif [ -d "apps/$clean" ]; then ## kdebase again
		Fmessage "Found Kde-Project "$clean" in apps/ dir.. Splitting.."
		KDE_project_split "$i" "apps/$clean"
	elif [ -d "libs/$clean" ]; then
		Fmessage "Found Kde-Project "$clean" in libs/ dir.. Splitting."
		KDE_project_split "$i" "libs/$clean"
	elif [ -d "libs/$cleanlib" ]; then
		Fmessage "Found Kde-Project "$cleanlib" ( subpkg_name lib$cleanlib ) in libs/ dir.. Splitting."
		KDE_project_split "$i" "libs/$cleanlib"
	elif [ -d "apps/lib/$clean" ]; then ## kdebase ;)
		Fmessage "Found Kde-Project "$clean" in apps/lib/ dir.. Splitting."
		KDE_project_split "$i" "apps/lib/$clean"
	elif [ -d "apps/lib/$cleanlib" ]; then
		Fmessage "Found Kde-Project "$cleanlib" ( subpkg_name lib$cleanlib ) in apps/lib/ dir.. Splitting."
		KDE_project_split "$i" "apps/lib/$cleanlib"
	else ## TODO: Add apps/*/<something> checks , maybe more paths ?
		if [ -z "$_F_kde_subpkgs_custom_path" ]; then
			Fmessage "Could not find $clean!! Maybe is not in the TOP_SRC or libs dir? Or Typo?"
                	Fdie
		else
			Fmessage "Could not find $clean but _F_kde_subpkgs_custom_path is set!"
			Fmessage "Won't die() here, assuming build() will handle this package!..."
		fi
	fi
}

KDE_split()
{
	local i clean
	## let's try that way
	for i in "${_F_kde_subpkgs[@]}"
	do
		## Shall we add something more generic some _ignore= ?
		## but for that we need some hacks in makepkg I guess
		if [ "$i" == "$pkgname-docs" ]; then
			Fmessage "Ignoring $pkgname-docs KDE_install() will take care.."
			continue
		fi
		__KDE_split
	done
}

KDE_export_flags()
{
	export CFLAGS="$CFLAGS -fno-strict-aliasing $_F_KDE_CXX_FLAGS"
	export CXXFLAGS="$CXXFLAGS -fno-strict-aliasing $_F_KDE_CXX_FLAGS"
}

KDE_make()
{
	KDE_export_flags
	CMake_make "$@"
}



KDE_make_split()
{
	KDE_make "$@"
	KDE_split
}

KDE_cleanup()
{
	Fcleandestdir "${_F_kde_subpkgs[@]}"
	Fcleandestdir "${subpkgs[@]}"
}

KDE_install()
{
	make DESTDIR="$Fdestdir" install || Fdie
	KDE_cleanup
	if [ "$_F_kde_split_docs" == 1 ]; then
          Fsplit "$pkgname-docs" /usr/share/doc/HTML
        fi

}


KDE_build()
{
	KDE_make_split
	KDE_install
}

###
# build: just calls Fbuild_KDE
###
build()
{
	KDE_build
}

