<?php

fwopenbox("$fwstrserverinfo", 100, false);
$statf=file($upfile);
list($uptime, $junk) = split(" ", $statf[0]);
$secuptime=floor($uptime);
// sec
$minuptime=60*floor($uptime/60);
$sec= $secuptime - $minuptime;
// min
$houruptime=3600*floor($minuptime/3600);
$min= $minuptime - $houruptime;
// hour
$dayuptime=86400*floor($houruptime/86400);
$hour= $houruptime - $dayuptime;
print("<div align=\"left\">Uptime:<br>" . $dayuptime/86400 . " $fwstrday " .
	$hour/3600 ." $fwstrhour " . $min/60 . " $fwstrmin ".$sec." $fwstrsec</div>\n");
fwclosebox(false);
?>
