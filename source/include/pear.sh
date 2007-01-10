#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# pear.sh for Frugalware
# distributed under GPL License

# common scheme for php pear packages

# usage:
# _F_pear_name - name of the pear package
# also don't forge to set pkgver, pkgdesc and depends
# the rest will be set by this scheme

pkgname=php-pear-`echo $_F_pear_name|tr [A-Z] [a-z]`
pkgrel=1
url="http://pear.php.net/package/$_F_pear_name"
groups=('devel-extra')
archs=('i686' 'x86_64') # it's safe to add x86_64 by default
up2date="lynx -dump http://pear.php.net/package/$_F_pear_name|grep released|sed 's/.*\]\([^ ]*\) (.*/\1/'"
source=(http://pear.php.net/get/$_F_pear_name-$pkgver.tgz)
install=src/pear.install

Fbuildpear()
{
	# install the package
	pear install --nodeps -R $Fdestdir $_F_pear_name-$pkgver.tgz || Fdie
	# remove the common files, they will be updated by the scriptlet
	Frm /usr/share/pear/{.channels,.registry,.depdb,.depdblock,.filemap,.lock} /tmp
	# the package.xml is required to update the common files
	Ffilerel package.xml /var/lib/pear/$_F_pear_name.xml
	# move the documentation to the correct location
	Fcd $_F_pear_name-$pkgver
	if [ -d docs ]; then
		Frm /usr/share/pear/doc/
		Fdocrel docs/*
	fi
	# now prepare the scriptlet
	cp $Fincdir/pear.install $Fsrcdir || Fdie
	Fsed '$_F_pear_name' "$_F_pear_name" $Fsrcdir/pear.install
}

build()
{
	Fbuildpear
}
