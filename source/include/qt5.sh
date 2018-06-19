#!/bin/sh

###
# = qt5.sh(3)
# Marius Cirsta <mcirsta@frugalware.org>
#
# == NAME
# qt5.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for qt5 packages
###

###
# == PROVIDED FUNCTIONS
# * build_qt5(): function to build qt5 source packages
###

## always use these
_qt_extra_cxx+=" -Wno-deprecated -Wno-deprecated-declarations  -fno-delete-null-pointer-checks"

if [ -n "$_F_qt_extra_cxx" ]; then
        _qt_extra_cxx+=" ${_F_qt_extra_cxx[@]}"
fi

if [ -z "$_F_qt_nocore" ]; then
	qtpkgname=${pkgname/5-/}
	qtpkgfilename=${qtpkgname}-everywhere-src-${pkgver}
	pkgdesc="The Qt5 toolkit, ${qtpkgname}"
	url="http://www.qt.io"
	if [ -z "$groups" ]; then
		groups=('xlib')
	fi
	options+=('nodocs')
	source=(http://download.qt.io/archive/qt/${pkgver%.*}/${pkgver}/submodules/${qtpkgfilename}.tar.xz)
	_F_archive_grepv="5.8"
	up2date="Flastverdir http://download.qt-project.org/official_releases/qt/\$(Flastverdir http://download.qt-project.org/official_releases/qt/)"
	_F_cd_path=${qtpkgfilename}
fi

makedepends+=('x11-protos' 'gperf')

if [ -z "$archs" ]; then
	archs=('x86_64')
fi

_qmake_conf() {

	## always replace -isystem with -I..
	## alyway drop in CXX/LD FLAGS
	if [ -z "$_F_qt_nobase_flags" ]; then
		## use whatever flags from qt-base configuration file
		Fexec qmake-qt5 QMAKE_CXXFLAGS+=" ${_qt_extra_cxx[@]}"  QMAKE_LFLAGS+=" ${LDFLAGS}" QMAKE_CFLAGS_ISYSTEM=-I ${_FQt_confopts[@]} "$@"
	else
		## kill flags from qt-base and use = our ones so options=('flags_options')
		## are working. That is for the case some app won't work with some CXX/LD flags
		Fexec qmake-qt5 \
			QMAKE_CXXFLAGS=" ${CXXFLAGS} ${_qt_extra_cxx[@]}"  \
			QMAKE_LFLAGS=" ${LDFLAGS}" \
			QMAKE_CFLAGS_ISYSTEM=-I \
			QMAKE_CXXFLAGS_RELEASE="" \
			QMAKE_CXXFLAGS_DEBUG="" \
			${_FQt_confopts[@]} "$@"
	fi
}

_qmake_make() {

	## there is reason for doing so
	Fmake
}

_qmake_install() {

	Fexec make INSTALL_ROOT=$Fdestdir install || Fdie
}

_qt_symlink() {

	local i
	if [ -d "${Fdestdir}/usr/lib/qt5/bin" ]; then
		for i in ${Fdestdir}/usr/lib/qt5/bin/*; do
			q5=`basename ${i}`
			Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}-qt5
			Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}
		done
	fi
}

FQt_conf() {

	_qmake_conf "$@" || Fdie
}

FQt_make() {

	_qmake_make
}

FQt_install() {

	_qmake_install
}

FQt_symlink() {

	_qt_symlink
}

FQt_build()
{
	Fcd
	Fpatchall
	FQt_conf
	FQt_make
	FQt_install
	FQt_symlink
}

## to be removed soon
build_qt5() {

	FQt_build
}

build()
{
	build_qt5
}
