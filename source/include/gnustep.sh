#!/bin/sh

###
# = gnustep.sh(3)
# Priyank Gosalia <priyankmg@gmail.com>
#
# == NAME
# gnustep.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for GNUstep packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=gnustep-make
# pkgver=2.0.6
# pkgrel=1
# pkgdesc="The GNUstep make utilities"
# archs=('i686' 'x86_64')
# Finclude gnustep
# sha1sums=('86eab53a01b16dee695002dd22981b55a16cc085')
# --------------------------------------------------
#
# == OPTIONS
# * _F_gnustep_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name

###

if [ -z $_F_gnustep_name ] ; then
	_F_gnustep_name=$pkgname
fi

if [ -z $_F_gnustep_category ] ; then
	_F_gnustep_category="core"
fi

_F_archive_name=$_F_gnustep_name

_F_GNUSTEP_BASE="/usr/lib/GNUstep"
_F_GNUSTEP_LOCAL="$_F_GNUSTEP_BASE/Local/Library"
_F_GNUSTEP_SYSTEM="$_F_GNUSTEP_BASE/System/Library"

###
# == OVERWRITTEN VARIABLES
# * url
# * groups
# * up2date
# * makedepends
# * depends
# * groups
# * source()
###

Fprefix="/usr/lib/GNUstep"
makedepends=('gcc-objc' 'libffi')
depends=('gnustep-make>=2.2.0' 'libobjc>=4.4.0-6')
groups=('gnustep-extra')
url="http://www.gnustep.org/"
dlurl="http://ftpmain.gnustep.org/pub/gnustep/$_F_gnustep_category/"
up2date="lynx -dump $url/resources/downloads.php | grep '${_F_gnustep_name}-\(.*\).tar.gz' | head -n1 | Flasttar"
source=($dlurl/${_F_gnustep_name}-${pkgver}.tar.gz)

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
options=(${options[@]} 'scriptlet')

Fgnustep_init()
{
	Fmessage "sourcing /etc/profile.d/GNUstep.sh"
	if [ ! $_F_gnustep_name == "gnustep-make" ]; then
		source /etc/profile.d/GNUstep.sh || Fdie
	fi
	Fprefix="/usr/lib/GNUstep"
	Fconfopts="--prefix=$Fprefix"
}

Fgnustep_build()
{
	Fgnustep_init
	Fconf
	make || Fdie
	make DESTDIR=$Fdestdir install || Fdie
}

build()
{
	Fgnustep_build
}

