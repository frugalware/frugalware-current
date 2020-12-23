#!/bin/sh

###
# = haskell.sh(3)
# Rhyhann/Othmane Benkirane <eo-at-rhyhann.net>
#
# == NAME
# haskell.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Haskell packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=haskell-x11
# pkgver=1.4.2
# pkgrel=1
# pkgdesc="A Haskell binding to the X11 graphics library."
# archs=('x86_64')
# url="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/X11"
# groups=('xlib-extra')
# sha1sums=('28f5a257b9f601538822f47c9731b6e20618fbcf')
# _F_cd_path=X11-$pkgver
# _F_haskell_name='X11'
# Finclude haskell
# --------------------------------------------------
#
# == OPTIONS
# * _F_haskell_name (defaults to $pkgname): Haskell name in hackage.haskell.org
# repository
# * _F_haskell_install (defaults to src/haskell.install): Install file
# * _F_haskell_ext (defaults to tar.gz): Package extension
# * _F_haskell_sep (defaults to -): Package separation string
# * _F_haskell_prefix: Package prefix (not package version prefix)
# * _F_haskell_register_dir: Register directory
# * _F_haskell_confopts: Configure options for Haskell package.
###
# General variables
if [ -z "$_F_haskell_name" ]; then
	_F_haskell_name=${pkgname##haskell-}
fi
if [ -z "$_F_haskell_install" ]; then
	_F_haskell_install="src/haskell.install"
fi
# Download variables
if [ -z "$_F_haskell_ext" ]; then
	_F_haskell_ext=".tar.gz"
fi
if [ -z "$_F_haskell_sep" ]; then
	_F_haskell_sep="-"
fi
if [ -z "$_F_haskell_prefix" ]; then
	_F_haskell_prefix=""
fi
# Compile variables
if [ -z "$_F_haskell_register_dir" ]; then
	_F_haskell_register_dir="$pkgname"
fi
if [ -z "$_F_haskell_confopts" ]; then
	_F_haskell_confopts=" --ghc --prefix=/usr --libsubdir=\$compiler/site-local/\$pkgid"
fi
if [ -z "$_F_haskell_setup" ]; then
	_F_haskell_setup="Setup.lhs"
fi
###
# == OVERWRITTEN VARIABLES
# * install
# * url
# * up2date
# * source
###

url="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/$_F_haskell_name"
[ -n "$_F_archive_name" ] || _F_archive_name="$_F_haskell_name"
up2date="Flasttar http://hackage.haskell.org/cgi-bin/hackage-scripts/package/$_F_haskell_name"
source=(http://hackage.haskell.org/packages/archive/${_F_haskell_name}/${pkgver}/${_F_haskell_prefix}${_F_haskell_name}${_F_haskell_sep}${pkgver}${_F_haskell_ext})
install=$_F_haskell_install

###
# == APPENDED VARIABLES
# * options: add genscriptlet to options=()
# * makedepends: ghc to makedepends=()
###
options+=('scriptlet' 'genscriptlet')
makedepends+=('ghc>=8.10.3' 'ghc-docs>=8.10.3')

###
# == PROVIDED FUNCTIONS
# * Fbuild_haskell_regscripts: Builds & bopy register scripts
# * Fbuild_haskell: Builds the software
# * build(): just calls Fbuild_haskell
###

Fbuild_haskell_regscripts() {
  cp $Fincdir/haskell.install $Fsrcdir
  Fsed '$_F_haskell_register_dir' "$_F_haskell_register_dir" ${Fsrcdir%/src}/$_F_haskell_install
  runhaskell $_F_haskell_setup register --gen-script
  runhaskell $_F_haskell_setup unregister --gen-script

  Fexerel register.sh /usr/share/haskell/$_F_haskell_register_dir/register.sh
  Fexerel unregister.sh usr/share/haskell/$_F_haskell_register_dir/unregister.sh
}
Fbuild_haskell() {
  Fcd
  Fpatchall
  runhaskell $_F_haskell_setup configure $_F_haskell_confopts || Fdie
  runhaskell $_F_haskell_setup haddock || Fdie
  runhaskell $_F_haskell_setup build || Fdie
  Fbuild_haskell_regscripts
  runhaskell $_F_haskell_setup copy --destdir=$Fdestdir
}
build() {
  Fbuild_haskell
}
