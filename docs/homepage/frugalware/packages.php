<?php
#packages2.php - pkgs from mysql db
$fwtitle="Packages";
include("header.php");

# Searching for a package
function search_pkg() {
	$res_set = array();

	$search = $_GET['srch'];
	$repo = $_GET['repo'];
	$arch = $_GET['arch'];
	$fwver = $_GET['fwver'];
	($_GET['sub'] == "on") ? $sub = 1 : $sub = 0; # whether the search is for a substring or exact match

	$query = "select id, pkgname, pkgver, pkgrel, fwver, repo, arch from packages where ";
	# if the 'desc' is set (searching in description, too) I have to put 
	# the restrictions between brackets, because of the 'repo' below...
	if ($sub == 0){
		($_GET['desc'] == "on" || $_GET['desc'] == 1) ? $query .= "(pkgname='$search' or `desc`='$search')" : $query .= "(pkgname='$search')"; # if the desc is set, the search is for description, too
	}
	else {
		($_GET['desc'] == "on" || $_GET['desc'] == 1) ? $query .= "(pkgname like '%$search%' or `desc` like '%$search%')" : $query .= "(pkgname like '%$search%')";
	}
	if ($repo != "" && $repo != "all") { # if repo is set to frugalware or extra
		$query .= " and repo='$repo'";
	}
	if ($arch != "") {
		$query .= " and arch='$arch'";
	}
	if ($fwver != "") {
		$query .= " and fwver='$fwver'";
	}

	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query($query, $conn);
	if (mysql_num_rows($res) > 0) {
		while ($i = mysql_fetch_array($res)) {
			$res_set[] = $i;
		}
		mysql_close($conn);
		res_show($res_set, 'p', $search);
	}
	else {
		print "<h3>No package found</h3>";
		mysql_close($conn);
		error();
	}
}

function search_file() {
	$res_set = array();

	$search = $_GET['srch'];
	$repo = $_GET['repo'];
	($_GET['sub'] == "") ? $sub = 0 : $sub = 1; # whether the search is for a substring or exact match

	$query = "select id, pkgname, pkgver, pkgrel, fwver, repo from packages where files like '%$search%' ";
	if ($repo != "" && $repo != "all")
		$query .= "and repo='$repo'";
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query($query, $conn);
	if (mysql_num_rows($res) > 0) {
		while ($i = mysql_fetch_array($res)) {
			$res_set[] = $i;
		}
		mysql_close($conn);
		res_show($res_set, 'f', $search);

	}
	else {
		print "<h3>No such file found</h3>";
		mysql_close($conn);
		error();
	}
}

function error() {
	if ( is_numeric($_GET['id'])) {
		if ($_GET['s'] == "f")
			file_from_id($_GET['id']);
		else
			pkg_from_id($_GET['id']);
	}
	else {
		$tmp = $_SERVER['PHP_SELF'];
		$resz = explode("/", $tmp);
		$resz = $resz[count($resz)-1];
		unset($tmp);
		fwopenbox("Search", 50, false);
?>
<!--div align=center-->
<script type="text/javascript">
<!--

function chkdesc() {
	if (document.forms.pkgsrch.desc.checked)
		document.forms.pkgsrch.desc.checked=false
	else
		document.forms.pkgsrch.desc.checked=true
}

function chksub() {
	if (document.forms.pkgsrch.sub.checked)
		document.forms.pkgsrch.sub.checked=false
	else
		document.forms.pkgsrch.sub.checked=true
}

-->
</script>
<table width="70%" border="0" align="center">
<form name="pkgsrch" action="<?php print $resz; ?>" method="GET">
<input type=hidden name=op value=pkg>
<tr><td colspan=2>Search for a package</td></tr>
<tr><td colspan=2><input type="text" name="srch" size=40></td></tr>
<tr><td onClick="chksub()">Search for substring:</td><td align=right><input type="checkbox" name="sub"></td></tr>
<tr><td onClick="chkdesc()">Search in description:</td><td align=right><input type="checkbox" name="desc"></td></tr>
<tr><td>Repo:</td><td align=right><select name="repo">
        <option value="all" selected="selected">all</option>
        <option value="frugalware">frugalware</option>
        <option value="extra">extra</option>
</select></td></tr>
<tr><td>Arch:</td><td align=right><select name="arch">
	<option value="i686" selected="selected">i686</option>
	<option value="x86_64">x86_64</option>
</select></td></tr>
<tr><td>Version:</td><td align=right><select name="fwver">
<?php
	# getting fw versions from database
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db("frugalware", $conn);
	$res = mysql_query("select version from releases where type='stable' order by version desc", $conn);
	print "<option value=\"current\" selected=\"selected\">current</option>\n";
	while ($row = mysql_fetch_row($res)) {
		print "<option value=\"".$row[0]."\">".$row[0]."</option>\n";
	}
	mysql_close($conn);
?>
</select></td></tr>
<tr><td colspan=2 align=center><input type="submit" value="Search"> <input type="reset" value="Reset"></td></tr>
</form>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td colspan=2>Search for a file</td></tr>
<form name="filesrch" action="<?php print $resz; ?>" method="GET" enctype="multipart/form-data">
<input type=hidden name=op value=file>
<tr><td colspan=2><input type="text" name="srch" size=40></td></tr>
<tr><td colspan=2>Repo: 
<select name="repo">
        <option value="all" selected="selected">all</option>
        <option value="frugalware">frugalware</option>
        <option value="extra">extra</option>
</select></td></tr>
<tr><td colspan=2 align=center><input type="submit" value="Search"> <input type="reset" value="Reset"></td></tr>
</form>
</table>
<!--/div-->
<?php
		fwclosebox(false);
	}
}

