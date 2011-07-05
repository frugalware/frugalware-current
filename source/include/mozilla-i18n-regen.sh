#! /bin/bash

###
# = mozilla-i18n-regen.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# mozilla-i18n-regen.sh - for Frugalware
#
# == SYNOPSIS
# Tool to regenerate FrugalBuild for Mozilla language packages.
#
# == EXAMPLE
# Update the FrugalBuild of firefox-i18n:
# --------------------------------------------------
# cd locale-extra/firefox-i18n
# vi FrugalBuild # Edit the FrugalBuild as wanted
# sh ../..//include/mozilla-i18n-regen.sh
# --------------------------------------------------
###

mozilla_i18n_lang_describe()
{
	echo "mozilla_i18n_lang_add '$1' '$(sha1sum $lang.xpi | awk '{print $1}')'"
}

# Cleanup
sed -i -r "/^mozilla_i18n_lang_(add|fini)/d" FrugalBuild

# Make FrugalBuild sourcing silent
source /usr/lib/frugalware/fwmakepkg
source ./FrugalBuild

# Download the xpi
rm -rf *.xpi
wget -r -nd "$_F_mozilla_i18n_mirror/$_F_mozilla_i18n_xpidirname/"

for xpi in *.xpi; do
	_F_mozilla_i18n_langs=("${_F_mozilla_i18n_langs[@]}" "${xpi/%\.xpi/}")
done

# Regen
mozilla_i18n_foreach_lang mozilla_i18n_lang_describe >> FrugalBuild
echo "mozilla_i18n_lang_fini" >> FrugalBuild

