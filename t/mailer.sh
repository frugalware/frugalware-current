#!/bin/bash

gen_output()
{
	# display a summary
	echo "================================================================================
$2 Results
--------------------------------------------------------------------------------"
	passed=0
	failed=0
	for i in $1/*
	do
		[ -d $i ] && continue
		if [ -z "`cat $i`" ]; then
			echo "[PASSED] `basename $i`"
			passed=$(($passed+1))
		else
			echo "[FAILED] `basename $i`"
			failed=$(($failed+1))
		fi
	done
	echo "--------------------------------------------------------------------------------"
	echo "TOTAL  =  $(($passed+$failed))"
	echo "PASSED =  $passed (`echo "100*$passed/$(($passed+$failed))"|bc`%)"
	echo "FAILED =  $failed (`echo "100*$failed/$(($passed+$failed))"|bc`%)"
	echo ""

	# detailed info on failed tests
	for i in $1/*
	do
		if [ -d $i ] || [ -z "`cat $i 2>&1`" ]; then
			continue
		fi
		echo "================================================================================
Details of '`basename $i`'
`$(basename $1)/$(basename $i) --help`
--------------------------------------------------------------------------------
"
		cat $i|sed 's/^\(.\)/| \1/'
		echo ""
	done
}

cd `dirname $0`
logdir=`mktemp -d`
mkdir $logdir/s

# run the tests
for i in *
do
	if [[ $i =~ sh$ ]] || [ $i == "README" ] || [ -d $i ]; then
		continue
	fi
	[ -x $i ] || chmod +x $i
	./$i > $logdir/$i
done

# run the stats
cd s
for i in *
do
	[ -x $i ] || chmod +x $i
	./$i > $logdir/s/$i
done
cd ..

(gen_output $logdir "Testsuite"; gen_output $logdir/s "Statistics") \
	| mail -r "Frugalware Testsuite <noreply@frugalware.org>" \
	-s "Testsuite results for `date +%Y-%m-%d`" frugalware-devel@frugalware.org
rm -rf $logdir
