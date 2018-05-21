#!/bin/sh

###
# = cross32.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# cross32.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for 32bit cross compiled packages.
#
# == EXAMPLE
#
# --------------------------------------------------
# pkgname=libxau
# _F_xorg_name=libXau
# pkgver=1.0.8
# pkgrel=4
# pkgdesc="X.Org Xau library"
# url="http://xorg.freedesktop.org"
# groups=('x11' 'xorg-core' 'xorg-libs')
# archs=('x86_64')
# depends=('glibc>=2.24-4')
# _F_cross32_simple_auto="yes"
# Finclude xorg cross32
# sha1sums=('d9512d6869e022d4e9c9d33f6d6199eda4ad096b')
# ----------------------------------------------------
#
# == OPTIONS
# * _F_cross32_simple_auto - if set an 32bit subpackage is created.
# This only works for packages without subpackages or build().
# * _F_cross32_simple  - like _F_cross32_simple_auto but need
# _F_cross32_subdepends in addition to work. This is for packages where we cannot guess the depends.
# * _F_cross32_subdepends - set depends() for _F_cross32_simple. Example:
# _F_cross32_subdepends=('foo bar baz')
# * _F_cross32_delete - a list of files or folders to be deleted form 32bit subpackage. Example:
# _F_cross32_delete=('usr/share/myfile' 'usr/lib32/libfoo.so.1')
# * _F_cross32_compiler - set an compiler , defaults to gcc , possible values are gcc or clang for 64bit
# and gcc only for 32bit
# * _F_cross32_use_meson - use meson schema automatically
# * _F_cross32_meson_confopts_64 - use to set extra meson options for 64bit build
# * _F_cross32_meson_confopts_32 - use to set extra meson options for 32bit build
# * _F_cross32_use_cmake - use cmake schema automatically
# * _F_cross32_cmake_confopts_64 - use to set extra cmake options for 64bit build
# * _F_cross32_cmake_confopts_32 - use to set extra cmake options for 32bit build
# * F32confopts - use like Fconfopts ( autotools only )
###

if [ -z "$_F_cross32_compiler" ]; then
	_F_cross32_compiler="gcc"
fi

if [ -z "$_F_cross32_new_path" ]; then
	_F_cross32_combined="yes"
fi

if [ -n "$_F_cross32_use_meson" ]; then
	_F_meson_is_cross32="yes"
	Finclude meson
fi

if [ -n "$_F_cross32_use_cmake" ]; then
	Finclude cmake
fi

## FIXME
if [ -n "$_F_cross32_use_meson" ] && [ -n "$_F_cross32_use_cmake" ]; then
	Fmessage "ERROR: you cannot set cmake and meson.."
	Fdie
fi

if [ -z "$_F_cross32_use_meson" ] && [ -z "$_F_cross32_use_cmake" ]; then
	_F_cross32_use_default="yes"
fi

case "$_F_cross32_compiler" in
gcc)
	_F_cross32_cc="gcc"
	_F_cross32_cxx="g++"
	;;
clang)
	## TODO: add extra flags for clang
	_F_cross32_cc="clang"
	_F_cross32_cxx="clang++"
	makedepends+=('clang')
	;;
*)
	Fmessage "Unknow compiler , cannot continue.."
	exit 1
	;;
esac

## since we need to build first the 32bit version
## we need to save these
__cross32_save_orig_vars() {


	CFLAGS_ORIG="$CFLAGS"
	CXXFLAGS_ORIG="$CXXFLAGS"
	LDFLAGS_ORIG="$LDFLAGS"
	CHOST_ORIG="$CHOST"
	if [ -n "$_F_cross32_combined" ]; then
		PKGCONFIG_ORIG="$PKG_CONFIG_PATH"
	fi
	PATH_ORIG="$PATH"
	ASFLAGS_ORIG="$ASFLAGS"

	CC_ORIG="$_F_cross32_cc"
	CXX_ORIG="$_F_cross32_cxx"

	CROSS_PREFIX_ORIG="$CROSS_PREFIX"
	CROSS_INC_ORIG="$CROSS_INC"
	CROSS_LIB_ORIG="$CROSS_LIB"
	CROSS_BIN_ORIG="$CROSS_BIN"
	CROSS_SBIN_ORIG="$CROSS_SBIN"
}


