#!/bin/sh

###
# = perl.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# perl.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Perl CPAN packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_perl_name=Pod-Simple
# _F_perl_author=A/AR/ARANDAL
# pkgver=3.04
# pkgdesc="framework for parsing Pod"
# depends=('perl-pod-escapes')
# Finclude perl
# pkgrel=1
# archs=('i686' 'x86_64')
# sha1sums=('45646ac806b91b37caadf0b08ce71d3f6ef2a60c')
# --------------------------------------------------
#
# == OPTIONS
# * _F_perl_name: name of the CPAN module
# * _F_perl_author: name of the module author
# * _F_perl_ext (defaults to .tar.gz): extension of the source tarball
# * _F_perl_sourcename (defaults to _F_perl_name): name of the source tarball
# without pkgver and _F_perl_ext
# * _F_perl_url (defaults to http://search.cpan.org/CPAN/authors/id/)
# * _F_perl_no_url: if set, don't overwrite $url
# * _F_perl_no_up2date: if set, don't set $up2date
# * _F_perl_no_source: if set, don't set $source()
###
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
[ -z "$_F_perl_url" ] && _F_perl_url="http://search.cpan.org/CPAN/authors/id/"
[ -z "$_F_perl_no_url" ] && url="http://cpan.org/"
[ -z "$_F_perl_no_up2date" ] && up2date="lynx -dump -nolist 'http://search.cpan.org/search?query="$_F_perl_name"&mode=module'|grep -m1 "$_F_perl_sourcename-"|sed -e 's/.*"$_F_perl_sourcename"-\(.*\) .*/\1/' -e 's/ .*//'"
[ -z "$_F_perl_no_source" ] && source=($_F_perl_url$_F_perl_author/$_F_perl_sourcename-$pkgver$_F_perl_ext)

###
# == OVERWRITTEN VARIABLES
# * _F_cd_path (if not set)
# * pkgname
# * pkgrel (if not set)
# * depends()
# * makedepends()
# * groups()
# * archs()
###
[ -z "$_F_cd_path" ] && _F_cd_path="$_F_perl_sourcename-$pkgver"
pkgname="perl-`echo $_F_perl_name|tr [A-Z] [a-z]`"
[ -z "$pkgrel" ] && pkgrel=1
depends=(${depends[@]} 'perl>=5.14.1')
groups=('devel-extra')
archs=('i686')

###
# == PROVIDED FUNCTIONS
# * Fbuild_perl(): improves build() to make use of these functions
###
Fbuild_perl()
{
	Fcd $_F_cd_path
	Fbuild
	Frm /usr/lib/perl5/current
}

###
# * build() just calls Fbuild_perl()
###
build() {
	Fbuild_perl
}
