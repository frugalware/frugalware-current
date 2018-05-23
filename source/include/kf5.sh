#!/bin/sh

Finclude cmake kf5-version

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
# archs=('x86_64')
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
	elif [ "$_F_kde_project" = "plasma" ]; then
		_F_kde_ver="$_F_kdever_plasma"
	elif [ "$_F_kde_project" = "applications" ]; then
		_F_kde_ver="$_F_kdever_apps"
	fi
fi

## TMP set to unstable
#if [ "$_F_kde_project" = "applications" ]; then
#	_F_kde_unstable="yes"
#fi

if [ -z "$_F_kde_qtver" ]; then
	_F_kde_qtver="$_F_kdever_qt5"
fi

if [ -z "$_F_kde_name" ]; then
        _F_kde_name=$pkgname
	if [ -n "$_F_kde_project" -a "${pkgname: -1}" = "5" ]; then
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
	_F_kde_mirror="http://ftp.rz.uni-wuerzburg.de/ftp/MIRROR/kde/"
	 _F_kde_up2date_mirror="ftp://ftp5.gwdg.de/pub/linux/kde/"
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
	if [ "$_F_kde_project" = "plasma" ]; then
		_F_kde_dirname="$_F_kde_folder/$_F_kdever_plasma"
	fi
	if [ "$_F_kde_project" = "frameworks" ]; then
		_F_kde_dirname="$_F_kde_folder/$_F_kdever_frameworks"
	fi
	if [ "$_F_kde_project" = "applications" ]; then
		 _F_kde_dirname="$_F_kde_folder/$_F_kdever_apps/src"
	fi
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


if [ -z "$groups" ]; then
	if [ "$_F_kde_project" = "plasma" ]; then
		groups+=('plasma')
	elif [ "$_F_kde_project" = "frameworks" ]; then
		groups+=('kf5')
	elif [ "$_F_kde_project" = "applications" ]; then
		groups+=('kde5')
	fi
fi

if [ "$_F_kde_defaults" -eq 1 ]; then
	if [ -z "$up2date" ]; then
		makedepends+=('rsync')
		#up2date="rsync -r -n  rsync://mirror.netcologne.de/kde/$_F_kde_folder | Flasttar"
		up2date="rsync -r -n rsync://ftp.rz.uni-wuerzburg.de/ftp/MIRROR/kde/$_F_kde_folder | Flasttar"
	fi

	if [ ${#source[@]} -eq 0 ]; then
		source=("$_F_kde_mirror/$_F_kde_dirname/$_F_kde_name-${_F_kde_pkgver}${_F_kde_ext}")
	fi
fi


if [ -z "$_F_cd_path" ]; then
	_F_cd_path=$_F_kde_name-$_F_kde_pkgver
fi


## X11/mesa changes
makedepends+=('x11-protos')

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

if [ "$_F_kde_name" != 'extra-cmake-modules' ]; then
	makedepends+=("extra-cmake-modules>=$_F_kf5_full" "qt5-tools>=$_F_kdever_qt5" 'gperf')
fi

## From gcc6 docs
## Value range propagation now assumes that the this pointer of C++ member functions is non-null. This eliminates common
## null pointer checks but also breaks some non-conforming code-bases (such as Qt-5, Chromium, KDevelop). As a temporary
## work-around -fno-delete-null-pointer-checks can be used. Wrong code can be identified by using -fsanitize=undefined.

_F_KDE_GCC_VER=$(gcc --version | head -n1 | cut -d" " -f4)

case "$_F_KDE_GCC_VER" in
6.*) _F_KDE_CXX_FLAGS_EXTRA+=" -fno-delete-null-pointer-checks";;
7.*) _F_KDE_CXX_FLAGS_EXTRA+=" -fno-delete-null-pointer-checks";;
8.*) _F_KDE_CXX_FLAGS_EXTRA+=" -fno-delete-null-pointer-checks";;
esac

case "$_F_cmake_type" in
None)	_F_KDE_CXX_FLAGS+=" -DNDEBUG -DQT_NO_DEBUG";;
Debug*)	_F_KDE_CXX_FLAGS+=" -O0 -ggdb3 -DDEBUG";;
esac

## to much auto::<...> deprecated messages
_F_KDE_CXX_FLAGS_WARN+=" -Wno-deprecated -Wno-deprecated-declarations"

_F_KDE_LD_FLAGS="-Wl,--no-undefined"

	_F_cmake_confopts="$_F_cmake_confopts \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DKDE_INSTALL_AUTOSTARTDIR=/etc/xdg/autostart \
	-DLIB_INSTALL_DIR=lib \
	-DLIBEXEC_INSTALL_DIR=lib/kf5 \
	-DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
	-DQML_INSTALL_DIR=share/qt5/qml \
	-DBUILD_TESTING=OFF -Wno-dev"

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

	if [[ "$_F_cmake_type" == Debug ]] || [[ "$_F_cmake_type" == DEBUG ]]; then
		unset CFLAGS CXXFLAGS
		options+=('nostrip')
		export CXXFLAGS="$_F_KDE_CXX_FLAGS"
		export CFLAGS="$_F_KDE_CXX_FLAGS"
		export LDFLAGS="$LDFLAGS $_F_KDE_LD_FLAGS"
	else
		export CFLAGS="$CFLAGS $_F_KDE_CXX_FLAGS"
		export CXXFLAGS="$CXXFLAGS  $_F_KDE_CXX_FLAGS"
		export LDFLAGS="$LDFLAGS $_F_KDE_LD_FLAGS"
	fi
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


