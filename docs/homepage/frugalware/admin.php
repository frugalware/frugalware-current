<?php

# admin.php

function main() {

	include("login.php");
	$login = new Login;
	$login->tologin();

	$fwtitle="Administration";
	global $fwstradminbox, $fwblack, $fwblacktext, $fwgray, $fwadmwshow, $fwadmlogout;
	include("header.php");

	fwopenbox ($fwstradminbox, 30, false, $fwgray);
	print "<div align=left>\n";
	print "<br>&nbsp;&nbsp;&nbsp;\n";
	print "<a href=admin.php?op=wshow>$fwadmwshow</a><br>&nbsp;&nbsp;&nbsp;\n";
	print "<a href=admin.php?op=tshow>$fwadmtshow</a><br>&nbsp;&nbsp;&nbsp;\n";
	print "<a href=admin.php?logout=>$fwadmlogout</a>\n";
	print "<br>&nbsp;&nbsp;&nbsp;\n";
	print "</div>\n";
	fwclosebox(false);

	include("footer.php");
}

##WISH List##

//function adm_wish_addtodo() {
function adm_wish_show() {

	global $fwblack, $fwblacktext;

//	$wid=$_POST["wid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=wshow");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");

	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$query = "select wid, wprog, wkero, wcomment from wishlist";
	$res1 = mysql_query($query);
	if ($res1) {
		print "<table width=\"100%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
		print "<tr><td bgcolor=\"$fwgray\"></td><td bgcolor=\"$fwgray\">$fwstrwprog</td><td bgcolor=\"$fwgray\">$fwstrwnick</td><td bgcolor=\"$fwgray\">$fwstrwcomment</td></tr>\n";
		if (mysql_num_rows($res1) > 0) {
			while($sor = mysql_fetch_object($res1)) {
				print  "<tr><td align=center>[ <a href=admin.php?op=wsett&wid=".$sor->wid.">$fwadmwsett</a> | <a href=admin.php?op=wdel&wid=".$sor->wid.">$fwadmwdel</a> ]</td><td bgcolor=\"$fwgray\">".$sor->wprog."</td><td bgcolor=\"$fwgray\">".$sor->wkero."</td><td bgcolor=\"$fwgray\">".$sor->wcomment."</td></tr>\n";
			}
		}
		else {
			print "<tr><td colspan=4  bgcolor=\"$fwgray\">$fwstrwnosuch</td></tr>\n";
		}
		print "</table>\n";
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	print "<br><a href=admin.php>$fwadmbackadm</a>\n";

	include("footer.php");
}

function adm_wish_settodo() {
	
	global $fwblack, $fwblacktext;

	$wid = $_GET["wid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=wsett");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");

	include("lang/todolist.$lang.php");

	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$query = "select wid, wprog, wkero, wcomment from wishlist where wid='$wid'";
	$res1 = mysql_query($query);
	if ($res1) {
		$sor = mysql_fetch_object($res1);
		print "<table width=\"60%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
		print "<form method=POST action=\"admin.php?op=wtot\" enctype=\"multipart/form-data\">\n";
		print "<input type=hidden name=wid value=$wid>\n";
		print "<input type=hidden name=aid value=".$login->loginID.">\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwprog:</td><td bgcolor=\"$fwgray\">".$sor->wprog."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwnick:</td><td bgcolor=\"$fwgray\">".$sor->wkero."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwcomment:</td><td bgcolor=\"$fwgray\">".$sor->wcomment."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwprior:</td><td bgcolor=\"$fwgray\"><select name=prior>";
		foreach($fwtodoprior as $key => $value) {
			print "<option value=\"".++$key."\">$value</option>\n";
		}
		print "</select></td></tr>\n";
		print "<tr><td colspan=2 bgcolor=$fwgray align=center><input type=submit value=\"$fwstrinpgo\"><input type=reset value=\"$fwstrinpdel\"></td></tr>\n";
		print "</form>\n";
		print "</table>\n";
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	print "<br><a href=admin.php>$fwadmbackadm</a>\n";

	include("footer.php");
}

function adm_wish_writetodo() {

	global $fwblack, $fwblacktext;
	
	$wid = $_POST["wid"];
	$aid = $_POST["aid"];
	$prior = $_POST["prior"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=wtot");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");

	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$query = "select wprog, wkero, wcomment from wishlist where wid='$wid'";
	$res1 = mysql_query($query);
	if ($res1) {
		list($wprog, $wkero, $wcomment) = mysql_fetch_row($res1);
#		print "insert into todolist (tprog, tkero, tprior, tido, tcomment, taddnick, tkesz) values('$wprog', '$wkero', $prior, now(), '$wcomment', $aid, 0";
		$wcomment=preg_replace("/'/", "\'", $wcomment);
		$res2 = mysql_query("insert into todolist (tprog, tkero, tprior, tido, tcomment, taddnick, tkesz) values('$wprog', '$wkero', $prior, now(), '$wcomment', $aid, 0)");
		if ($res2) {
			$res3 = mysql_query("delete from wishlist where wid=$wid");
			if ($res3) {
				print "<p>$fwadmtodoready<br><a href=\"admin.php?op=wshow\">$fwadmbackwish</a></p>\n";
			}
			else {
				echo "3. ".mysql_errno(). ": ".mysql_error(). "<br>";
				exit();
			}
		}
		else {
			echo "2. ".mysql_errno(). ": ".mysql_error(). "<br>";
			exit();
		}
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}
	mysql_close();
	include("footer.php");
}

function adm_wish_delwish() {

	global $fwblack, $fwblacktext;

	$wid = $_GET["wid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=wdel");

	$fwtitle="Administration";
	include("header.php");

	print "<p>$fwadmsurewdel<br>[ <a href=\"admin.php?op=wdyes&wid=$wid\">$fwadmyes</a> | <a href=admin.php?op=wshow>$fwadmno</a> ]</p>\n";

	include("footer.php");
}

function adm_wish_delete() {

	global $fwblack, $fwblacktext;

	$wid = $_GET["wid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=wdyes");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");

	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$res1 = mysql_query("delete from wishlist where wid='$wid'");
	if ($res1) {
		print "<p>$fwadmdelready<br><a href=\"admin.php?op=wshow\">$fwadmbackwish</a></p>\n";
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	include("footer.php");
}

##TODO List##

function adm_todo_show() {

	global $fwblack, $fwblacktext;

	include("login.php");
	$login = new Login;
	$login->tologin("op=tshow");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");
	include("lang/todolist.$lang.php");

	$conn1 = mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME, $conn1);
	$query = "select tid, tprog, tkero, tcomment, tprior, tido, tkesz, taddnick from todolist where tkesz=0 order by tprior desc";
	$res1 = mysql_query($query);
	if ($res1) {
		fwopenbox("$fwadmtodonotready", 100, false, $fwgray);
		print "<table width=\"100%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
		print "<tr><td bgcolor=\"$fwgray\">$fwstrtprog</td><td bgcolor=\"$fwgray\">$fwstrtnick</td><td bgcolor=\"$fwgray\">$fwstrtprior</td><td bgcolor=\"$fwgray\">$fwstrttime</td><td bgcolor=\"$fwgray\">$fwstrtcomment</td><td bgcolor=\"$fwgray\">$fwstrtaddnick</td><td bgcolor=\"$fwgray\">$fwstrtready</td><td bgcolor=\"$fwgray\"></td></tr>\n";
		if (mysql_num_rows($res1) > 0) {
			while($sor = mysql_fetch_object($res1)) {
				$res2 = mysql_query("select aname, areal from admins where aid=".$sor->taddnick."");
				list($taddnick, $taddreal) = mysql_fetch_row($res2);
				$tname = ($taddreal == "") ? $taddnick : $taddreal;
				print "<form method=POST action=\"admin.php?op=tdoready\" enctype=\"\">\n<input type=hidden name=tid value=\"".$sor->tid."\">\n";
				print  "<tr><td bgcolor=\"$fwgray\">".$sor->tprog."</td><td bgcolor=\"$fwgray\">".$sor->tkero."</td><td bgcolor=\"$fwgray\"><a href=\"admin.php?op=chprior&tid=".$sor->tid."\">(".$sor->tprior.") ".$fwtodoprior[--$sor->tprior]."</a></td><td bgcolor=\"$fwgray\">".$sor->tido."</td><td bgcolor=\"$fwgray\">".$sor->tcomment."</td><td bgcolor=\"$fwgray\">".$tname."</td><td bgcolor=\"$fwgray\"><input type=checkbox name=tready></td><td><input type=submit value=\"$fwstrinpgo\"></td></tr>";
				print "</form>\n";
			}
		}
		else {
			print "<tr><td colspan=6  bgcolor=\"$fwgray\">$fwstrtnosuch</td></tr>\n";
		}
		print "</table>\n";
		fwclosebox(false);
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	$query = "select tid, tprog, tkero, tcomment, tido, taddnick from todolist where tkesz=1 order by tido asc";
	$res1 = mysql_query($query);
	if ($res1) {
		fwopenbox("$fwadmtododone", 100, false, $fwgray);
		print "<table width=\"100%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
		print "<tr><td bgcolor=\"$fwgray\">$fwstrtprog</td><td bgcolor=\"$fwgray\">$fwstrtnick</td><td bgcolor=\"$fwgray\">$fwstrttime</td><td bgcolor=\"$fwgray\">$fwstrtcomment</td><td bgcolor=\"$fwgray\">$fwstrtaddnick</td></tr>\n";
		if (mysql_num_rows($res1) > 0) {
			while($sor = mysql_fetch_object($res1)) {
				$res2 = mysql_query("select aname, areal from admins where aid=".$sor->taddnick."");
				list($taddnick, $taddreal) = mysql_fetch_row($res2);
				$tname = ($taddreal == "") ? $taddnick : $taddreal;
				print  "<tr><td bgcolor=\"$fwgray\">".$sor->tprog."</td><td bgcolor=\"$fwgray\">".$sor->tkero."</td><td bgcolor=\"$fwgray\">".$sor->tido."</td><td bgcolor=\"$fwgray\">".$sor->tcomment."</td><td bgcolor=\"$fwgray\">".$tname."</td></tr>";
			}
		}
		else {
			print "<tr><td colspan=6  bgcolor=\"$fwgray\">$fwadmtnosuch</td></tr>\n";
		}
		print "</table>\n";
		fwclosebox(false);
	}
	else {
		echo "2. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close($conn1);
	print "<p><a href=admin.php>$fwadmbackadm</a></p>\n";

	include("footer.php");
}

function adm_todo_chprior() {

	global $fwblack, $fwblacktext;

	$tid = $_GET["tid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=chprior");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");

	include("lang/todolist.$lang.php");

	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$query = "select tprog, tkero, tcomment, tprior, taddnick from todolist where tid='$tid'";
	$res1 = mysql_query($query);
	if ($res1) {
		$sor = mysql_fetch_object($res1);
		$res2 = mysql_query("select aname, areal from admins where aid=".$sor->taddnick."");
		list($taddnick, $taddreal) = mysql_fetch_row($res2);
		$tname = ($taddreal == "") ? $taddnick : $taddreal;
		print "<table width=\"60%\" border=\"0\" cellspacing=1 cellpadding=1 bgcolor=\"$fwblack\">\n";
		print "<form method=POST action=\"admin.php?op=tsetprior\" enctype=\"multipart/form-data\">\n";
		print "<input type=hidden name=tid value=$tid>\n";
		print "<input type=hidden name=aid value=".$login->loginID.">\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwprog:</td><td bgcolor=\"$fwgray\">".$sor->tprog."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwnick:</td><td bgcolor=\"$fwgray\">".$sor->tkero."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrtaddnick:</td><td bgcolor=\"$fwgray\">".$tname."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwcomment:</td><td bgcolor=\"$fwgray\">".$sor->tcomment."</td></tr>\n";
		print "<tr><td align=left bgcolor=\"$fwgray\">$fwstrwprior:</td><td bgcolor=\"$fwgray\"><select name=prior>\n";
		foreach($fwtodoprior as $key => $value) {
			if (++$key == $sor->tprior) {
				print "<option value=\"".$key."\" selected>$value</option>\n";
			}
			else {
				print "<option value=\"".$key."\">$value</option>\n";
			}
		}
		print "</select></td></tr>\n";
		print "<tr><td colspan=2 bgcolor=$fwgray align=center><input type=submit value=\"$fwstrinpgo\"></td></tr>\n";
		print "</form>\n";
		print "</table>\n";
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	print "<br><a href=admin.php?op=tshow>$fwadmbacktodo</a>\n";

	include("footer.php");
}

function adm_todo_setprior() {

	global $fwblack, $fwblacktext;

	$tid = $_POST["tid"];
	$aid = $_POST["aid"];
	$prior = $_POST["prior"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=tsetprior");

	$fwtitle="Administration";
	include("header.php");
	include("/etc/todo.conf");
	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$res1 = mysql_query("select tprior from todolist where tid='$tid'");
	list($tprior) = mysql_fetch_row($res1);
	if ($res1) {
		if ($tprior != $prior) {
			$res2 = mysql_query("update todolist set tprior=$prior where tid=$tid");
			if ($res2) {
				print "<p>$fwadmpriorready<br><a href=\"admin.php?op=tshow\">$fwadmbacktodo</a></p>\n";
			}
			else {
				echo "2. ".mysql_errno(). ": ".mysql_error(). "<br>";
				exit();
			}
		}
		else {
			print "<p>$fwadmsameprior<br><a href=\"admin.php?op=chprior&tid=$tid\">$fwadmback</a></p>";
			exit();
		}
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	include("footer.php");
}

function adm_todo_doready() {

	global $fwblack, $fwblacktext;

	$ready = (!$_POST["tready"]) ? 0 : 1;
	$tid = $_POST["tid"];

	include("login.php");
	$login = new Login;
	$login->tologin("op=tdoready");

	$fwtitle="Administration";
	include("header.php");

	if ($ready) {
		print "<p>$fwadmreadydochange<br>[ <a href=\"admin.php?op=twready&tid=$tid\">$fwadmyes</a> | <a href=\"admin.php?op=tshow\">$fwadmno</a> ]</p>\n";
	}
	else {
		print "<p>$fwadmreadynochange<br><a href=\"admin.php?op=tshow\">$fwadmbacktodo</a></p>\n";
	}

	include("footer.php");
}

function adm_todo_writeready() {

	global $fwblack, $fwblacktext;

	include("login.php");
	$login = new Login;
	$login->tologin("op=twready");

	$fwtitle="Administration";
	include("header.php");
	$tid = $_GET["tid"];
	include("/etc/todo.conf");
	mysql_connect(DBHOST, DBUSER, DBPASS);
	mysql_select_db(DBNAME);
	$res1 = mysql_query("update todolist set tkesz=1 where tid=$tid");
	if ($res1) {
		print "<p>$fwadmmadeready<br><a href=\"admin.php?op=tshow\">$fwadmbacktodo</a></p>\n";
	}
	else {
		echo "1. ".mysql_errno(). ": ".mysql_error(). "<br>";
		exit();
	}

	mysql_close();
	include("footer.php");
}

$op = $_GET["op"];

switch ($op) {

	case "wshow":
		adm_wish_show();
		break;

	case "wsett":
		adm_wish_settodo();
		break;

	case "wtot":
		adm_wish_writetodo();
		break;

	case "wdel":
		adm_wish_delwish();
		break;

	case "wdyes":
		adm_wish_delete();
		break;

	case "tshow":
		adm_todo_show();
		break;

	case "chprior":
		adm_todo_chprior();
		break;

	case "tsetprior":
		adm_todo_setprior();
		break;

	case "tdoready":
		adm_todo_doready();
		break;

	case "twready":
		adm_todo_writeready();
		break;

	default:
		main();
		break;

}

?>
