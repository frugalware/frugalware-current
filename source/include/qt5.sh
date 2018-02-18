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


qtpkgname=${pkgname/5-/}
qtpkgfilename=${qtpkgname}-everywhere-src-${pkgver}
pkgdesc="The Qt5 toolkit, ${qtpkgname}"
url="http://www.qt.io"
if [ -z "$groups" ]; then
	groups=('xlib')
fi
archs=('x86_64')
options+=('nodocs')
source=(http://download.qt.io/archive/qt/${pkgver%.*}/${pkgver}/submodules/${qtpkgfilename}.tar.xz)
_F_archive_grepv="5.8"
up2date="Flastverdir http://download.qt-project.org/official_releases/qt/\$(Flastverdir http://download.qt-project.org/official_releases/qt/)"
_F_cd_path=${qtpkgfilename}
makedepends+=('x11-protos' 'gperf')

_qt_extra_cxx=" -Wno-deprecated -Wno-deprecated-declarations"

if [ -n "$_F_qt_extra_cxx" ]; then
	_qt_extra_cxx+=" ${_F_qt_extra_cxx[@]}"
fi

build_qt5()
{
	Fcd
	Fpatchall
	qmake-qt5 QMAKE_CXXFLAGS+=" ${_qt_extra_cxx[@]}" || Fdie
	Fmake
	make  INSTALL_ROOT=$Fdestdir install || Fdie
	if [ -d "${Fdestdir}/usr/lib/qt5/bin" ]; then
		local i
		for i in ${Fdestdir}/usr/lib/qt5/bin/*; do
			q5=`basename ${i}`
			Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}-qt5
			Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}
		done
        fi
}

build()
{
	build_qt5
}
