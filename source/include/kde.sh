#!/bin/sh

Finclude cmake kde-version

###
# = kde.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org> and Michel Hermier <hermier@frugalware.org>
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
	_F_kde_ver="$_F_kdever_ver"
	if [ "$_F_kde_project" = "frameworks" ]; then
		_F_kde_ver="${_F_kdever_frameworks}.${_F_kdever_frameworks_revision}"
	fi
fi

if [ -z "$_F_kde_qtver" ]; then
	_F_kde_qtver="$_F_kdever_qt"
	if [ "$_F_kde_project" = "frameworks" ]; then
		_F_kde_qtver="$_F_kdever_qt5"
	fi
fi

if [ -z "$_F_kde_name" ]; then
        _F_kde_name=$pkgname
	if [ "$_F_kde_project" = "frameworks" -a "${pkgname: -1}" = "5" ]; then
		_F_kde_name="${pkgname%?}"
	fi
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
	_F_kde_mirror="https://kde.cu.be"
	#_F_kde_mirror="ftp://ftp.kde.org/pub/kde"
fi

if [ -z "$_F_kde_folder" ]; then
	if [ -z "$_F_kde_unstable" ]; then
		_F_kde_folder="stable/$_F_kde_project"
	else
		_F_kde_folder="unstable/$_F_kde_project"
	fi
fi

if [ -z "$_F_kde_dirname" ]; then
	_F_kde_dirname="$_F_kde_folder/$_F_kde_pkgver/src"
	if [ "$_F_kde_project" = "frameworks" ]; then
		_F_kde_dirname="$_F_kde_folder/$_F_kdever_frameworks"
	fi
fi

if [ -n "$_F_kde_final" ]; then
	_F_cmake_confopts="$_F_cmake_confopts -DKDE4_ENABLE_FINAL=$_F_kde_final"
fi

if [ -z "$_F_kde_defaults" ]; then
	_F_kde_defaults=1
fi

if [ -z "$_F_kde_ext" ]; then
	_F_kde_ext=".tar.xz"
fi

###
# == OVERWRITTEN VARIABLES
# * _F_archive_name (default to $_F_kde_name if not set)
# * pkgver (default to $_F_kde_ver if not set)
# * url (if not set)
# * up2date (if not set)
# * source (if empty)
# * sha1sums (if sources is empty)
# * _F_cd_path (if not set)
# * makedepends (if not set)
###

if [ -z "$_F_archive_name" ]; then
	_F_archive_name="$_F_kde_name"
fi

if [ -z "$pkgver" ]; then
	pkgver="$_F_kde_pkgver"
fi

if [ -z "$url" ]; then
	url="http://www.kde.org"
fi

if [ "$_F_kde_defaults" -eq 1 ]; then
	if [ -z "$up2date" ]; then
		if [ -z "$_F_kde_project" ]; then
			up2date="Flasttar $_F_kde_mirror/$_F_kde_folder/\$(Flastverdir $_F_kde_mirror/$_F_kde_folder)/src"
		else
			up2date="Flasttar $_F_kde_mirror/$_F_kde_folder/\$(Flastverdir $_F_kde_mirror/$_F_kde_folder)"
		fi
	fi

	if [ ${#source[@]} -eq 0 ]; then
		source=("$_F_kde_mirror/$_F_kde_dirname/$_F_kde_name-${_F_kde_pkgver}${_F_kde_ext}")
		if [ -n "${_F_kdever_sha1sums["$_F_kde_name"]}" ]; then
			sha1sums=("${_F_kdever_sha1sums["$_F_kde_name"]}")
		fi
	fi
fi


if [ -z "$_F_cd_path" ]; then
	_F_cd_path=$_F_kde_name-$_F_kde_pkgver
fi

if [ -n "$_F_kde_id" ]; then
	url="http://www.kde-apps.org/content/show.php?content=$_F_kde_id"
	up2date="lynx -dump "$url"|grep -v http|grep  -m1 ' \{6\}[0-9.0-9.0-9]'|sed 's/ \+\([0-9.]*\).*/\1/'"
	_F_kde_defaults=0
fi

if [ -n "$_F_kde_id2" ]; then
	url="http://www.kde-look.org/content/show.php?content=$_F_kde_id2"
	up2date="lynx -dump "$url"|grep -v http|grep  -m1 ' \{6\}[0-9.0-9.0-9]'|sed 's/ \+\([0-9.]*\).*/\1/'"
	_F_kde_defaults=0
fi

###
# == APPENDED VARIABLES
# makedepends: if kde4 append automoc4 unless building it, if kf5 append some other deps.
# _F_cmake_confopts: append some kde specific options.
###
if [ -z "$_F_kde_old_defines" ]; then
	_F_cmake_old_defines=0
else
	_F_cmake_old_defines="$_F_kde_old_defines"
fi

if [ "$_F_kde_project" = "frameworks" ]; then
	if [ "$_F_kde_name" != 'extra-cmake-modules' ]; then
		makedepends=("${makedepends[@]}" 'extra-cmake-modules' 'libqt5imageformats' 'libqt5platformsupport' 'libqt5quick')
	fi
else
	if [ "$_F_kde_name" != 'automoc4' ]; then
		makedepends=("${makedepends[@]}" 'automoc4')
	fi
fi

case "$_F_cmake_type" in
None)	_F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -DNDEBUG -DQT_NO_DEBUG";;
Debug*)	_F_KDE_CXX_FLAGS="$_F_KDE_CXX_FLAGS -ggdb3";;
esac

_F_KDE_LD_FLAGS="-Wl,--no-undefined -Wl,--as-needed"