function res_show($res_set, $what, $search) {
	switch ($what) {
		case 'p':
			fwopenbox("Search result for: \"$search\"", 50, false);
			print "<table width=\"100%\" border=\"0\">\n";
			$tmp = $_SERVER['PHP_SELF'];
			$resz = explode("/", $tmp);
			$resz = $resz[count($resz)-1];
			unset($tmp);
			for ($i=0,$j=1;$i<count($res_set);$i++,$j++) {
				print "<tr><td>".$j.". <a href=\"".$resz."?id=".$res_set[$i]['id']."\">".$res_set[$i]['pkgname']."</a> ".$res_set[$i]['pkgver']."-".$res_set[$i]['pkgrel']."<br>FwVer: ".$res_set[$i]['fwver']."; Repo: ".$res_set[$i]['repo']."; Arch: ".$res_set[$i]['arch']."</td></tr>\n";
			}
			fwclosebox(false);
			print "</table>\n";
			break;
		case 'f':
			fwopenbox("Search result for: \"$search\"", 50, false);
			print "<table width=\"100%\" border=\"0\">\n";
			$tmp = $_SERVER['PHP_SELF'];
			$resz = explode("/", $tmp);
			$resz = $resz[count($resz)-1];
			unset($tmp);
			for ($i=0,$j=1;$i<count($res_set);$i++,$j++) {
				print "<tr><td>".$j.". <a href=\"".$resz."?id=".$res_set[$i]['id']."&s=f\">".$res_set[$i]['pkgname']."</a> ".$res_set[$i]['pkgver']."-".$res_set[$i]['pkgrel']."<br>FwVer: ".$res_set[$i]['fwver']."; Repo: ".$res_set[$i]['repo']."</td></tr>\n";
			}
			fwclosebox(false);
			print "</table>\n";
			break;
	}
}

