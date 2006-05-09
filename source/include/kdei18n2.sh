#!/bin/sh

# (c) 2006 Craciunescu Gabriel <crazy@frugalware.org>
# kdei18n.sh for Frugalware
# distributed under GPL License

url="http://www.kde.org"
pkgver=3.5.2
pkgrel=2
pkgurl="http://ftp.tu-chemnitz.de/pub/X11/kde/stable/$pkgver/src/kde-i18n"
## we just need the right version
up2date="lynx -dump http://www.kde.org/download/|grep 'kdelibs'|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
makedepends=("kdelibs>=$pkgver")
groups=('locale-extra')
archs=('i686' 'x86_64')
options=(${options[@]} 'scriptlet')
groups=('locale-extra')
## This parts are most from the OOo build. *me gives janny and vmiklos some power cookies* :)
klangs=('af' 'ar' 'az' 'bg' 'bn' 'br' 'bs' 'ca' 'cs' 'cy' 'da' 'de' 'el' 'en_GB' 'eo' 'es' 'et' 'eu' 'fa' 'fi' 'fr' 'fy' 'ga' 'gl' 'he' 'hi' 'hr' 'hu' 'is' 'it' 'ja' 'km' 'ko' 'lt' 'lv' 'mk' 'mn' 'ms' 'nb' 'nds' 'nl' 'nn' 'pa' 'pl' 'pt' 'pt_BR' 'ro' 'ru' 'rw' 'se' 'sk' 'sl' 'sr' 'sr@Latn' 'ss' 'sv' 'ta' 'tg' 'tr' 'uk' 'uz' 'zh_CN' 'zh_TW')
kdescs=('Afrikaans' 'Arabic' 'Azerbaijani' 'Bulgarian' 'Bengali' 'Breton' 'Bosnian' 'Catalan' 'Czech' 'Welsh' 'Danish' 'German' 'EL' 'British' 'Esperanto' 'Spanish' 'Estonian' 'Basque' 'Farsi (Persian)' 'Finnish' 'French' 'Frisian' 'Irish' 'Galician' 'Hebrew' 'Hindi' 'Croatian' 'Hungarian' 'Icelandic' 'Italian' 'Japanese' 'Khmer' 'Korean' 'Lithuanian' 'Latvian' 'Macedonian' 'Mongolian' 'Malay' 'Norwegian' 'Low Saxon' 'Dutch' 'Norwegian' 'Punjabi' 'Polish' 'Portuguese' 'Brazilian' 'Romanian' 'Russian' 'Kinyarwanda' 'Northern' 'Slovak' 'Slovenian' 'Serbian' 'Swati' 'Swedish' 'Tamil' 'Tajik' 'Turkish' 'Ukrainian' 'Uzbek' 'Chinese Simplified' 'Chinese Traditional')

i=0
while [ $i -lt ${#klangs[@]} ]
do
        source=("${source[@]}" "$pkgurl/$pkgname-${klangs[$i]}-$pkgver.tar.bz2")
        i=$(($i+1))
done
## subpkgs
i=0
while [ $i -lt ${#klangs[@]} ]
do
        subpkgs=("${subpkgs[@]}" "$pkgname-${klangs[$i]}")
        subdescs=("${subdescs[@]}" "${kdescs[$i]} Localization for KDE.")
        subdepends=("${subdepends[@]}" "kdelibs>=$pkgver")
        subrodepends=("${subrodepends[@]}" "kdebase>=$pkgver")
        subgroups=("${subgroups[@]}" "locale-extra")
        subarchs=("${subarchs[@]}" "i686 x86_64")
        i=$(($i+1))
done


build()
{
        for ksub in "${klangs[@]}"
        do
                cd "$Fsrcdir/$pkgname-$ksub-$pkgver"
                Fbuild --disable-debug --without-debug
                Fsplit $pkgname-$ksub  usr
        done
}


