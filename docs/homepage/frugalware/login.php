<?php
// CGI atiranyitas eltûntetése az url-bõl (javitva by IroNiQ)
$reszek=explode('/', $_SERVER["PHP_SELF"]);
$_SELF=$reszek[count($reszek)-1];

if (defined("login.php"))
	return;

define("login.php", "1");

include("/etc/todo.conf");

class Login {

	/* Valtozok inicializalasa */
	var
		$loginName,
		$realName,
		$loginID,
		$goodLogin,
		$haveTried;

	function Login() {

		/* Csak GET metodussal lehet kilepni, POST-tal nem... */
		$logout = $_GET["logout"];

		$this->goodLogin = false;
		$this->haveTried = false;
		$this->realName = "";
		$this->loginName = "";
		$this->loginID=0;

		//a $kilep változóval lehet jelezni, hogy
		//ki kell léptetni a felhasználót
		if (isset($logout)) {
			$this->tologout();
		}
	}

	function tologin($params = "") {

		/* Csak FORM-bol fogadunk el adatot, POST metodussal (Cimsorba iras kizarva) */
		$aLogin = $_POST["aLogin"];
		$aName = $_POST["aName"];
		$aPass = $_POST["aPass"];

//	$_SESSION valtozo tartalma, debug info
/*			echo "<pre>\n";
			var_dump($_SESSION);
			var_dump($params);
			echo "</pre>\n";
*/

		if ($params != "") {
			$param = explode("&", $params);
			for($i=0;$i<count($param);$i++) {
				list($valt, $ertek) = explode("=", $param[$i]);
				$$valt = $ertek;
			}
		}

		if (isset($aLogin)) {
		//az urlapból jöttek adatok

			$upwd = md5($aPass);
//			$params = $_POST["params"];

			mysql_pconnect(DBHOST, DBUSER, DBPASS);
			mysql_select_db(DBNAME);
			$result = mysql_query("select aid, areal from admins where aname='$aName' and apass='$upwd'");
			$ertek = mysql_num_rows($result);
			if ($ertek > 0) {
			/* helyesek voltak az adatok -> el kell tárolni
			   a session-ben a felhasználó azonosítóját */

				list($aid, $user) = mysql_fetch_row($result);
				$result = "";
				$loginName=$aName;
				session_register("loginName");
				$_SESSION["loginName"]=$loginName;
				$loginID=$aid;
				session_register("loginID");
				$_SESSION["loginID"]=$aid;
				$realName = $user;
				session_register("realName");
				$_SESSION["realName"]=$realName;

				$this->goodLogin = true;
				$this->haveTried = true;

				$this->loginName = $aName;
				$this->realName = $realName;
				$this->loginID=$aid;
			}
			else
				$this->haveTried = true;
		}
		else {
//	$_SESSION valtozo tartalma, debug info
/*			echo "<pre>\n";
			var_dump($_SESSION);
			echo "</pre>\n";
*/
			if (isset($_SESSION["loginName"])) {
				//session-bõl jöttek az adatok
				$this->loginName=$_SESSION["loginName"];
				$this->loginID=$_SESSION["loginID"];
				$this->realName=$_SESSION["realName"];
				$this->goodLogin=true;
			}
		}

		if (!$this->goodLogin) {
			//nem lépett be a felhasználó, ûrlapot kell neki kirakni
			/* params valtozo azert kell, hogy tovabb lehessen leptetni a bejelentkezes utan az illetot a megfelelo helyre... */
			$this->loginForm($params);
			exit();
		}
	}

	function tologout() {
		unset($_SESSION["loginName"]);
		unset($_SESSION["loginID"]);
		unset($_SESSION["realName"]);
		session_unregister("loginName");
		session_unregister("loginID");
		session_unregister("realName");
		header("Location: news.php");
	}

	function loginForm($params) {

		/* Csak FORM-bol, POST metodussal fogadjuk el az adatokat... */
//		$params = $_POST["params"];
//		echo "2. $params<br>\n";

		$tmp = $_SERVER["PHP_SELF"];
		$resz = explode("/", $tmp);
		$_SELF = $resz[count($resz)-1];

		$fwtitle="Administration";
		include("header.php");
		?>
		&nbsp;<p align=center><b>
		<?= ($this->haveTried ?
			"$fwerrbadpass\n" :
			"$fwerrhavetologin\n")?>
		</b></p>
		&nbsp;<br>
		<table align="center" border="0" cellspacing="2" cellpadding="0" width="60%">
		<form method="post" action="<?=$_SELF?>?<?=$params?>">
		<?php
		?>
		<tr align="left" valign="middle">
			<td><?php echo $fwstruname; ?></td>
			<td><input type="text" name="aName" value=""></td>
		</tr>
		<tr align="left" valign="middle">
			<td><?php echo $fwstrpass; ?></td>
			<td><input type="password" name="aPass" value=""></td>
		</tr>
		<tr>
			<td> </td>
			<td><input type="submit" name="aLogin" value=<?php echo $fwstrlogin; ?>></td>
		</tr>
		</form>
		</table>
		&nbsp;<br>
		<?php
		include("footer.php");
	}
}

session_start();
?>