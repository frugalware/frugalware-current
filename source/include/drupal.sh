#!/bin/sh

###
# = drupal.sh(3)
# CSÉCSY László <boobaa@frugalware.org>
#
# == NAME
# drupal.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for drupal module packages.
#
# == EXAMPLE
# --------------------------------------------------
# # Compiling Time: 0 SBU
# # Maintainer: CSÉCSY László <boobaa@frugalware.org>
#
# _F_drupal_module=image
# pkgver=5.x_1.6
# pkgrel=1
# pkgdesc="Allow users with proper permissions to upload images into Drupal"
# Finclude drupal
# sha1sums=('7ee3232930abdf07e130ee0a4eb66bb8fb025dc1')
# --------------------------------------------------
#
# == OPTIONS
# * _F_drupal_module: the name of the module
# * _F_drupal_ver (defaults to 5.x): the module is made for this version of Drupal
# * _F_drupal_dev (defaults to 0): set to 1 for -dev modules
###
[ -z "$_F_drupal_ver" ] && _F_drupal_ver=5.x
[ -z "$_F_drupal_dev" ] && _F_drupal_dev=0

###
# == OVERWRITTEN VARIABLES
# * pkgname
# * url
# * rodepends()
# * groups()
# * archs()
# * up2date
# * source()
# * options()
###
pkgname=drupal-$_F_drupal_module
url="http://drupal.org/project/$_F_drupal_module"
rodepends=('drupal>=5.0' ${rodepends[@]})
groups=('network-extra')
archs=('i686' 'x86_64')
if [ $_F_drupal_dev == 0 ]; then
	up2date="lynx -dump http://drupal.org/project/$_F_drupal_module | grep 'http://.*$_F_drupal_ver.*[^v]\.tar\.gz' | sed 's/.*$_F_drupal_module-\(.*\)\.tar.*/\1/;y/-/_/'"
	source=(http://ftp.drupal.org/files/projects/$_F_drupal_module-${pkgver//_/-}.tar.gz)
else
#	up2date="lynx -dump http://drupal.org/project/$_F_drupal_module | grep '$_F_drupal_ver.*-dev[0-9][0-9]\]Download' | sed 's/.*$_F_drupal_module-\(.*\)\.tar.*/\1/;s/-/_/'"
	up2date="lynx -dump http://drupal.org/project/$_F_drupal_module | grep '$_F_drupal_ver.*-dev.*[0-9][0-9]\]Download' | sed 's/.*]\($_F_drupal_ver-[^ ]*\) \+\([0-9]\{4\}-.\{3\}-[0-9][0-9]\).*/\1\2/;s/-Jan-/01/;s/-Feb-/02/;s/-Mar-/03/;s/-Apr-/04/;s/-May-/05/;s/-Jun-/06/;s/-Jul-/07/;s/-Aug-/07/;s/-Sep-/09/;s/-Oct-/10/;s/-Nov-/11/;s/-Dec-/12/;y/-/_/'"
	filever=${pkgver//_dev*/_dev}
	source=(http://ftp.drupal.org/files/projects/$_F_drupal_module-${filever//_/-}.tar.gz)
fi
options=('stick' 'nodocs')

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
	Fmkdir var/www/drupal/sites/all/modules
	mv $Fsrcdir/$_F_drupal_module $Fdestdir/var/www/drupal/sites/all/modules/$_F_drupal_module
}
