<?
	switch($_GET['type'])
	{
		case "stable":
			include("/etc/todo.conf");
			$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
			mysql_select_db(DBNAME, $conn);
			$query="select version, `desc` from releases where type='stable' order by date desc";
			$result = mysql_query($query) or die();
			while ($i = mysql_fetch_array($result, MYSQL_ASSOC))
				$items[] = $i;
			mysql_free_result($result);
			break;
		case "darcs":
			header('Content-Type: application/xml; charset=utf-8');
			print(file_get_contents("http://darcs.frugalware.org/cgi-bin/darcs.cgi/frugalware-current/?c=rss"));
			die();
		case "bugs":
			header('Content-Type: application/xml; charset=utf-8');
			print(file_get_contents("http://bugs.frugalware.org/rss.php?type=new"));
			die();
		default:
			die();
	}
	
	header('Content-Type: application/xml; charset=utf-8');
	print('<?xml version="1.0"  encoding="utf-8"?>
<rss version="2.0">
<channel>
	<title>Frugalware Linux</title>
	<description>Frugalware Linux is general purpose Linux distribution designed for intermediate users. Some of its elements were borrowed from Slackware Linux and Arch Linux.</description>
	<link>http://frugalware.org/</link>');
	foreach($items as $i)
	{
		print("<item>
<title>frugalware-" . $i['version'] . "</title>
<description>" . $i['desc'] . "</description>
<link>http://frugalware.org/download.php?url=frugalware-" . $i['version'] . "-iso/frugalware-" . $i['version'] . "-dvd.iso</link>
</item>");
	}
print('</channel>
</rss>');
?>
