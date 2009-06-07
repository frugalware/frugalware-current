#!/bin/sh

###
# = opensync.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# opensync.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for OpenSync packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=libopensync-plugin-kdepim
# pkgver=0.22
# pkgrel=1
# pkgdesc="file-sync plugin for opensync"
# Finclude opensync
# depends=('libopensync' 'kdepim>=3.5.9')
# groups=('kde-extra')
# archs=('i686' 'x86_64')
# sha1sums=('591fa5ebdaa87bb75fe557156bb09d8bbffd2ebd')
# --------------------------------------------------
###


###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source
###

url="http://www.opensync.org"
# Note: there is no way to really get the up2date of the _next_ stable release
# it will be 0.4x but this has to be monitored by the maintainers of these packages
up2date="Flasttar http://opensync.org/wiki/releases/0.2x/download"
source=($url/download/releases/$pkgver/$pkgname-$pkgver.tar.bz2)

###
# == APPENDED VARIABLES
# * scriptlet to options()
###

options=(${options[@]} 'scriptlet')

###
# == PROVIDED FUNCTIONS
# * Fbuild_opensync()
###

Fbuild_opensync()
{
	Fcd
	Fpatchall
        Fsed '-Werror' '' src/Makefile.am
        Fautoreconf
        Fmake
	Fmakeinstall

}


###
# * build(): just calls Fbuild_opensync()
###

build()
{
        Fbuild_opensync
}

