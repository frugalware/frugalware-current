# Makefile for Frugalware documentation
#
# Copyright (C) 2005-2007 Miklos Vajna <vmiklos@frugalware.org>
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

VERSION = $(shell date +%Y%m%d) (-current)
#VERSION = 0.6 (Terminus)
PO_DIR ?= ~/darcs/translations/po
XML_PATH = /usr/share/sgml/docbook/dtd/xml-dtd-4.2

# force the usage of gcj, we have no time to test fop with other jdks
export JAVA_HOME = /usr

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

MERGE = : > $(2); \
	for i in `cat $(1) |grep link:.*html |sed 's/.*:\(.*\).html\[.*/\1.txt/'`; \
	do \
		[ "$$i" = "$(2)" ] && continue; \
		cat $$i >> $(2); \
		echo >> $(2); \
	done; \
	sed -i 's/^\(=\+ \)/=\1/' $(2); \
	sed -i '/^\^\{2,\}$$/s/\^/+/g' $(2); \
	sed -i '/^~\{2,\}$$/s/~/^/g' $(2); \
	sed -i '1i include::header.txt[]\n' $(2)

I18NBUILD = po4a -k 0 po4a.cfg; \
		darcs revert -a po/*.po; \
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
	asciidoc -a toc -a numbered $(basename $@).txt

%.text: %.html
	lynx -dump $(basename $@).html > $@

%.xml: %.txt
	asciidoc -a toc -a numbered -b docbook $(basename $@).txt
	sed -i '/<!DOCTYPE/s|\("http[^"].*"\)|"file://$(XML_PATH)/docbookx.dtd"|' $@

%.fo: %.xml
	xsltproc --nonet --path $(XML_PATH) /etc/asciidoc/docbook-xsl/fo.xsl $(basename $@).xml > $(basename $@).fo
	sed -i 's/sans-serif,Symbol,ZapfDingbats/DejaVuSans/g' $(basename $@).fo
	sed -i 's/serif,Symbol,ZapfDingbats/DejaVuSerif/g' $(basename $@).fo
	sed -i 's|\(src="./images/icons/[^"]\+\).png"|\1.jpg"|g' $(basename $@).fo
	sed -i 's/bgcolor="[^"]\+"//g;s/border-right-color=""//g;s/border-bottom-color=""//g' $(basename $@).fo

%.pdf: %.fo images
	fop -c /usr/share/fop/dejavu-ttf.xml $(basename $@).fo $(basename $@).pdf

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

# checks if all the txts are included in index.txt
# -2 is for the two tags: index-user.txt and index-devel.txt
check: clean
	[ "`grep -c html index.txt`" = "$$((`ls *txt{,.in}|wc -l`-2))" ]
