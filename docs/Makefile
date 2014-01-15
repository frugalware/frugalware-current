# Makefile for Frugalware documentation
#
# Copyright (C) 2005, 2006, 2007, 2008, 2009, 2010 Miklos Vajna <vmiklos@frugalware.org>
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

VERSION = $(shell git describe) (Rigel)
PO_DIR ?= ~/git/translations/po
XML_PATH = /usr/share/sgml/docbook/dtd/xml-dtd-4.2

# metadocuments
GENERATED = index.html manual.html index-user.html user.html index-devel.html devel.html

PDFS = manual.pdf user.pdf devel.pdf

TEXTS = manual.text user.text devel.text

# generated sources for metadocuments
DYNAMIC_SOURCES = header.txt

# dependencies for metadocuments
MANUAL_SOURCES = $(shell grep link:.*html index.txt|grep -v manual.html |sed 's/.*:\(.*\)\[.*/\1/')
USER_SOURCES = $(shell grep link:.*html index-user.txt|grep -v user.html |sed 's/.*:\(.*\).html\[.*/\1.txt/')
DEVEL_SOURCES = $(shell grep link:.*html index-devel.txt|grep -v devel.html |sed 's/.*:\(.*\).html\[.*/\1.txt/')

# sources to be removed on make clean
GENERATED_SOURCES = packages.txt manual.txt user.txt devel.txt po images $(DYNAMIC_SOURCES)

# list of supported languages
LANGS = $(shell grep '\[po4a_langs\]' po4a.cfg |sed 's/\[po4a_langs\] //')

GETLANG = $(shell lang="$(shell basename `pwd`|sed 's/docs//')"; if [ -n "$$lang" ]; then echo $$lang; else echo en; fi)

MERGE = cat header.txt > $(2); \
	for i in `cat $(1) |grep link:.*html |sed 's/.*:\(.*\).html\[.*/\1.txt/'`; \
	do \
		[ "$$i" = "$(2)" ] && continue; \
		echo "include::$$i[]" >> $(2); \
		echo >> $(2); \
	done

I18NBUILD = po4a -k 0 po4a.cfg; \
		for i in $(LANGS); \
		do \
			for j in Makefile $(shell grep link:.*html index.txt|grep -v manual.html |sed 's/.*:\(.*\)\[.*/\1/;s/html/txt/g'); \
			do \
				[ "`stat -c %Y $$j`" -gt "`stat -c %Y $$i/$$j 2>/dev/null || echo 0`" ] && \
					`which cp` -v $$j $$i/; \
			done; \
			sed -i 's| ../source | ../../source |' $$i/Makefile; \
			sed -i 's| -maxdepth 3 | -maxdepth 4 |' $$i/Makefile; \
			sed -i 's/^\(=\+\)/\n\1/' $$i/*.txt; \
			$(MAKE) -C $$i $(1) || exit 1; \
		done

html: $(MANUAL_SOURCES) $(GENERATED)

po:
	[ -d $(PO_DIR) ]
	mkdir po
	for i in $(LANGS); \
	do \
		cp $(PO_DIR)/docs/$$i/docs.po po/$$i.po; \
	done

html-i18n: html po
	$(call I18NBUILD,html)

pdf: $(PDFS)

pdf-i18n: pdf po
	$(call I18NBUILD,pdf)

text: $(TEXTS)

text-i18n: text po
	$(call I18NBUILD,text)

all: html pdf text

i18n: html-i18n

all-i18n: html-i18n pdf-i18n text-i18n

images:
	ln -s /etc/asciidoc/images ./

%.html: %.txt
	asciidoc -a toc -a numbered -a sectids -a lang=$(call GETLANG) $^

%.text: %.txt
	a2x -a toc -a numbered -a sectids -f text -a lang=$(call GETLANG) $^

# If this fails, make sure you have texlive-fonts-extra installed.
%.pdf: %.txt
	a2x --dblatex-opts "-P latex.output.revhistory=0" -a toc -a numbered -a sectids -f pdf -a lang=$(call GETLANG) $^

%.txt: %.txt.in
	sed 's/@VERSION@/$(VERSION)/' $^ > $@

index.html: index.txt header.txt
	asciidoc -a numbered -a sectids -a lang=$(call GETLANG) $<

manual.txt: $(MANUAL_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index.txt,manual.txt)

user.txt: $(USER_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index-user.txt,user.txt)

devel.txt: $(DEVEL_SOURCES) $(DYNAMIC_SOURCES)
	$(call MERGE,index-devel.txt,devel.txt)

packages.txt: packages.txt.in
	( cat packages.txt.in; \
	for i in `find ../source -maxdepth 3 -name README.Frugalware|sed 's|.*/\(.*\)/README.Frugalware|\1|'|sort`; \
	do \
		echo -e "== $$i\n"; \
		cat ../source/*/$$i/README.Frugalware; \
		echo ""; \
	done ) >packages.txt

clean:
	rm -rf *.html *.pdf *.text $(GENERATED_SOURCES) $(LANGS)

# deletes interim files like .xml or .fo but leaves the result (.pdf,
# etc) untouched
cronclean:
	find . ! -name authors.xml -a -name '*.xml' -o -name '*.fo' -o -name po|xargs rm -rfv

# checks if all the txts are included in index.txt
# -2 is for the two tags: index-user.txt and index-devel.txt
check: clean
	[ "`grep -c html index.txt`" = "$$((`ls *txt{,.in}|wc -l`-2))" ]
