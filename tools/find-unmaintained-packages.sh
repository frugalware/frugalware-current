#!/bin/bash

# the output of this script is published daily at
# http://frugalware.org/~repo/stats/unmaintained.txt

cd ../t
activedevs=$(./chkacc |sed "s/.*'\(.*\)'/\1/g" |xargs echo|sed 's/ /|/g')
cd ..

for i in `git ls-files source |grep FrugalBuild`
do
	egrep -q "Maintainer:.*($activedevs)" $i || echo "$i is unmaintained"
done
