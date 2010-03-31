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
	_F_kde_ver=4.4.1
fi

if [ -z "$_F_kde_qtver" ]; then
	_F_kde_qtver=4.6.2
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

if [ -z "$_F_kde_unstable" ]; then
	_F_kde_folder="stable"
else
	_F_kde_folder="unstable"
fi

if [ -z "$_F_kde_dirname" ]; then
	_F_kde_dirname="$_F_kde_folder/$_F_kde_ver/src"
fi

if [ -n "$_F_kde_final" ]; then
	_F_cmake_confopts="$_F_cmake_confopts -DKDE4_ENABLE_FINAL=$_F_kde_final"
fi

if [ -z "$_F_kde_defaults" ]; then
	_F_kde_defaults=1
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

if [ "$_F_kde_defaults" -eq 1 ]; then
	if [ -z "$up2date" ]; then
		if [ -z "$_F_kde_unstable" ]; then
			up2date="Flasttar http://kde.org/download/"
		else
			up2date=$pkgver
		fi
	fi

	if [ ${#source[@]} -eq 0 ]; then
		source=("$_F_kde_mirror/$_F_kde_dirname/$_F_kde_name-$_F_kde_pkgver.tar.bz2")
	fi
fi


if [ -z "$_F_cd_path" ]; then
        _F_cd_path=$_F_kde_name-$_F_kde_pkgver
fi

if [ -n "$_F_kde_id" ]; then
        url="http://www.kde-apps.org/content/show.php?content=$_F_kde_id"
        up2date="lynx -dump  $url|grep -m1 grep -v http|grep  -m1 '      [0-9.0-9.0-9]'|sed -e 's/^[ \t]*//'"
	_F_kde_no_compiletime=1
	_F_kde_no_auto_docs=1
fi

if [ -n "$_F_kde_id2" ]; then
        url="http://www.kde-look.org/content/show.php?content=$_F_kde_id2"
        up2date="lynx -dump  $url|grep -m1 grep -v http|grep  -m1 '      [0-9.0-9.0-9]'|sed -e 's/^[ \t]*//'"
	_F_kde_no_compiletime=1
        _F_kde_no_auto_docs=1

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

_F_KDE_LD_FLAGS="-Wl,--no-undefined -Wl,--as-needed"

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

# stolen from makepkg ;))
__kde_in_array()
{
        local i
        _package=$1
        shift 1
        # array() undefined
        [ -z "$1" ] && return 1
        for i in "$@"
        do
                [ "$i" == "${_package}" ] && return 0
        done
        return 1
}

__KDE_pre_build_check()
{

	if [ -n "$_F_kde_no_auto_docs" ]; then
		if __kde_in_array "$pkgname-docs" "${subpkgs[@]}"; then ## that is not allowed anymore
			Fmessage "ERROR: You cannot have _F_kde_no_auto_docs AND $pkgname-docs set!!"
                        Fmessage "ERROR: Fix your FrugalBuild.. Bailing out!"
                        Fdie
                fi
	else
		if ! __kde_in_array "$pkgname-docs" "${subpkgs[@]}"; then
			Fmessage "ERROR: Cannot find $pkgname-docs in your subpkgs."
			Fmessage "ERROR: If you don't want any -docs subpkg add _F_kde_no_auto_docs=1 to your FrugalBuild."
			Fmessage "ERROR: Else copy and paste the following to your FrugalBuild:"
				echo 'subpkgs=("${subpkgs[@]}" "$pkgname-docs")'
				echo 'subdescs=("${subdescs[@]}" "$pkgname Documentation")'
				echo 'subdepends=("${subdepends[@]}" "")'
				if [ -n "$subrodepends" ]; then
					echo 'subrodepends=("${subrodepends[@]}" "")'
				fi
				echo 'subgroups=("${subgroups[@]}" "docs-extra kde-docs")'
				echo 'subarchs=("${subarchs[@]}" "i686 x86_64 ppc")'
				Fdie
		fi
	fi

	if [ -n "$_F_kde_no_compiletime" ]; then
		if __kde_in_array "$pkgname-compiletime" "${subpkgs[@]}"; then ## not allowed will produce conflicts / empty packages
			Fmessage "ERROR: You cannot have _F_kde_no_compiletime AND $pkgname-compiletime set!!"
			Fmessage "ERROR: Fix your FrugalBuild.. Bailing out!"
			Fdie
		fi
	else
		if ! __kde_in_array "$pkgname-compiletime" "${subpkgs[@]}"; then
			Fmessage "ERROR: Cannot find $pkgname-compiletime in your subpkgs."
			Fmessage "ERROR: If you don't want -compiletime subpkg add _F_kde_no_compiletime=1 to your FrugalBuild."
			Fmessage "ERROR: Fix your FrugalBuild.. Bailing out!"
			Fdie
		fi
	fi

	## TODO: add check for missing $CARCH in subarchs ( porting / splitting issues )
}


KDE_project_install()
{
	## OK we want the docs to be in one place $pkgname-docs so..
	if [ -n "$_F_kde_no_auto_docs" ]; then ## really do not use for kde<core_modules>
		if [ -d "doc" ]; then # does a doc folder exists ?
			if [ -d "doc/$1" ]; then #  does the package has docs ?
				Fmessage "Installing docs from TOP_SRC dir for $1."
				## install docs
				make -C "doc/$1" DESTDIR="$Fdestdir" install || Fdie
			elif [ -d "apps/doc" ]; then ## kdebase
				if [ -d "apps/doc/$1" ]; then #  does the package has docs ?
					Fmessage "Installing docs from apps/ dir for $1."
					make -C "apps/doc/$1" DESTDIR="$Fdestdir" install || Fdie
				fi
			fi
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

	 if [ -z "$_F_kde_no_auto_docs" ]; then
                Frm usr/share/doc
        fi

}


###
# * KDE_project_split(): Moves a KDE project to a subpackage. Parameters:
# 1) name of the subpackage 2) Name of the project (see KDE_project_install).
# Example: KDE_project_split kopete-irc kopete/protocols/irc
###

__kde_remove_files()
{
	local i j
	[ -z "$1" ] && Fdie
	for i in `find $Fdestdir -name "$1"`
	do
		if [ -f "$i" ]; then
			j=`echo $i|sed 's|.*/pkg/||g'`
		 	Frm $j
		else
			Fdie
		fi
	done
}

__kde_find_split_files()
{

	local i j
	[ -z "$1" ] && Fdie
	[ -z "$2" ] && Fdie
	for i in `find $Fdestdir ! -type d -name "$1" -prune`
	do
		if [ -f "$i" ]; then
			j=`echo $i|sed 's|.*/pkg/||g'`
			Fsplit $2 $j
		else
			Fdie
		fi
	done
}

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
	elif [ -d "$cleanlib" ]; then
		Fmessage "Found Kde-Project "$cleanlib" ( subpkg_name lib$cleanlib ) in TOP_SRC dir.. Splitting.."
		KDE_project_split "$i" "$cleanlib"
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
               elif [ "$i" == "$pkgname-compiletime" ]; then
			Fmessage "Ignoring $pkgname-compiletime KDE_install() will take care.."
			continue
		fi
		__KDE_split
	done
}

KDE_export_flags()
{
	export CFLAGS="$CFLAGS $_F_KDE_CXX_FLAGS"
	export CXXFLAGS="$CXXFLAGS  $_F_KDE_CXX_FLAGS"
	export LDFLAGS="$LDFLAGS $_F_KDE_LD_FLAGS"
}

KDE_make()
{
	KDE_export_flags
	CMake_make "$@"
}


KDE_make_split()
{
## only check on core stuff
if [ "$_F_kde_defaults" -eq 1 ]; then
	__KDE_pre_build_check
fi
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

	if [ -z "$_F_kde_no_auto_docs" ]; then
          	Fsplit "$pkgname-docs" usr/share/doc/HTML
        fi

	KDE_cleanup

	if [ -z "$_F_kde_no_compiletime" ]; then
		if [ -d $Fdestdir/usr/include ]; then
			Fsplit "$pkgname-compiletime" usr/include
		fi
		if [ -d $Fdestdir/usr/share/apps/cmake ]; then
			Fsplit "$pkgname-compiletime" usr/share/apps/cmake
		fi
		__kde_find_split_files "*.cmake" "$pkgname-compiletime"
		__kde_find_split_files "*.pc" "$pkgname-compiletime"
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

