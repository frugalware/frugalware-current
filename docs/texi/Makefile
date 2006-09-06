LANGS = en_US fr_FR pl_PL

all:
	@for i in $(LANGS); do $(MAKE) -C $$i install clean || break; done
