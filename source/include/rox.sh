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
# _F_rox_use_sourceforge=1
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
# * _F_rox_use_sourceforge - enable the use of sourceforge, and some other
# defaults that go with it (do not use with the others)
# * _F_rox_use_kerofin - enable the use of one of the other sources of rox
# desktop software (do not use with the others)
# * _F_rox_use_rox4debian - enable the use of one of the other sources of rox
# desktop software (do not use with the others)
# * _F_rox_use_hayber - enable the user of one of the other sources of rox
# desktop software (do not use with the others)
# * _F_rox_hayber_subdir - use to change the subdir that is used for up2date
# and source in hayber mirror setup, defaults to $pkgname
# * _F_rox_subdir - used to install the rox app to a subdir of the install
# path
# * _F_rox_sep - used to change the seperator between version and
# $_F_rox_name, if applicable.
###

[ -z "$_F_rox_name" ] && _F_rox_name=$pkgname
[ -z "$_F_rox_subdir" ] && _F_rox_subdir=
[ -z "$_F_rox_sep" ] && _F_rox_sep=-
[ -z "$_F_rox_use_sourceforge" ] && _F_rox_use_sourceforge=0
[ -z "$_F_rox_use_kerofin" ] && _F_rox_use_kerofin=0
[ -z "$_F_rox_use_rox4debian" ] && _F_rox_use_rox4debian=0
[ -z "$_F_rox_use_hayber" ] && _F_rox_use_hayber=0
[ -z "$_F_rox_hayber_subdir" ] && _F_rox_hayber_subdir=$pkgname
if echo $pkgname | grep -q lib; then
	_F_rox_installpath=/usr/lib/
else
	_F_rox_installpath=/usr/share/Apps/
fi
_F_rox_installpath="$_F_rox_installpath$_F_rox_subdir"

###
# == OVERWRITTEN VARIABLES
# * up2date (only for sourceforge)
# * source (only for sourceforge)
# * options (nodocs appended)
# * groups
###

if [ "$_F_rox_use_sourceforge" -eq 1 ]; then
	_F_sourceforge_dirname=rox
	Finclude sourceforge
	unset url
fi

if [ "$_F_rox_use_kerofin" -eq 1 ]; then
	_F_rox_kerofin_url="http://www.kerofin.demon.co.uk/rox"
	url="$_F_rox_kerofin_url/$pkgname.html"
	_F_archive_name="$_F_rox_name"
	up2date="Flasttar $url"
	source=($_F_rox_kerofin_url/$_F_rox_name-$pkgver.tar.gz)
fi

if [ "$_F_rox_use_rox4debian" -eq 1 ]; then
	_F_rox_rox4debian_url="ftp://ftp.berlios.de/pub/rox4debian"
	if echo $pkgname | grep -q lib; then
		_F_rox_rox4debian_url="$_F_rox_rox4debian_url/libs"
	else
		_F_rox_rox4debian_url="$_F_rox_rox4debian_url/apps"
	fi
	url="$_F_rox_rox4debian_url"
	_F_archive_name="$_F_rox_name"
	up2date="Flasttar $url"
	source=($_F_rox_rox4debian_url/$_F_rox_name-$pkgver.tgz)
fi

if [ "$_F_rox_use_hayber" -eq 1 ]; then
	_F_rox_hayber_url="http://www.hayber.us/rox"
	url="$_F_rox_hayber_url/$_F_rox_name"
	_F_archive_name="$_F_rox_name"
	up2date="Flasttar $_F_rox_hayber_url/$_F_rox_hayber_subdir"
	source=($_F_rox_hayber_url/$_F_rox_hayber_subdir/$_F_rox_name-$pkgver.tgz)
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
