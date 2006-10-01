[ -z "$arch" ] && arch=`uname -m`
ver=`grep '<version>' ../docs/xml/volumes.xml |sed 's/.*>\(.*\)<.*/\1/'`
[ -z "$ver" ] && ver=`date +%Y%m%d`

mkdir frugalware-$ver-$arch-usb
cd frugalware-$ver-$arch-usb
cp ../usb_install.sh ./
chmod +x usb_install.sh
cp -v ../../boot/initrd-$arch.img.gz ./
cp -v ../../boot/vmlinuz-*$arch ./
cp -v ../../boot/grub/message ./
cp -v ../../docs/xml/volumes.xml ./
echo "This tarball contains all the necessary tools to install the Frugalware
\"-net\" install to your usb stick.

Run ./usb_install.sh as root and follow the instructions." > README
cd ..
tar cvzf frugalware-$ver-$arch-usb.tar.gz frugalware-$ver-$arch-usb
rm -rf frugalware-$ver-$arch-usb
