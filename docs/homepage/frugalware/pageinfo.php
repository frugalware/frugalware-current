<?php

fwopenbox("$fwstrpageinfo", 100, false);
print("<a href=\"http://uptime.netcraft.com/up/graph?host=frugalware.org\" " .
	"title=\"View Netcraft statistics\">" .
	"<img border=0 src=\"images/netcraft.gif\" alt=\"Netcraft\"></a>");
print("<p><a href=\"http://validator.w3.org/check?uri=referer\"" .
	"title=\"Valid HTML 4.01 Transitional\">" .
	"<img border=0 src=\"http://www.w3.org/Icons/valid-html401\"" .
	"alt=\"Valid HTML 4.01!\"></a>");
print("<p><a href=\"http://jigsaw.w3.org/css-validator/validator?uri=" .
	"http://frugalware.org$PHP_SELF\" title=\"Valid CSS\">" .
	"<img border=0 src=\"http://jigsaw.w3.org/css-validator/images/vcss\"" .
	"alt=\"Valid CSS!\"></a>");
fwclosebox(false);
?>
