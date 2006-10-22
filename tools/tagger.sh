#!/bin/bash

get_next_tag()
{
	LASTTAG=$(darcs changes -t . |sed -n 's/.* \(.*\)/\1/;2 p')
	LASTPREF=$(echo $LASTTAG | sed 's/-.*//')
	LASTSUFF=$(echo $LASTTAG | sed 's/.*-//')
	if [[ "$LASTPREF" == "$LASTSUFF" ]]; then
		NEWTAG="-dr1"
	else
		DRNUM=${LASTSUFF//dr/}
		NEWTAG="-dr$[$DRNUM + 1]"
	fi
	echo $LASTPREF$NEWTAG
}

cd $1
nexttag=`get_next_tag`
darcs tag --checkpoint $nexttag >/dev/null
darcs optimize >/dev/null
