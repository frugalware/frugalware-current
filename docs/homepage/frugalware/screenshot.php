<?
$fwtitle="Screenshots";
include("header.php");

foreach($shot_titles as $key => $value)
{
	print("<table align=left><tr><td><a href=\"images/shots/$key\">" .
		"<img src=\"images/shots/" . preg_replace("/\./", "s.", $key) .
		"\" alt=\"$value\"></a><br>$value</td></tr></table>\n");
}

include("footer.php");
?>
