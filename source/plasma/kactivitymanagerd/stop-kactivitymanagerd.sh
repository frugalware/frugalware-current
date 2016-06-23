#!/bin/sh

## WEIRD workaround for :
## -> kactivitymanagerd[7332]: segfault at 7fd0ac115bd0 ip 00007fd0ac0c5121 sp 00007ffd4d173848 error 4 in libQt5Sql.so.5.6.1
## see https://bugs.kde.org/show_bug.cgi?id=348194
##     https://bugreports.qt.io/browse/QTBUG-35977

/usr/bin/kactivitymanagerd stop
