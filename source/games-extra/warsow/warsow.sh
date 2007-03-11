#!/bin/bash

cd "/usr/share/warsow/"
./warsow +set fs_usehomedir 1 $*
exit $?
