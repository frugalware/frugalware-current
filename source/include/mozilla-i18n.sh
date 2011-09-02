#! /bin/bash

Finclude i18n

###
# = mozilla-i18n.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# mozilla-i18n.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Mozilla language packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_mozilla_i18n_name=thunderbird
# pkgver=3.0
# pkgrel=1
# Finclude mozilla-i18n
# --------------------------------------------------
#
# == OPTIONS
# * _F_mozilla_i18n_name (required): The name of the Mozilla project.
# * _F_mozilla_i18n_xpidirname (optional): The directory to the xpi.
# * _F_mozilla_i18n_mirror (optional): The name of the mirror to use.
# * _F_mozilla_i18n_archive_name (optional, defaults to empty string): The name of the archive to prepend to local code.
# * _F_mozilla_i18n_ext (optional, defaults to ".xpi"): The extention of the i18n archive name.
###

if [ -z "$_F_mozilla_i18n_xpidirname" ]; then
	_F_mozilla_i18n_xpidirname="$_F_mozilla_i18n_dirname$_F_mozilla_i18n_name/releases/$pkgver/linux-i686/xpi"
fi

if [ -z "$_F_mozilla_i18n_mirror" ]; then
	_F_mozilla_i18n_mirror="ftp://ftp.mozilla.org/pub/mozilla.org"
fi

if [ -z "$_F_mozilla_i18n_ext" ]; then
	_F_mozilla_i18n_ext=".xpi"
fi

###
# == OVERWRITTEN VARIABLES
# * pkgname (if not set, defaults to $_F_mozilla_i18n_name-i18n)
# * archs()
# * groups()
# * options()
# * up2date
# * url
###
if [ -z "$pkgname" ]; then
	pkgname="$_F_mozilla_i18n_name-i18n"
fi
if [ -z "$pkdesc" ]; then
	pkgdesc="Language support for ${_F_mozilla_i18n_name^}"
fi
archs=('i686' 'x86_64' 'ppc')
groups=('locale-extra')
options=("${options[@]}" 'noversrc')
up2date="eval \"_F_archive_name=$_F_mozilla_i18n_name; Flastarchive $_F_mozilla_i18n_mirror/$_F_mozilla_i18n_dirname$_F_mozilla_i18n_name/releases/latest/source '\.source\.tar\.bz2'\""
url="http://www.mozilla.org/projects/l10n/mlp.html"

Finclude xpi

###
# == OVERWRITTEN VARIABLES
# * rodepends()
###
rodepends=("${subpackage[@]}" "$_F_mozilla_i18n_name>=$pkgver")

###
# == PROVIDED FUNCTIONS
###
mozilla_i18n_foreach_lang() {
	local lang
	for lang in "${_F_mozilla_i18n_langs[@]}"; do
		$1 $lang
	done
}

###
# * mozilla_i18n_lang_add()
###
mozilla_i18n_lang_add() {
	_F_mozilla_i18n_langs=("${_F_mozilla_i18n_langs[@]}" "$1")
	source=("${source[@]}" "$_F_mozilla_i18n_mirror/$_F_mozilla_i18n_xpidirname/$_F_mozilla_i18n_archive_name$1$_F_mozilla_i18n_ext")
	subpkgs=("${subpkgs[@]}" "$_F_mozilla_i18n_name-${1,,}")
	subdescs=("${subdescs[@]}" "`i18n_language_from_locale "$1"` language support for ${_F_mozilla_i18n_name^}") # Requires a locale to name function.
	subrodepends=("${subrodepends[@]}" "$_F_mozilla_i18n_name>=$pkgver")
	subgroups=("${subgroups[@]}" "${groups[*]}")
	subarchs=("${subarchs[@]}" "${archs[*]}")
	sha1sums=("${sha1sums[@]}" "$2")
	suboptions=("${suboptions[@]}" 'nostrip')
}

###
# * mozilla_i18n_lang_fini()
###
mozilla_i18n_lang_fini() {
	rodepends=("${rodepends[@]}" "${subpkgs[@]}")
}

mozilla_i18n_lang_install()
{
	if [ -z "$_F_xpi_product" ]; then
		_F_xpi_product="$_F_mozilla_i18n_name"
	fi

	Fxpi_installxpi "$Fsrcdir/$_F_mozilla_i18n_archive_name$1$_F_mozilla_i18n_ext"
	Fxpi_installfixes
	Fsplit $_F_mozilla_i18n_name-${1,,} /usr/lib/$_F_mozilla_i18n_name/extensions/
}

###
# * build()
###
build() {
	mozilla_i18n_foreach_lang mozilla_i18n_lang_install
}

