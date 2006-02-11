#!/bin/bash

if [ "$#" -lt "1" ]; then
	echo "$0: calls fpmjunks.sh for each repo & arch"
	echo "usage: $0 <startdir> [--remove]"
	exit 1
fi

startdir=$1

archs=('i686' 'x86_64' 'ppc')

cd $startdir
for i in "${archs[@]}"
do
	if [ -e ../frugalware-$i/frugalware-current.fdb ]; then
		sh fpmjunk.sh $2 .. frugalware-current $i
	fi
	if [ -e ../extra/frugalware-$i/extra-current.fdb ]; then
		sh fpmjunk.sh $2 ../extra extra-current $i
	fi
done
