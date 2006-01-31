<?php
include("/etc/todo.conf");
fwopenbox("$fwstrpkginfo", 100, false);

if(file_exists($fwpkgcache))
	$info = stat($fwpkgcache);
if(!(isset($info) && ((time() - $info["mtime"])<$fwpkgcachetimeout)))
{
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$query = "select groups, pkgname, id, pkgver, pkgrel, arch from packages order by updated desc limit 10";
	$result = mysql_query($query) or die('Error in query: ' . mysql_error());
	while($i = mysql_fetch_array($result, MYSQL_ASSOC))
		$pkgs[] = $i;
	mysql_free_result($result);
	mysql_close($conn);
	$fp = fopen($fwpkgcache, "w");
	fwrite($fp, "<div align=\"left\">\n");
	foreach($pkgs as $i)
		fwrite($fp, preg_replace("/^([^ ]*) .*/", "$1", $i['groups']) . "/${i['pkgname']}<br>" .
		"<a href=\"packages.php?id=${i['id']}\">${i['pkgver']}-${i['pkgrel']}-${i['arch']}</a><br>");
	fwrite($fp, "</div><p>");
	fwrite($fp, "<a href=\"/rss.php?type=packages\">RSS</a>");
	fclose($fp);
}

include($fwpkgcache);
fwclosebox(false);
?>
