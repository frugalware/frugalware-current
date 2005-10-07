<?php
fwopenbox("$fwstrchlang", 100, false);
print("<div align=\"center\"><a href=\"$PHP_SELF?lang=en\"><img alt=\"$fwstrchlang\" title=\"$fwstrchlang\" src=\"images/english.gif\" border=\"0\"></a>
<a href=\"$PHP_SELF?lang=hu\"><img alt=\"$fwstrchlang\" title=\"$fwstrchlang\" src=\"images/hungarian.gif\" border=\"0\"></a>
<a href=\"$PHP_SELF?lang=es\"><img alt=\"$fwstrchlang\" title=\"$fwstrchlang\" src=\"images/spanish.gif\" border=\"0\"></a></div>\n");
fwclosebox(false);
?>
