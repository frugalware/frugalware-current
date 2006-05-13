<?
$fwtitle="Authors";
include("header.php");

$people=file($fwautorsfile);

fwopenbox("$fwstraudev", 100, false, $fwwhite);
print("<div align=left><pre>");
foreach($people as $key => $value)
{
	// fix mail addresses
	print(str_replace(array("<", ">", "@"), array("&lt;", "&gt;", " at "), $value));
}
print("</pre></div>");
fwclosebox(false);
print("<p>");

include("footer.php");
?>
