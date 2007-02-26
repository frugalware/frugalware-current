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
# _F_app_dir="Load"
# Finclude rox
# --------------------------------------------------
#
# == OPTIONS
# * _F_app_dir: the name of the rox applet
###

[ -z "$_F_app_dir" ] && Fdie

###
# == OVERWRITTEN VARIABLES
# * options
###
options=('nobuild')

###
# == PROVIDED FUNCTIONS
# * Froxbuild()
###
Froxbuild()
{
	Fcd $_F_app_dir
	if [ -d src ] ; then ./AppRun --compile || Fdie ; fi
	if [ -f libdir ] ; then Fsed '/usr/apps' '/usr/share/Apps' libdir ; fi
	Fmkdir /usr/{bin,share/{Apps,doc}}
	Fcpr $_F_app_dir /usr/share/Apps/
	[ -d $Fdestdir/usr/share/Apps/$_F_app_dir/src ] && \
		Frm /usr/share/Apps/$_F_app_dir/src
	[ -f $Fdestdir/usr/share/Apps/$_F_app_dir/.cvsignore ] && \
		Frm /usr/share/Apps/$_F_app_dir/.cvsignore
	Fln /usr/share/Apps/$F_appdir/Help /usr/share/doc/$pkgname-$pkgver
	if [ -f $Fsrcdir/$pkgname ] ; then
		Fexe /usr/bin/$pkgname
	else
		Fln /usr/share/Apps/$_F_app_dir/AppRun /usr/bin/$pkgname
	fi
}

###
# * build() just calls Froxbuild()
###
build()
{
	Froxbuild
}
