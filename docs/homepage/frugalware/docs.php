<?
$fwtitle="Documentation";
include("header.php");

fwopenbox("Documentation");
print("<p align=\"left\">The most common questions are collected on the <a href=\"about.php\">about</a> page.</p>
<p align=\"left\">This documentation is generated from tex files in the <a href=\"http://darcs.frugalware.org/cgi-bin/darcs.cgi/frugalware-current/docs/?c=browse\">-current darcs tree</a>.</p>
<p align=\"left\">I'd like to translate the documentation into my own language, what do I do to start?<br>
Send email to the <a href=\"mailto:frugalware-devel@frugalware.org\">-devel</a> mailing list, and we'll post our instructions.</p>");
fwclosebox();
print("<p>");

$translations = array(
	array('en', '', 'English'),
       	array('hu', '_hu', 'Hungarian'),
	array('sk', '_SK_sk','Slovak')
	);

fwopenbox("View online");
print("<div align=\"left\"><ul>");
foreach($translations as $i)
{
	print("<li>" . $i[2] . ": <a href=\"http://ftp.frugalware.org/pub/frugalware/frugalware-current/docs/html/" . $i[0] . "/\">HTML</a> or <a href=\"http://ftp.frugalware.org/pub/frugalware/frugalware-current/docs/html/" . $i[0] . "/frugalware-howto" . $i[1] . ".html\">HTML single file</a></li>\n");
}
print("</ul></div>");
fwclosebox();

include("footer.php");
?>
