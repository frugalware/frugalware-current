<?
$fwtitle="Donations";
include("header.php");

fwopenbox($fwdonatestring, 80, false);
print $fwdonatewelcome;
fwclosebox(false);
print("<p>");

fwopenbox("The Frugalware Team", 80, false);
print("<div align=left>Wishes:<ul>
<li>Socket939 Motherboard + AMD Athlon64 3000+ or better (or X2 DualCore 4400+) CPU Socket939 version + DDR RAM's for the motherboard for x86_64 package building</li>
<li>American mirror</li>
<li>Asian mirror</li>
</ul>Received:<ul>
<li>i586 Server: Pentium MMX 200 Mhz CPU, 64 Mb memory, 2.8Gb + 37Gb HDD (Botond Balazs, Miklos Vajna)</li>
<li>Main server hosting (Sandor Szentirmay)</li>
<li>Hungarian mirrors: inflame.hu, linuxforum.hu, FSN.hu</li>
<li>European mirrors: belnet.be</li>
<li>i686 Server: Pentium III (Coppermine) 600 Mhz, 256 Mb memory (the developer team)</li>
<li>i686 build server: Pentium II (Deschutes) 300 Mhz, 384 Mb memory (University of Debrecen)</li>
<li>i686 build server hosting (University of Debrecen)</li>
<li>Advertising: linuxuser.hu, linuxlinks.com</li>
<li>2x40GB IDE HDD (Szalai, Ervin)</li>
<li>2x160GB IDE HDD for the i686 server (Miklos Vajna)</li>
<li>40GB IDE HDD (Kovacs, Janos)</li>
</ul></div>");
fwclosebox(false);
print("<p>");

fwopenbox("Andras Voroskoi", 80, false);
print("<div align=left>Received:<ul>
<li>Ati video card for fglrx package testing (David Kimpe)</li>
</ul></div>");
fwclosebox(false);
print("<p>");

include("footer.php");
?>
