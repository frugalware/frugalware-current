<?
$fwtitle="Authors";
include("header.php");

$people=file($fwautorsfile);

// fix mail addresses
foreach($people as $key => $value)
{
	$people[$key] = str_replace(array("<", ">", "@", "á", "ä", "é", "ó", "ö", "ü"), array("&lt;", "&gt;", "_at_", "&aacute;", "&eacute;", "&auml;", "&oacute;", "&ouml;", "&uuml;"), $value);
}

// skip to list
$i=0;
while (!preg_match("/^[A-Z][a-z]*,/", $people[$i]))
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

fwopenbox("$fwstrauthx", 100, false, $fwwhite);
print("<div align=left><pre>");
while (!preg_match("/^$/", $people[$i]))
{
	print(preg_replace("/^\t/", "", $people[$i]));
	$i++;
}
print("</pre></div>");
fwclosebox(false);

include("footer.php");
?>
