#!/bin/sh

###
# = meson.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# meson.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages using meson build system.
#
# == OPTIONS
# * _F_meson_type (default: release ): Possible values : plain debug debugoptimized release minsize
# * _F_meson_confopts (default: nothing): Use like with Fconfopts , syntax is -Dsomething=something
# * _F_meson_compiler ( default: gcc ): Possible values: gcc or clang
###


if [ -z "$_F_meson_build_type" ]; then
	_F_meson_build_type="release"
fi

if [ -z "$_F_meson_compiler" ]; then
	_F_meson_compiler="gcc"
fi

if [ -z "$_F_meson_build_dir" ]; then
        _F_meson_build_dir="frugalware_meson_build"
fi


###
# == APPENDED VARIABLES
# * makedepends(): add meson and pkgconfig
# * options(): add nostrip if _F_meson_build_type is debug*
###

makedepends+=('meson>=0.43.0-3' 'pkgconfig')

###
# == PROVIDED FUNCTIONS
# * Meson_setup(): Setup packages depending on some _F_cmake_* options.
###
Meson_setup()
{
	local i

	case "$_F_meson_build_type" in
	debug*)
		options=("${options[@]}" 'nostrip')
		for i in $(seq 0 $((${#subpkgs[@]} - 1))); do
			suboptions[$i]="${suboptions[$i]} nostrip"
		done
		;;
	esac

	case "$_F_meson_compiler" in
	gcc)
		_F_meson_cc="gcc"
		_F_meson_cxx="g++"
		;;
	clang)
		_F_meson_cc="clang"
		_F_meson_cxx="clang++"
		;;
	*)
		Fmessage "Unknow compiler , cannot continue.."
		exit 1
		;;
	esac

	## workaround for this POS .. so we can work from cross32 with it
	if [ -z "$_F_meson_is_cross32" ]; then
		export CC="$_F_meson_cc"
		export CXX="$_F_meson_cxx"
	fi

}

## FIXME
CROSS_LIB="lib"
CROSS_BIN="bin"
CROSS_SBIN="sbin"
CROSS_PREFIX="/usr"
CROSS_INC="${CROSS_PREFIX}/include"

###
# * Meson_conf(): This is the 'configure' part but cmake way.
###
Meson_conf()
{

	export LANG=en_US.utf8
	export LC_ALL=en_US.utf8
	## NOTE: no other backend but ninja for LINUX
	Meson_setup
	CXXFLAGS+=" -Wno-deprecated -Wno-deprecated-declarations  -fno-delete-null-pointer-checks"
	## we need all these to be sure we build with own flags..
	CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" \
		Fexec meson \
			--prefix ${CROSS_PREFIX} \
			--datadir share \
			--libdir ${CROSS_LIB} \
			--libexecdir ${CROSS_LIB}/$pkgname \
			--includedir ${CROSS_INC} \
			--mandir share/man \
			--bindir ${CROSS_BIN} \
			--sbindir ${CROSS_SBIN} \
			--sysconfdir /etc \
			--localstatedir /var \
			--buildtype $_F_meson_build_type \
			--backend ninja \
			$_F_meson_confopts "$@" $_F_meson_build_dir || Fdie
}

###
# * Meson_prepare_build(): Runs 'Fpatchall' and prepares the 'build' dir needed by meson.
###
Meson_prepare_build()
{
	Fcd
	Fpatchall
	if [ -d  "$_F_meson_build_dir" ]; then
		Fexec rm -rf "$_F_meson_build_dir" || Fdie
		Fexec mkdir -p "$_F_meson_build_dir" || Fdie
	else
		Fexec mkdir -p "$_F_meson_build_dir" || Fdie
	fi

}

###
# * Meson_make(): Calls 'Meson_prepare_build()' , 'Meson_conf()' and runs ninja
###
Meson_make()
{
	Meson_prepare_build
	Meson_conf "$@"

	if [[ -n $MAKEFLAGS ]]; then
		_flags="${MAKEFLAGS/-j/}"
	else
		_flags="1"
	fi

	## we run ninja with verbose , *always*
	Fexec ninja -j$_flags -v -C "$_F_meson_build_dir" || Fdie
}

Meson_install()
{

	if [[ -n $MAKEFLAGS ]]; then
		_flags="${MAKEFLAGS/-j/}"
	else
		_flags="1"
	fi

	DESTDIR=$Fdestdir Fexec ninja -j$_flags -v -C "$_F_meson_build_dir" install || Fdie
	Fremove_static_libs ## should not be needed but ..
}
###
# * Meson_build(): build() wrapper
###
Meson_build()
{
	Meson_make "$@"
	Meson_install
}

###
# * build(): Calls 'Meson_build()'
###
build()
{
	Meson_build
}

