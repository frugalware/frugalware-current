#!/bin/sh

###
# = xpi.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# xpi - for Frugalware
#
# == SYNOPSIS
# Common schema for XPI (XPCOMM Mozilla extension) packages.
#
# == EXAMPLE
# There is no real example for now. This package is mostly intented to be used by
# other helpers.
#
# == OPTIONS
# * _F_xpi_pkgname (REQUIRED): name of the extension.
# * _F_xpi_ext (APTIONAL): extension of the xpi archive (defaults to ".xpi").
# * _F_xpi_num: number assigned by mozilla website (if not set, url,
# up2date, and source must be manually set)
# * _F_xpi_product (REQUIRED): name of the product this xpi extends (ex: Firefox).
# * _F_xpi_productver (OPTIONAL): required version of the product this xpi extends.
# * _F_xpi_installpath (OPTIONAL): where the xpi will be installed.
#
# == OVERWRITTEN VARIABLES
# * pkgname (if not set, defaults to $_F_xpi_product-$_F_xpi_pkgname)
## * groups()
## * archs()
## * url (only if _F_xpi_num is set)
## * up2date (only if _F_xpi_num is set)
## * source (only if _F_xpi_num is set)
###
: ${_F_xpi_ext='.xpi'} \
  ${pkgname="$_F_xpi_product-$_F_xpi_pkgname"}
groups=("${groups[@]}" "$_F_xpi_product-extensions")
archs=('x86_64')

if [ -n "$_F_xpi_num" ]; then
	: ${url="https://addons.mozilla.org/en-US/$_F_xpi_product/addon/$_F_xpi_pkgname/"} \
	  ${up2date="curl -s -k '$url' | sed -n 's|.*Version \(\S*\)<.*|\1|p'"}
	source=("http://releases.mozilla.org/pub/mozilla.org/addons/$_F_xpi_num/$_F_xpi_pkgname-$pkgver$_F_xpi_ext")
fi

###
# == APPENDED VARIABLES
# * makedepends
# * rodepends()
###
makedepends=("${makedepends[@]}" 'unzip')
if [ -z "$_F_xpi_productver" ]; then
	rodepends=("${rodepends[@]}" "$_F_xpi_product")
else
	rodepends=("${rodepends[@]}" "$_F_xpi_product>=$_F_xpi_productver")
fi

###
# == PROVIDED FUNCTIONS
###

###
# * Fxpi_installxpi(): Arguments: 1) xpi to install.
###
Fxpi_installxpi()
{

	local lang_id full_id
	lang_id=$(unzip -qc $1 manifest.json | grep langpack_id | sed 's/.*: "\(.*\).*",.*/\1/')
       if [ -z "$_F_xpi_rdf" ]; then
               ## new ff style
               lang_id=$(unzip -qc $1 manifest.json | grep langpack_id | sed 's/.*: "\(.*\).*",.*/\1/')
       else
               # old way used by tbird ..
               lang_id=$(unzip -qc $1 install.rdf | grep -m1 'em:id=' | sed 's/.*="\(.*\)".*/\1/')
       fi
	
	if [ -z $lang_id ]; then
		error "identifier not found in $1"
		Fdie
	fi

       if [ -z "$_F_xpi_rdf" ]; then
               full_id="langpack-$lang_id@${_F_xpi_product}.mozilla.org"
       else
               full_id="$lang_id"
       fi

	Fmkdir "${_F_xpi_installpath}"
	Fcprel "$1" "${_F_xpi_installpath}/${full_id}.xpi"
}

###
# Fxpi_installfixes(): Various post install fixes.
###
Fxpi_installfixes()
{
	Fdirschmod  "${_F_xpi_installpath}" 755
	Ffileschmod "${_F_xpi_installpath}" 644
}

###
# * Fxpi_install()
###
Fxpi_install()
{
	: ${_F_xpi_installpath="/usr/lib/$_F_xpi_product/extensions/"}

	Fxpi_installxpi "$_F_xpi_pkgname-$pkgver$_F_xpi_ext"
	Fpatchall
	Fxpi_installfixes
}

###
# * build() just calls Fxpi_install()
###
build()
{
	Fxpi_install
}
