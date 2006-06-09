LANGS = en_US fr_FR

all:
	@for i in $(LANGS); do $(MAKE) -C $$i install clean || break; done
