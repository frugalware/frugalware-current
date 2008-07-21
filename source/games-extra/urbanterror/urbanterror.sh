#!/bin/sh
if [ ! -e "$HOME/.urbanterror" ]; then mkdir $HOME/.urbanterror; fi
cd /usr/share/urbanterror/
exec ./ioUrbanTerror +set cl_curllib /usr/lib/libcurl.so \
     +set fs_basepath $HOME/.urbanterror +set fs_homepath $HOME/.urbanterror $*
