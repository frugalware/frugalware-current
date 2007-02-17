# Makefile for Frugalware documentation
#
# Copyright (C) 2005-2007 Miklos Vajna <vmiklos@frugalware.org>
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

# TODO: pdf, manpages, authors, po4a
# TODO: remove these hardwired values
VERSION = 0.6rc1 (Terminus)
FST_ROOT ?= ~/darcs/current

# metadocuments
GENERATED = index.html manual.html index-user.html user.html index-devel.html devel.html

# generated sources for metadocuments
DYNAMIC_SOURCES = header.txt

# dependencies for metadocuments
MANUAL_SOURCES = $(shell grep link: index.txt|grep -v manual.html |sed 's/.*:\(.*\)\[.*/\1/')
USER_SOURCES = $(shell grep link: index-user.txt|grep -v user.html |sed 's/.*:\(.*\).html\[.*/\1.txt/')
DEVEL_SOURCES = $(shell grep link: index-devel.txt|grep -v devel.html |sed 's/.*:\(.*\).html\[.*/\1.txt/')

# sources to be removed on make clean
GENERATED_SOURCES = packages.txt manual.txt user.txt devel.txt $(DYNAMIC_SOURCES)

# no need to modify anything below this line

MERGE = : > $(2); \
	for i in `cat $(1) |grep link:|sed 's/.*:\(.*\).html\[.*/\1.txt/'`; \
	do \
		[ "$$i" = "$(2)" ] && continue; \
		cat $$i >> $(2); \
		echo >> $(2); \
	done; \
	sed -i 's/^\(=\+ \)/=\1/' $(2); \
	sed -i '1i include::header.txt[]' $(2)

all: $(MANUAL_SOURCES) $(GENERATED)

%.html: %.txt
	asciidoc -a toc -a numbered $(basename $@).txt

%.txt: %.txt.in
	sed 's/@VERSION@/$(VERSION)/' $(basename $@).txt.in > $@

index.html: index.txt header.txt
	asciidoc -a numbered $(basename $@).txt

manual.txt: $(MANUAL_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index.txt,manual.txt)

user.txt: $(USER_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index-user.txt,user.txt)

devel.txt: $(DEVEL_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index-devel.txt,devel.txt)

packages.txt:
	( echo "= Packages"; \
	echo -e "\nThe following sections describe the configuration of some packages.\n"; \
	for i in `find $(FST_ROOT)/source -maxdepth 5 -name README.Frugalware`; \
	do \
		pkgname=`echo $$i |sed 's|.*/\(.*\)/README.Frugalware|\1|'`; \
		echo "== $$pkgname"; \
		cat $$i; \
		echo ""; \
	done ) >packages.txt

clean:
	rm -f *.html $(GENERATED_SOURCES)

# checks if all the txts are included in index.txt
# -2 is for the two tags: index-user.txt and index-devel.txt
check: clean
	[ "`grep -c html index.txt`" = "$$((`ls *txt{,.in}|wc -l`-2))" ]
