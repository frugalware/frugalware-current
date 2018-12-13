#!/bin/bash

# the output of this script is published daily at
# http://frugalware.org/~repo/stats/unmaintained.txt

cd `dirname $0`/../t
activedevs=$(./chkacc --verbose |sed "s/.*'\(.*\)'/\1/g" |xargs echo|sed 's/ /|/g')
cd ..

for i in `git ls-files source |grep FrugalBuild`
do
	egrep -i -q "Maintainer:.*($activedevs)" $i || echo "$i has inactive or wrong maintainer"
done
