#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# pecl.sh for Frugalware
# distributed under GPL License

# common scheme for php extensions

pkgname=php-pecl-$_F_pecl_name
pkgrel=1
url="http://pecl.php.net/package/$_F_pecl_name"
groups=('devel-extra')
archs=('i686')
up2date="lynx -dump $url  |grep gz$|sed 's/.*-\(.*\)\.t.*/\1/;q'"
source=(http://pecl.php.net/get/$_F_pecl_name-$pkgver.tgz)

Fbuildpecl()
{
	Fcd $_F_pecl_name-$pkgver
	phpize || Fdie
	Fmake
	cd modules
	Fexerel /usr/lib/php/$_F_pecl_name.so
}

build()
{
	Fbuildpecl
}
