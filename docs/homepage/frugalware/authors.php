<?
$fwtitle="Authors";
include("header.php");

$people=file($fwautorsfile);

// fix mail addresses
foreach($people as $key => $value)
{
	$people[$key] = str_replace(array("<", ">", "@", "á", "Á", "ä", "Ä", "é", "É", "ó", "Ó", "ö", "Ö", "ü", "Ü", "õ"), array("&lt;", "&gt;", "_at_", "&aacute;", "&Aacute;", "&auml;", "&Auml;", "&eacute;", "&Eacute;", "&oacute;", "&Oacute;", "&ouml;", "&Ouml;", "&uuml;", "&Uuml;", "&#337;"), $value);
}

// skip to list
$i=0;
while (!preg_match("/^Maintainers:/", $people[$i]))
	$i++;
$i++;

fwopenbox("$fwstraudev", 100, false, $fwwhite);
print("<div align=left><pre>");
while (!preg_match("/^$/", $people[$i]))
{
	print($people[$i]);
	$i++;
}
$i+=2;
print("</pre></div>");
fwclosebox(false);
print("<p>");

fwopenbox("$fwstraucontrib", 100, false, $fwwhite);
print("<div align=left><pre>");
while (!preg_match("/^$/", $people[$i]))
{
	print(preg_replace("/^\t/", "", $people[$i]));
	$i++;
}
$i+=2;
print("</pre></div>");
fwclosebox(false);
print("<p>");

include("footer.php");
?>
