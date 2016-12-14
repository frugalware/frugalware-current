#!/bin/sh

###
# = texinfo.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# texinfo.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages containing texinfo documentation.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=libassuan
# pkgver=1.0.1
# pkgrel=1
# pkgdesc="Libassuan  is the IPC library used by some GnuPG related software."
# url="http://www.gnupg.org"
# depends=() # This time it's _really_ empty ;-)
# makedepends=('pth') # it must be compiled with pth for gpg-agent
# groups=('lib')
# archs=('x86_64')
# up2date="lynx -dump http://www.gnupg.org/\(en\)/download/index.html |grep libassuan.*tar |sed -n -e 's/.*n-\(.*\)\.t.*/\1/;s/-/_/;1 p'"
# source=(http://gd.tuwien.ac.at/privacy/gnupg/libassuan/libassuan-$pkgver.tar.bz2)
# Finclude texinfo
# sha1sums=('4e12bd924e01c31c7d4c021b465c94ec55b1cb17')
# --------------------------------------------------
#
# == OVERWRITTEN VARIABLES
# * install
###
install=$Fincdir/texinfo.install

###
# == APPENDED VARIABLES
# * genscriptlet to options()
###
options=(${options[@]} 'genscriptlet')
