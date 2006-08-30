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

[ -z "$_F_perl_sourcename" ] && _F_perl_sourcename="$modname"

[ -z "$_F_perl_url" ] && _F_perl_url="ftp://cpan.org/authors/id/"

url="http://cpan.org/"
up2date="lynx -dump -nolist 'http://search.cpan.org/search?query="$modname"&mode=module'|grep -m1 "$modname-"|sed -e 's/.*"$modname"-\(.*\) .*/\1/' -e 's/ .*//'"
source=($_F_perl_url$modauthor/$_F_perl_sourcename-$pkgver$_F_perl_ext)

build()
{
	Fcd $modname-$pkgver
	Fbuild
	Frm /usr/lib/perl5/current
}

# defaults
pkgname="perl-`echo $modname|tr [A-Z] [a-z]`"
[ -z "$pkgrel" ] && pkgrel=1
depends=(${depends[@]} 'perl')
makedepends=(${makedepends[@]} 'perl-libwww')
groups=('devel-extra')
archs=('i686')

unset _F_perl_ext _F_perl_url
