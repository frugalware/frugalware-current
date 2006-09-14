#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# java.sh for Frugalware
# distributed under GPL License

# common functions for java-related tasks

# usage:
# _F_java_compiler: defaults to 'ecj', can be 'gcj', too
# Fant(): a wrapper for ant to use _F_java_compiler as compiler
# Fgcj(): compile a native binary
#	example: Fgcj org.foo.hello.Main output input.jar [input2.jar]
# Fgcjshared(): compile a native library
#	example: Fgcjshared liboutput.jar.so input.jar [input2.jar]
# Fjar(): calls Fgcjshared the installs the original and the native jar, too
# Fjavacleanup(): cleans up the source tree (jar and class files) before
# building

depends=('libgcj')
makedepends=('gcc-gcj' 'ant-eclipse-ecj')

if [ -z "$_F_java_cflags" ]; then
	_F_java_cflags="-fPIC -findirect-dispatch -fjni"
fi

if [ -z "$_F_java_ldflags" ]; then
	_F_java_ldflags="-Wl,-Bsymbolic"
fi

Fant()
{
	if [ -n "$_F_java_compiler" ]; then
		ant -Dbuild.compiler=$_F_java_compiler $@ || Fdie
	else
		ant $@ || Fdie
	fi
}

Fgcj()
{
	local main="$1" output="$2"
	shift 2
	if [ ! -d "`dirname $output`" ]; then
		mkdir -p "`dirname $output`" || Fdie
	fi
	echo "gcj $CFLAGS --main=$main -o $output $@"
	gcj $CFLAGS --main=$main -o $output $@ || Fdie
}

Fgcjshared()
{
	local output="$1"
	shift 1
	if [ ! -d "`dirname $output`" ]; then
		mkdir -p "`dirname $output`" || Fdie
	fi
	echo "gcj -shared $CFLAGS $_F_java_cflags $_F_java_ldflags -o $output $@"
	gcj -shared $CFLAGS $_F_java_cflags $_F_java_ldflags -o $output $@ || Fdie
}

Fjar()
{
	local i dir file
	for i in $@
	do
		dir=`dirname $i`
		file=`basename $i`
		Ffilerel $dir/$file /usr/share/java/$file
		if [ ! -e $dir/lib$file.so ]; then
			Fgcjshared $dir/lib$file.so $i
		fi
		Fexerel $dir/lib$file.so /usr/lib/lib$file.so
	done
}

Fjavacleanup()
{
	find . -name "*.class" -exec rm -vf {} \;
	find . -name "*.jar" -exec rm -vf {} \;
}
