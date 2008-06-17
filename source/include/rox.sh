#!/bin/sh

###
# = rox.sh(3)
# James Buren <ryuo@frugalware.org>
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
# _F_rox_name="Load"
# Finclude rox
# --------------------------------------------------
#
# == OPTIONS
# * _F_rox_name - real name of the rox app, defaults to $pkgname
# * _F_rox_subdir - used to install the rox app to a subdir of the install
# path
# * _F_rox_sep - used to change the seperator between version and
# $_F_rox_name, if applicable.
###

[ -z "$_F_rox_name" ] && _F_rox_name=$pkgname
[ -z "$_F_rox_subdir" ] && _F_rox_subdir=
[ -z "$_F_rox_sep" ] && _F_rox_sep=-
if echo $pkgname | grep -q lib; then
	_F_rox_installpath=/usr/lib/
else
	_F_rox_installpath=/usr/share/Apps/
fi
_F_rox_installpath="$_F_rox_installpath$_F_rox_subdir"

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date (only for sourceforge)
# * source (only for sourceforge)
# * options (nodocs appended)
###
_F_rox_index_page="http://roscidus.com/desktop/software"
A=`lynx -dump "$_F_rox_index_page" | grep "$_F_rox_name --" | sed -n '1p' | sed 's|.*\[\(.*\)].*|\1|'`
url2=`lynx -dump "$_F_rox_index_page" | grep ' $A. ' | sed 's|^.* ||'`
if lynx -dump "$url2" | grep -q sourceforge.net; then
        _F_sourceforge_dirname=rox
        Finclude sourceforge
fi
url=$url2
options=(${options[@]} 'nodocs')
groups=('rox-extra')
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
	Fmkdir $_F_rox_fullpath /usr/share/doc
}

Frox_setup()
{
	if [ ! -d "$Fsrcdir/$_F_rox_name" ]; then
		if [ -d "$Fsrcdir/$pkgname$_F_rox_sep$pkgver/$_F_rox_name" ]; then
			_F_rox_appdir=$pkgname$_F_rox_sep$pkgver/$_F_rox_name
		else
			error "The appdir cannot be found."
			Fdie
		fi
	else
		_F_rox_appdir=$_F_rox_name
	fi
	Fcd $_F_rox_appdir
	_F_rox_installpath="$_F_rox_installpath$_F_rox_name"
}

Frox_install()
{
	Fcp $_F_rox_appdir $_F_rox_installpath
	Fmv $_F_rox_fullpath/Help /usr/share/doc/$pkgname-$pkgver
	Fln /usr/share/doc/$pkgname-$pkgver $_F_rox_fullpath/Help
	Fdirschmod $_F_rox_installpath +r
}

Frox_cleanup()
{
	[ -d $Fdestdir/$_F_rox_fullpath/src ] && Frm $_F_rox_fullpath/src
	[ -d $Fdestdir/$_F_rox_fullpath/build ] && Frm $_F_rox_fullpath/build
	[ -f $Fdestdir/$_F_rox_fullpath/.cvsignore ] && Frm $_F_rox_fullpath/.cvsignore
	[ -f $Fdestdir/$_F_rox_fullpath/.gitignore ] && Frm $_F_rox_fullpath/.gitignore
	if [ -f $Fdestdir/$_F_rox_fullpath/.DirIcon ]; then
		if file .DirIcon | grep -q SVG; then
			rodepends=(${rodepends[@]} 'librsvg')
		fi
	fi
}

Fbuild_rox()
{
	Frox_setup
	Frox_compile
	Frox_mkdir
	Frox_install
	Frox_cleanup
}

###
# * build() simply calls Fbuild_rox()
###

build()
{
	Fbuild_rox
}
