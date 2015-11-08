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
#

###
# == PROVIDED FUNCTIONS
# * build_qt5(): function to build qt5 source packages
###
pkgver=5.5.1
pkgrel=1
qtpkgname=${pkgname/5-/}
qtpkgfilename=${qtpkgname}-opensource-src-${pkgver}
pkgdesc="The Qt5 toolkit, ${qtpkgname}"
url="http://www.qt.io"
groups=('xlib-extra')
archs=('i686' 'x86_64')
options=('nodocs')
up2date="Flasttar $url/download-open-source/"
source=(http://download.qt.io/archive/qt/${pkgver%.*}/${pkgver}/submodules/${qtpkgfilename}.tar.xz)
_F_cd_path=qtxmlpatterns-opensource-src-${pkgver}
_F_archive_name=qt-everywhere-opensource-src
up2date="Flasttar $url/download-open-source/"
_F_cd_path=${qtpkgfilename}

build_qt5()
{
	Fcd
	qmake-qt5 || Fdie
	Fmake
	make  INSTALL_ROOT=$Fdestdir install || Fdie
	for i in ${Fdestdir}/usr/lib/qt5/bin/*; do
		q5=`basename ${i}`
		Fln /usr/lib/qt5/bin/${q5} /usr/bin/${q5}-qt5
        done
}

build()
{
	build_qt5
}