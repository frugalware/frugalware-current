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
# archs=('x86_64')
# sha1sums=('81e711b5f00816c57e205c9e60f69237c709679d')
# --------------------------------------------------
#
# == OPTIONS
# * _F_fonts_subdir: specifies the directory to install fonts to
###
if [ -n "$_F_fonts_subdir" ]; then
	_F_fonts_dir="/usr/share/fonts/X11/$_F_fonts_subdir"
	_F_fonts_dirs=($_F_fonts_dir)
fi

###
# == OVERWRITTEN VARIABLES
# * _F_genscriptlet_install
# * _F_cd_path
###
_F_genscriptlet_install="$Fincdir/fonts.install"
_F_cd_path='.'

###
# == APPENDED VARIABLES
# * makedepends
# * depends
# * rodepends
# * _F_genscriptlet_hooks
###
makedepends=(${makedepends[@]} 'bdftopcf')
depends=(${depends[@]} 'mkfontdir')
rodepends=(${rodepends[@]} 'mkfontscale' 'fontconfig')
_F_genscriptlet_hooks=(${_F_genscriptlet_hooks[@]} 'fonts_genscriptlet_hook')

Finclude genscriptlet

###
# == PROVIDED FUNCTIONS
# * fonts_genscriptlet_hook
# * Fbuild_fonts
###
fonts_genscriptlet_hook()
{
	Freplace '_F_fonts_dirs' "$1"
}

Fbuild_fonts() {
	Fcd

	# find and install all font extensions we support
	for i in `find -iregex '.*\.\(spd\|bdf\|ttf\|otf\|pcf\|pcf.gz\|afm\|pfa\)'`; do
		if [ -z "$_F_fonts_subdir" ]; then
			case $i in
				*.ttf)    _F_fonts_dir='/usr/share/fonts/X11/TTF'    ;;
				*.otf)    _F_fonts_dir='/usr/share/fonts/X11/OTF'    ;;
				*.afm)    _F_fonts_dir='/usr/share/fonts/X11/Type1'  ;;
				*.pfa)    _F_fonts_dir='/usr/share/fonts/X11/Type1'  ;;
				*.spd)    _F_fonts_dir='/usr/share/fonts/X11/Speedo' ;;
				*.bdf)    _F_fonts_dir='/usr/share/fonts/X11/misc'   ;;
				*.pcf)    _F_fonts_dir='/usr/share/fonts/X11/misc'   ;;
				*.pcf.gz) _F_fonts_dir='/usr/share/fonts/X11/misc'   ;;
			esac
			if ! echo "${_F_fonts_dirs[@]}" | grep -q "$_F_fonts_dir"; then
				_F_fonts_dirs=(${_F_fonts_dirs[@]} $_F_fonts_dir)
			fi
		fi
		Ffilerel "$i" "$_F_fonts_dir/`basename $i`"
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

	Fgenscriptlet
}

###
# * build() just calls Fbuild_fonts
###
build() {
	Fbuild_fonts
}
