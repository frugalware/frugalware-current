#!/usr/bin/perl

open FL, "<FrugalBuild";
@sorok=<FL>;
close FL;

$blah = `bash -c "makepkg -oe 2>/dev/null"`;
$sha1sm = `bash -c "makepkg -g 2>/dev/null | sed '1 d'"`;

print "Updating sha1sums in ".$ARGV[0].": ";

open FL, ">FrugalBuild";
$out=1;
for($i=0,$j=1; $i<=$#sorok;$i++,$j++) {
	chop $sorok[$i];

	if ($sorok[$i] =~ /^sha1sums/) {
		$out=0;
	}
	else {
		if ($sorok[$i] =~ /\)$/) {
			if ($out eq 0) {
				$out = 2;
			}
		}
	}

	if ($out eq 1) {
		print FL "$sorok[$i]\n";
	}
	else {
		if ($out eq 2) {
			$out = 1;
		}
	}
}

print FL $sha1sm;
close FL;
#print "SHA1SUM in ".$ARGV[0].": $sha1sm";

print "done...\n";
