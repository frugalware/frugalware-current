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
# == OPTIONS
# * no options yet
###

## proto ...

## since we need to build first the 32bit version
## we need to save these
__cross32_save_orig_vars() {

	CFLAGS_ORIG="$CFLAGS"
	CXXFLAGS_ORIG="$CXXFLAGS"
	LDFLAGS_ORIG="$LDFLAGS"
	CHOST_ORIG="$CHOST"
	PKGCONFIG_ORIG="$PKG_CONFIG_PATH"
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
	## reset options to default
	Fconfopts=""
}


## unset all defaults
__cross32_unset_vars() {
	## common
	unset CFLAGS CXXFLAGS CHOST PKG_CONFIG_PATH

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
	export CPPFLAGS=" -I/usr/${CHOST}/inlcude"
	export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"

	## cmake.sh
	export CMAKE_LIB="lib32"
	export CMAKE_BIN="lib32/${CHOST}/bin"
	export CMAKE_SBIN="lib32/${CHOST}/sbin"

	## util.sh
	export Fbuildchost="${CHOST}"

	## ./configure ..
	Fconfopts+=" \
		--bindir=/usr/${CHOST}/bin \
		--sbindir=/usr/${CHOST}/sbin \
		--includedir=/usr/${CHOST}/inlcude \
		--libexecdir=/usr/${CHOST}/${pkgname} \
		--libdir=/usr/lib32 pkgconfigdir=/usr/lib32/pkgconfig"

}


## these don't need be packaged
## maybe etc but this need  discuss
__cross32_delete_files() {

	Fmessage "Removing no needed files for 32bit packages"
        Frm usr/share/{man,info,doc}
        Frm etc
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
}

__cross32_bug_me_reset() {

	Fmessage "Setting up ENV for 64bit tool chain:"
        msg2 "CFLAGS to $CFLAGS"
        msg2 "CXXFLAGS to $CXXFLAGS"
        msg2 "LDFLAGS to $LDFLAGS"
        msg2 "CHOST to $CHOST"
        msg2 "CC to $CC"
        msg2 "CXX to $CXX"
}

Fcross32_prepare() {

        __cross32_save_orig_vars
        __cross32_unset_vars
        __cross32_set_vars
	__cross32_bug_me_set
}


Fcross32_reset_and_fix() {

	__cross32_export_orig_vars
	__cross32_bug_me_reset
	__cross32_delete_files

}

__cross32_delete_empty() {

	Fmessage "Removing empty dir"
        find $Fdestdir -type d -empty -exec rmdir -v  {} +
}

Fcross32_delete_empty() {
	__cross32_delete_empty
}

__cross32_common_build() {
	Fcross32_prepare
	Fbuild
	make distclean
	Fcross32_reset_and_fix
}

Fcross32_common_build() {
	__cross32_common_build
}


## don't remove
unset build

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
		Fmessage "Auto building ${pkgname}32 subpackage"
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
