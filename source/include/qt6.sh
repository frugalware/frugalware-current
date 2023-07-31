#!/bin/sh

###
# = qt6.sh(3)
# DeX77 <dex77@frugalware.org>
#
# == NAME
# qt6.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for qt6 packages
#
# == OPTIONS
# * _F_qt_nocore: when set to true it indicates is not a core
#   qt6 package.
###

###
# == PROVIDED FUNCTIONS
# * build_qt6(): function to build qt6 source packages
###

if [ -z "$_F_qt_nocore" ]; then
	qtpkgname=${pkgname/6-/}
	qtpkgfilename=${qtpkgname}-everywhere-src-${pkgver}
	pkgdesc="The Qt6 toolkit, ${qtpkgname}"
	url="http://www.qt.io"
	if [ -z "$groups" ]; then
		groups=('xlib-extra')
	fi
	options+=('nodocs')
	source=(https://mirror.netcologne.de/qtproject/archive/qt/${pkgver%.*}/${pkgver}/submodules/${qtpkgfilename}.tar.xz)
	up2date="Flastverdir https://mirror.netcologne.de/qtproject/official_releases/qt/\$(Flastverdir https://mirror.netcologne.de/qtproject/official_releases/qt/)"
	_F_cd_path=${qtpkgname}-everywhere-src-${pkgver}
fi

if [[ "$pkgname" =~ "qt6-base" ]]; then
	makedepends+=('x11-protos' 'gperf')
else
	makedepends+=('x11-protos' 'gperf' "qt6-base-static")
fi

if [ -z "$archs" ]; then
	archs=('x86_64')
fi

_F_cmake_use_ninja=yes
Finclude cmake
