# Makefile for Frugalware documentation
#
# Copyright (C) 2007 Miklos Vajna <vmiklos@frugalware.org>
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

all: $(subst .sh,.sh.3,$(wildcard *.sh))

stat:
	@echo $(shell ls *.3|wc -l)/$(shell ls *.sh|wc -l)

%.sh.txt: %.sh
	sed -n 's/^#\( \|$$\)//;/^###/,/^###/p' $(basename $@)|sed 's/^###//' > $@

%.sh.xml: %.sh.txt
	asciidoc -d manpage -b docbook $(basename $@).txt

%.sh.3: %.sh.xml
	xsltproc /etc/asciidoc/docbook-xsl/manpage.xsl $(basename $@).xml
	sed -i 's/\\(bu/*/' $@

clean:
	rm -f *.3
