<?
$fwtitle="Download";
include("header.php");

fwopenbox($fwstrdlfw, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($mirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]>$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

fwopenbox($fwstrdlhttp, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($httpmirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]>$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

fwopenbox($fwstrdlrsync, 100, false, $fwwhite);
print("<table width=\"100%\">\n");
foreach($rsyncmirrors as $i)
{
	print("<tr><td width=\"50%\"><a href=$i[1]>$i[0]" .
		"<td>$i[2]\n");
}
print("</table>\n");
fwclosebox(0);
print("<p></p>");

fwopenbox($fwstrdlrsynct, 100, false, $fwwhite);
print("<div align=left><ul>
<li>$fwstrdlrsync1<br>
<br><tt>rsync -avP --delete-after <i>server</i> /download/directory</tt><br>&nbsp;
<li>$fwstrdlrsync2<br>
<br><tt>rsync -avP --delete-after <i>server</i>/pub/frugalware/frugalware-current/ /download/directory/location </tt><br>&nbsp;
<li>$fwstrdlrsync3<br>
<br><tt>rsync -avP --delete-after --exclude '*.fpm' --exclude '*.tar.gz' --exclude '*.tar.bz2' --exclude '*.tgz' --exclude '*.tbz' --exclude '*.bin' --exclude '*.rpm' --exclude '*.zip' --exclude '*.tar.Z' --exclude '*.exe' --exclude '*.img.gz' <i>server</i>/pub/frugalware/frugalware-current/ /download/directory/location</tt><br>&nbsp;
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

include("footer.php");
?>
