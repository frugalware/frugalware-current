#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# perl.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for perl modules

# sanility checks
[ -z "$_F_perl_name" ] && \
{
	error "No \$_F_perl_name set!"
	Fdie
}
[ -z "$_F_perl_author" ] && \
{
	error "No \$_F_perl_author set!"
	Fdie
}

[ -z "$_F_perl_ext" ] && _F_perl_ext=".tar.gz"

[ -z "$_F_perl_sourcename" ] && _F_perl_sourcename="$_F_perl_name"

[ -z "$_F_perl_url" ] && _F_perl_url="ftp://cpan.org/authors/id/"

[ -z "$_F_perl_no_url" ] && url="http://cpan.org/"
[ -z "$_F_perl_no_up2date" ] && up2date="lynx -dump -nolist 'http://search.cpan.org/search?query="$_F_perl_name"&mode=module'|grep -m1 "$_F_perl_name-"|sed -e 's/.*"$_F_perl_name"-\(.*\) .*/\1/' -e 's/ .*//'"
[ -z "$_F_perl_no_source" ] && source=($_F_perl_url$_F_perl_author/$_F_perl_sourcename-$pkgver$_F_perl_ext)
[ -z "$_F_cd_path" ] && _F_cd_path="$_F_perl_sourcename-$pkgver"

build()
{
	Fcd $_F_cd_path
	Fbuild
	Frm /usr/lib/perl5/current
}

# defaults
pkgname="perl-`echo $_F_perl_name|tr [A-Z] [a-z]`"
[ -z "$pkgrel" ] && pkgrel=1
depends=(${depends[@]} 'perl')
makedepends=(${makedepends[@]} 'perl-libwww')
groups=('devel-extra')
archs=('i686')
