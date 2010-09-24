#!/bin/sh

###
# = fonts.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# fonts.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for font packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=artwiz-fonts
# pkgver=1.3
# pkgrel=3
# pkgdesc="A set of fonts known as artwiz."
# _F_sourceforge_name=artwiz-aleczapka-en
# _F_sourceforge_dirname=artwizaleczapka
# _F_sourceforge_ext=.tar.bz2
# _F_sourceforge_realname=iso-8859-1
# _F_fonts_subdir="TTF"
# Finclude sourceforge fonts
# groups=('xlib-extra')
# archs=('i686' 'x86_64')
# sha1sums=('81e711b5f00816c57e205c9e60f69237c709679d')
# --------------------------------------------------
#
# == OPTIONS
# * _F_fonts_subdir (required): specifies the directory to install fonts to
###
if [ -z "$_F_fonts_subdir" ]; then
	error '$_F_fonts_subdir is not defined.'
  Fdie
fi

_F_fonts_dir="/usr/share/fonts/X11/$_F_fonts_subdir"

###
# == OVERWRITTEN VARIABLES
# * install
# * _F_cd_path
###
install="src/fonts.install"
_F_cd_path='.'

###
# == APPENDED VARIABLES
# * makedepends
# * rodepends
# * options
###
makedepends=(${makedepends[@]} 'bdftopcf')
rodepends=(${rodepends[@]} 'mkfontscale' 'mkfontdir' 'fontconfig')
options=(${options[@]} 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * Fbuild_fonts
###
Fbuild_fonts() {

	# find and install all font extensions we support
	for i in `find -iregex '.*\.\(spd\|bdf\|ttf\|otf\|pcf\|pcf.gz\|afm\|pfa\)'`; do
		Ffile "$i" "$_F_fonts_dir/`basename $i`"
	done

	# find any BDF fonts and convert them
	for i in `find "$Fdestdir" -name "*.bdf"`; do
    		Fmessage "Converting BDF font to PCF font: $i"
    		bdftopcf -t "$i" -o "${i/bdf/pcf}" || Fdie
		rm -f "$i" || Fdie
	done

	# find any uncompressed PCF fonts and compress them
	for i in `find "$Fdestdir" -name "*.pcf"`; do
		Fmessage "Compressing PCF font: $i"
		gzip -9 "$i" || Fdie
	done

	# generate the install script
	cp "$Fincdir/fonts.install" "$Fsrcdir" || Fdie
	Fsed '$_F_fonts_dir' "$_F_fonts_dir" "$Fsrcdir/fonts.install"

}

###
# * build() just calls Fbuild_fonts
###
build() {
	Fbuild_fonts
}
