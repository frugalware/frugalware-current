#!/bin/sh

###
# = vim-spell.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# vim-spell.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for vim dictonary packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_vim_lang=hu
# pkgver=20060413
# _F_vim_desc=Hungarian
# _F_vim_encodings=('cp1250' 'iso-8859-2' 'utf-8')
# Finclude vim-spell
# --------------------------------------------------
#
# == OPTIONS
# * _F_vim_lang: the language code of the dictionary
# * _F_vim_desc: the language of the dictionary
# * _F_vim_encodings: available encodings
# * _F_vim_sug_encodings: available suggestion encodings
###
[ -z "$pkgver" ] && "error: no pkgver is set!"

###
# == OVERWRITTEN VARIABLES
# * pkgname
# * pkgrel
# * url
# * rodepends()
# * groups()
# * archs()
# * up2date
# * source()
###
pkgname=vim-spell-$_F_vim_lang
pkgrel=1
pkgdesc="$_F_vim_desc spellcheck files for VIM."
url="http://ftp.vim.org/pub/vim/unstable/runtime/spell/"
rodepends=('vim>=7.0')
groups=('locale-extra')
archs=('i686' 'x86_64')
up2date="date --date \$(lynx -dump http://ftp.vim.org/pub/vim/unstable/runtime/spell/|grep '$_F_vim_lang\..*\.spl '|sed 's/.* \([^- ]*-[^- ]*-[^- ]*\) .*/\1/;q') +%Y%m%d"
source=(http://ftp.vim.org/pub/vim/unstable/runtime/spell/README_$_F_vim_lang.txt)
for i in ${_F_vim_encodings[@]}
do
	source=(${source[@]} http://ftp.vim.org/pub/vim/unstable/runtime/spell/$_F_vim_lang.$i.spl)
done
for i in ${_F_vim_sug_encodings[@]}
do
	source=(${source[@]} http://ftp.vim.org/pub/vim/unstable/runtime/spell/$_F_vim_lang.$i.sug)
done

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
	mkdir $pkgname-$pkgver
	mv * $pkgname-$pkgver
	Fcd
	ls *.spl &>/dev/null && Ffilerel *.spl /usr/share/vim/spell/
	ls *.sug &>/dev/null && Ffilerel *.sug /usr/share/vim/spell/
}
