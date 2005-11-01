#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# aspell.sh for Frugalware
# distributed under GPL License

# common up2date, source() and build() for aspell dicts

up2date="lynx -dump http://ftp.gnu.org/pub/gnu/aspell/dict/$lang/\?M=D|grep aspell6-$lang|sed -n -e \"s/aspell6-$lang-//\" -e 's/\.tar\..* / /' -e 's/-/r/' -e '1p'|cut -d ] -f 3|cut -d ' ' -f 1"
source=(ftp://ftp.gnu.org/gnu/aspell/dict/$lang/$pkgname-`echo $pkgver|sed 's/r/-/'`.tar.bz2)

build()
{
	Fcd $pkgname-`echo $pkgver|sed 's/r/-/'`
	./configure
	
	make || return 1
	
	Fmakeinstall
}
