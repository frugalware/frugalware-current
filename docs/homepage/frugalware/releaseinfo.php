<?php
$fwisos=split("\n", `ls -l $fwtopsrcdir/frugalware-current-iso/`);

fwopenbox("$fwstrreleaseinfo", 100, false);
foreach($fwreleases as $i)
{
	foreach($fwisos as $j)
	{
		if (preg_match ("/^l.*$i-cd1.iso$/i", $j))
			break;
	}
	$fwisover=preg_replace("|.*e-(.*)-cd1.iso ->.*|", "$1", $j);
	$isoname="$fwtopsrcdir/frugalware-current-iso/frugalware-$i-cd1.iso";
	print("<div align=\"left\">$arrow-$i<br>\n");
	print("&nbsp;&nbsp;&nbsp;" .
		date("M d H:i:s", filemtime($isoname)) . "<br>");
	print("&nbsp;&nbsp;&nbsp;frugalware-$fwisover");
	print("</div><p>");
}
print("<a href=\"download.php\">$fwstrdl</a>");
fwclosebox(false);
?>
