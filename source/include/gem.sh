depends=('ruby')
makedepends=('rubygems')
source=(http://gems.rubyforge.org/gems/"$pkgname"-"$pkgver".gem)
up2date='lynx -dump "http://gems.rubyforge.org/gems/" | grep "$pkgname-[0-9.]\+.gem$" | tail -n 1 | sed "s/.*$pkgname-\(.*\).gem.*/\1/"'

Frubygem() {
	gem install "$pkgname" --local --version "$pkgver" --install-dir . --ignore-dependencies
	cd gems/"$pkgname"-"$pkgver"
	libdir=`ruby -r rbconfig -e 'print Config::CONFIG["rubylibdir"]'`
	archdir=`ruby -r rbconfig -e 'print Config::CONFIG["archdir"]'`
	Fmkdir "$libdir" "$archdir"
	cp -R lib/* "$Fdestdir"/"$libdir" || Fdie
	cp -R ext/* "$Fdestdir"/"$archdir" || Fdie
	Fdocrel `find . -mindepth 1 -maxdepth 1 -type f`
	cp -R doc/"$pkgname"-"$pkgver"/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
	rm -rf doc/"$pkgname"-"$pkgver"/ || Fdie
	cp -R doc/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
}

build() {
	Frubygem
}
