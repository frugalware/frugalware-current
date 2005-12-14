depends=('ruby')
makedepends=('rubygems')
source=(http://gems.rubyforge.org/gems/"$pkgname"-"$pkgver".gem)
up2date='lynx -dump "http://gems.rubyforge.org/gems/" | grep "$pkgname-[0-9.]\+.gem$" | tail -n 1 | sed "s/.*$pkgname-\(.*\).gem.*/\1/"'

Finstallgem() {
	gem install "$pkgname" --local --version "$pkgver" --install-dir . --ignore-dependencies
	cd gems/"$pkgname"-"$pkgver"
	libdir=`ruby -r rbconfig -e 'print Config::CONFIG["rubylibdir"]'`
	archdir=`ruby -r rbconfig -e 'print Config::CONFIG["archdir"]'`
	if [ -d lib ]; then
		Fmkdir "$libdir"
		cp -R lib/* "$Fdestdir"/"$libdir" || Fdie
	fi
	if [ -d ext ]; then
		Fmkdir "$archdir"
		cp -R ext/* "$Fdestdir"/"$archdir" || Fdie
	fi
	Fmkdir /usr/share/doc/"$pkgname"-"$pkgver"
	cp -R doc/"$pkgname"-"$pkgver"/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
	rm -rf doc/"$pkgname"-"$pkgver"/ || Fdie
	cp -R doc/* "$Fdestdir"/usr/share/doc/"$pkgname"-"$pkgver" || Fdie
	mv `find . -mindepth 1 -maxdepth 1 -type f` $Fsrcdir
}

build() {
	Finstallgem
}
