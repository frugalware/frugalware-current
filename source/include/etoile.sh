#!/bin/sh

###
# = etoile.sh(3)
# Priyank Gosalia <priyankmg@gmail.com>
#
# == NAME
# etoile.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Etoile packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=etoile-foundation
# pkgver=0.4.1
# pkgrel=1
# pkgdesc="Etoile Core Framework"
# _F_etoile_type="Frameworks"
# _F_etoile_name="EtoileFoundation"
# Finclude etoile
# depends=()
# archs=('i686')
# --------------------------------------------------
#
# == OPTIONS
# * _F_etoile_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name

###

if [ -z $_F_etoile_name ] ; then
	_F_etoile_name=$pkgname
fi

if [ -z $_F_etoile_type ] ; then
	_F_etoile_type="Framework"
fi

_F_archive_name=Etoile-$pkgver.tar.gz

###
# == OVERWRITTEN VARIABLES
# * url
# * groups
# * up2date
# * source()
# * _F_cd_path
###

Finclude gnustep
groups=('etoile-extra')
url="http://www.etoile-project.org/"
up2date="lynx -dump http://etoileos.com/downloads/ | grep tar.gz -m1 | sed 's/.*e-\(.*\).t.*/\1/'"
source=(http://download.gna.org/etoile/etoile-${pkgver}.tar.gz)
_F_cd_path="Etoile-${pkgver}"

Fetoile_init()
{
	Fcd
	Fsed '-Werror' '' etoile.make
	cd ${_F_etoile_type}/${_F_etoile_name} || Fdie
	Fgnustep_init
}

Fetoile_build()
{
	Fetoile_init
	make || Fdie
	make DESTDIR=$Fdestdir install || Fdie
}

build()
{
	Fetoile_build
}
