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


_F_kdever_ver=4.7.3
_F_kdever_qt=4.7.4

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["blinken"]='24f09f604e1687062b3296a30b873d1781379543'
	["cantor"]='ce6240d44cbf47b3dbfd1dbc03196c916e4394e9'
	["gwenview"]='7096721285d15311699acc76abd62755d6e93860'
	["kalgebra"]='88cc89a6c942b7cef548532702c5e68bf75f0748'
	["kalzium"]='e22b54be4a2e8ce8a22af73fa6155ee012fa6fdf'
	["kamera"]='820f9b6449732f6cab48f5c2d9e7dbcf53eb6437'
	["kanagram"]='44a60b76bbc8ae61b8673c37c2b8721f12dc22bb'
	["kate"]='d67e871a49d426246f2e555ace0ad5a303c41045'
	["kbruch"]='c90205954d9c153aaa5966b424aa437b07e657f7'
	["kcolorchooser"]='bdd35e5defbcfc151f4960541c351246cb4dfa9e'
	["kdeaccessibility"]='9695d2b8b6f55266e3f76ebf05543f23857b9520'
	["kdeadmin"]='b2d6d210bc40e8731a9ae8409673f3d71b57de0a'
	["kdeartwork"]='4d3611cbcd6052a7ba7137baa196c654d9d38d4d'
	["kde-baseapps"]='952dc26d0d908b41973a8d7b4d27765bf5128d58'
	["kdegames"]='abd90be42fa67cd6d6be1defe90dcd0408e94445'
	["kdegraphics-strigi-analyzer"]='827b18fd902a464162db7a3cd98a22fa211bafc9'
	["kdegraphics-thumbnailers"]='219fd55d94d695cee8c7b650dbe8088cc9807e5c'
	["kdelibs"]='4f1bbd1b4d558f3541057747db9bf7e9dcececb3'
	["kdemultimedia"]='4db44494e6a2ef886e3513b6a2eb4e526741a6ff'
	["kdenetwork"]='5d8ed6a478d9afdaf19d350f1d2fe7e9dd48b2f7'
	["kdepim"]='b540de51ba5b9995ce3b7c05cfb09112423d8569'
	["kdepimlibs"]='b95822a3e38587744174308b629336cd3d0444f4'
	["kdepim-runtime"]='fa0e336e17f7abea1e36d28d941a4ef79b4e4635'
	["kdeplasma-addons"]='decdea2d081396c90daabc9af754a233b43a0783'
	["kde-runtime"]='293dec26e0d7278396d2ad0240d14aeea6060970'
	["kdesdk"]='c0afae643345c92bce387ceafbcea59d3fbd812e'
	["kdetoys"]='93d6f0a92c805de51fc68469f940f38858f81fbe'
	["kdeutils"]='23fc9823647152d5d8cc250a55402c8930db4059'
	["kde-wallpapers"]='d1b5b9a65a731469a3fbeaae9169d50196fe4158'
	["kdewebdev"]='11108698887d376d00f02cbdfa1496aa3cb268c1'
	["kde-workspace"]='f3ed24e3e70671033718a5139cb61d0d7e2e709e'
	["kgamma"]='d97511574120614ffb85308888c23eb2d3ba1b01'
	["kgeography"]='5f9835994ec6ad9454f7ee19bf003c8457e11d9e'
	["khangman"]='aef288a20209a4c1bf5d6f48be689c433049ea83'
	["kig"]='5a948b641f380e1cc6cf0f91d795a97029464bbb'
	["kimono"]='d87622d46bce9a5f8b875393ac2292f5a57d5f78'
	["kiten"]='5df19802a731b5f7033b43aa9b35e0b20164cd3e'
	["klettres"]='da01b1c71d74f634ace0b6c2fc6e0186a08f9974'
	["kmplot"]='e98ba022e987b9601ea1b27e97607ff7885ff788'
	["kolourpaint"]='d276d230e76f7fbe91229dd015a6465cb1a6956e'
	["konsole"]='ecf5d1cc087d78ba049fe65e06ee992a2fadcc19'
	["korundum"]='bf41817298a8b18ba3542e45256c1c6ddb08c900'
	["kross-interpreters"]='3e31b85d1a27a273450652d9f5a33f2c3c035329'
	["kruler"]='2cc0b9d31248604ab570404a0c67ef325e8ed00e'
	["ksaneplugin"]='547c298e2f3f7b8f651e3402bf18507321d4a7ce'
	["ksnapshot"]='e0dd6e093cd487fa6604077371122d84b3e8efb7'
	["kstars"]='41d333f726d9752a7ddb48f98817d91744adb7b0'
	["ktouch"]='46b865ece6e14d4476297d4a3b400d5fab6564ea'
	["kturtle"]='07d5ad5c1b8308c2c8c2ff48e2c0c18adfd051ca'
	["kwordquiz"]='616c16a94066ec2930bc0795f8053be221c871e5'
	["libkdcraw"]='084f6aff760957d2005dd571dad178ca685abb68'
	["libkdeedu"]='d2a1e88c6135fa23cea7670dfbb7c8634dc9c870'
	["libkexiv2"]='daaf507f75855660ae9f1af00158c2746c574902'
	["libkipi"]='9c6d4406a1292cfe81fa27508ffe4d96633417bf'
	["libksane"]='d1efdd1f5f7f99ba173ddcc88b2ddee343ecf96b'
	["marble"]='980a8dae9c7a0f8483fde5dc839fae834763933a'
	["mobipocket"]='a55908cbc951c98dd27171909c1ccc5d978eec65'
	["okular"]='a14700386f386cc50f7dd6785eeb93dae10a0362'
	["oxygen-icons"]='eb26498ba287098127fc259816335f21cffe3784'
	["parley"]='a5d06f373976554d58c8aae279e411a6be028826'
	["perlkde"]='e0cc0d644084f1c71b6afc30d5467c49ba9a9fab'
	["perlqt"]='6e69719edccb23e3ced7ba30b72e88d214d6f54e'
	["pykde4"]='16063793d39fdc9f5b9916cab49236103ce79da2'
	["qtruby"]='2e3b36ece9039ccd39be76145575015503c6283c'
	["qyoto"]='676042633b8c426adf1f47ad143f5db20ae257ef'
	["rocs"]='5c7d4115f029e09a006912bf816d4ce396a9b49a'
	["smokegen"]='ede4095fdb190b3bef13b246111e7d79903ad77e'
	["smokekde"]='a25114d92c540f16af9022366ca2b5da447a1531'
	["smokeqt"]='cf1c4b7116695f0842972b2985eca65f6b63702e'
	["step"]='411695882916a8a1d0db86426a0d8f935fab21ad'
	["svgpart"]='fa7f8cac53f6041f18a2bee09c2aa3885e27f7c7'
)
