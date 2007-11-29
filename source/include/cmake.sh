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
# * _F_cmake_color (default: Off): Possible values ON or OFF
# * _F_cmake_confopts (default: nothing): Use like with Fconfopts
###

if [ -z "$_F_cmake_type" ]; then
	_F_cmake_type="None"
fi

if [ -z "$_F_cmake_verbose" ]; then
	_F_cmake_verbose="TRUE"
fi

if [ -z "$_F_cmake_color" ]; then
	_F_cmake_color="OFF"
fi

###
# == APPENDED VARIABLES
# * cmake to makedepends()
###
makedepends=(${makedepends[@]} 'cmake')

###
# == PROVIDED FUNCTIONS
# * CMake_conf(): This is the 'configure' part but cmake way.
###
CMake_conf()
{
	## CMAKE_INSTALL_PREFIX -> prefix
	## SYSCONF_INSTALL_DIR -> sysconfdir
	## LIB_INSTALL_DIR -> libdir
	## LOCALSTATE_INSTALL_DIR -> localstatedir

	cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DSYSCONF_INSTALL_DIR=/etc \
		-DLIB_SUFFIX="" \
		-DLIB_INSTALL_DIR=/usr/lib \
		-DLOCALSTATE_INSTALL_DIR=/var \
		-DCMAKE_BUILD_TYPE="$_F_cmake_type" \
		-DCMAKE_VERBOSE_MAKEFILE="$_F_cmake_verbose" \
		-DCMAKE_COLOR_MAKEFILE="$_F_cmake_color" \
		-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
		$_F_cmake_confopts "$@" .. || Fdie
}

###
# * CMake_prepare_build(): Runs 'Fpatchall' and prepares the 'build' dir needed by cmake.
###
CMake_prepare_build()
{
	Fcd
	Fpatchall
	if [ -d  "build" ]; then
		rm -rf build || Fdie
		mkdir build || Fdie
		cd build || Fdie
	else
		mkdir build || Fdie
		cd build || Fdie
	fi
}

###
# * CMake_make(): Calls 'CMake_prepare_build()' , 'CMake_conf()' and runs 'make'
###
CMake_make()
{
	CMake_prepare_build
	CMake_conf
	## do _not_ use any F* stuff here , cmake does not like it
	make || Fdie
}

###
# * CMake_build(): build() wrapper
###
CMake_build()
{

	CMake_make
	make DESTDIR=$Fdestdir install || Fdie
}

###
# * build(): Calls 'CMake_build()'
###
build()
{
	CMake_build
}

