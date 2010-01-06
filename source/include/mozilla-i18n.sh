#! /bin/bash

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
# * _F_mozilla_i18n_mirror (optional): The name of the mirror to use.
###

if [ -z "$_F_mozilla_i18n_mirror" ]; then
	_F_mozilla_i18n_mirror=ftp://ftp.mozilla.org/pub/mozilla.org
fi

###
# == OVERWRITTEN VARIABLES
# * pkgname (if not set, defaults to $_F_mozilla_i18n_name-i18n)
# * up2date
# * url
# * options()
# * depends()
# * makedepends()
# * groups()
# * archs()
###
if [ -z "$pkgname" ]; then
	pkgname=$_F_mozilla_i18n_name-i18n
fi
if [ -z "$pkdesc" ]; then
	pkgdesc="Language support for ${_F_mozilla_i18n_name^}"
fi
up2date="eval \"_F_archive_name=$_F_mozilla_i18n_name; Flastarchive $_F_mozilla_i18n_mirror/$_F_mozilla_i18n_name/releases/latest/source '\.source\.tar\.bz2'\""
url="http://www.mozilla.org/projects/l10n/mlp.html"
options=('noversrc')
rodepends=("$_F_mozilla_i18n_name>=$pkgver" "${subpackage[@]}")
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64' 'ppc')

###
# == PROVIDED FUNCTIONS
###
mozilla_i18n_foreach_lang() {
	local lang
	for lang in `ls *.xpi 2>/dev/null | sed s/\.xpi// | sort`; do
		$1 $lang
	done
}

mozilla_i18n_lang_add() {
	source=("${source[@]}" "$_F_mozilla_i18n_mirror/$_F_mozilla_i18n_name/releases/$pkgver/linux-i686/xpi/$1.xpi")
	subpkgs=("${subpkgs[@]}" "$_F_mozilla_i18n_name-${1,,}")
	subdescs=("${subdescs[@]}" "${1} language support for ${_F_mozilla_i18n_name^}") # Requires a locale to name function.
	subrodepends=("${subrodepends[@]}" "$_F_mozilla_i18n_name>=$pkgver")
	subgroups=("${subgroups[@]}" "${groups[*]}")
	subarchs=("${subarchs[@]}" "${archs[*]}")
	sha1sums=("${sha1sums[@]}" "$2")
}

mozilla_i18n_lang_fini() {
	rodepends=("${rodepends[@]}" "${subpkgs[@]}")
}

mozilla_i18n_lang_install()
{
	unzip -qqo $1.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/$_F_mozilla_i18n_name/chrome/$1.manifest
	Ffilerel chrome/$1.jar /usr/lib/$_F_mozilla_i18n_name/chrome/$1.jar

	Fdirschmod  /usr/lib/$_F_mozilla_i18n_name 755
	Ffileschmod /usr/lib/$_F_mozilla_i18n_name 644
	Fsplit $_F_mozilla_i18n_name-${1,,} /usr/lib/$_F_mozilla_i18n_name
}

###
# * build()
###
build() {
	mozilla_i18n_foreach_lang mozilla_i18n_lang_install
}

###
# == UTILITY FUNCTIONS
###
mozilla_i18n_lang_describe()
{
	echo "mozilla_i18n_lang_add \"$1\" '$(sha1sum $lang.xpi | awk '{print $1}')'"
}

if [ "$1" = "regen" ]; then
	Finclude() { false; } # Make FrugalBuild sourcing silent
	source ./FrugalBuild

	if [ -z "$_F_mozilla_i18n_name" -o -z "$pkgver" ]; then
		echo "_F_mozilla_i18n_name and pkgver must be defined in your FrugalBuid"
		exit 1;
	fi

	rm -rf *.xpi
	wget -r -nd $_F_mozilla_i18n_mirror/$_F_mozilla_i18n_name/releases/$pkgver/linux-i686/xpi/

sed -i -r "/^mozilla_i18n_lang_(add|fini)/d" FrugalBuild
	mozilla_i18n_foreach_lang mozilla_i18n_lang_describe >> FrugalBuild
	echo "mozilla_i18n_lang_fini" >> FrugalBuild
fi
