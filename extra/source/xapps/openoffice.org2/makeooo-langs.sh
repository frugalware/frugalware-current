#!/bin/sh

echo -e "Searching locale files and putting same locales into tar...\n"
for code in `ls -1 *.res` 
do
    x=`echo $code | awk -F 0 '{print $NF}' | sed 's|.res||'`
    echo $x
    echo -e "Adding $code to ooo2-i18n-$x.tar\n"
    tar -rf ooo2-i18n-$x.tar $code
done
echo -e "TAR packages completed.\n\n"

echo -e "Compressing tar packages...\n"
for tars in `ls -1 *.tar`
do
    echo -e "Compressing $tars...\n"
    bzip2 $tars
done
echo -e "Done.\n"
