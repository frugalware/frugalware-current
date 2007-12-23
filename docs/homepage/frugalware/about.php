<?
$fwtitle="What is Frugalware Linux";
include("header.php");

fwopenbox($fwstraboutshort, 100, false, $fwwhite);
print("<div align=left>$fwshortabout</div>");
fwclosebox(false);
print("<p>");
fwopenbox($fwstraboutlong, 100, false, $fwwhite);
foreach($fwabout as $i)
{
	print("<p align=left><b>$arrow $fwstrquestion: " . $i[0] . "</b></p>" .
		"<p align=left>$fwstranswer: " . $i[1] . "</p>");
}
fwclosebox(false);

include("footer.php");
?>
