#!/bin/bash

cd ~/.etwolf
mv pb pb.old
mkdir pb
if [ -e "etmain/etkey" ]; then
	mv etmain/etkey etmain/etkey.old
fi

/us/share/games/enemy-territory/pb/pb_setup_and_etkey.sh

exit 1