## reset to default $CARCH
__cross32_export_orig_vars() {

	export CFLAGS="$CFLAGS_ORIG"
	export CXXFLAGS="$CXXFLAGS_ORIG"
	export LDFLAGS="$LDFLAGS_ORIG"
	export CHOST="$CHOST_ORIG"
	export Fbuildchost="$CHOST_ORIG"

	export CC="$CC_ORIG"
	export CXX="$CXX_ORIG"

	if [ -n "$_F_cross32_combined" ]; then
		export PKG_CONFIG_PATH="$PKGCONFIG_ORIG"
	else
		unset PKG_CONFIG_LIBDIR
	fi
	## reset CPP
	unset CPPFLAGS
	## reset PATH
	export PATH="$PATH_ORIG"

	## reset ASFLAGS
	export ASFLAGS="$ASFLAGS_ORIG"

	# CROSS_XXX stuff
	export CROSS_PREFIX="$CROSS_PREFIX_ORIG"
	export CROSS_INC="$CROSS_INC_ORIG"
	export CROSS_LIB="$CROSS_LIB_ORIG"
	export CROSS_BIN="$CROSS_BIN_ORIG"
	export CROSS_SBIN="$CROSS_SBIN_ORIG"

}


## unset all defaults
__cross32_unset_vars() {
	## common
	unset CFLAGS CXXFLAGS CHOST PKG_CONFIG_PATH PATH

	## cmake.sh , meson.sh
	unset CROSS_LIB CROSS_BIN CROSS_SBIN CROSS_PREFIX CROSS_INC

	## util.sh
	unset Fbuildchost
}


## set up tc32
__cross32_set_vars() {


	## util.sh
	export CHOST="i686-frugalware-linux"
	export Fbuildchost="${CHOST}"

	## cmake.sh , meson.sh
	export CROSS_PREFIX="/usr"
	export CROSS_INC="${CROSS_PREFIX}/${CHOST}/include"
	export CROSS_LIB="lib32"
	export CROSS_BIN="${CROSS_PREFIX}/${CHOST}/bin"
	export CROSS_SBIN="${CROSS_PREFIX}/${CHOST}/sbin"

	## common
	export CFLAGS=" -m32 ${CFLAGS_ORIG/x86-64/i686}"
	export CXXFLAGS=" -m32 ${CXXFLAGS_ORIG/x86-64/i686}"
	## clang is broken for 32bit , force gcc
	export CC="gcc"
	export CXX="g++"
	LDFLAGS+=" -L${CROSS_PREFIX}/${CROSS_LIB} -m32"
	export CPPFLAGS=" -I${CROSS_INC}"
	if [ -n "$_F_cross32_combined" ]; then
		export PKG_CONFIG_PATH="${CROSS_PREFIX}/${CROSS_LIB}/pkgconfig"
	else
		export PKG_CONFIG_LIBDIR="${CROSS_PREFIX}/${CROSS_LIB}/pkgconfig"
	fi
	export ASFLAGS="--32"

	## we share some tools like tools for building docs
	## shell scripts and such .. for that matter we need
	## orig system PATH + 32bit PATH but put 32bit first

	export PATH=/usr/${CHOST}/bin:usr/${CHOST}/sbin:$PATH_ORIG

	## auto tools - default
	if [ -n "$_F_cross32_use_default" ]; then
		if [ -z "$_F_conf_configure" ]; then
			_F_conf_configure="./configure"
		fi

		F32bindir="/usr/${CHOST}/bin"
		F32sbindir="/usr/${CHOST}/sbin"
		F32includedir="/usr/${CHOST}/include"
		F32libdir="/usr/lib32"
		F32libexecdir="/usr/${CHOST}/${pkgname}"

		Fconfoptstryset "bindir" "$F32bindir"
		Fconfoptstryset "sbindir" "$F32sbindir"
		Fconfoptstryset "libdir" "$F32libdir"
		Fconfoptstryset "includedir" "$F32includedir"
		Fconfoptstryset "libexecdir" "$F32libexecdir"
	fi

}


