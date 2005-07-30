# Makefile for Frugalware documentation
#
# Copyright (C) 2005 Miklos Vajna <vmiklos@frugalware.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

compile: uninstall one install-one clean multi install-multi clean

clean:
	rm -rf en/frugalware-howto/
	rm -rf hu/frugalware-howto_hu/
	rm -rf sk/frugalware-howto_SK_sk/

uninstall:
	rm -rf html/en/*
	rm -rf html/hu/*
	rm -rf html/sk/*

one:
	cd en && latex2html -split 0 frugalware-howto.tex
	cd hu && latex2html -split 0 frugalware-howto_hu.tex
	cd sk && latex2html -split 0 frugalware-howto_SK_sk.tex

multi:
	cd en && latex2html frugalware-howto.tex
	cd en/frugalware-howto/ && rm -rf WARNINGS *.pl frugalware-howto.html
	cd hu && latex2html frugalware-howto_hu.tex
	cd hu/frugalware-howto_hu/ && rm -rf WARNINGS *.pl frugalware-howto_hu.html
	cd sk && latex2html frugalware-howto_SK_sk.tex
	cd sk/frugalware-howto_SK_sk/ && rm -rf WARNINGS *.pl frugalware-howto_SK_sk.html

install-one:
	cp en/frugalware-howto/frugalware-howto.html html/en/
	cp hu/frugalware-howto_hu/frugalware-howto_hu.html html/hu/
	cp sk/frugalware-howto_SK_sk/frugalware-howto_SK_sk.html html/sk/

install-multi:
	cp en/frugalware-howto/* html/en/
	cp hu/frugalware-howto_hu/* html/hu/
	cp sk/frugalware-howto_SK_sk/* html/sk/
