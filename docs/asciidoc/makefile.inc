# Makefile for Frugalware documentation
#
# Copyright (C) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# Copyright (C) 2007 Andras Voroskoi <voroskoi@frugalware.org>
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

all: xhtml

frugalware-apps.txt:
	( echo "== Applications"; \
	echo "The following sections describe the configuration of some applications."; \
	echo ""; \
	for i in `find ../../../ -maxdepth 5 -name README.Frugalware`; \
	do \
		pkgname=`echo $$i |sed 's|.*/\(.*\)/README.Frugalware|\1|'`; \
		echo "=== $$pkgname"; \
		cat $$i; \
		echo ""; \
	done ) >frugalware-apps.txt

xhtml: frugalware-apps.txt
	asciidoc -a toc -a numbered -d book frugalware.txt

install: all
	cp frugalware.html ../../xhtml/$(LANG)/

clean:
	rm -f frugalware-apps.txt
	rm -f frugalware.html

# vim: ft=make
