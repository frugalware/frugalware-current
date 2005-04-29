#!/bin/sh
if [ "$MOZILLA_FIVE_HOME" == "" ]; then
	echo "/usr/lib/firefox-1.0/chrome/rc.d/generate-chrome.sh"
	echo "MOZILLA_FIVE_HOME must be set !";
	echo "Rebuild the installed-chrome.txt file according to the installed extension"
	echo "Extensions must provide a *.txt file starting by a number in the"
	echo "MOZILLA_FIVE_HOME/chrome/rc.d directory"
	exit -1;
fi
chrome_directory=$MOZILLA_FIVE_HOME/chrome
pushd $chrome_directory/rc.d 1>/dev/null

# If there is no rc.d/installed-chrome.txt then this is the first time
# this script is run. Let's copy it !
if [ ! -f $chrome_directory/rc.d/installed-chrome.txt ]; then
	cp -f $chrome_directory/installed-chrome.txt $chrome_directory/rc.d
fi
cp -f $chrome_directory/installed-chrome.txt \
$chrome_directory/installed-chrome.txt.rc.d.old
cat installed-chrome.txt > $chrome_directory/installed-chrome.txt
FILES=`ls [0-9]*.txt 2>/dev/null`
if [[ -n "$FILES" ]]; then
cat $FILES >> $chrome_directory/installed-chrome.txt
fi
popd 1>/dev/null
