#!/bin/sh

###
# = octave.sh(3)
# Andras Voroskoi <voroskoi@frugalware.org>
#
# == NAME
# octave.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for octave packages.
#
# == EXAMPLE
# --------------------------------------------------
# FIXME
# --------------------------------------------------
###

###
# == APPENDED VARIABLES
# * octave-forge to groups()
# * octave-forge to conflicts()
###

groups=(${groups[@]} 'octave-forge')
# remove after 0.9 release
conflicts=(${conflicts[@]} 'octave-forge')

###
# == OVERWRITTEN VARIABLES
# * _F_cd_path 
# * up2date
###

_F_cd_path="${_F_sourceforge_name}-${pkgver}"
up2date="lynx -dump http://octave.sourceforge.net/\$(echo ${pkgname} |sed 's/octave-//')/index.html |grep Version |sed 's/^.*\([0-9].[0-9].[0-9]\)/\1/'"

###
# == PROVIDED FUNCTIONS
# * build()
###

build() {
	Fbuild
	Frm /usr/share/octave/octave_packages
}
