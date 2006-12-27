#!/bin/sh

# (c) 2003-2006 AlexExtreme <alex@alex-smith.me.uk>
# beryl.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for beryl packages

if [ -z "$_F_beryl_name" ]; then
	_F_beryl_name=$pkgname
fi

pkgver=0.1.4
pkgdesc="Beryl is a compositing window manager which provides lots of fancy effects on your desktop"
url="http://www.beryl-project.org/"
up2date="lynx -dump http://releases.beryl-project.org/current/ | grep $_F_beryl_name | Flasttarbz2"
srcurl="http://releases.beryl-project.org/$pkgver"
source=($srcurl/$_F_beryl_name-$pkgver.tar.bz2)
options=(${options[@]} 'force')
_F_cd_path="$_F_beryl_name-$pkgver"

unset MAKEFLAGS

# optimization OK