## these don't need be packaged
## maybe etc but this need  discuss
__cross32_delete_files() {


	Fmessage "Removing no needed files for 32bit packages"
        Frm usr/share/{man,aclocal,info,doc,locale}
        Frm etc


	if [ -n "$_F_cross32_delete" ]; then
		local i
		for i in "${_F_cross32_delete[@]}"
		do
			Frm "$i"
		done
	fi

}


__cross32_bug_me_set() {

	Fmessage "Setting up ENV for 32bit tool chain:"
	msg2 "CFLAGS to $CFLAGS"
	msg2 "CXXFLAGS to $CXXFLAGS"
	msg2 "LDFLAGS to $LDFLAGS"
	msg2 "CHOST to $CHOST"
	msg2 "CC to $CC"
	msg2 "CXX to $CXX"
	msg2 "CPPFLAGS to $CPPFLAGS"
	msg2 "PKG_CONFIG_PATH to $PKG_CONFIG_PATH"
	msg2 "PATH to $PATH"
	msg2 "CROSS_PREFIX to $CROSS_PREFIX"
	msg2 "CROSS_LIB to $CROSS_LIB"
	msg2 "CROSS_BIN to $CROSS_BIN"
	msg2 "CROSS_SBIN to $CROSS_SBIN"
	msg2 "CROSS_INC to $CROSS_INC"
}

__cross32_bug_me_reset() {

	Fmessage "Setting up ENV for 64bit tool chain:"
	msg2 "CFLAGS to $CFLAGS"
	msg2 "CXXFLAGS to $CXXFLAGS"
	msg2 "LDFLAGS to $LDFLAGS"
	msg2 "CHOST to $CHOST"
	msg2 "CC to $CC"
	msg2 "CXX to $CXX"
	msg2 "PATH to $PATH"
	msg2 "CROSS_PREFIX to $CROSS_PREFIX"
	msg2 "CROSS_LIB to $CROSS_LIB"
	msg2 "CROSS_BIN to $CROSS_BIN"
	msg2 "CROSS_SBIN to $CROSS_SBIN"
	msg2 "CROSS_INC to $CROSS_INC"
}

__cross32_conf_make_opts_pre_save() {

	## autotools only..
	if [ -n "$_F_cross32_use_default" ]; then
		## this is ..
		F_CONFOPTS="$Fconfopts"
		if [ -n "$_F32_make_opts" ]; then
			FMAKEOPTS="$_F_make_opts"
			_F_make_opts=""
		else
			_F32_make_opts="$_F_make_opts"
		fi
	fi
}

__cross32_conf_make_opts_reset() {

	## autotools only
	if [ -n "$_F_cross32_use_default" ]; then
		Fconfopts=""
		if [ -n "$_F32_make_opts" ]; then
			_F_make_opts="$FMAKEOPTS"
		fi
		Fconfopts+=" $F_CONFOPTS"
	fi

}

Fcross32_prepare() {


	__cross32_conf_make_opts_pre_save
        __cross32_save_orig_vars
        __cross32_unset_vars
        __cross32_set_vars
        __cross32_bug_me_set
}

Fcross32_reset_and_fix() {

	__cross32_unset_vars
	__cross32_export_orig_vars
	__cross32_bug_me_reset
	__cross32_delete_files
	__cross32_conf_make_opts_reset

}

__cross32_delete_empty() {

	Fmessage "Removing empty dir(s)"
        find $Fdestdir -type d -empty -exec rmdir -v  {} +
}

Fcross32_delete_empty() {
	__cross32_delete_empty
}


