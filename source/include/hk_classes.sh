#!/bin/sh

# (c) 2005 Marcus Habermehl <bmh1980de@yahoo.de>
# hk_classes.sh for Frugalware
# distributed under GPL License

realname=hk_classes
up2date="lynx -dump 'http://knoda.sourceforge.net/tiki-page.php?pageName=Download'|grep 'stable.*hk_classes'|cut -d - -f 2"
source=(http://dl.sourceforge.net/sourceforge/hk-classes/$realname-$pkgver.tar.bz2)
sha1sums=('a6cfec587b046db244268546bb71a24afea21396')
