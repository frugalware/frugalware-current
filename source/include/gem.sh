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
# archs=('x86_64')
# Finclude gem
# sha1sums=('2712601395ec0a059263b730b10db9f93cd5a1f1')
# --------------------------------------------------
#
# == OPTIONS
# * _F_gem_name (defaults to $pkgname): if you want to use a custom
# package name (for example the upstream name contains uppercase letters) then
# use this to declare the real name
###
if [ -z "$_F_gem_name" ]; then
	_F_gem_name=$pkgname
fi

###
# == APPENDED VARIABLES
# * ruby to depends()
# * rubygems to makedepends()
###
depends=(${depends[@]} 'ruby>=3.0.0')

###
# == OVERWRITTEN VARIABLES
# * source()
# * up2date
###
source=(http://rubygems.org/downloads/"$_F_gem_name"-"$pkgver".gem)
up2date='lynx -dump http://rubygems.org/gems/$_F_gem_name | grep downloads/$_F_gem_name | sed "s/.*$_F_gem_name-\(.*\).gem.*/\1/"'

###
# == PROVIDED FUNCTIONS
# * Finstallgem()
###
Finstallgem() {
	local _gemdir="$(ruby -e 'puts Gem.default_dir')"

	Fexec gem install "$_F_gem_name" --local --version "$pkgver" --install-dir "${Fdestdir}/$_gemdir" \
		-n "${Fdestdir}/usr/bin" --ignore-dependencies --verbose || Fdie
}

###
# * build() just calls Finstallgem()
###
build() {
	Finstallgem
}
