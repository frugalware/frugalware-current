#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# thunderbird-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for thunderbird i18n packages

up2date="1.5.0.7"
url="http://www.mozilla.org/projects/l10n/mlp.html"
source=(http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/$pkgver/linux-i686/xpi/$_F_thunderbird_lang.xpi)
options=('scriptlet')
depends=('thunderbird>=1.5.0.7')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

build()
{
	unzip -qqo $_F_thunderbird_lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/thunderbird/chrome/$_F_thunderbird_lang.manifest
	Ffilerel chrome/$_F_thunderbird_lang.jar /usr/lib/thunderbird/chrome/$_F_thunderbird_lang.jar
}
