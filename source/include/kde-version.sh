#!/bin/bash

###
# = kde-version.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# kkde-version.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages built against a given KDE version.
#
# == OVERWRITTEN VARIABLES
# * _F_kdever_ver: the KDE realease
# * _F_kdever_qt: the Qt release required for KDE
# * _F_kdever_sha1sums: a hash of all the sha1sums for the various KDE projects
###


_F_kdever_ver=4.7.4
_F_kdever_qt=4.7.4

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["blinken"]='edeb024db23da00cf896bc41c6e3efa371d9867d'
	["cantor"]='da39832093c1ea6eb28c6b5b4f67cb24473d8fb5'
	["gwenview"]='598714d18cf7adab8afd4f906070f0915e1cdc95'
	["kalgebra"]='8ef005a50316d7d86b7bc1ed306380d69ce946a0'
	["kalzium"]='6cb65b2c524f529976e4c63a75a7637a181d08d9'
	["kamera"]='098c71d7588d5163656cb07a476efbfc6755900a'
	["kanagram"]='15fda47cd6685a7e19fb4744ec930b9a4dcfbe05'
	["kate"]='b808f01213e0e44607e8f2577f9d1b4f88e14388'
	["kbruch"]='36165292cb9935343d1aa2572935a130b6619f00'
	["kcolorchooser"]='bbfda234e8aec109c63226499fc72355b1c051ca'
	["kdeaccessibility"]='03f4ac8234dcc49eb93eff3630f76e226e290fff'
	["kdeadmin"]='1a294315645adbbff348a380196d4300a408b70d'
	["kdeartwork"]='f397f49a73273baadabcaf45cf18c4d6a3efbe44'
	["kde-baseapps"]='ad4b6d8479bcf8be49b5f53ee8fdcc1b3d1106d6'
	["kdegames"]='a1f97524f868ab9dae0439abcbf4b41f68715598'
	["kdegraphics-strigi-analyzer"]='39b3b0312663a3ef7a68c972b39bf12fb4cabe8b'
	["kdegraphics-thumbnailers"]='0e1636da30c78ad2c186bcd30c0566406b920126'
	["kdelibs"]='78b25e93a8c70ccc1e0f117cce960fe4e1deb8d8'
	["kdemultimedia"]='e0001afac38e35e3ab7b919d79f74cd57e3c18dd'
	["kdenetwork"]='15d5bdcda0e05de6247b22b96c6ca4a98da8a278'
	["kdepim"]='233f6c413eeedd4af7cf15106a2af7b8f29977bf'
	["kdepimlibs"]='a539e29557c0a30779e752b9349b3a0c000ffbba'
	["kdepim-runtime"]='fb02f53673316aaafb65b7c4dd570f3be3b4e935'
	["kdeplasma-addons"]='2bbf77d77e809733e6a74ff5688e6ff5487bc8bf'
	["kde-runtime"]='bf5c266b7748cda44cc3a2fb231a2d6dde2b09f6'
	["kdesdk"]='3a0f61204653dc3f9f975732b6f67659c60ecaf3'
	["kdetoys"]='f929e598180f420d7fc6e4642ed56af9eee5a22b'
	["kdeutils"]='4630f01f36558eb5494fc562086fbd4e488e411e'
	["kde-wallpapers"]='9380bc39db369457e9cea9166c374f3390cc52cc'
	["kdewebdev"]='1e37e877d4f5ec8f6dcd05e828b4a8f0fd743d2c'
	["kde-workspace"]='b7810ba13f6f2a1c4783b153ad9349a1dd27b495'
	["kgamma"]='cd528839b6a9be997ed8d4a2fc87a8b5b8e8de91'
	["kgeography"]='4a90c59928a4947c5cd970ed72e5e9cea370d8e6'
	["khangman"]='c5999ba4218cb0331b906fbcaafa7f497762221d'
	["kig"]='4c76ef89e6210f2f25e719176db4d8a2b31b6222'
	["kimono"]='8f260e09bffcf74bad18a5168016d0dad5db3656'
	["kiten"]='8ec806306a7b08cb8ca5e567a48417cd2268e501'
	["klettres"]='d2450f7aa24fc0118dd20d2e11d61fca68ba5461'
	["kmplot"]='b0b2b748e4ea0f670ffe5c9be01a6997a061a75c'
	["kolourpaint"]='31e23ab6735291ec86ebd83e2eee7afa191a4a59'
	["konsole"]='33e1bc6f1043c9bf6186190b66b21483301eac7e'
	["korundum"]='e220dc672461aa1369e58de325f980139fcd52f6'
	["kross-interpreters"]='416e9f25ff2050d9c5518254a7cc7d4cad22b648'
	["kruler"]='a854213e5342e382d3b9c4a29d1aada654378d0f'
	["ksaneplugin"]='15f7ca6fbabb757898cc0f18685f5e204e6b3f56'
	["ksnapshot"]='bc40ae740e3a684e47ba1b5af01aeb427bb4336e'
	["kstars"]='d4e489093b440e4246c817821187193e4e53be66'
	["ktouch"]='92d7e446216bdfdf68e13c9f0ba39d44e02b29c9'
	["kturtle"]='b3baa81277417f352d4a0bdca61df75515f30c0d'
	["kwordquiz"]='c726b0856234ce78fab0ecd61072cdb035e66513'
	["libkdcraw"]='f97516a2da26da3c15075a007bec7c8f9860379b'
	["libkdeedu"]='2f508c6efa9ef9561d25578000c7d5bb5ed1c5ee'
	["libkexiv2"]='19031140c87d9d7003fef564b6927c6f69d7e3d3'
	["libkipi"]='3225ac0c55f5e4fef71a8baee8d3c49efff6adbf'
	["libksane"]='3c7a8d5b7fd80175684a0373fae26197e8158565'
	["marble"]='e560c355a8d91bbb61b9f2e6c7cb11bd79eba1ab'
	["mobipocket"]='db278a2ebe4680a94c4963a53c1501cf1f1d9d2a'
	["okular"]='5f02bbfeff81b55e0fd5d9e973cb927909faccb1'
	["oxygen-icons"]='b8ebe40c26be41558ac26151894f975ac278b791'
	["parley"]='e61d0192dce0e1427ee41ff96f1bcb73c77cbcef'
	["perlkde"]='7116668ecd5baf55734a8349a2f0b04d0e701898'
	["perlqt"]='b4b3d8ce2b08af62202f5ae79fe57bde60dd9a85'
	["pykde4"]='cac4b94098dba73d58fb4f7d73d7c65c306517d1'
	["qtruby"]='e49e38a59238cf6f5ec9c2d9afc06f3330369fc7'
	["qyoto"]='8f2412a8bbb343bdb1e14c0fc6ef3681afe9d601'
	["rocs"]='f808118fcd5df59a9a808747be940a88b30cf6f3'
	["smokegen"]='068d37e2404311b9caa23d78ee7fa262188a8622'
	["smokekde"]='c3e2bd07158c4bc6a19123d5ae8e81529b52e07b'
	["smokeqt"]='2b1033732d166946db3096ddbf6eb9a6ddb61877'
	["step"]='30dba80e6f34124fd5a8ebf6688e261ab109d0d4'
	["svgpart"]='38dcb3c468ca359e7b0a0027523b8156de6a06a1'
)
