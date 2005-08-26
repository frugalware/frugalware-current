<?
$fwtitle="Donations";
include("header.php");

fwopenbox($fwdonatestring, 80, false);
/*
print("<div align=left>Donations are a great way to show your appreciation
and support for Frugalware Linux. On this page we list the donations we have
received so far and those that would help us in our work on Frugalware Linux.
If you have a piece of hardware or something whose Frugalware support could be
improved, a good way to achieve this is to donate it to a developer.</div>");
*/
print $fwdonatewelcome;
fwclosebox(false);
print("<p>");

fwopenbox("The Frugalware Team", 80, false);
print("<div align=left>Wishes:<ul>
<li>Socket939 Motherboard + AMD Athlon64 3000+ or better (or X2 DualCore 4400+) CPU Socket939 version + DDR RAM's for the motherboard for x86_64 package building</li>
</ul>Received:<ul>
<li>2x40GB IDE HDD (Szalai, Ervin)</li>
<li>40GB IDE HDD (Kovacs, Janos)</li>
<li>Ati video card (DNAKU-san)</li>
</ul></div>");
fwclosebox(false);

include("footer.php");
?>
