<?php

if ($_GET["str"]) {
	$str = $_GET["str"];
	print $str."==".md5($str)." :: ".strlen(md5($str));
}
else {
	print "adj meg parametert...";
}

?>