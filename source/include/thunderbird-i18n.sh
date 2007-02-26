#!/bin/sh

###
# = thunderbird-i18n.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# thunderbird-i18n.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Thunderbird language packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_thunderbird_lang=fi
# pkgname=thunderbird-$_F_thunderbird_lang
# pkgver=1.5.0.7
# pkgrel=1
# pkgdesc="Finnish language support for Thunderbird"
# Finclude thunderbird-i18n
# sha1sums=('ed10b93d8fc4bd9ea7a0fe698fed82e519e7dc5a')
# --------------------------------------------------
#
# == OVERWRITTEN VARIABLES
# * up2date
# * url
# * source()
# * options()
# * depends()
# * makedepends()
# * groups()
# * archs()
###
up2date="1.5.0.7"
url="http://www.mozilla.org/projects/l10n/mlp.html"
source=(http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/$pkgver/linux-i686/xpi/$_F_thunderbird_lang.xpi)
options=('scriptlet')
depends=('thunderbird>=1.5.0.7')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
	unzip -qqo $_F_thunderbird_lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/thunderbird/chrome/$_F_thunderbird_lang.manifest
	Ffilerel chrome/$_F_thunderbird_lang.jar /usr/lib/thunderbird/chrome/$_F_thunderbird_lang.jar
}
