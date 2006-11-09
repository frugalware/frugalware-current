#!/bin/sh

# (c) 2003-2006 AlexExtreme <alex@alex-smith.me.uk>
# beryl.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for beryl packages

pkgver=0.1.2
pkgdesc="Beryl is a compositing window manager which provides lots of fancy effects on your desktop"
url="http://www.beryl-project.org/"
up2date="lynx -dump http://releases.beryl-project.org/current/ | grep $pkgname | Flasttarbz2"
srcurl="http://releases.beryl-project.org/current"
source=($srcurl/$pkgname-$pkgver.tar.bz2)
options=(${options[@]} 'force')

unset MAKEFLAGS

# optimization OK
