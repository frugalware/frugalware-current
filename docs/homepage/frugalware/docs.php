<?
$fwtitle="Documentation";
include("header.php");

fwopenbox("$fwstrdocs");
printf($fwstrdocsabout, "about.php");
printf($fwstrdocsdarcs, "http://darcs.frugalware.org/darcsweb/darcsweb.cgi?r=frugalware-current;a=tree;f=/docs");
print($fwstrdocsq);
printf($fwstrdocsa, "mailto:frugalware-devel@frugalware.org");
fwclosebox();
print("<p>");

$translations = array(
	array('en', '', $fwstrdocsen),
       	array('hu', '_hu', $fwstrdocshu),
	array('sk', '_SK_sk',$fwstrdocssk)
	);

fwopenbox($fwstrdocsonline);
print("<div align=\"left\"><ul>");
foreach($translations as $i)
{
	print("<li>" . $i[2] . ": <a href=\"http://ftp.frugalware.org/pub/frugalware/frugalware-current/docs/html/" . $i[0] . "/\">$fwstrdocshtml</a> or <a href=\"http://ftp.frugalware.org/pub/frugalware/frugalware-current/docs/html/" . $i[0] . "/frugalware-howto" . $i[1] . ".html\">$fwstrdocshtmlsingle</a></li>\n");
}
print("</ul></div>");
fwclosebox();

include("footer.php");
?>
