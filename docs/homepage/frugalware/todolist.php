<?php
$fwtitle="TodoList";
include("header.php");
print ("<!-- start todolist.php -->\n");

function todo_show() {
	global $fwgray, $fwblack, $fwstrtodolist, $fwstrtprog, $fwstrtnick, $fwstrttime, $fwstrtcomment, $fwstrtnosuch, $fwstrtaddnick, $fwstrtprior;
	include("/etc/todo.conf");
	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db("frugalware");
	$res1 = mysql_query("select * from todolist where tkesz=0 order by tprior desc");

	fwopenbox("$fwstrtodolist", 100, false, $fwgray);

	print "<table width=\"100%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
	print "<tr><td bgcolor=\"$fwgray\">$fwstrtprog</td><td bgcolor=\"$fwgray\">$fwstrtnick</td><td bgcolor=\"$fwgray\">$fwstrtprior</td><td bgcolor=\"$fwgray\">$fwstrttime</td><td bgcolor=\"$fwgray\">$fwstrtcomment</td><td bgcolor=\"$fwgray\">$fwstrtaddnick</td></tr>\n";
	if (mysql_num_rows($res1) > 0) {
		while($sor = mysql_fetch_object($res1)) {
			$res2 = mysql_query("select aname, areal from admins where aid=".$sor->taddnick."");
			list($taddnick, $taddreal) = mysql_fetch_row($res2);
			$tname = ($taddreal == "") ? $taddnick : $taddreal;
			print  "<tr><td bgcolor=\"$fwgray\">".$sor->tprog."</td><td bgcolor=\"$fwgray\">".$sor->tkero."</td><td bgcolor=\"$fwgray\"><a href=\"todolist.php?op=prior&prior=".$sor->tprior."\">".$sor->tprior."</a></td><td bgcolor=\"$fwgray\">".$sor->tido."</td><td bgcolor=\"$fwgray\">".$sor->tcomment."</td><td bgcolor=\"$fwgray\">".$tname."</td></tr>";
		}
	}
	else {
		print "<tr><td colspan=6  bgcolor=\"$fwgray\">$fwstrtnosuch</td></tr>\n";
	}
	print "</table>\n";
	fwclosebox(false);
}

function todo_prior() {

	if ($_GET["prior"] != "" && $_GET["prior"] > 0 && $_GET["prior"] < 5) {
		global $lang, $fwstrtprior, $fwgray;
		$prior = $_GET["prior"];
		include("lang/todolist.$lang.php");
	
		fwopenbox("$fwstrtprior", 70, false, $fwgray);
		print "<div align=center>$prior - ".$fwtodoprior[--$prior]."</div>\n";
		fwclosebox(false);
	}
	else {
		global $fwstrerrnoprior;
		print "<p align=center>$fwstrerrnoprior</p>\n";
	}

}

if ($_GET["op"] != "") {

	switch($_GET["op"]) {

		case "show":
			todo_show();
			break;

		case "prior":
			todo_prior();
			break;

		default;
			todo_show();
			break;

	}

}
else {

	todo_show();

}

print ("<!-- end todolist.php -->\n");
include("footer.php");

?>
