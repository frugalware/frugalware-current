#!/bin/sh

# (c) 2005 Bence Nagy <nagybence@tipogral.hu>
# gem.sh for Frugalware
# distributed under GPL License

# using ruby gem sources

depends=('ruby')
makedepends=('rubygems')
source=(http://gems.rubyforge.org/gems/"$pkgname"-"$pkgver".gem)
up2date='lynx -dump "http://gems.rubyforge.org/gems/" | grep "$pkgname-[0-9.]\+.gem$" | sed "s/.*$pkgname-\(.*\).gem.*/\1/" | Fsort | tail -n 1'

Finstallgem() {
	gem install "$pkgname" --local --version "$pkgver" --install-dir . --ignore-dependencies
	cd gems/"$pkgname"-"$pkgver"
	libdir=`ruby -r rbconfig -e 'print Config::CONFIG["rubylibdir"]'`
	archdir=`ruby -r rbconfig -e 'print Config::CONFIG["archdir"]'`
	if [ -d bin ]; then
		Fmkdir /usr/bin
		cp -R bin/* "$Fdestdir"/usr/bin || Fdie
		Ffileschmod /usr/bin +x
	fi
	if [ -d lib ]; then
		Fmkdir "$libdir"
		cp -R lib/* "$Fdestdir"/"$libdir" || Fdie
	fi
	if [ -d ext ]; then
		Fmkdir "$archdir"
		cp -R ext/* "$Fdestdir"/"$archdir" || Fdie
	fi
	if [ -d doc -a -n "`ls doc`" ]; then
		Fmkdir /usr/share/doc/"$pkgname"-"$pkgver"
		if [ -d doc/"$pkgname"-"$pkgver" -a -n "`ls doc/$pkgname-$pkgver`" ]; then
			cp -R doc/"$pkgname"-"$pkgver"/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
			rm -rf doc/"$pkgname"-"$pkgver"/ || Fdie
		fi
		if [ -n "`ls doc`" ]; then
			cp -R doc/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
		fi
	fi
	mv `find . -mindepth 1 -maxdepth 1 -type f` $Fsrcdir
}

build() {
	Finstallgem
}
