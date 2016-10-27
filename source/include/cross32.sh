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
# * F32confopts - use like Fconfopts.
###


## since we need to build first the 32bit version
## we need to save these
__cross32_save_orig_vars() {

	CFLAGS_ORIG="$CFLAGS"
	CXXFLAGS_ORIG="$CXXFLAGS"
	LDFLAGS_ORIG="$LDFLAGS"
	CHOST_ORIG="$CHOST"
	PKGCONFIG_ORIG="$PKG_CONFIG_PATH"
	PATH_ORIG="$PATH"
}


## reset to default $CARCH
__cross32_export_orig_vars() {

	export CFLAGS="$CFLAGS_ORIG"
	export CXXFLAGS="$CXXFLAGS_ORIG"
	export LDFLAGS="$LDFLAGS_ORIG"
	export CHOST="$CHOST_ORIG"
	export Fbuildchost="$CHOST_ORIG"

	export CC="gcc"
	export CXX="g++"

	export PKG_CONFIG_PATH="$PKGCONFIG_ORIG"
	## reset CPP
	unset CPPFLAGS
	## reset PATH
	export PATH="$PATH_ORIG"

}


## unset all defaults
__cross32_unset_vars() {
	## common
	unset CFLAGS CXXFLAGS CHOST PKG_CONFIG_PATH PATH

	## cmake.sh
	unset CMAKE_LIB CMAKE_BIN CMAKE_SBIN

	## util.sh
	unset Fbuildchost
}


## set up tc32
__cross32_set_vars() {

	## common
	export CFLAGS="-march=i686 -mtune=generic -O2 -pipe"
	export CXXFLAGS="-march=i686 -mtune=generic -O2 -pipe"
	export CHOST="i686-frugalware-linux"
	export CC="gcc -m32"
	export CXX="g++ -m32"
	LDFLAGS+=" -L/usr/lib32"
	export CPPFLAGS=" -I/usr/${CHOST}/include"
	export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"

	## we share some tools like tools for building docs
	## shell scripts and such .. for that matter we need
	## orig system PATH + 32bit PATH but put 32bit first

	export PATH=/usr/${CHOST}/bin:usr/${CHOST}/sbin:$PATH_ORIG

	## cmake.sh
	export CMAKE_LIB="lib32"
	export CMAKE_BIN="lib32/${CHOST}/bin"
	export CMAKE_SBIN="lib32/${CHOST}/sbin"

	## util.sh
	export Fbuildchost="${CHOST}"

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


	## ./configure ..
	F32confopts+=" pkgconfigdir=/usr/lib32/pkgconfig"

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
}

Fcross32_prepare() {

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


	## this is ..
	F_CONFOPTS="$Fconfopts"
	if [ -n "$_F32_make_opts" ]; then
		FMAKEOPTS="$_F_make_opts"
		_F_make_opts=""
	else
		_F32_make_opts="$_F_make_opts"
	fi
	Fcross32_prepare
	Fcross32_copy_source
	Fbuild $F32confopts $_F32_make_opts
	## HACK2
	Fcross32_copy_back_source
	Fcross32_reset_and_fix
	Fconfopts=""
	if [ -n "$_F32_make_opts" ]; then
		_F_make_opts="$FMAKEOPTS"
	fi
	Fconfopts+=" $F_CONFOPTS"
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
	fi
fi

Fbuild_cross32() {

	Fcd
	if [ -z "$_F_cross32_simple" ]; then

		Fcross32_common_build ## 32bit
		Fcross32_delete_empty
		Fbuild ## second build 64bit
	else
		## with subpackge
		Fmessage "Auto building lib32-${pkgname} subpackage"
		Fcross32_common_build
		Fcross32_delete_empty
		Fsplit "${subpkgs[0]}" /\* ## everything else ignored only first one
		Fbuild ## 64bit
	fi

}

build() {
	Fbuild_cross32
}

## EOF
