# Makefile for Frugalware documentation
#
# Copyright (C) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
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

all: html txt

frugalware-apps.texi:
	( echo "@section Applications"; \
	echo "The following sections describe the configuration of some applications."; \
	for i in `find ../../../ -maxdepth 5 -name README.Frugalware`; \
	do \
		pkgname=`echo $$i |sed 's|.*/\(.*\)/README.Frugalware|\1|'`; \
		echo "@subsection $$pkgname"; \
		echo "@verbatim"; \
		cat $$i; \
		echo "@end verbatim"; \
	done ) >frugalware-apps.texi

info: frugalware-apps.texi
	makeinfo -v --force frugalware.texi

html: frugalware-apps.texi
	makeinfo -v --force --html frugalware.texi

txt: frugalware-apps.texi
	makeinfo -v --force --plaintext -o frugalware.txt frugalware.texi

install: all
	cp frugalware.txt ../../txt/en_US/
	cp frugalware/* ../../html/en_US/

clean:
	rm -f frugalware-apps.texi
	rm -f frugalware.txt frugalware.info
	rm -rf frugalware
