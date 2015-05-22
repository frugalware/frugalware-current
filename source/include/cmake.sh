#!/bin/sh

###
# = cmake.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# cmake.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages using cmake build system.
#
# == OPTIONS
# * _F_cmake_type (default: None): Possible values  Debug, Debugfull, Release, Relwithdebinfo
# * _F_cmake_verbose (default: True): Possible values True or False
# * _F_cmake_color (default: OFF): Possible values ON or OFF
# * _F_cmake_confopts (default: nothing): Use like with Fconfopts
###

if [ -z "$_F_cmake_type" ]; then
	_F_cmake_type="None"
fi

if [ -z "$_F_cmake_verbose" ]; then
	_F_cmake_verbose="True"
fi

if [ -z "$_F_cmake_color" ]; then
	_F_cmake_color="OFF"
fi

if [ -z "$_F_cmake_in_source_build" ]; then
	_F_cmake_in_source_build=0
fi

if [ -z "$_F_cmake_old_defines" ]; then
	_F_cmake_old_defines=1
fi

if [ -z "$_F_cmake_rpath" ]; then
        _F_cmake_rpath="OFF"
fi

if [ -z "$_F_cmake_build_dir" ]; then
        _F_cmake_build_dir="frugalware_cmake_build"
fi

###
# == APPENDED VARIABLES
# * makedepends(): add cmake and pkgconfig
# * options(): add nostrip if _F_cmake_type is Debug*
###
makedepends=(${makedepends[@]} 'cmake' 'pkgconfig')

###
# == PROVIDED FUNCTIONS
# * CMake_setup(): Setup packages depending on some _F_cmake_* options.
###
CMake_setup()
{
	local i

	case "$_F_cmake_type" in
	Debug*)
		options=("${options[@]}" 'nostrip')
		for i in $(seq 0 $((${#subpkgs[@]} - 1))); do
			suboptions[$i]="${suboptions[$i]} nostrip"
		done
		;;
	esac
}

###
# * CMake_conf(): This is the 'configure' part but cmake way.
###
CMake_conf()
{
	CMake_setup

	## CMAKE_INSTALL_PREFIX -> prefix
	## SYSCONF_INSTALL_DIR -> sysconfdir
	## LIB_INSTALL_DIR -> libdir
	## LOCALSTATE_INSTALL_DIR -> localstatedir

	if [ "$_F_cmake_in_source_build" -eq "0" ]; then
		_F_cmake_src=".."
	else
		_F_cmake_src="."
	fi

	if [ "$_F_cmake_old_defines" != "0" ]; then
		_F_cmake_confopts="-DLIB_INSTALL_DIR=/usr/lib
			-DLIB_SUFFIX=''
			-DLOCALSTATE_INSTALL_DIR=/var
			$_F_cmake_confopts"
	fi

	cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DSYSCONF_INSTALL_DIR=/etc \
		-DCMAKE_BUILD_TYPE="$_F_cmake_type" \
		-DCMAKE_VERBOSE_MAKEFILE="$_F_cmake_verbose" \
		-DCMAKE_COLOR_MAKEFILE="$_F_cmake_color" \
		-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
		-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
		-DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-DCMAKE_CXX_FLAGS_DEBUG="$CXXFLAGS" \
		-DCMAKE_C_FLAGS_DEBUG="$CFLAGS" \
		-DCMAKE_SKIP_RPATH="$_F_cmake_rpath" \
		$_F_cmake_confopts "$@" $_F_cmake_src || Fdie
}

###
# * CMake_prepare_build(): Runs 'Fpatchall' and prepares the 'build' dir needed by cmake.
###
CMake_prepare_build()
{
	Fcd
	Fpatchall
	if [ "$_F_cmake_in_source_build" -eq "0" ]; then
		if [ -d  "$_F_cmake_build_dir" ]; then
			rm -rf $_F_cmake_build_dir || Fdie
			mkdir $_F_cmake_build_dir || Fdie
			cd $_F_cmake_build_dir || Fdie
		else
			mkdir $_F_cmake_build_dir || Fdie
			cd $_F_cmake_build_dir || Fdie
		fi
	else
		export CMAKE_IN_SOURCE_BUILD=1
	fi
}

###
# * CMake_make(): Calls 'CMake_prepare_build()' , 'CMake_conf()' and runs 'make'
###
CMake_make()
{
	CMake_prepare_build
	CMake_conf "$@"
	## do _not_ use any F* stuff here , cmake does not like it
	make || Fdie
}

CMake_install()
{
	make DESTDIR=$Fdestdir install/fast || Fdie
}
###
# * CMake_build(): build() wrapper
###
CMake_build()
{
	CMake_make "$@"
	CMake_install
}

###
# * build(): Calls 'CMake_build()'
###
build()
{
	CMake_build
}

