#!/bin/sh

###
# = rox.sh(3)
# Marcus Habermehl <bmh1980@frugalware.org>
#
# == NAME
# rox.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for ROX packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=rox-load
# pkgver=2.1.4
# pkgrel=1
# pkgdesc="This applet displays the load average of your system."
# url="http://www.kerofin.demon.co.uk/rox/load.html"
# license="GPL2"
# up2date="lynx -dump $url|grep 'Load [0-9\.]\+[0-9]'|tail -n 1|cut -d ' ' -f 8"
# source=(http://www.kerofin.demon.co.uk/rox/Load-$pkgver.tar.gz $pkgname)
# sha1sums=('1be4ef2394dbdebaab9ebf7240aae93ee3a13177' \
#           'b181a0765fb3323072aba1dfb4ac7abd6907c9fd')
# groups=('rox-extra')
# archs=('i686')
# depends=('libgtop' 'rox-clib')
# _F_rox_appname="Load"
# Finclude rox
# --------------------------------------------------
#
# == OPTIONS
# * _F_rox_appname - name of the rox app to install (mandatory)
# * _F_rox_subdir - used to divide rox apps into group dirs (optional)
# * _F_rox_updatename - used to finetune the default up2date (optional)
# * _F_rox_updateext - used to finetune the default up2date (optional)
# * _F_rox_seperator - use if you have an unusual directory path to the appdir (optional)
###

[ -z "$_F_rox_appname" ] && Fdie
[ -z "$_F_rox_subdir" ] && _F_rox_subdir=
[ -z "$_F_rox_updatename" ] && _F_rox_updatename=$pkgname
[ -z "$_F_rox_updateext" ] && _F_rox_updateext=.tar.bz2
[ -z "$_F_rox_seperator" ] && _F_rox_seperator=-
if [ "`echo $pkgname | grep 'lib'`" != "" ]; then
	_F_rox_installpath=/usr/lib/
else
	_F_rox_installpath=/usr/share/Apps/
fi
_F_rox_installpath="$_F_rox_installpath$_F_rox_subdir"

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source
# * archs
###
_F_rox_index_page="http://roscidus.com/desktop/software"
A=`lynx -dump '$_F_rox_index_page' | grep "$_F_rox_appname --" | sed -n '1p' | sed 's|.*\[\(.*\)].*|\1|'`
url2=`lynx -dump '$_F_rox_index_page' | grep ' $A. ' | sed 's|^.* ||'`
if [ "`lynx -dump '$url2' | grep 'sourceforge'`" != "" ]; then
        _F_sourceforge_dirname=rox
        Finclude sourceforge
fi
url=$url2
# disable nodocs since we already handle that
options=(${options[@]} 'nodocs')
unset A
unset url2

###
# == PROVIDED FUNCTIONS
# * Frox_compile()
# * Frox_mkdir()
# * Frox_setup()
# * Frox_install()
# * Frox_cleanup()
# * Fbuild_rox()
###

Frox_compile()
{
	if [ -d $Fsrcdir/$_F_rox_appdir/src ]; then 
		./AppRun --compile CC="gcc $CFLAGS" || Fdie
	fi
}

Frox_mkdir()
{
	[ "$_F_rox_lib" -eq 0 ] && Fmkdir /usr/bin
	Fmkdir $_F_rox_fullpath /usr/share/doc
}

Frox_setup()
{
	if [ ! -d "$Fsrcdir/$_F_rox_appname" ]; then
		if [ -d "$Fsrcdir/$pkgname$_F_rox_seperator$pkgver/$_F_rox_appname" ]; then
			_F_rox_appdir=$pkgname$_F_rox_seperator$pkgver/$_F_rox_appname
		else
			error "The appdir cannot be found."
			Fdie
		fi
	else
		_F_rox_appdir=$_F_rox_appname
	fi
	Fcd $_F_rox_appdir
	_F_rox_fullpath=$_F_rox_installpath/$_F_rox_appname
}

Frox_install()
{
	Fcp $_F_rox_appdir $_F_rox_installpath
	Fmv $_F_rox_fullpath/Help /usr/share/doc/$pkgname-$pkgver
	Fln /usr/share/doc/$pkgname-$pkgver $_F_rox_fullpath/Help

	if [ "$_F_rox_lib" -eq 0 ]; then
		if [ -f $Fsrcdir/$pkgname ]; then
			Fexe /usr/bin/$pkgname
		fi
	fi
}

Frox_cleanup()
{
	[ -d $Fdestdir/$_F_rox_fullpath/src ] && Frm $_F_rox_fullpath/src
	[ -d $Fdestdir/$_F_rox_fullpath/build ] && Frm $_F_rox_fullpath/build
	[ -f $Fdestdir/$_F_rox_fullpath/.cvsignore ] && Frm $_F_rox_fullpath/.cvsignore
	[ -f $Fdestdir/$_F_rox_fullpath/.gitignore ] && Frm $_F_rox_fullpath/.gitignore
}

Fbuild_rox()
{
	Frox_setup
	Frox_compile
	Frox_mkdir
	Frox_install
	Frox_cleanup
	Fmessage "Entering final preparation phase..."
}

###
# * build() simply calls Fbuild_rox()
###

build()
{
	Fbuild_rox
}
