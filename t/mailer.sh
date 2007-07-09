#!/bin/bash

stabledir="../../frugalware-stable/t"

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
`./$3/$(basename $i) --help`
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
	if [[ $i =~ sh$ ]] || [[ $i =~ py$ ]] || [ -d $i ]; then
		continue
	fi
	[ -x $i ] || chmod +x $i
	./$i > $logdir/$i
done

# run the stable tests
if [ -d $stabledir ]; then
	mkdir $logdir/stable
	cd $stabledir
	for i in *
	do
		if [[ $i =~ sh$ ]] || [[ $i =~ py$ ]] || [ -d $i ]; then
			continue
		fi
		[ -x $i ] || chmod +x $i
		./$i > $logdir/stable/$i
	done
	cd - >/dev/null
fi

# run the stats
cd s
for i in *
do
	[ -x $i ] || chmod +x $i
	./$i > $logdir/s/$i
done
cd ..

(gen_output $logdir "-current Testsuite" ""; gen_output $logdir/stable "-stable Testsuite" "$stabledir"; gen_output $logdir/s "-current Statistics" "s") \
	| mail -r "Frugalware Testsuite <noreply@frugalware.org>" \
	-s "Testsuite results for `date +%Y-%m-%d`" frugalware-devel@frugalware.org
if [ -e $HOME/dead.letter ]; then
	# ugly hack
	cat $HOME/dead.letter | mail -r "Frugalware Testsuite <noreply@frugalware.org>" \
	-s "Testsuite results for `date +%Y-%m-%d`" frugalware-devel@frugalware.org
	rm $HOME/dead.letter
fi
rm -rf $logdir
