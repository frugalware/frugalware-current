<?php

fwopenbox("$fwstrpageinfo", 100, false);
print("<img border=0 src=\"images/frugalware80x15.png\" alt=\"Powered by Frugalware\" title=\"Powered by Frugalware\">");
print("<p><a href=\"http://validator.w3.org/check?uri=referer\"" .
	"title=\"Valid HTML 4.01 Transitional\">" .
	"<img border=0 src=\"images/html401.png\"" .
	"alt=\"Valid HTML 4.01!\"></a>");
print("<p><a href=\"http://jigsaw.w3.org/css-validator/validator?uri=" .
	"http://frugalware.org$PHP_SELF\" title=\"Valid CSS\">" .
	"<img border=0 src=\"images/css.png\"" .
	"alt=\"Valid CSS!\"></a>");
fwclosebox(false);
?>
