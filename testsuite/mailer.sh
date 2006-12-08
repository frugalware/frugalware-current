#!/bin/bash

gen_output()
{
	# display a summary
	echo "================================================================================
Results
--------------------------------------------------------------------------------"
	passed=0
	failed=0
	for i in $logdir/*
	do
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
	for i in $logdir/*
	do
		if [ -z "`cat $i`" ]; then
			continue
		fi
		echo "================================================================================
Details of '`basename $i`'
`./$(basename $i) --help`
--------------------------------------------------------------------------------"
		cat $i|sed 's/^\(.\)/| \1/'
		echo ""
	done
}

cd `dirname $0`
logdir=`mktemp -d`

# run the tests
for i in *
do
	if [[ $i =~ sh$ ]] || [ $i == "README" ]; then
		continue
	fi
	[ -x $i ] || chmod +x $i
	./$i > $logdir/$i
done

gen_output |mail -r "Frugalware Testsuite <noreply@frugalware.org>" \
	-s "Testsuite results for `date +%Y-%m-%d`" frugalware-devel@frugalware.org
rm -rf $logdir
