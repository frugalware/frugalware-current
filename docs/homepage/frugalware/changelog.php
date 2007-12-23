<?
$fwtitle="Changelog";
include("header.php");

if (file_exists("$fwchlfile.$lang"))
	$changelogf=file("$fwchlfile.$lang");
else
	$changelogf=file($fwchlfile);
$opennew=true;
foreach($changelogf as $i)
{
	if ($i != "\n")
	{
		$i = str_replace("\n", "", $i);
		$i = str_replace("\r", "", $i);
		$i = str_replace(" ", "&nbsp;", $i);
		if ($opennew)
		{
			if ($j < $fwchangelogentries)
			{
				fwopenbox("$i", 100, false, $fwwhite);
				// print("<tt>");
				print ("<p align=\"left\">\n");
				$j++;
			}
			else
				break;
			$firstline=true;
		}
		else
		{
			if (substr($i, 0, 1) == "-" && !$firstline)
#				print("<br>\n" . $i);
				print($i . "<br>\n");
			else
				print($i."<br>");
			$firstline=false;
		}
		$opennew=false;
	}
	else
	{
		print ("</p>\n");
		fwclosebox(0);
		print("<p>\n");
		$opennew=true;
	}
}
print("<p>$fwstrprelog<a href=\"${fwtopsrcpubdir}frugalware-current/ChangeLog.txt\">$fwstrmidlog</a>$fwstrpostlog");

include("footer.php");
?>
