#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kernel-module.sh for Frugalware
# distributed under GPL License

# a common function and a scriptlet for externel kernel module packages

kernelbasever=2.6.18
kernelrel=1
kernelver=$kernelbasever-$kernelrel
_F_kernel_dir=/lib/modules/$kernelbasever-fw$kernelrel
depends=("kernel=$kernelver")
makedepends=("kernel-source=$kernelver")
install=$Fincdir/kernel-module.install
options=(${options[@]} 'scriptlet')

Fcheckkernel()
{
	if [ "`uname -r|sed 's/fw//'`" != "$kernelver" ]; then
		error "You might installed the required kernel package, but"
		plain "you're not running that kernel. Please reboot your system."
		Fdie
	fi
}
