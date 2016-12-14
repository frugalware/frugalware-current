#!/bin/sh

###
# = mono.sh(3)
# Alex Smith <alex@alex-smith.me.uk>
#
# == NAME
# mono.sh - for Frugalware
#
# == SYNOPSIS
# Common functions for mono packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=galago-sharp
# pkgver=0.5.0
# pkgrel=2
# pkgdesc="Galago Desktop Presence Framework - C# Bindings"
# url="http://www.galago-project.org"
# depends=('libgalago' 'gtk2-sharp>=2.10.0' 'perl-xml-libxml' 'dbus-mono')
# groups=('gnome')
# archs=('x86_64')
# source=($url/files/releases/source/$pkgname/$pkgname-$pkgver.tar.bz2 \
#         galago-sharp-0.5.0-fix-nunit-name.patch)
# Finclude mono
# up2date="lynx -dump http://www.galago-project.org/files/releases/source/$pkgname | Flasttar"
# sha1sums=('67ec03129e3ca55c982f0fc3c61825779f80b9f0' \
#           '3e4dcbd3fa3f7b5bb1995c3f268ac19e4c9da15f')
# --------------------------------------------------
#
# == PROVIDED FUNCTIONS
# * Fmonoexport(): creates MONO_SHARED_DIR
###

if [ ! -n "$_F_mono_nodepends" ]; then # isset
	depends=("${depends[@]}" 'mono')
fi

if [ -z "$_F_mono_aot" ]; then
        _F_mono_aot=1
fi


Fmonoexport() {
	Fmessage "Exporting weird MONO_SHARED_DIR..."
	export MONO_SHARED_DIR=$Fdestdir/weird
	export XDG_CONFIG_HOME=$Fdestdir/weird
	mkdir -p $MONO_SHARED_DIR
	export MONO_REGISTRY_PATH="${Fdestdir}/registry"
	export XDG_CONFIG_HOME="${Fdestdir}/config"
	export HOME="${Fdestdir}/home"
}

###
# * Fmonoccompileaot(): AOT all of the libraries in the pkg
###
Fmonocompileaot() {
	Fmessage "AOTing all of the libraries..."
	for i in $Fdestdir/usr/lib/mono/gac/*/*/*.dll
	do
		echo mono --aot $i
		mono --aot $i || Fdie
	done
}

###
# * Fmonocleanup(): removes MONO_SHARED_DIR
###
Fmonocleanup() {
	Fmessage "Cleaning up MONO_SHARED_DIR..."
	rm -rf $MONO_SHARED_DIR
	rm -rf $MONO_REGISTRY_PATH
	rm -rf $XDG_CONFIG_HOME
	rm -rf $HOME
}

###
# * Fbuild_mono(): improves build() to make use of these functions
###
Fbuild_mono() {
	unset MAKEFLAGS
	Fmonoexport
	Fbuild $@
if [ "$_F_mono_aot" -eq 1 ]; then
	Fmonocompileaot
fi
	Fmonocleanup
}

###
# * build() just calls Fbuild_mono()
###
build() {
	Fbuild_mono
}
