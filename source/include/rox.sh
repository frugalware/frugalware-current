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
# pkgname=rox-lib
# pkgver=2.0.5
# pkgrel=1
# pkgdesc="An essential library for ROX Desktop."
# _F_rox_name="ROX-Lib"
# _F_rox_sep=2-
# _F_sourceforge_name=${pkgname}2
# _F_sourceforge_ext=.tar.bz2
# Finclude rox
# _F_rox_name=${_F_rox_name}2
# rodepends=('rox-filer' 'pygtk')
# groups=(${groups[@]} 'rox-core')
# archs=('i686')
# sha1sums=('62283301b4f2bb9fda5cafcd0785d4a8aa156914')
# --------------------------------------------------
#
# == OPTIONS
# * _F_rox_name - real name of the rox app, defaults to $pkgname
# * _F_rox_override - set to 1 if you wish to disable automatic detection
# of url, and up2date/source if sourceforge is used.
# * _F_rox_subdir - used to install the rox app to a subdir of the install
# path
# * _F_rox_sep - used to change the seperator between version and
# $_F_rox_name, if applicable.
###

[ -z "$_F_rox_name" ] && _F_rox_name=$pkgname
[ -z "$_F_rox_subdir" ] && _F_rox_subdir=
[ -z "$_F_rox_sep" ] && _F_rox_sep=-
[ -z "$_F_rox_override" ] && _F_rox_override=0
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
if [ "$_F_rox_override" -eq 0 ]; then
	_F_rox_index_page="http://roscidus.com/desktop/software"
	A=`lynx -dump "$_F_rox_index_page" | grep "]$_F_rox_name --" | sed -n '1p' | sed 's|.*\[\(.*\)].*|\1|'`
	url2=`lynx -dump "$_F_rox_index_page" | grep " $A. " | sed 's|^.* ||'`
	if lynx -dump "$url2" | grep -v http://sourceforge.net/projects/rox | grep -q sourceforge.net; then
        	[ -z "$_F_sourceforge_dirname" ] && _F_sourceforge_dirname=rox
        	Finclude sourceforge
	fi
	url=$url2
	unset A
	unset url2
fi

options=(${options[@]} 'nodocs')
groups=('rox-extra')

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
	Fmkdir $_F_rox_installpath /usr/share/doc
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
	Fcp $_F_rox_appdir `echo "$_F_rox_installpath" | sed 's|\(.*\)/.*|\1|'`
	Fmv $_F_rox_installpath/Help /usr/share/doc/$pkgname-$pkgver
	Fln /usr/share/doc/$pkgname-$pkgver $_F_rox_installpath/Help
	Fdirschmod $_F_rox_installpath +r
}

Frox_cleanup()
{
	[ -d $Fdestdir/$_F_rox_installpath/src ] && Frm $_F_rox_installpath/src
	[ -d $Fdestdir/$_F_rox_installpath/build ] && Frm $_F_rox_installpath/build
	[ -f $Fdestdir/$_F_rox_installpath/.cvsignore ] && Frm $_F_rox_installpath/.cvsignore
	[ -f $Fdestdir/$_F_rox_installpath/.gitignore ] && Frm $_F_rox_installpath/.gitignore
}

Fbuild_rox()
{
	Frox_setup
	Frox_compile
	Frox_mkdir
	Frox_install
	Frox_cleanup
	Fmessage "Entering packaging phase..."
}

###
# * build() simply calls Fbuild_rox()
###

build()
{
	Fbuild_rox
}
