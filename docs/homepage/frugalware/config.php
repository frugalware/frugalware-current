<?php
// colors
$fwwhite="#FFFFFF";
// for gray, see lib.php line ~16, too
$fwgray="#E7EAF4";
$fwblack="#8296BB";
$fwlink="#58657E";
#$fwlink="#14439C";
$fwlinkover="#000073";
$fwblacktext="#FFFFFF";

// pathes and files
$fwsitename="frugalware.org";
$fwtopsrcdir="/home/ftp/pub/frugalware/";
$fwtopsrcpubdir="ftp://ftp.frugalware.org/pub/frugalware/";
$fwnewsfile="$fwtopsrcdir/frugalware-current/NEWS";
$fwchlfile="$fwtopsrcdir/frugalware-current/ChangeLog.txt";

// mirrors
/*	array("ftp.frugalware.org",
		"ftp://ftp.frugalware.org/pub/frugalware/",
		"Hungary (100 Mbit)"),*/
$mirrors=array(
	array("ftp2.frugalware.org",
		"ftp://ftp2.frugalware.org/frugalware.org/pub/frugalware/",
		"Hungary (100 Mbit)"),
	array("ftp3.frugalware.org",
		"ftp://ftp3.frugalware.org/mirrors/frugalware/pub/frugalware/",
		"Hungary (100 Mbit)"),
	array("ftp4.frugalware.org",
		"ftp://ftp4.frugalware.org/pub/linux/distributions/frugalware/",
		"Hungary (2x100 Mbit, ftp.fsn.hu)")
	);

// misc
$fwdebug=false;
$fwchangelogentries=10;
$fwnewsentries=2;
$upfile="/proc/uptime";
$fwprefmirror=$mirrors[1][1];

// releases
$fwreleases=array("current", "testing");
?>
