#!/bin/sh

# (c) 2003-2004 Vajna Miklos <mamajom@axelero.hu>
# rc.M for FrugalWare
# distriuted under GPL license

export PATH=/sbin:/usr/sbin:/bin:/usr/bin
. /etc/profile.d/lang.sh

/etc/rc.d/rc.sysvinit 30 100 S
