#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# aspell.sh for Frugalware
# distributed under GPL License

# common pkgname, url, depends, groups, archs, up2date, source() and build()
# for aspell dicts

[ -z "$_F_aspell_ver" ] && _F_aspell_ver=6

pkgname=aspell$_F_aspell_ver-$lang
url="http://aspell.net/"
depends=('aspell>=0.60')
groups=('locale-extra')
archs=('i686' 'x86_64')
up2date="lynx -dump http://ftp.gnu.org/pub/gnu/aspell/dict/$lang/\?M=D|grep aspell$_F_aspell_ver-$lang|sed -n -e \"s/aspell$_F_aspell_ver-$lang-//\" -e 's/\.tar\..* / /' -e 's/-/r/' -e '1p'|cut -d ] -f 3|cut -d ' ' -f 1"
source=(ftp://ftp.gnu.org/gnu/aspell/dict/$lang/$pkgname-${pkgver/r/-}.tar.bz2)

build()
{
	Fcd $pkgname-${pkgver/r/-}
	./configure
	
	make || return 1
	
	Fmakeinstall
}

unset _F_aspell_ver
