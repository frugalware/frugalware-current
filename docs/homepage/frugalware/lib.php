<?php
// page generation stopper
$stopper_start = getmicrotime();

// include language strings

if (isset($lang) && $lang != "" ) {
	if (isset($_GET["lang"]) && $_GET["lang"] != "") {
		$nlang = $_GET["lang"];
		if ($nlang != $lang) {
			$lang = $nlang;
			setcookie("fwcurrlang", $lang);
		}
	}
}
else {
	if (isset($_GET["lang"]) && $_GET["lang"] != "") {
		$lang=$_GET["lang"];
		setcookie("fwcurrlang", $lang);
	}
	else {
		$lang=preg_replace( "/^([a-z]*)-.*/", "$1",
			preg_replace("/^([a-z\-]*),.*/", "$1", $HTTP_ACCEPT_LANGUAGE));
	}
}

if ( $lang == "" ) {
	$lang="en";
}

$inclang="lang/$lang.php";
include($inclang);

$aboutlang="lang/about.$lang.php";
if (file_exists($inclang))
        include($inclang);
if (preg_replace("|.*/(.*)|", "$1", $PHP_SELF) == "about.php")
{
	include("lang/about.en.php");
	if (file_exists($aboutlang))
	        include($aboutlang);
}

$arrow="<img src=\"images/arrow.gif\" alt=\"$fwstrarrow\">";
	
// functions

function fwopenbox($fwtitle, $fwpercent=100, $fwflip=false, $fwfill="#E7EAF4")
{
	global $fwblack, $fwblacktext;
	print ("<!-- :: start fwopenbox :: -->\n");
	print("<table width=\"$fwpercent%\" cellspacing=\"1\" "."bgcolor=\"$fwblack\">\n");
	$upopts = "";
	$downopts = "";
	$uptdopts = "";
	$downtdopts = "";
	if (!$fwflip)
	{
		$upopts="<font color=\"$fwblacktext\">"; # cimszoveg feher
		$downtdopts=" bgcolor=\"$fwfill\""; # tartalmi resz hatterszine
	}
	else
	{
		$downopts="<font color=\"$fwblacktext\">"; # cimszoveg szine sotet
		$uptdopts=" bgcolor=\"$fwfill\""; # tartalmi resz hatterszine
	}
	if ($fwtitle != "") # ha van cime a boxnak
	{
		print("  <tr>\n    <td${uptdopts} align=\"center\">${upopts}\n$fwtitle\n");
		if ($upopts != "")
			print("    </font></td>\n  </tr>\n");
		else
			print("    </td>\n  </tr>\n");
	}
	print("  <tr>\n    <td${downtdopts} align=\"center\">\n      $downopts");
	print ("\n<!-- :: end fwopenbox :: -->\n");
}

function fwclosebox($fwkellfont=true)
{

	print ("<!-- :: start fwclosebox :: -->\n");
	if ($fwkellfont)
		print ("      </font>\n");
	print("    </td>\n  </tr>\n</table>\n");
	print ("\n<!-- :: end fwclosebox :: -->\n");
}

function getmicrotime(){
	list($usec, $sec) = explode(" ",microtime());
	return ((float)$usec + (float)$sec);
}
?>
