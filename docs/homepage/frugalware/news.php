<?php
$fwtitle="News";
include("header.php");

print ("<!-- start news.php -->\n");

if (file_exists("$fwnewsfile.$lang"))
	$newsf=file("$fwnewsfile.$lang");
else
	$newsf=file($fwnewsfile);
$opennew=true;
foreach($newsf as $i)
{
	if ($i != "\n")
	{
		$i = str_replace("\n", "", $i);
		$i = str_replace("\r", "", $i);
		if ($opennew)
		{
			if ($j < $fwnewsentries)
			{
				fwopenbox("$i", 100, false, $fwwhite);
				$j++;
			}
			else
				break;
		}
		elseif ($nextdate)
			print("<div align=right>\n<small>$i<br>");
		elseif ($nextname)
			print("$fwstrpby $i</small>\n</div>\n<p align=\"left\">");
		else
		{
			print($i . "<br>\n");
		}
		if ($nextdate)
		{
			$nextdate=false;
			$nextname=true;
		}
		else
			$nextname=false;
		if ($opennew)
		{
			$opennew=false;
			$nextdate=true;
		}
	}
	else
	{
		print ("</p>\n");
		fwclosebox(false);
		print("<p>\n");
		$opennew=true;
	}
}
print("<p>$fwstrprenews<a href=\"$fwtopsrcpubdir/frugalware-current/NEWS\">$fwstrmidnews</a>$fwstrpostnews");

include("footer.php");

print ("<!-- end news.php -->\n");

?>
