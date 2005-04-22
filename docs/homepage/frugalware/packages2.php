<?php
#packages2.php - pkgs from mysql db

function search_pkg() {

	$search = $_GET['srch'];
	$repo = $_GET['repo'];
	($_GET['sub'] == "") ? $sub = 0 : $sub = 1;

	$query = "select * from packages where ";
	switch($sub) {
		case 0:
			($_GET['desc'] == "" || $_GET['desc'] == 0) ? $query .= "(pkgname='$search') " : $query .= "(pkgname='$search' or `desc`='$search') ";
		
		case 1:
			($_GET['desc'] == "" || $_GET['desc'] == 0) ? $query .= "(pkgname like '%$search%') " : $query .= "(pkgname like '%$search%' or `desc` like '%$search%') ";
	}
	if ($repo != "" && $repo != "all") {
		$query .= "and repo='$repo'";
	}

	echo $query."<br>";
	include("/etc/todo.conf");
	$conn = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn);
	$res = mysql_query($query, $conn);
	echo mysql_num_rows($res);
	mysql_close($conn);
}

function search_file() {
}

function error() {
	if ( $_GET['id'] != "" ) {
		echo "id szerinti kereses";
	}
	else {
?>
<div class="error">HIBA!!! Valami paraméter nincs, vagy hibásan lett megadva !!!</div>
<?php
	}
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
