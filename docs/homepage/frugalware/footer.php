<?php

print ("<!-- start footer.php -->\n");

print("      </div>
    </td>
    <td valign=top width=\"15%\">
      <div align=\"center\">\n"); 

// right side box-list
include("releaseinfo.php");
print("<p>");
include("swpat.php");
print("<p>");
include("pageinfo.php");
// box-list ends

print("      </div>
    </td>
  </tr>
</table>\n");

print ("<br>\n<div align=\"center\">\n<a name=\"bottom\"></a>\n<small>");

if ($fwdebug)
{
	// stopper
	$stopper_stop = getmicrotime();
	if($stopper_start)
	{
		print ("$fwstrgentime: " .
		substr(($stopper_stop-$stopper_start), 0, 6) .
		" $fwstrsecs<br>");
	}
	print("$fwstrlastmod: " . 
		date("D M d H:i:s T Y", filemtime($pagename)) . "<br>");
}
print("&copy; 2003-" . date("Y") . " <a href=\"mailto:frugalware-devel@frugalware.org\">The Frugalware Developer Team</a>" .
	"</small>\n</div>\n</body>\n</html>\n");

print ("<!-- end footer.php -->\n");

?>
