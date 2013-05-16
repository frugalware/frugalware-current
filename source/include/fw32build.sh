#!/bin/sh

###
# = fw32build.sh(3)
# kikadf <kikadf.01@gmail.com>
#
# == NAME
# fw32build.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for build i686 packages on x86_64.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=foxitreader
# _F_archive_name=FoxitReader
# pkgver=1.1
# pkgrel=3
# pkgdesc="A small and fast PDF viewer"
# url="http://www.foxitsoftware.com"
# rodepends=('gtk+2-libs' 'libcups')
# _F_desktop_name='Foxit Reader'
# _F_desktop_categories='Viewer;Office'
# _F_desktop_icon='Foxitreader.png'
# _F_fw32build_desktop_icon="$_F_fw32_dir/usr/share/pixmaps/Foxitreader.png"
# _F_cd_path="$pkgver-release"
# _F_fw32build_nobuild="yes"
# options=('nobuild')
# groups=('xapps-extra')
# archs=('i686' 'x86_64')
# up2date="$pkgver"
# source=('http://cdn04.foxitsoftware.com/pub/foxit/reader/desktop/linux/1.x/'$pkgver'/enu/'$_F_archive_name'-'$pkgver'.0.tar.bz2' \
#         'http://upload.wikimedia.org/wikipedia/en/a/a6/Foxitreader.png')
# sha1sums=('7de9de0886c9196d93e6c51efe81681163d5038a' \
#           '3621263dadd26c63201fd8498743a13ad5edff54')
# Finclude fw32build
#
# build()
# {
# 	if [ "$CARCH" == "x86_64" ] ; then
# 		Fw32_build
# 	else
# 		Ffile $_F_cd_path/*.{bin,fhd} /usr/share/$pkgname
# 		Fexe $_F_cd_path/$_F_archive_name /usr/share/$pkgname
# 		Fwrapper "cd /usr/share/foxitreader && ./FoxitReader $@" $pkgname
# 		Fcd $_F_cd_path/po
# 		for _lang in *; do
# 			Ffile $_F_cd_path/po/$_lang/$_F_archive_name.mo /usr/share/locale/$_lang/LC_MESSAGES/$_F_archive_name.mo
# 		done
# 		Ficon Foxitreader.png
# 		Fdesktop2
# 	fi
# }
# --------------------------------------------------
#
# == OPTIONS
# * _F_fw32_dir: fw32 package's chroot dir
# * _F_fw32build_bin_name: defaults to $pkgname, wrapper string or command
# from fw32's chroot
# * _F_fw32build_wrapper_name: defaults to $_F_fw32build_bin_name, name
# of the wrapper file on x86_64
# * _F_fw32build_desktop_icon: icon's path to desktop file
# * _F_fw32build_scriptlet: the i686 package install script
# * _F_fw32build_nobuild(default is empty): set if package is nobuild package
# * _F_fw32build_nodesktop(default is empty): set if package doesn't need desktop file
###
_F_fw32_dir="/usr/lib/fw32"

if [ -z "$_F_fw32build_bin_name" ]; then
	_F_fw32build_bin_name=$pkgname
fi

if [ -z "$_F_fw32build_wrapper_name" ]; then
	_F_fw32build_wrapper_name=$_F_fw32build_bin_name
fi

if [ -z "$_F_fw32build_desktop_icon" ]; then
	_F_fw32build_desktop_icon="$_F_fw32_dir/usr/share/pixmaps/$pkgname.png"
fi

if [ -z "$_F_fw32build_scriptlet" ]; then
	_F_fw32build_scriptlet="$Fincdir/fw32build.install"
fi

###
# == OVERWRITTEN VARIABLES
# * depends(): remove depends
# * makedepends(): remove makedepends
# * rodepends(): add only fw32
# * source(): remove source(s)
# * sha1sums(): remove sha1sums
# * _F_cd_path()
# * _F_desktop_exec()
# * _F_desktop_icon()
# * _F_genscriptlet_install()
# * install()
###
if [ "$CARCH" == "x86_64" ] ; then
	unset depends
	unset makedepends
	unset source
	unset install
	unset sha1sums
	rodepends=('fw32')
	_F_desktop_exec="$_F_fw32build_wrapper_name"
	_F_desktop_icon="$_F_fw32build_desktop_icon"
	_F_genscriptlet_install="$_F_fw32build_scriptlet"
	_F_cd_path="."
fi

Finclude genscriptlet

###
# == PROVIDED FUNCTIONS
# * Fbuild_fw32build_scriptlet(): generates a scriptlet
###
Fbuild_fw32build_scriptlet()
{
	Fgenscriptlet
	Fsed '@_F_fw32_package_name@' "$pkgname" "${Fsrcdir}/$(basename "$_F_fw32build_scriptlet")"
	if [ ! -z $_F_fw32build_nobuild ]; then
		Fsed '_F_fw32build_build' '_F_fw32build_nobuild' "${Fsrcdir}/$(basename "$_F_fw32build_scriptlet")"
	fi
}

###
# * Fw32_build(): build wrapper and desktop file to an i686 package on x86_64.
# Fdesktop2 use fw32build.sh's overwritten _F_desktop_exec and _F_desktop_icon variables.
# Other Fdesktop2's variables are compatible with fw32build.sh.
###
Fw32_build()
{
	Fwrapper "fw32-run $_F_fw32build_bin_name" $_F_fw32build_wrapper_name
	if [ -z $_F_fw32build_nodesktop ]; then
		Fdesktop2
	fi
	Fbuild_fw32build_scriptlet
}

###
# * build(): if $CARCH=x86_64 just calls Fw32_build(), else calls Fbuild().
###
build()
{
	if [ "$CARCH" == "x86_64" ] ; then
		Fw32_build
	else
		Fbuild
	fi
}
