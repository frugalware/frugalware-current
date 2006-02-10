#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kernel-module.sh for Frugalware
# distributed under GPL License

# a common function and a scriptlet for externel kernel module packages

kernelver=2.6.15-2
makedepends=("kernel-source=$kernelver")
install=$Fincdir/kernel-module.install

Fcheckkernel()
{
	if [ "`uname -r|sed 's/fw//'`" != "$kernelver" ]; then
		error "You might installed the required kernel package, but"
		plain "you're not running that kernel. Please reboot your system."
		Fdie
	fi
}
