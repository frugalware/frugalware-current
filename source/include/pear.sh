#!/bin/sh

###
# = pear.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# pear.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for PHP PEAR packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_pear_name="MDB2"
# pkgver=2.3.0
# pkgdesc="PEAR: database abstraction layer"
# depends=('php')
# Finclude pear
# pkgrel=2
# sha1sums=('1f9b11d273352209143b5989bc65a3a73f364b3e')
# --------------------------------------------------
#
# == OPTIONS
# You need to set pkgver, pkgdesc and depends() manually from the standard
# directives and the followings:
# * _F_pear_name - name of the pear package
#
# == OVERWRITTEN VARIABLES
# * pkgname
# * pkgrel
# * url
# * groups()
# * archs()
# * up2date
# * source()
# * install
###
pkgname=php-pear-`echo $_F_pear_name|tr [A-Z] [a-z]`
[ -z "$pkgrel" ] && pkgrel=1
url="http://pear.php.net/package/$_F_pear_name"
groups=('devel-extra')
archs=('x86_64')
up2date="lynx -dump http://pear.php.net/package/$_F_pear_name|grep stable.*released|sed 's/.*\]\([^ ]*\) (.*/\1/'"
source=(http://pear.php.net/get/$_F_pear_name-$pkgver.tgz)
install=src/pear.install

###
# == APPENDED VARIABLES
# * genscriptlet to options()
###
options=(${options[@]} 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * Fbuildpear()
###
Fbuildpear()
{
	# install the package
	pear install --nodeps -R $Fdestdir $_F_pear_name-$pkgver.tgz || Fdie
	cd $Fdestdir/usr/share/pear
	Fpatchall
	cd - >/dev/null
	# remove the common files, they will be updated by the scriptlet
	Frm /usr/share/pear/{.channels,.registry,.depdb,.depdblock,.filemap,.lock} /tmp
	# the package.xml is required to update the common files
	Ffilerel package.xml /var/lib/pear/$_F_pear_name.xml
	# move the documentation to the correct location
	Fcd $_F_pear_name-$pkgver
	if [ -d docs ]; then
		Frm /usr/share/pear/doc/
		Fdocrel docs/*
	fi
	# now prepare the scriptlet
	cp $Fincdir/pear.install $Fsrcdir || Fdie
	Fsed '$_F_pear_name' "$_F_pear_name" $Fsrcdir/pear.install
}

###
# * build() just calls Fbuildskel()
###
build()
{
	Fbuildpear
}
