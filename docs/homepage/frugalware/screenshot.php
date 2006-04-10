<?
$fwtitle="Screenshots";
include("header.php");
include("lang/shots.".$lang.".php");

print "<div class=\"screenshots\">\n";
print "<form>\n<fieldset class=\"fieldset\" id=\"installer\">\n<legend>Installer</legend>\n";
for ($i=0; $i<count($shots[inst]); $i++)
{
	print "<div><a href=\"http://www2.frugalware.org/images/screenshots/installer/".$shots[inst][$i][name]."\">".
	"<img src=\"http://www2.frugalware.org/images/screenshots/installer/thumbnails/".$shots[inst][$i][name]."\"></a>".
	"<br />".$shots[inst][$i][title]."</div>\n";
}
//print "</div>\n";
print "</fieldset>\n<fieldset class=\"fieldset\" id=\"default\">\n";
//print "<div class=\"screenshots\">\n";
print "<legend>Default Desktop</legend>\n";
for ($i=0; $i<count($shots[defdesk]); $i++)
{
	print "<div><a href=\"http://www2.frugalware.org/images/screenshots/default/".$shots[defdesk][$i][name]."\">".
	"<img src=\"http://www2.frugalware.org/images/screenshots/default/thumbnails/".$shots[defdesk][$i][name]."\"></a>".
	"<br />".$shots[defdesk][$i][title]."</div>\n";
}
print "</form>\n";
print "</div>\n";

/*
foreach($shot_titles as $key => $value)
{
	print("<table align=left><tr><td><a href=\"images/shots/$key\">" .
		"<img src=\"images/shots/" . preg_replace("/\./", "s.", $key) .
		"\" alt=\"$value\"></a><br>$value</td></tr></table>\n");
}
*/

include("footer.php");
?>
