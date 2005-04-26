<?
$fwtitle="#frugalware channel";
include("header.php");

fwopenbox($fwstrircgeninfo);
print("<div align=left>$fwstrircgeninfod</div>");
fwclosebox(false);
print("<p>");


fwopenbox($fwstrirclogint);
print("<!-- This is part of CGI:IRC 0.5
  == http://cgiirc.sourceforge.net/
  == Copyright (C) 2000-2005 David Leadbeater <cgiirc@dgl.cx>
  == Released under the GNU GPL
  -->

<script language=\"JavaScript\" type=\"text/javascript\"><!--
function setjs() {
 if(navigator.product == 'Gecko') {
   document.loginform[\"interface\"].value = 'mozilla';
 }else if(window.opera && document.childNodes) {
   document.loginform[\"interface\"].value = 'opera7';
 }else if(navigator.appName == 'Microsoft Internet Explorer' &&
    navigator.userAgent.indexOf(\"Mac_PowerPC\") > 0) {
    document.loginform[\"interface\"].value = 'konqueror';
 }else if(navigator.appName == 'Microsoft Internet Explorer' &&
 document.getElementById && document.getElementById('ietest').innerHTML) {
   document.loginform[\"interface\"].value = 'ie';
 }else if(navigator.appName == 'Konqueror') {
    document.loginform[\"interface\"].value = 'konqueror';
 }else if(window.opera) {
   document.loginform[\"interface\"].value = 'opera';
 }
}
function nickvalid() {
   var nick = document.loginform.Nickname.value;
   if(nick.match(/^[A-Za-z0-9\[\]\{\}^\\\|\_\-`]{1,32}$/))
      return true;
   alert('$fwstrircvalidnick');
   document.loginform.Nickname.value = nick.replace(/[^A-Za-z0-9\[\]\{\}^\\\|\_\-`]/g, '');
   return false;
}
function setcharset() {
	if(document.charset && document.loginform[\"Character set\"])
		document.loginform['Character set'].value = document.charset
}
setcharset();
//-->
</script>
<form method=\"post\" action=\"irc/irc.cgi\" name=\"loginform\" onsubmit=\"setjs();return nickvalid()\">
<input type=\"hidden\" name=\"interface\" value=\"nonjs\">
<table border=\"0\" cellpadding=\"5\" cellspacing=\"0\">
<tr><td align=\"right\">$fwstrircnick</td><td align=\"left\"><input type=\"text\" name=\"Nickname\" value=\"\"></td></tr>
<tr><td align=\"right\">$fwstrircserver</td><td align=\"left\"><input type=\"text\" name=\"Server\" value=\"irc.freenode.net\" disabled=\"disabled\"></td></tr>
<tr><td align=\"right\">$fwstrircchan</td><td align=\"left\"><input type=\"text\" name=\"Channel\" value=\"#frugalware\" disabled=\"disabled\"></td></tr>
<tr><td align=\"left\">
<small><a href=\"irc/irc.cgi?adv=1\">$fwstrircadv</a></small>
</td><td align=\"right\">
<input type=\"submit\" value=\"$fwstrircloginb\">
</td></tr></table></form>");
fwclosebox(false);
print("<p>");

fwopenbox($fwstrircsocdiag, 0);
print("<img alt=\"Social network diagram\" src=\"/~vmiklos/pics/piespy/frugalware-current.png\">");
fwclosebox(false);
print("<p>");

if ($dir = @opendir("/home/xbit/public_html/irclog"))
{
	while ($file = readdir($dir)) {
		if ($file != "." and $file != ".." and $file != "log.html")
		{
			$month = preg_replace("/3-0-([0-9]*)-([0-9]*)-([0-9]*)\.html/", "$3-$1", $file);
			if (!isset($logs[$month]))
				$logs[$month]=array();
			$logs[$month][]=$file;
		}
	}
	closedir($dir);
	
	fwopenbox($fwstrirclogt);
	print("<div align=left><table>");
	foreach($logs as $key => $value)
	{
		print("<tr><td>$key");
		foreach($value as $i)
			print("<td><a href=\"/~xbit/irclog/$i\">" . preg_replace("/3-0-([0-9]*)-([0-9]*)-([0-9]*)\.html/", "$2", $i) . "</a>");
	}
	print("</table></div>");
	printf($fwstrirclogd, "/~xbit/irclog/log.html");
	fwclosebox(false);

}

include("footer.php");
?>
