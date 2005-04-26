<?php
#packages2.php - pkgs from mysql db
$fwtitle="Packages";
include("header.php");

# Searching for a package
function search_pkg() {
	$res_set = array();

	$search = $_GET['srch'];
	$repo = $_GET['repo'];
	($_GET['sub'] == "on") ? $sub = 1 : $sub = 0; # whether the search is for a substring or exact match

	$query = "select id, pkgname, pkgver, pkgrel, fwver, repo from packages where ";
	# if the 'desc' is set (searching in description, too) I have to put 
	# the restrictions between brackets, because of the 'repo' below...
	if ($sub == 0){
		($_GET['desc'] == "on" || $_GET['desc'] == 1) ? $query .= "(pkgname='$search' or `desc`='$search') " : $query .= "(pkgname='$search') "; # if the desc is set, the search is for description, too
	}
	else {
		($_GET['desc'] == "on" || $_GET['desc'] == 1) ? $query .= "(pkgname like '%$search%' or `desc` like '%$search%') " : $query .= "(pkgname like '%$search%') ";
	}
	if ($repo != "" && $repo != "all") { # if repo is set to frugalware or extra
		$query .= "and repo='$repo'";
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
	if ( $_GET['id'] != "" ) {
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
?>
<div align=center>
<table width="70%" border="0" align="center">
<tr><td>Search for a package</td></tr>
<tr><td>
<form action="<?php print $resz; ?>" method="GET">
<input type=hidden name=op value=pkg>
<input type="text" name="srch" size=40><br>
Search for substring: <input type="checkbox" name="sub"><br>
Search in description: <input type="checkbox" name="desc"><br>
Repo: 
<select name="repo">
        <option value="all" selected="selected">all</option>
        <option value="frugalware">frugalware</option>
        <option value="extra">extra</option>
</select><br>
<input type="submit" value="Search"> <input type="reset" value="Reset">
</form>
</td></tr>
<tr><td><br>Search for a file</td></tr>
<tr><td>
<form action="<?php print $resz; ?>" method="GET" enctype="multipart/form-data">
<input type=hidden name=op value=file>
<input type="text" name="srch" size=40><br>
Repo: 
<select name="repo">
        <option value="all" selected="selected">all</option>
        <option value="frugalware">frugalware</option>
        <option value="extra">extra</option>
</select><br>
<input type="submit" value="Search"> <input type="reset" value="Reset">
</form>
</td></tr>
</table>
</div>
<?php
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
				print "<tr><td>".$j.". <a href=".$resz."?id=".$res_set[$i]['id'].">".$res_set[$i]['pkgname']."</a> ".$res_set[$i]['pkgver']."-".$res_set[$i]['pkgrel']."<br>FwVer: ".$res_set[$i]['fwver']."; Repo: ".$res_set[$i]['repo']."</td></tr>\n";
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
				print "<tr><td>".$j.". <a href=".$resz."?id=".$res_set[$i]['id']."&s=f>".$res_set[$i]['pkgname']."</a> ".$res_set[$i]['pkgver']."-".$res_set[$i]['pkgrel']."<br>FwVer: ".$res_set[$i]['fwver']."; Repo: ".$res_set[$i]['repo']."</td></tr>\n";
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
	$res = mysql_query("select pkgname, pkgver, pkgrel, groups, provides, depends, conflicts, replaces, csize, arch, `desc`, maintainer, md5, fwver, repo, updated from packages where id=$id", $conn);
	$arr = mysql_fetch_array($res);
	
	// query dep ids
	$query="select id, pkgname from packages where ";
	foreach(explode(" ", strtr($arr['depends'], "\n", " ")) as $i)
		$query .= " or pkgname='" . $i . "'";
	$res2 = mysql_query(preg_replace("/or /", "", $query, 1));
	while ($i = mysql_fetch_array($res2, MYSQL_ASSOC))
	{
		$id_set[$i['pkgname']]=$i['id'];
	}
	
	fwopenbox("Package information: ".$arr['pkgname'], 80, false);
	print "<table border=0 width=100%>\n";
	print "<tr><td>Name:</td><td><a href=\"".$resz."?id=".$id."&s=f\">".$arr['pkgname']."</a></td></tr>\n";
	print "<tr><td>Version:</td><td>".$arr['pkgver']."-".$arr['pkgrel']."</td></tr>\n";
	if ($arr['groups'] != '') print "<tr><td>Groups:</td><td>".$arr['groups']."</td></tr>\n";
	if ($arr['provides'] != '') print "<tr><td>Provides:</td><td>".$arr['provides']."</td></tr>\n";
	if ($arr['depends'] != '')
	{
		print("<tr><td>Depends:</td><td>");
		foreach(explode(" ", strtr($arr['depends'], "\n", " ")) as $i)
			print("<a href=\"" . $resz . "?id=" . $id_set[$i] . "\">$i</a> ");
		print("</td></tr>\n");
	}
	if ($arr['conflicts'] != '') print "<tr><td>Conflicts:</td><td>".$arr['conflicts']."</td></tr>\n";
	if ($arr['replaces'] != '') print "<tr><td>Replaces:</td><td>".$arr['replaces']."</td></tr>\n";
	if ($arr['size'] != '') print "<tr><td>Size:</td><td>".$arr['size']."</td></tr>\n";
	if ($arr['arch'] != '') print "<tr><td>Arch:</td><td>".$arr['arch']."</td></tr>\n";
	if ($arr['desc'] != '') print "<tr><td>Description:</td><td>".$arr['desc']."</td></tr>\n";
	if ($arr['maintainer'] != '') print "<tr><td>Maintainer:</td><td>".$arr['maintainer']."</td></tr>\n";
	print("<tr><td>Download: </td><td><a href=\"download.php?url=frugalware-" . $arr['fwver'] . "/" . $arr['repo'] . "/" . $arr['pkgname'] . "-" . $arr['pkgver'] . "-" . $arr['pkgrel'] . ".fpm\">" . $arr['pkgname'] . "-" . $arr['pkgver'] . "-" . $arr['pkgrel'] . ".fpm</a></td></tr>");
	if ($arr['md5'] != '') print "<tr><td>MD5 Sum:</td><td>".$arr['md5']."</td></tr>\n";
	if ($arr['fwver'] != '') print "<tr><td>Frugalware version:</td><td>".$arr['fwver']."</td></tr>\n";
	if ($arr['repo'] != '') print "<tr><td>Repository:</td><td>".$arr['repo']."</td></tr>\n";
	if ($arr['updated'] != '') print "<tr><td>Updated:</td><td>".$arr['updated']."</td></tr>\n";
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
	$files = explode(" ", $arr['files']);
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