if [ -z "$_F_kde_project" ]; then
	_F_cmake_confopts="$_F_cmake_confopts \
		-DCONFIG_INSTALL_DIR=/etc/kde/config \
		-DKCFG_INSTALL_DIR=/etc/kde/config.kcfg \
		-DICON_INSTALL_DIR=/usr/share/kde/icons \
		-DKDE_DISTRIBUTION_TEXT='Frugalware Linux'"
else
	_F_cmake_confopts="$_F_cmake_confopts \
		-DCONFIG_INSTALL_DIR=/etc/kde5/config \
		-DKCFG_INSTALL_DIR=/etc/kde5/config.kcfg \
		-DICON_INSTALL_DIR=/usr/share/kde5/icons \
		-DKDE_DISTRIBUTION_TEXT='Frugalware Linux'"
fi

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
	if __kde_in_array "$pkgname-docs" "${subpkgs[@]}"; then
		Fmessage "FOUND $pkgname-docs: package will be automagically built!!"
	fi

	if __kde_in_array "$pkgname-compiletime" "${subpkgs[@]}"; then
		Fmessage "FOUND $pkgname-compiletime: package will be automagically built!!"
	fi

	## TODO: add check for missing $CARCH in subarchs ( porting / splitting issues )
}

###
# == PROVIDED FUNCTIONS
# * KDE_cleanup: Remove duplicates in Fdestdir from all the subpkgs
###
KDE_cleanup()
{
	Fcleandestdir "${subpkgs[@]}"
}

###
# * KDE_path_install: Install the content of a path if it exist. Parameters: 1)
# Path to install.
###
KDE_path_install()
{
	Fmessage "Installing files from path $1."
	make -C "$1" DESTDIR="$Fdestdir" install || Fdie
}

###
# * KDE_project_install: Install a specific package. Parameters: 1) Name of the
# project. 2) path of the project (optional).
###
__KDE_project_install()
{
	local fail=1 path="${2:-$1}"
	local -a paths
	paths=(
		"$path"
		"apps/$path"
		"apps/lib/$path"
		"experimental/$path"	# for kdebase-runtime
		"filters/$path"		# for koffice
		"interfaces/$path"	# for kdelibs
		"lib/$path"
		"libs/$path"
	)

	for path in "${paths[@]}"; do
		Fmessage "Installing project $1 ($path) ???"
		if [ -d "$path" ]; then
			Fmessage "Installing project $1 ($path)"
			KDE_path_install "$path"
			fail=0
		fi
	done

	## install the documentation
	if __kde_in_array "$pkgname-docs" "${subpkgs[@]}"; then
		# documentation is in $pkgname-docs so ...
		if [ -d "$Fdestdir/usr/share/doc" ]; then
#			Fsplit "$pkgname-docs" usr/share/doc
			Frm usr/share/doc
		fi
	else
		# documentation is per package so ...
		paths=(
			"doc/$1"
			"apps/doc/$1"
		)

		for path in "${paths[@]}"; do
			if [ -d "$path" ]; then #  does the package has docs ?
				Fmessage "Installing project $1 documentation"
				KDE_path_install "$path"
			fi
		done
	fi
	return $fail
}

KDE_project_install()
{
	## we use for weird or not logical names
	## $pkgname-<the_weird_name>
	local path="${2:-$1}"
	local clean="$(eval "echo -n \"\${path/#$pkgname-/}"\")" # Remove front "$pkgname-"
	if [ "$path" != "$clean" ] && \
	   KDE_project_install "$1" "$clean"; then
		return 0
	fi

	if __KDE_project_install "$1" "${path}"; then
		return 0
	fi
	if __KDE_project_install "$1" "${path//-//}"; then # Transform "-" into "/"
		return 0
	fi

	clean="${path/#lib/}" # Remove front "lib"
	if [ "$path" != "$clean" ] && \
	   KDE_project_install "$1" "$clean"; then
		return 0
	fi

	return 1
}

###
# * KDE_project_split(): Moves a KDE project to a subpackage. Parameters:
# 1) name of the subpackage 2) Name of the project (see KDE_project_install).
# Example: KDE_project_split kopete-irc kopete/protocols/irc
###

KDE_project_split()
{
	KDE_project_install "$1" "$2"
	KDE_cleanup
	Fsplit "$1" /\*
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

###
# * KDE_split(): Moves the _F_kde_subpkgs name list to subpackages. Parameters:
# None. To find the projects dir, front "$pkgname-" and '-' are changed in '/'
# to _F_kde_subpkgs names. That way one can produce subpackage for a
# subdirectory project. Example: "kdelibs-kioslave-ftp" would search for
# kioslave/ftp project subdir.
###
KDE_split()
{
	local i
	## let's try that way
	for i in "${_F_kde_subpkgs[@]}"
	do
		## Shall we add something more generic some _ignore= ?
		## but for that we need some hacks in makepkg I guess
		case "$i" in
		"$pkgname-docs"| \
		"$pkgname-compiletime")
			Fmessage "Ignoring $i KDE_install() will take care.."
			continue
		esac

		Fmessage "Splitting $i"
		if KDE_project_install "$i"; then
			KDE_cleanup
			Fsplit "$i" /\*
		else
			Fmessage "Could not find $i for automagic _F_kde_subpkgs splitting !!"
			Fdie
		fi
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

KDE_install()
{
	make DESTDIR="$Fdestdir" install || Fdie

	KDE_cleanup

	if __kde_in_array "$pkgname-docs" "${subpkgs[@]}" && [ -d $Fdestdir/usr/share/doc ]; then
          	Fsplit "$pkgname-docs" usr/share/doc
        fi

	if __kde_in_array "$pkgname-compiletime" "${subpkgs[@]}"; then
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
	KDE_make_split "$@"
	KDE_install
}

###
# build: just calls Fbuild_KDE
###
build()
{
	KDE_build
}

