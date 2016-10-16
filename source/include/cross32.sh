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
__cross_save_orig_vars() {
	CFLAGS_ORIG="$CFLAGS"
	CXXFLAGS_ORIG="$CXXFLAGS"
	LDFLAGS_ORIG="$LDFLAGS"
	CHOST_ORIG="$CHOST"
}


## reset to default $CARCH
__cross_export_orig_vars() {

	export CFLAGS="$CFLAGS_ORIG"
	export CXXFLAGS="$CXXFLAGS_ORIG"
	export LDFLAGS="$LDFLAGS_ORIG"
	export CHOST="$CHOST_ORIG"
	export Fbuildchost="$CHOST_ORIG"

	export CC="gcc"
	export CXX="g++"

	## reset CPP
	unset CPPFLAGS
	## reset options to default
	Fconfopts=""
}


## unset all defaults
__cross_unset_vars() {
	## common
	unset CFLAGS CXXFLAGS CHOST

	## cmake.sh
	unset CMAKE_LIB CMAKE_BIN CMAKE_SBIN

	## util.sh
	unset Fbuildchost
}


## set up tc32
__cross_set_vars() {

	## common
	export CFLAGS="-march=i686 -mtune=generic -O2 -pipe"
	export CXXFLAGS="-march=i686 -mtune=generic -O2 -pipe"
	export CHOST="i686-frugalware-linux"
	export CC="gcc -m32"
	export CXX="g++ -m32"
	LDFLAGS+=" -L/usr/lib32"
	export CPPFLAGS=" -I/usr/${CHOST}/inlcude"

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
__cross_delete_files() {

        Frm usr/share/{man,info,doc}
        Frm etc
}

Fcross_prepare() {

        __cross_save_orig_vars
        __cross_unset_vars
        __cross_set_vars
}


Fcross_reset_and_fix() {

	__cross_export_orig_vars
	__cross_delete_files

}

Fbuild_coss() {

	Fcross_prepare
	Fbuild
	Fcross_reset_and_fix

}

## EOF
