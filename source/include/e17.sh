#!/bin/sh

###
# = e17.sh(3)
# Andras Voroskoi <voroskoi@frugalware.org>
#
# == NAME
# e17.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for e17 packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=ewl
# pkgver=0.0.4.007
# pkgrel=2
# pkgdesc="EWL is a simple-to-use general purpose widget library based on the \
# 	Evas canvas for E17."
# depends=('edje>=0.5.0.033-2' 'evas>=0.9.9.033' 'ecore>=0.9.9.033-2')
# makedepends=('edb')
# groups=('e17-extra' 'e17-misc')
# archs=('i686' 'x86_64')
# Finclude e17
# sha1sums=('c003a1b0423a61a28b76aa68bde59e0f333ae6d3')
# --------------------------------------------------
###

###
# == OVERWRITTEN VARIABLES
# * url
# * source()
# * up2date
###
url="http://download.enlightenment.org/"
source=($url/snapshots/2007-06-17/$pkgname-$pkgver.tar.gz)
up2date="lynx -dump $url/snapshots/\$(lynx -dump http://download.enlightenment.org/snapshots/ |sed -ne 's#.*shots/\(.*\)#\1#;$ p') |grep /$pkgname |Flasttar"
