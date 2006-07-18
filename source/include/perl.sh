#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# perl.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for perl modules

# sanility checks
[ -z "$modname" ] && \
{
	error "No \$modname set!"
	Fdie
}
[ -z "$modauthor" ] && \
{
	error "No \$modauthor set!"
	Fdie
}

[ -z "$_F_perl_ext" ] && _F_perl_ext=".tar.gz"

url="http://cpan.org/"
up2date="lynx -dump -nolist 'http://search.cpan.org/search?query="$modname"&mode=module'|grep -m1 "$modname-"|sed -e 's/.*"$modname"-\(.*\) .*/\1/' -e 's/ .*//'"
#up2date="pud -p 'http://search.cpan.org/search?query=$(echo $modname |sed s/-/::/g)&mode=all' -e '$modname-(.*?) '"
source=(http://search.cpan.org/CPAN/authors/id/$modauthor/$modname-$pkgver$_F_perl_ext)
build()
{
	Fcd $modname-$pkgver
	Fbuild
	Frm /usr/lib/perl5/current
}

# defaults
pkgname="perl-`echo $modname|tr [A-Z] [a-z]`"
pkgrel=1
depends=(${depends[@]} 'perl')
makedepends=(${makedepends[@]} 'perl-libwww')
groups=('devel-extra')
archs=('i686')

unset _F_perl_ext
