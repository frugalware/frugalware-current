#!/bin/sh

# (c) 2006 Gabriel Craciunescu <crazy@frugalware.org>
# kdeapps.sh for Frugalware
# distributed under GPL License


build()
{
	Fcd
	for i in `find . -iname configure`
	do
		Fsed '-O2' '' $i
	done
	Fbuild  --disable-dependency-tracking \
		--disable-debug --without-debug \
		--with-gnu-ld --enable-new-ld-flags
}

