#!/bin/sh

# (c) 2006 Rohan Dhruva
# cvs.sh for Frugalware
# distributed under GPL License

# Manages the pkgver and provides a default build()

if [ ! -z $_F_cvs_cvsroot -a ! -z $_F_cvs_cvsmod ]; then
	Fmessage "No CVS variables found!"
	Fmessage "Please use _F_cvs_cvsroot and _F_cvs_cvsmod variables "
	Fmessage "for the server and the cvs module name respectively."
	Fmessage "Aborting!"
	Fdie
fi

pkgver=`date +%Y%m%d`
makedepends=(${makedepends[@]} 'cvs')

Fcvsbuild()
{
	Fmessage "Connecting to $pkgname CVS server...."
	cvs -z3 -d$_F_cvs_cvsroot co -D $pkgver -f -P $_F_cvs_cvsmod
	Fcd $_F_cvs_cvsmod
	if [ -x autogen.sh ]; then
		Fsed './configure' '#./configure' autogen.sh
		./autogen.sh || Fdie
	fi
	Fbuild
}

build()
{
	Fcvsbuild
}

unset _F_cvs_cvsroot _F_cvs_cvsmod
