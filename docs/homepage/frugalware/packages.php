<?
$fwtitle="Packages";
include("header.php");

// defaults
if (!isset($fwversion))
	$fwversion="frugalware-current";
//
if (!isset($reponame))
	$reponame="frugalware";
//
if (!isset($catname))
{
	if ($reponame == "frugalware")
		$catname="base";
	if ($reponame == "extra")
		$catname="locale";
}
// repo datas
if ($reponame=="frugalware")
{
	$repodir="frugalware";
	$repodbname="current";
}
if ($reponame=="extra")
{
	$repodir="extra/frugalware";
	$repodbname="extra";
}

// search
$fwversions=explode("\n",
	preg_replace("/\n$/", "",
	`ls $fwtopsrcdir|grep ^frugalware-|grep -v iso`));
$fwrepos = array("frugalware", "extra");

// print stuff
fwopenbox("$fwstrpacsearch");
print("<form action=\"$PHP_SELF\" method=post>");

// versions
print("$fwstrpacver: ");
print("<select name=fwversion onChange='submit()'>\n");
foreach($fwversions as $ifwversion)
{
	print("<option ");
	if ($ifwversion == $fwversion)
		print("selected ");
	print("value=\"$ifwversion\">$ifwversion</option>\n");
}
print("</select>");

// repos
print(" $fwstrpacrepo: ");
print("<select name=reponame onChange='submit()'>\n");
foreach($fwrepos as $ifwrepo)
{
	print("<option ");
	if ($ifwrepo == $reponame)
		print("selected ");
	print("value=\"$ifwrepo\">$ifwrepo</option>\n");
}
print("</select>");

// categories
$pkgsf=file("$fwtopsrcdir/$fwversion/$repodir/../Packages.lst");
if (!isset($fwcategories))
	$fwcategories=array();
foreach ($pkgsf as $i)
{
	$c=preg_replace("|(.*)/.*\n|", "$1", $i);
	if (array_search($c, $fwcategories) === false)
		$fwcategories[] = $c;
}
print(" $fwstrpaccat: ");
print("<select name=catname onChange='submit()'>\n");
foreach ($fwcategories as $i)
{
	print("<option ");
	if ($i == $catname)
		print("selected ");
	print("value=\"$i\">$i</option>\n");
}
print("</select>");

// packages
foreach ($pkgsf as $i)
{
	if ($catname == preg_replace("|(.*)/.*\n|", "$1", $i))
		$fwpackages[]=preg_replace("|.*/(.*)-.*-.*\.fpm\n|", "$1", $i);
}
if (is_array($fwpackages))
	sort ($fwpackages);
print(" $fwstrpacpac: ");
print("<select name=pkgname onChange='submit()'>\n");
foreach ($fwpackages as $i)
{
	print("<option ");
	if ($i == $pkgname)
		print("selected ");
	print("value=\"$i\">$i</option>\n");
}
print("</select>");
print("</form>");
fwclosebox(0);
print("<p>");

// packages

// search first package in the selected category if no pkgname
if (!isset($pkgname))
{
	foreach ($pkgsf as $i)
	{
		if (strstr($i, "$catname/"))
		{
			$pkgname=preg_replace("|.*/(.*)-.*-.*\.fpm\n|", "$1", $i);
			break;
		}
	}
}
// typos
$pkgname = preg_replace("/(.*)<.*/", "$1", $pkgname);
$pkgname = preg_replace("/(.*)=.*/", "$1", $pkgname);
$pkgname = preg_replace("/(.*)>.*/", "$1", $pkgname);

// this will create $pkginfo[0-3] (category, pkgname, version, release)
foreach ($pkgsf as $i)
{
	if (strstr($i, "/$pkgname-"))
	{
		$pkginfo=explode("|", preg_replace(
			"|(.*)/(.*)-([0-9].*)-([0-9]*).*|",
			"$1|$2|$3|$4", $i));
		$pkginfo[3] = preg_replace("/\n/", "", $pkginfo[3]);
		break;
	}
}
if($pkginfo != null)
{
// this will create $pkginfo[4-6] (desc, md5sum, depends)
$pkgdbf="$fwtopsrcdir/$fwversion/$repodir/$repodbname.fdb";
$pkgdb=explode ("\n", `tar xzfO $pkgdbf $pkgname-$pkginfo[2]-$pkginfo[3]/desc`);
$pkgdeps=explode ("\n", `tar xzfO $pkgdbf $pkgname-$pkginfo[2]-$pkginfo[3]/depends`);
foreach ($pkgdeps as $i)
{
	$pkgdb[]=$i;
}
foreach ($pkgdb as $i)
{
	if ($desc)
		$pkginfo[4]=$i;
	if ($md5sum)
		$pkginfo[5]=$i;
	if ($depends)
		$pkginfo[6] .="<a href=$PHP_SELF?pkgname=". rawurlencode($i) .
			">$i</a> ";
	$desc=false;
	$md5sum=false;
	if ($i == "")
		$depends=false;
	if ($i=="%DESC%")
		$desc=true;
	if ($i=="%MD5SUM%")
		$md5sum=true;
	if ($i=="%DEPENDS%")
		$depends=true;
}

$fwpacurl="<a href=\"$fwprefmirror/$fwversion/$repodir/" .
	$pkginfo[1] . "-" . $pkginfo[2] . "-" . $pkginfo[3] . ".fpm\">" .
	$pkginfo[1] . "-" . $pkginfo[2] . "-" . $pkginfo[3] . ".fpm</a>";

fwopenbox("$fwstrpacinfo: $pkginfo[1]", 100, false, $fwwhite);
print("<table width=\"100%\">
	<tr><td>$fwstrpaccat:<td>$pkginfo[0]
	<tr><td>$fwstrpacname:<td>$pkginfo[1]
	<tr><td>$fwstrpacver:<td>$pkginfo[2]
	<tr><td>$fwstrpacrel:<td>$pkginfo[3]
	<tr><td>$fwstrpacdesc:<td>$pkginfo[4]
	<tr><td>$fwstrpacmd5:<td>$pkginfo[5]
	<tr><td>$fwstrpacdeps:<td>$pkginfo[6]
	<tr><td>$fwstrpacrepo:<td>$reponame
	<tr><td>$fwstrpacfwver:<td>$fwversion
	<tr><td>$fwstrpacdl:<td>$fwpacurl
	</table>");
fwclosebox(0);
}
else
{
	print("$fwstrpacnopac\n");
}
include("footer.php");
?>
