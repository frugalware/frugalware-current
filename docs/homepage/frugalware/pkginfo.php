<?php
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);

fwopenbox("$fwstrpkginfo", 100, false);
	$query = "select groups, pkgname, id, pkgver, pkgrel, arch from packages order by updated desc limit 10";
	$result = mysql_query($query) or die('Error in query: ' . mysql_error());
	while($i = mysql_fetch_array($result, MYSQL_ASSOC))
		$pkgs[] = $i;
	mysql_free_result($result);
	print("<div align=\"left\">\n");
	foreach($pkgs as $i)
		print(preg_replace("/^([^ ]*) .*/", "$1", $i['groups']) . "/${i['pkgname']}<br>" .
		"<a href=\"packages.php?id=${i['id']}\">${i['pkgver']}-${i['pkgrel']}-${i['arch']}</a><br>");
	print("</div><p>");
print("<a href=\"/rss.php?type=packages\">RSS</a>");
fwclosebox(false);
?>
