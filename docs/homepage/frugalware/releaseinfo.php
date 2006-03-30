<?php
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);

fwopenbox("$fwstrreleaseinfo", 100, false);
foreach($fwreleases as $i)
{
	$query = "select version, unix_timestamp(date) from releases where type = '$i' order by date desc";
	$result = mysql_query($query) or die('Error in query: ' . mysql_error());
	while($j = mysql_fetch_array($result, MYSQL_ASSOC))
		$releases[] = $j;
	mysql_free_result($result);
	print("<div align=\"left\">$arrow-$i<br>\n");
	foreach($releases as $j)
	{
		print("<p>&nbsp;&nbsp;&nbsp;<a href=\"http://frugalware.org/download.php?url=frugalware-" . $j['version'] . "-iso/frugalware-" . $j['version'] . ($j['version'] > "0.2" ? "-i686" : "") . "-dvd.iso\">frugalware-" . $j['version'] . "</a><br>");
		print("&nbsp;&nbsp;&nbsp;" .
			date("M d H:i:s", $j['unix_timestamp(date)']) . "<br></p>");
	}
	print("</div><p>");
}
print("<a href=\"download.php\">$fwstrdl</a> &middot; <a href=\"/rss.php?type=stable\">RSS</a>");
fwclosebox(false);
?>
