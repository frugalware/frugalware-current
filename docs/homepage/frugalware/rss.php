<?
	switch($_GET['type'])
	{
		case "stable":
			$handle['title']="Frugalware Linux";
			$handle['desc']="Frugalware Linux is general purpose Linux distribution designed for intermediate users. Some of its elements were borrowed from Slackware Linux and Arch Linux.";
			$handle['link']="http://frugalware.org/";
			include("/etc/todo.conf");
			$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
			mysql_select_db(DBNAME, $conn);
			$query="select version, `desc` from releases where type='stable' order by date desc";
			$result = mysql_query($query) or die();
			while ($i = mysql_fetch_array($result, MYSQL_ASSOC))
			{
				$handle['items'][] = array("title" => "frugalware-" . $i['version'],
						"desc" => $i['desc'],
						"link" => "http://frugalware.org/download.php?url=frugalware-" . $i['version'] . "-iso/frugalware-" . $i['version'] . "-dvd.iso");
			}
			mysql_free_result($result);
			break;
		case "packages":
			$handle['title']="Frugalware Linux Packages";
			$handle['desc']="Latest updates to the Frugalware Linux package repositories.";
			$handle['link']="http://frugalware.org/packages.php";
			include("/etc/todo.conf");
			$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
			mysql_select_db(DBNAME, $conn);
			$query="select groups, pkgname, id, pkgver, pkgrel, arch, `desc`, unix_timestamp(updated) from packages order by updated desc limit 10";
			$result = mysql_query($query) or die();
			while ($i = mysql_fetch_array($result, MYSQL_ASSOC))
			{
				$handle['items'][] = array("title" => preg_replace("/^([^ ]*) .*/", "$1", $i['groups']) . "/${i['pkgname']}-${i['pkgver']}-${i['pkgrel']}-${i['arch']}",
						"desc" => $i['desc'],
						"pubDate" => date(DATE_RFC2822, $i['unix_timestamp(updated)']),
						"link" => "http://frugalware.org/packages.php?id=${i['id']}");
			}
			mysql_free_result($result);
			break;
		case "darcs":
			header('Content-Type: application/xml; charset=utf-8');
			print(file_get_contents("http://darcs.frugalware.org/genesis.darcsweb/darcsweb.cgi?r=frugalware-current;a=rss"));
			die();
		case "bugs":
			header('Content-Type: application/xml; charset=utf-8');
			print(file_get_contents("http://bugs.frugalware.org/rss.php?type=new"));
			die();
		default:
			$fwtitle="RSS";
			include("header.php");

			fwopenbox("Frugalware RSS feeds");
			print('<div align="left"><ul>
			<li><a href="/rss.php?type=stable">Stable releases</a></li>
			<li><a href="/rss.php?type=darcs">Darcs commits</a></li>
			<li><a href="/rss.php?type=bugs">BTS entries</a></li>
			<li><a href="/rss.php?type=packages">Package updates</a></li>
			</ul></div>');
			fwclosebox(false);

			include("footer.php");
			die();
	}
	
	header('Content-Type: application/xml; charset=utf-8');
	print("<?xml version=\"1.0\"  encoding=\"utf-8\"?>
<rss version=\"2.0\">
<channel>
	<title>" . $handle['title'] . "</title>
	<description>" . $handle['desc'] . "</description>
	<link>" . $handle['link'] . "</link>");
	foreach($handle['items'] as $i)
	{
		print("<item>
<title>" . $i['title'] . "</title>
<description>" . htmlspecialchars($i['desc']) . "</description>
<link>" . $i['link'] . "</link>\n");
if(isset($i['pubDate']))
	print("<pubDate>" . $i['pubDate'] . "</pubDate>\n");
print("</item>");
	}
print('</channel>
</rss>');
?>
