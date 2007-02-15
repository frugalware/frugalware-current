LANGS = en_US

all:
	@for i in $(LANGS); do $(MAKE) -C $$i install clean || break; done
