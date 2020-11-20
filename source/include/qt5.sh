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
# == OPTIONS
# * _F_qt_extra_cxx: adding extra CXX compiler flags.
#  _F_qt_extra_cxx+=" -fsomething"
# * _F_qt_extra_ldflags: adding extra LD linker flags.
#  _F_qt_extra_ldflags+=" -lfoo"
# * _F_qt_nocore: when set to true it indicates is not a core
#   qt5 package.
###

###
# == PROVIDED FUNCTIONS
# * build_qt5(): function to build qt5 source packages
###

## always use these

if [ -n "$_F_qt_extra_cxx" ]; then
        _qt_extra_cxx+=" ${_F_qt_extra_cxx[@]}"
fi

if [ -n "$_F_qt_extra_ldflags" ]; then
        _qt_extra_ldflags+=" ${_F_qt_extra_ldflags[@]}"
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
	up2date="Flastverdir http://download.qt-project.org/official_releases/qt/\$(Flastverdir http://download.qt-project.org/official_releases/qt/)"
	_F_cd_path=${qtpkgfilename}
fi

if [[ "$pkgname" =~ "qt5-base" ]]; then
	makedepends+=('x11-protos' 'gperf')
else
	makedepends+=('x11-protos' 'gperf' "qt5-base-static>=5.15.2")
fi

if [[ ! "$pkgname" =~ "qt5-base" ]] || [[ ! "$pkgname" =~ "qt5-declarative" ]]; then
	makedepends+=('qt5-declarative-static>=5.15.2')
fi

if [ -z "$archs" ]; then
	archs=('x86_64')
fi

_qmake_conf() {


	if [ ! "`check_option ODEBUG`" ]; then
		_build_type="release"
	else
		_build_type="debug"
	fi

	if [  "`check_option NOLTO`" ]; then
		_drop_lto="CONFIG-=ltcg"
	fi
	## kill flags from qt-base and use = our ones so options=('flags_options')
	## are working. That is for the case some app won't work with some CXX/LD flags
	Fexec qmake-qt5 \
		CONFIG+="${_build_type}" \
		${_drop_lto} \
		QMAKE_CFLAGS_ISYSTEM=-I \
		QMAKE_CXXFLAGS=" ${_qt_extra_cxx[@]} ${CXXFLAGS}"  \
		QMAKE_CXXFLAGS_RELEASE=" ${_qt_extra_cxx[@]} ${CXXFLAGS}" \
		QMAKE_LFLAGS=" ${_qt_extra_ldflags[@]} ${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE=" ${_qt_extra_ldflags[@]} ${LDFLAGS}" \
		QMAKE_CXXFLAGS_DEBUG="" \
		QMAKE_CFLAGS_OPTIMIZE="" \
		QMAKE_CFLAGS_OPTIMIZE_SIZE="" \
		QMAKE_CFLAGS_OPTIMIZE_FULL="" \
		${_FQt_confopts[@]} "$@"
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
	Ffix_la_files
}

## to be removed soon
build_qt5() {

	FQt_build
}

build()
{
	build_qt5
}
