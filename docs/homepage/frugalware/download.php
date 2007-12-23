<?
$fwtitle="Download";
include("header.php");

fwopenbox($fwstrdlfw, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($mirrors as $i)
{
	print("<tr><td><a href=$i[1]>$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);

include("footer.php");
?>
