#!/bin/sh

###
# = firefox-i18n.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# firefox-i18n.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Firefox language packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_firefox_lang=it
# pkgver=2.0
# pkgrel=1
# pkgdesc="Italian language support for Firefox"
# Finclude firefox-i18n
# sha1sums=('0b8a517c87e9e2c0143eb60f10ce0e07316eb733')
# --------------------------------------------------
#
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
# * pkgname
# * url
# * rodepends()
# * makedepends()
# * groups()
# * archs()
###

up2date="3.0"
source=(http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0/linux-i686/xpi/$_F_firefox_lang.xpi)
pkgname=firefox-`echo $_F_firefox_lang|tr [A-Z] [a-z]`
url="http://www.mozilla.org/projects/l10n/mlp.html"
rodepends=('firefox>=3.0')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
    #this method comes from gentoo (http://kambing.ui.edu/gentoo-portage/eclass/mozextension.eclass)
    cd ${Fsrcdir}		|| return 1
    local emid=$(sed -n -e '/<\?em:id>\?/!d; s/.*\([\"{].*[}\"]\).*/\1/; s/\"//g; p; q' install.rdf) || return 1
    local dstdir=${Fdestdir}/usr/lib/firefox/extensions/${emid}
    install -d ${dstdir}		|| return 1
    cp -R * ${dstdir}		|| return 1
    rm -f ${dstdir}/${_F_firefox_lang}.xpi || return 1
}
