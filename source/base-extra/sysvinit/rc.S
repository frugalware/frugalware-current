#!/bin/sh

# (c) 2003-2004 Vajna Miklos <vmiklos@frugalware.org>
# rc.S for Frugalware
# distriuted under GPL license

export PATH=/sbin:/usr/sbin:/bin:/usr/bin
. /etc/profile.d/lang.sh

/etc/rc.d/rc.sysvinit 0 30 S
