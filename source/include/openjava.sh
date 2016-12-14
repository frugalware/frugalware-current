#!/bin/sh

###
# = openjava.sh(3)
# Marius Cirsta <mcirsta@frugalware.org>
#
# == NAME
# openjava.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for java packages that uses openjre and openjdk.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=jakarta-regexp
# pkgver=1.4
# pkgrel=1
# pkgdesc="100% Pure Java Regular Expression package"
# url="http://jakarta.apache.org/regexp"
# groups=('devel-extra')
# archs=('x86_64')
# up2date="lynx -dump http://www.apache.org/dist/jakarta/regexp/source/ |Flasttar"
# source=(http://www.apache.org/dist/jakarta/regexp/source/jakarta-regexp-$pkgver.tar.gz)
# signatures=($source.asc)
# Finclude java
#
# build()
# {
#         Fcd
#         Fjavacleanup
#         Fant
#         mv build/jakarta-regexp{-$pkgver,}.jar
#         Fjar build/jakarta-regexp.jar
# }
# --------------------------------------------------
#
# == OPTIONS
# * _F_java_no_cleanup: do not delete all jars from source


###
# == APPENDED VARIABLES
# * makedepends()
###
makedepends=("${makedepends[@]}" 'openjdk' 'apache-ant' 'openjre')

###
# == PROVIDED FUNCTIONS
# * Fant(): a wrapper for ant to use _F_java_compiler as compiler
###
Fant()
{
	ant $@ || Fdie
}

###
# * Fjar(): installs the jar(s)
###
Fjar()
{
	local i dir file
	for i in $@
	do
		dir=`dirname $i`
		file=`basename $i`
		Ffilerel $dir/$file /usr/share/java/$file
	done
}

###
# * Fjavacleanup(): cleans up the source tree (jar and class files) before
# building. optional parameter: root of the source tree
###
Fjavacleanup()
{

	if [ -z "$_F_java_no_cleanup" ]; then
		local root="."
		[ -n "$1" ] && root=$1
		find $root -name "*.class" $_F_javacleanup_opts -exec rm -vf {} \;
		find $root -name "*.jar" $_F_javacleanup_opts -exec rm -vf {} \;
	fi
}
