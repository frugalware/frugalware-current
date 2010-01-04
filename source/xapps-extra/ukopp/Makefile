PROGRAM = ukopp
VERSION = 3.6

# use $PREFIX if defined, else assume /usr/local
ifeq "$(PREFIX)" ""
	PREFIX = /usr
endif

SOURCE = $(PROGRAM)-$(VERSION).cpp
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share/$(PROGRAM)
DOCDIR = $(PREFIX)/share/doc/$(PROGRAM)
DESKTOP = $(PREFIX)/share/applications/$(PROGRAM).desktop
MANDIR = $(PREFIX)/share/man/man1

# replace CFLAGS and LFLAGS -O (oh) with -g for GDB debugging
CFLAGS = -O -Wall -c `pkg-config --cflags gtk+-2.0`
LFLAGS = -O -Wall -rdynamic `pkg-config --libs gtk+-2.0 gthread-2.0`

$(PROGRAM): $(PROGRAM).o zfuncs.o
	@ g++ $(LFLAGS) -o $(PROGRAM) $(PROGRAM).o zfuncs.o

$(PROGRAM).o: $(SOURCE) zfuncs.h
	@ g++ $(CFLAGS) -o $(PROGRAM).o $(SOURCE)		\
	  -D "DATADIR=\"$(DATADIR)\"" -D "DOCDIR=\"$(DOCDIR)\""

zfuncs.o: zfuncs.cpp zfuncs.h
	@ g++ $(CFLAGS) zfuncs.cpp	\
	  -D "DATADIR=\"$(DATADIR)\"" -D "DOCDIR=\"$(DOCDIR)\"" -D "BINDIR=\"$(BINDIR)\""

install: $(PROGRAM)
	mkdir -p $(DESTDIR)$(DOCDIR) 
	mkdir -p $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(DATADIR)
	cp -R doc/* $(DESTDIR)$(DOCDIR)
	cp -R data/* $(DESTDIR)$(DATADIR)
	cp $(PROGRAM) $(DESTDIR)$(BINDIR)
#  install .desktop file (menu entry)
	@echo "[Desktop Entry]" > $(DESTDIR)/$(DESKTOP)
	@echo "Name=$(PROGRAM)" >> $(DESTDIR)/$(DESKTOP)
	@echo "Categories=Utility" >> $(DESTDIR)/$(DESKTOP)
	@echo "Type=Application" >> $(DESTDIR)/$(DESKTOP)
	@echo "Terminal=false" >> $(DESTDIR)/$(DESKTOP)
	@echo "Exec=$(BINDIR)/$(PROGRAM)" >> $(DESTDIR)/$(DESKTOP)
	@echo "Icon=$(DATADIR)/icons/$(PROGRAM).png" >> $(DESTDIR)/$(DESKTOP)
	@echo "GenericName=Copy Files to Removable Media" >> $(DESTDIR)/$(DESKTOP)