Fcross32_copy_source() {

	# sf.net broken , util.sh broken , github.sh broken etc
	if [ -n "$_F_cd_path" ]; then
		local src="$_F_cd_path"
	else
	     ## assume $pkgname-$pkgver$pkgextraver
		local src="$pkgname-$pkgver$pkgextraver"
	fi
	Fexec cd $Fsrcdir || Fdie
	## copy to something unique
	Fexec cp -Ra "$src" "${src}-cross32-source-copy" || Fdie
	Fcd
}

Fcross32_copy_back_source() {

	Fexec cd $Fsrcdir || Fdie
	## _F_cd_path bug....
	local move=$(basename *-cross32-source-copy)
        Fexec rm -rf "./${move/-cross32-source-copy}" || Fdie
        Fexec mv "${move}" "${move/-cross32-source-copy}" || Fdie
	Fcd
}

__cross32_common_build() {

	Fcross32_prepare
	Fcross32_copy_source

	if [ -n "$_F_cross32_use_default" ]; then
		Fbuild $F32confopts $_F32_make_opts
	elif [ -n "$_F_cross32_use_meson" ]; then
		if [ -n "$_F_cross32_meson_confopts_32" ]; then
			_F_meson_confopts="$_F_cross32_meson_confopts_32"
		fi
		Meson_build
		## zero _F_meson_confopts
		_F_meson_confopts=""
	elif [ -n "$_F_cross32_use_cmake" ]; then
		if [ -n "$_F_cross32_cmake_confopts_32" ]; then
			_F_cmake_confopts="$_F_cross32_cmake_confopts_32"
		fi
		CMake_build
		## zero _F_cmake_confopts
		_F_cmake_confopts=""
	fi

	## HACK2
	Fcross32_copy_back_source
	Fcross32_reset_and_fix

}

__cross32_64bit_build() {

	if [ -n "$_F_cross32_use_default" ]; then
		Fbuild
	elif [ -n "$_F_cross32_use_meson" ]; then
		if [ -n "$_F_cross32_meson_confopts_64" ]; then
			_F_meson_confopts="$_F_cross32_meson_confopts_64"
		fi
		Meson_build
		_F_meson_confopts=""
	elif [ -n "$_F_cross32_use_cmake" ]; then
		if [ -n "$_F_cross32_cmake_confopts_64" ]; then
			_F_cmake_confopts="$_F_cross32_cmake_confopts_64"
		fi
		CMake_build
		_F_cmake_confopts=""
	fi
}

Fcross32_64bit_build() {
	__cross32_64bit_build
}

Fcross32_common_build() {
	__cross32_common_build
}

Fbuild_no_patch() {

	Fmake "$@"
	Fmakeinstall
}

## don't remove
unset build

if [ -n "$_F_cross32_simple_auto" ]; then

	_F_cross32_simple="yes"
	_F_cross32_subdepends=(${depends[@]/#/lib32-})
fi

## simple build foo with foo32 subpackage
## don't use this with things have more subs..
if [ -n "$_F_cross32_simple" ]; then
	if [ -z "$_F_cross32_subdepends" ]; then
		error "You need _F_cross32_subdepends=('depends_here') to be set"
		error "Fix your package!.."
		exit 1
	else
		subpkgs=("lib32-${pkgname}")
		subdescs=("$pkgdesc ( 32bit )")
		subdepends=("${_F_cross32_subdepends[*]}")
		subgroups=('lib32-extra')
		subarchs=('x86_64')
		suboptions=('force')
	fi
fi

Fbuild_cross32() {

	Fcd
	if [ -z "$_F_cross32_simple" ]; then

		Fcross32_common_build ## 32bit
		Fcross32_delete_empty
		## 64bit
		Fcross32_64bit_build

	else
		## with subpackge
		Fmessage "Auto building lib32-${pkgname} subpackage"
		Fcross32_common_build ## 32bit
		Fcross32_delete_empty
		Fsplit "${subpkgs[0]}" /\* ## everything else ignored only first one
		## 64bit
		Fcross32_64bit_build

	fi

}

build() {
	Fbuild_cross32
}

## EOF
