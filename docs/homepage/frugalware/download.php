<?
$fwtitle="Download";
include("header.php");

if (isset($_GET['url']))
	fwopenbox($fwstrdlfile, 100, false, $fwwhite);
else
	fwopenbox($fwstrdlfw, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($mirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]" . $_GET['url'] . ">$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

fwopenbox($fwstrdlhttp, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($httpmirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]" . $_GET['url'] . ">$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

fwopenbox($fwstrdlrsync, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($rsyncmirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]" . $_GET['url'] . ">$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

if (!isset($_GET['url']))
{
fwopenbox($fwstrdltorrentt, 100, false, $fwwhite);
printf("<div align=lef>" . $fwstrdltorrentd . "</div>");
fwclosebox(false);
print("<p>");

fwopenbox($fwstrdlrsynct, 100, false, $fwwhite);
print("<div align=left><ul>
<li>$fwstrdlrsync1<br>
<br><tt>rsync -avP --delete-after <i>server</i> /download/directory</tt><br>&nbsp;
<li>$fwstrdlrsync2<br>
<br><tt>rsync -avP --delete-after <i>server</i>/frugalware-current/ /download/directory/location </tt><br>&nbsp;
</ul></div>");
fwclosebox(0);
print("<p>");

fwopenbox($fwstrcheapisot, 100, false, $fwwhite);
print("<div align=left>" . $fwstrcheapisod . "<ul>");
foreach($buycd as $i)
{
	print("<li><a href=\"$i[1]\">$i[0]</a>");
}
print("</ul></div>");
fwclosebox(false);
}

include("footer.php");
?>
