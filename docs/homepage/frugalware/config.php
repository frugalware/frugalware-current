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
$fwtopsrchtmlpubdir="http://ftp.frugalware.org/pub/frugalware/";
$fwnewsfile="$fwtopsrcdir/frugalware-current/NEWS";
$fwautorsfile="$fwtopsrcdir/frugalware-current/AUTHORS";
$fwchlfile="$fwtopsrcdir/frugalware-current/ChangeLog.txt";

// mirrors
/*	array("ftp.frugalware.org",
		"ftp://ftp.frugalware.org/pub/frugalware/",
		"Hungary (100 Mbit)"),*/
$mirrors=array(
	array("ftp2.frugalware.org",
		"ftp://ftp2.frugalware.org/frugalware.org/pub/frugalware/",
		"Hungary (36x2.8 MBit)"),
	array("ftp3.frugalware.org",
		"ftp://ftp3.frugalware.org/mirrors/frugalware/pub/frugalware/",
		"Hungary (100 MBit, usually obsolete)"),
	array("ftp4.frugalware.org",
		"ftp://ftp4.frugalware.org/pub/linux/distributions/frugalware/",
		"Hungary (2x100 MBit, ftp.fsn.hu)"),
	array("ftp5.frugalware.org",
		"ftp://ftp5.frugalware.org/packages/frugalware/pub/frugalware/",
		"Belgium (2x1GBit, ftp.belnet.be)")
	);

$httpmirrors=array(
	array("www5.frugalware.org",
		"http://www5.frugalware.org/linux/frugalware/pub/frugalware/",
		"Belgium (2x1GBit, ftp.belnet.be)"),
	array("www6.frugalware.org",
		"http://www6.frugalware.org/",
		"Hungary (-current only, no isos)")
	);
$rsyncmirrors=array(
	array("ftp4.frugalware.org",
		"rsync://ftp4.frugalware.org::ftp/pub/linux/distributions/frugalware/",
		"Hungary (2x100 MBit, ftp.fsn.hu)"),
	array("ftp5.frugalware.org",
		"rsync://ftp5.frugalware.org::packages/frugalware/",
		"Belgium (2x1GBit, ftp.belnet.be)")
	);
$buycd=array(
	array("CheapISO.com",
		"http://cheapiso.com/product_info.php&amp;cPath=1&amp;products_id=141"),
	array("Linux Central",
		"http://linuxcentral.com/catalog/index.php3&amp;prod_code=L000-321&amp;id=C1Cto1Nc0CrCp")
	);

// misc
$fwdebug=false;
$fwchangelogentries=10;
$fwnewsentries=10;
$upfile="/proc/uptime";
$fwprefmirror=$mirrors[1][1];

// releases
$fwreleases=array("current", "testing", "stable");
?>
