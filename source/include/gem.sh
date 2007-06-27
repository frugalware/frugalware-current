#!/bin/sh

###
# = gem.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# gem.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Ruby gem packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=actionwebservice
# pkgver=1.2.2
# pkgrel=1
# pkgdesc="Simple Support for Web Services APIs for Rails"
# url="http://rubyforge.org/projects/aws/"
# depends=('activerecord>=1.15.2' 'actionpack>=1.13.2')
# groups=('devel-extra')
# archs=('i686' 'x86_64')
# Finclude gem
# sha1sums=('2712601395ec0a059263b730b10db9f93cd5a1f1')
# --------------------------------------------------
#
# == APPENDED VARIABLES
# * ruby to depends()
# * rubygems to makedepends()
###
depends=(${depends[@]} 'ruby')
makedepends=(${makedepends[@]} 'rubygems')

###
# == OVERWRITTEN VARIABLES
# * source()
# * up2date
###
source=(http://gems.rubyforge.org/gems/"$pkgname"-"$pkgver".gem)
up2date='lynx -dump "http://rubyforge.vm.bytemark.co.uk/gems/" | grep "$pkgname-[0-9.]\+.gem$" | sed "s/.*$pkgname-\(.*\).gem.*/\1/" | Fsort | tail -n 1'

###
# == PROVIDED FUNCTIONS
# * Finstallgem()
###
Finstallgem() {
	gem install "$pkgname" --local --version "$pkgver" --install-dir . --ignore-dependencies
	cd gems/"$pkgname"-"$pkgver"
	Fpatchall
	libdir=`ruby -r rbconfig -e 'print Config::CONFIG["rubylibdir"]'`
	archdir=`ruby -r rbconfig -e 'print Config::CONFIG["archdir"]'`
	if [ -d bin ]; then
		Fmkdir /usr/bin
		cp -R bin/* "$Fdestdir"/usr/bin || Fdie
		Ffileschmod /usr/bin +x
	fi
	if [ -d lib ]; then
		Fmkdir "$libdir"
		cp -R lib/* "$Fdestdir"/"$libdir" || Fdie
	fi
	if [ -d ext ]; then
		Fmkdir "$archdir"
		cp -R ext/* "$Fdestdir"/"$archdir" || Fdie
	fi
	if [ -d doc -a -n "`ls doc`" ]; then
		Fmkdir /usr/share/doc/"$pkgname"-"$pkgver"
		if [ -d doc/"$pkgname"-"$pkgver" -a -n "`ls doc/$pkgname-$pkgver`" ]; then
			cp -R doc/"$pkgname"-"$pkgver"/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
			rm -rf doc/"$pkgname"-"$pkgver"/ || Fdie
		fi
		if [ -n "`ls doc`" ]; then
			cp -R doc/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
		fi
	fi
	mv `find . -mindepth 1 -maxdepth 1 -type f` $Fsrcdir
}

###
# * build() just calls Fxpiinstall()
###
build() {
	Finstallgem
}