function pkg_from_id($id) {
	$tmp = $_SERVER['PHP_SELF'];
	$resz = explode("/", $tmp);
	$resz = $resz[count($resz)-1];
	unset($tmp);
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query("select pkgname, pkgver, pkgrel, groups, provides, depends, conflicts, replaces, csize, arch, `desc`, maintainer, md5, sha1, fwver, repo, updated from packages where id=$id", $conn);
	$arr = mysql_fetch_array($res);
	
	// query dep ids
	$query="select id, pkgname from packages where ( ";
	foreach(explode(" ", strtr($arr['depends'], "\n", " ")) as $i)
		$query .= " or pkgname='" . preg_replace('/(<>|>=|<=|=).*/', '', $i) . "'";
	$query = preg_replace("/or /", "", $query, 1) . " ) and " .
		"fwver='" . $arr['fwver'] . "' and " .
		"arch='" . $arr['arch'] . "'";
	$res2 = mysql_query($query);
	while ($i = mysql_fetch_array($res2, MYSQL_ASSOC))
	{
		$id_set[$i['pkgname']]=$i['id'];
	}
	
	fwopenbox("Package information: ".$arr['pkgname'], 80, false);
	print "<table border=0 width=100%>\n";
	print "<tr><td>Name:</td><td><a href=\"".$resz."?id=".$id."&s=f\">".$arr['pkgname']."</a></td></tr>\n";
	print "<tr><td>Version:</td><td>".$arr['pkgver']."-".$arr['pkgrel']."</td></tr>\n";
	if ($arr['repo']=="extra")
	{
		$repodir="/" . $arr['repo'];
		$pkgpath = $arr['repo'] . "/frugalware-" . $arr['arch'];
	}
	else
		$pkgpath = "/frugalware-" . $arr['arch'];
	$groupdir=preg_replace("/-extra/", "", $arr['groups']);
	print "<tr><td>Changelog:</td><td><a href=\"http://ftp.frugalware.org/pub/frugalware/frugalware-" . $arr['fwver'] . "$repodir/source/" . preg_replace("/^([^ ]*) .*/", "$1", $groupdir) . "/" . $arr['pkgname'] . "/Changelog\">Changelog</a></td></tr>\n";
	print "<tr><td>Darcs:</td><td><a href=\"http://darcs.frugalware.org/darcsweb/darcsweb.cgi?r=frugalware-" . $arr['fwver'] . ";a=tree;f=$repodir/source/" . preg_replace("/^([^ ]*) .*/", "$1", $groupdir) . "/" . $arr['pkgname'] . "\">View entry</a></td></tr>\n";
	if ($arr['groups'] != 'NULL') print "<tr><td>Groups:</td><td>".$arr['groups']."</td></tr>\n";
	if ($arr['provides'] != 'NULL') print "<tr><td>Provides:</td><td>".$arr['provides']."</td></tr>\n";
	if ($arr['depends'] != 'NULL')
	{
		print("<tr><td>Depends:</td><td>");
		foreach(explode(" ", strtr($arr['depends'], "\n", " ")) as $i)
			print("<a href=\"" . $resz . "?id=" . $id_set[preg_replace('/(<>|>=|<=|=).*/', '', $i)] . "\">$i</a> ");
		print("</td></tr>\n");
	}
	if ($arr['conflicts'] != 'NULL') print "<tr><td>Conflicts:</td><td>".$arr['conflicts']."</td></tr>\n";
	if ($arr['replaces'] != 'NULL') print "<tr><td>Replaces:</td><td>".$arr['replaces']."</td></tr>\n";
	if ($arr['csize'] != 'NULL') printf("%s%.2f%s", "<tr><td>Compressed size:</td><td>", $arr['csize']/1048576, "MiB</td></tr>\n");
	if ($arr['arch'] != 'NULL') print "<tr><td>Arch:</td><td>".$arr['arch']."</td></tr>\n";
	if ($arr['desc'] != 'NULL') print "<tr><td>Description:</td><td>".$arr['desc']."</td></tr>\n";
	if ($arr['maintainer'] != 'NULL') print "<tr><td>Maintainer:</td><td>".$arr['maintainer']."</td></tr>\n";
	print("<tr><td>Download: </td><td><a href=\"download.php?url=frugalware-" . $arr['fwver'] . "/" . $pkgpath . "/" . $arr['pkgname'] . "-" . $arr['pkgver'] . "-" . $arr['pkgrel'] . "-" . $arr['arch'] . ".fpm\">" . $arr['pkgname'] . "-" . $arr['pkgver'] . "-" . $arr['pkgrel'] . "-" . $arr['arch'] . ".fpm</a></td></tr>");
	print "<tr><td>Forums:</td><td><a href=\"http://forums.frugalware.org/index.php?t=search&srch=".$arr['pkgname']."\">forums.frugalware.org</a></td></tr>\n";
	print "<tr><td>Wiki:</td><td><a href=\"http://wiki.frugalware.org/Special:Search?search=".$arr['pkgname']."\">wiki.frugalware.org</a></td></tr>\n";
	print "<tr><td>Bug Tracking System:</td><td><a href=\"http://bugs.frugalware.org/index.php?string=".$arr['pkgname']."\">related open bugs</a>; file a feature request, bug report or mark outdated <a href=\"http://bugs.frugalware.org/?do=newtask&project=1\">here</td></tr>\n";
	if ($arr['md5'] != 'NULL') print "<tr><td>MD5 Sum:</td><td>".$arr['md5']."</td></tr>\n";
	if ($arr['sha1'] != '') print "<tr><td>SHA1 Sum:</td><td>".$arr['sha1']."</td></tr>\n";
	if ($arr['fwver'] != 'NULL') print "<tr><td>Frugalware version:</td><td>".$arr['fwver']."</td></tr>\n";
	if ($arr['repo'] != 'NULL') print "<tr><td>Repository:</td><td>".$arr['repo']."</td></tr>\n";
	if ($arr['updated'] != 'NULL') print "<tr><td>Updated:</td><td>".$arr['updated']."</td></tr>\n";
	print "</table>\n";
	fwclosebox(false);
	mysql_close($conn);
}

function file_from_id($id) {
	$tmp = $_SERVER['PHP_SELF'];
	$resz = explode("/", $tmp);
	$resz = $resz[count($resz)-1];
	unset($tmp);
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query("select pkgname, pkgver, pkgrel, files from packages where id=$id", $conn);
	$arr = mysql_fetch_array($res);
	mysql_close($conn);
	fwopenbox("File list for ".$arr['pkgname'], 80, false);
	print "<table border=0 width=100%>\n";
	print "<tr><td>Name:</td><td><a href=\"".$resz."?id=".$id."\">".$arr['pkgname']."</a></td></tr>\n";
	print "<tr><td>Version:</td><td>".$arr['pkgver']."-".$arr['pkgrel']."</td></tr>\n";
	print "<tr><td colspan=2>Files:</td></tr>\n";
	$files = explode("\n", substr($arr['files'], 0, -1));
	for($i=0;$i<count($files);$i++) {
		print "<tr><td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/".$files[$i]."</td></tr>\n";
	}
	print "</table>\n";
	fwclosebox(true);
}

switch ($_GET['op']) {
	case 'pkg':
		search_pkg();
		break;

	case 'file':
		search_file();
		break;
	default:
		error();
		break;
}

include("footer.php");

?>
