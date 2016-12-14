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
qtpkgfilename=${qtpkgname}-opensource-src-${pkgver}
pkgdesc="The Qt5 toolkit, ${qtpkgname}"
url="http://www.qt.io"
if [ -z "$groups" ]; then
	groups=('xlib')
fi
archs=('x86_64')
options+=('nodocs')
source=(http://download.qt.io/archive/qt/${pkgver%.*}/${pkgver}/submodules/${qtpkgfilename}.tar.xz)
_F_archive_name=qt-everywhere-opensource-src
up2date="Flasttar $url/download-open-source/"
_F_cd_path=${qtpkgfilename}
makedepends+=('x11-protos' 'gperf')


## From gcc6 docs
## Value range propagation now assumes that the this pointer of C++ member functions is non-null. This eliminates common
## null pointer checks but also breaks some non-conforming code-bases (such as Qt-5, Chromium, KDevelop). As a temporary
## work-around -fno-delete-null-pointer-checks can be used. Wrong code can be identified by using -fsanitize=undefined.

_F_QT5_GCC_VER=$(gcc --version | head -n1 | cut -d" " -f4)

case "$_F_QT5_GCC_VER" in
6.*) CXXFLAGS+=" -fno-delete-null-pointer-checks -Wno-deprecated -Wno-deprecated-declarations";;
esac

build_qt5()
{
	Fcd
	Fpatchall
	qmake-qt5 || Fdie
	Fmake
	make  INSTALL_ROOT=$Fdestdir install || Fdie
	if [ -d "${Fdestdir}/usr/lib/qt5/bin" ]; then
		local i
		for i in ${Fdestdir}/usr/lib/qt5/bin/*; do
			q5=`basename ${i}`
			Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}-qt5
		done
        fi
}

build()
{
	build_qt5
}
