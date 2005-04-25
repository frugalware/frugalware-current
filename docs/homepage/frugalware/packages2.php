<?php
#packages2.php - pkgs from mysql db

# Searching for a package
function search_pkg() {
	$res_set = array();

	$search = $_GET['srch'];
	$repo = $_GET['repo'];
	($_GET['sub'] == "") ? $sub = 0 : $sub = 1; # whether the search is for a substring or exact match

	$query = "select * from packages where ";
	switch($sub) {
		# if the 'desc' is set (searching in description, too) I have to put 
		# the restrictions between brackets, because of the 'repo' below...
		case 0: # exact match
			($_GET['desc'] == "" || $_GET['desc'] == 0) ? $query .= "(pkgname='$search') " : $query .= "(pkgname='$search' or `desc`='$search') "; # if the desc is set, the search is for description, too
		
		case 1: # substring
			($_GET['desc'] == "" || $_GET['desc'] == 0) ? $query .= "(pkgname like '%$search%') " : $query .= "(pkgname like '%$search%' or `desc` like '%$search%') ";
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
		res_show($res_set, 'p', $search);

	}
	mysql_close($conn);
}

function res_show($res_set, $what, $search) {
	switch ($what) {
		case 'p':
			include("header.php");
			fwopenbox("Search result for: $search");
?>
<table width="70%" border="0">
<?php
			$tmp = $_SERVER['PHP_SELF'];
			$resz = explode("/", $tmp);
			$resz = $resz[count($resz)-1];
			unset($tmp);
			for ($i=0,$j=1;$i<count($res_set);$i++,$j++) {
				print "<tr><td>".$j.". <a href=".$resz."?id=".$res_set[$i]['id'].">".$res_set[$i]['pkgname']."</a></td></tr>\n";
			}
			fwclosebox(false);
?>
</table>
<?php
			include("footer.php");
			break;
		case 'f':
			break;
	}
}

function search_file() {
	print "Not ready yet...";
}

function error() {
	if ( $_GET['id'] != "" ) {
		pkg_from_id($_GET['id']);
	}
	else {
?>
<div class="error">HIBA!!! Valami paraméter nincs, vagy hibásan lett megadva !!!</div>
<?php
	}
}

function pkg_from_id($id) {
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query("select pkgname, pkgver, pkgrel, groups, provides, depends, conflicts, replaces, csize, arch, `desc`, maintainer, md5, fwver, repo, updated from packages where id=$id", $conn);
	$arr = mysql_fetch_array($res);
	include("header.php");
	fwopenbox("Package information: ".$arr['pkgname'], 100, false);
	print "<table border=0 width=70%>\n";
	print "<tr><td>Name:</td><td>".$arr['pkgname']."</td></tr>\n";
	print "<tr><td>Version:</td><td>".$arr['pkgver']."-".$arr['pkgrel']."</td></tr>\n";
	if ($arr['groups'] != '') print "<tr><td>Groups:</td><td>".$arr['groups']."</td></tr>\n";
	if ($arr['provides'] != '') print "<tr><td>Provides:</td><td>".$arr['provides']."</td></tr>\n";
	if ($arr['depends'] != '') print "<tr><td>Depends:</td><td>".$arr['depends']."</td></tr>\n";
	if ($arr['conflicts'] != '') print "<tr><td>Conflicts:</td><td>".$arr['conflicts']."</td></tr>\n";
	if ($arr['replaces'] != '') print "<tr><td>Replaces:</td><td>".$arr['replaces']."</td></tr>\n";
	if ($arr['size'] != '') print "<tr><td>Size:</td><td>".$arr['size']."</td></tr>\n";
	if ($arr['arch'] != '') print "<tr><td>Arch:</td><td>".$arr['arch']."</td></tr>\n";
	if ($arr['desc'] != '') print "<tr><td>Description:</td><td>".$arr['desc']."</td></tr>\n";
	if ($arr['maintainer'] != '') print "<tr><td>Maintainer:</td><td>".$arr['maintainer']."</td></tr>\n";
	if ($arr['md5'] != '') print "<tr><td>MD5 Sum:</td><td>".$arr['md5']."</td></tr>\n";
	if ($arr['fwver'] != '') print "<tr><td>Frugalware version:</td><td>".$arr['fwver']."</td></tr>\n";
	if ($arr['repo'] != '') print "<tr><td>Repository:</td><td>".$arr['repo']."</td></tr>\n";
	if ($arr['updated'] != '') print "<tr><td>Updated:</td><td>".$arr['updated']."</td></tr>\n";
	print "</table>\n";
	fwclosebox(true);
	include("footer.php");
	mysql_close($conn);
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

?>
