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
makedepends=("${makedepends[@]}" 'unzip' 'xmlstarlet')
if [ -z "$_F_xpi_productver" ]; then
	rodepends=("${rodepends[@]}" "$_F_xpi_product")
else
	rodepends=("${rodepends[@]}" "$_F_xpi_product>=$_F_xpi_productver")
fi

###
# == PROVIDED FUNCTIONS
# * Fxpi_get(): Extract data in the install rdf. Arguments: 1) Path to the xpi
# file. 2) XPATH request to the wanted information.
###
Fxpi_get()
{
	# http://kb.mozillazine.org/Determine_extension_ID
	# xml is provided by xmlstarlet
	# sed removes empty lines (usefull for wrongly formated files)
	unzip -qc $1 install.rdf | \
		sed '/^\s*$/d' | \
		xml sel -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
		-N em=http://www.mozilla.org/2004/em-rdf# -t -v "$2"
}

###
# * Fxpi_id(): Extract the extension id of a given xpi. Arguments: 1) Path to
# the xpi file.
###
Fxpi_id()
{
	# http://kb.mozillazine.org/Determine_extension_ID
	local id

	id=`Fxpi_get "$1" "//rdf:Description[@about='urn:mozilla:install-manifest']/em:id"`
	if [ -z "$id" ]; then
		# Variant used by language pack at least
		id=`Fxpi_get "$1" "//rdf:Description[@about='urn:mozilla:install-manifest']/@em:id"`
	fi
	if [ -z "$id" ]; then
		error "identifier not found in $1"
		Fdie
	fi
	echo -n "$id"
}

###
# * Fxpi_installxpi(): Arguments: 1) xpi to install.
###
Fxpi_installxpi()
{
	local id=`Fxpi_id "$1"`

	Fmkdir "${_F_xpi_installpath}"
	Fcprel "$1" "${_F_xpi_installpath}/${id}.xpi"
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
