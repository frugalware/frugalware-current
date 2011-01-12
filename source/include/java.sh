#!/bin/sh

###
# = java.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# java.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for java packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=jakarta-regexp
# pkgver=1.4
# pkgrel=1
# pkgdesc="100% Pure Java Regular Expression package"
# url="http://jakarta.apache.org/regexp"
# groups=('devel-extra')
# archs=('i686' 'x86_64')
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
# * _F_java_compiler: Sets the java compiler used for building. Defaults to
# 'ecj', can be 'gcj', too.
# * _F_java_cflags (defaults to -fPIC -findirect-dispatch -fjni): compiler flags passed to the bytecompiler (gcj)
# * _F_java_ldflags (defaults to -Wl,-Bsymbolic): linker flags passed to the bytecompiler (gcj)
# * _F_javacleanup_opts: you can set this to define some exclude patterns if
# you really need (for bootstrapping) some binary jars.
# * _F_java_jars: a bash array to specify what jars to install using Fjar in
# Fmakeinstall if build.xml found
# * _F_java_no_gcj: use Fwrapper in Fgcj(), it is useful on low memory
# boxes (default on ppc)
###
if [ -z "$_F_java_cflags" ]; then
	_F_java_cflags="-fPIC -findirect-dispatch -fjni"
fi

if [ -z "$_F_java_ldflags" ]; then
	_F_java_ldflags="-Wl,-Bsymbolic"
fi
if [ "$CARCH" == "ppc" ]; then
	# oom would just kill it
	_F_java_no_gcj=1
fi

###
# == APPENDED VARIABLES
# * depends()
# * makedepends()
###
depends=("${depends[@]}" 'libgcj>=4.5.0')
makedepends=("${makedepends[@]}" 'gcc-gcj>=4.5.0' 'ant-eclipse-ecj')

###
# == PROVIDED FUNCTIONS
# * Fant(): a wrapper for ant to use _F_java_compiler as compiler
###
Fant()
{
	if [ -n "$_F_java_compiler" ]; then
		ant -Dbuild.compiler=$_F_java_compiler $@ || Fdie
	else
		ant $@ || Fdie
	fi
}

###
# * Fgcj(): compile a native binary
# (example: Fgcj org.foo.hello.Main output input.jar [input2.jar])
###
Fgcj()
{
	local main="$1" output="$2"
	shift 2
	if [ ! -d "`dirname $output`" ]; then
		mkdir -p "`dirname $output`" || Fdie
	fi
	if [ -z "$_F_java_no_gcj" ]; then
		Fexec gcj ${CFLAGS/O2/O0} ${_F_java_cflags/-fPIC } $_F_java_ldflags \
			--main=$main -o $output $@ || Fdie
	else
		Fwrapper "gij -cp $(echo $@|sed "s|$Fdestdir||") $main \"\$@\"" $(basename $output)
	fi
}

###
# * Fgcjshared(): compile a native library
# (example: Fgcjshared liboutput.jar.so input.jar [input2.jar])
###
Fgcjshared()
{
	local output="$1"
	shift 1
	if [ ! -d "`dirname $output`" ]; then
		mkdir -p "`dirname $output`" || Fdie
	fi
	Fexec gcj -shared ${CFLAGS/O2/O0} $_F_java_cflags $_F_java_ldflags \
		-o $output $@ || Fdie
}

###
# * Fjar(): calls Fgcjshared the installs the original and the native jar, too
###
Fjar()
{
	local i dir file
	for i in $@
	do
		dir=`dirname $i`
		file=`basename $i`
		Ffilerel $dir/$file /usr/share/java/$file
		if [ -z "$_F_java_no_gcj" ]; then
			if [ ! -e $dir/lib$file.so ]; then
				Fgcjshared $dir/lib$file.so $i
			fi
			Fexerel $dir/lib$file.so /usr/lib/lib$file.so
		fi
	done
}

###
# * Fjavacleanup(): cleans up the source tree (jar and class files) before
# building. optional parameter: root of the source tree
###
Fjavacleanup()
{
	local root="."
	[ -n "$1" ] && root=$1
	find $root -name "*.class" $_F_javacleanup_opts -exec rm -vf {} \;
	find $root -name "*.jar" $_F_javacleanup_opts -exec rm -vf {} \;
}
