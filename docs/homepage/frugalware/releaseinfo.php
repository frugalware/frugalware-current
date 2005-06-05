<?php
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);

$fwisos=split("\n", `ls -l $fwtopsrcdir/frugalware-current-iso/`);

fwopenbox("$fwstrreleaseinfo", 100, false);
foreach($fwreleases as $i)
{
	$query = "select version, unix_timestamp(date) from releases where type = '$i' order by date desc limit 0,1";
	$result = mysql_query($query) or die('Error in query: ' . mysql_error());
	$release = mysql_fetch_array($result, MYSQL_ASSOC);
	mysql_free_result($result);
	print("<div align=\"left\">$arrow-$i<br>\n");
	print("&nbsp;&nbsp;&nbsp;" .
		date("M d H:i:s", $release['unix_timestamp(date)']) . "<br>");
	print("&nbsp;&nbsp;&nbsp;frugalware-" . $release['version']);
	print("</div><p>");
}
print("<a href=\"download.php\">$fwstrdl</a>");
fwclosebox(false);
?>
