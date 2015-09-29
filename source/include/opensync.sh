#!/bin/sh

Finclude cmake
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
# pkgname=libopensync-plugin-file
# pkgver=0.39
# pkgrel=1
# pkgdesc="file-sync plugin for opensync"
# Finclude opensync
# depends=('libopensync>=0.39' 'zlib' 'libxslt')
# groups=('lib')
# archs=('i686' 'x86_64')
# sha1sums=('bbb540f954d0bb51b1126937ec3a2b4b9c5c297b')
# --------------------------------------------------
###


###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source
###

url="http://www.opensync.org"
#up2date="Flasttar http://opensync.org/download/releases/0.39/"
up2date="0.39"
source=($url/download/releases/$pkgver/$pkgname-$pkgver.tar.bz2)

###
# == APPENDED VARIABLES
# * scriptlet to options()
# * cmake to makedepends()
###

options=("${options[@]}" 'scriptlet')
makedepends=("${makedpends[@]}" 'cmake')

###
# == PROVIDED FUNCTIONS
# * Fbuild_opensync()
###

Fbuild_opensync()
{
	CMake_build

}


###
# * build(): just calls Fbuild_opensync()
###

build()
{
        Fbuild_opensync
}

