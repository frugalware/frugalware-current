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


_F_kdever_ver=4.7.1
_F_kdever_qt=4.7.4

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["blinken"]='3b3062ce82174417c8a7496743f78e6b583fa1e9'
	["cantor"]='97251c369424e22d26c804387270d0e3291587b1'
	["gwenview"]='a58997d7e23f5708ff94d9198258dc0d6e82f8cf'
	["kalgebra"]='16d74602bc446d3e45688379b92aabb2158becbb'
	["kalzium"]='08600b1cf7df1afed67e5edd619953ae0f585687'
	["kamera"]='3b6dda64d13f25f521e9839709d716af27cf9f74'
	["kanagram"]='8e1aab59132504d36cedfe843290d9a630562f7c'
	["kate"]='12eadb7c74c16fb11d51d4415d141095a624f010'
	["kbruch"]='6d6a44740e52618c84dffb33dec41535637a7466'
	["kcolorchooser"]='ca8885cf33806e32c9be572d5c5819c17f935f75'
	["kdeaccessibility"]='b9d0bf7503e684f9ddd1912d9c274bcdd8489bfd'
	["kdeadmin"]='3d1b1be2003fe20c5c3faee63ba31c65621d53b7'
	["kdeartwork"]='df8c3225b025e0afb43efb73a5c53573ee3be77e'
	["kde-baseapps"]='5e7ced4d94f035ed86960025dbd66a1126a848ac'
	["kdegames"]='282a54432b3f38bbb6afcf13e859299757ce59f8'
	["kdegraphics-strigi-analyzer"]='1d88ceb5c156625945dabbb347cc405b253b67a5'
	["kdegraphics-thumbnailers"]='b82128adbd0cc352765a25428f38839f40715bc4'
	["kdelibs"]='661cc56f199b7250bd825cc0e85ff442b85171e2'
	["kdemultimedia"]='7f20d969133a146bce0e3ea18285aa6db9e4a262'
	["kdenetwork"]='4fd674223dcb68a548ddec3e65acf380d3d2ec68'
	["kdepim"]='be22b012f547b2caa6ca92a6dd396328fda6a53b'
	["kdepimlibs"]='6a2cb3d872339fc9549189f31163fc07889fc3ec'
	["kdepim-runtime"]='0e7645c83debc64d0b351d39f97b801dc8417630'
	["kdeplasma-addons"]='301714467bef00c99613d334558eb517664e29a5'
	["kde-runtime"]='fc8da236bff699518b54b2fe6bcf8a518206b6e3'
	["kdesdk"]='0c47d62a32e737c6ff576843d5b5c7f9bceeccbd'
	["kdetoys"]='05e0f77fd13ed9887afa0c5dd33afd224abc2505'
	["kdeutils"]='96eb89be0e319e5d0709430f86dc6a7db80d9967'
	["kde-wallpapers"]='c6c724409c403a54959f5f6c035d7513f0a3d735'
	["kdewebdev"]='ce9e7c37d2056b2f69e88fb92154463d917c9b85'
	["kde-workspace"]='c7867d2f788086078abbcff53a035a6131232539'
	["kgamma"]='789a1b7908be10711e2c4c38abecf37cebc8239d'
	["kgeography"]='65ebeb391952229ee3d410d0087d8a4e5262b6f7'
	["khangman"]='ac13da342cb2380ba2c703fbef9f131b75675b9e'
	["kig"]='b198ceff93164fe455e466cb8e1d5616f524d209'
	["kimono"]='e8cf2bfbb47a606a5ca8674a8b6913bb1dcac96f'
	["kiten"]='bc9f7b4e1891d8be6e322345e941377c988b8697'
	["klettres"]='e7fba352257c44d9ee84439dee4d3dfb58d4fd8d'
	["kmplot"]='d0058f4d7a3f63b9a092085cb8058c4426dba1f8'
	["kolourpaint"]='bb49a7e07fea66110502f7042c898611d2d5329e'
	["konsole"]='1169c7ea5e4c5aa0a29d1948c9e02ee3cc2c54a2'
	["korundum"]='fdbcde4dd622f41faa7c22cbc96a8687612d099e'
	["kross-interpreters"]='4e5923fcb30501ca3474981a3d210940f0bc7320'
	["kruler"]='96fd638bb9db27abd3bbb57d90d7c60ec6d65185'
	["ksaneplugin"]='e5b94fd03ddbc1be74881f19e52932c070663044'
	["ksnapshot"]='a59b5bf582a70cd4b8620697161b022df31294e2'
	["kstars"]='e9f899897df555933c7f9fd9e931dc49bcb924ae'
	["ktouch"]='88e607fb584ea5cacc05f0f2909ae07139fdeed3'
	["kturtle"]='c2a33ff1ac68715e81108a8009ff67b5cb53ae2e'
	["kwordquiz"]='17952dd5f8c042c467f15f2840399b7c5dd3fa05'
	["libkdcraw"]='d54aa4671c0d1f396bf1923583988d6c3aa19137'
	["libkdeedu"]='6eb16c156f35332675c9eaad0074e31969313e7b'
	["libkexiv2"]='c1c1afb6c3928222eb33ce592d77dd6478aa4911'
	["libkipi"]='309b93ca86ae2c803f5b91ac206affc0059059f1'
	["libksane"]='d461b668e890069afb8818e6b367063fc92721da'
	["marble"]='71c9ccd884495b34c8af4f7c432ca8942dfaa9dd'
	["mobipocket"]='54b7cd4e32325f8fe10f1765856e418fcc75e469'
	["okular"]='73d2b9ecdafa43feb9da645d6ff9ea309a55b669'
	["oxygen-icons"]='1638096cde02ec69d5c412eb2bc13886906f7386'
	["parley"]='c89739816f87048b0f9e336c3f3b74d038b8fae9'
	["perlkde"]='24e90923554ac1194da9fb84dab9efe580fa979e'
	["perlqt"]='f2534fc9677ce4f3e58a67b4d9b255f403250064'
	["pykde4"]='fd05f0c04586878c3c23e80bb1c59b316184d7ab'
	["qtruby"]='a40e760ea16482885cbd061c95cec984af1ec4ac'
	["qyoto"]='a08fd3750cd021578e82e096a1534b093591dbb1'
	["rocs"]='a22bfef644447271702c7e164070306a54270d57'
	["smokegen"]='952181277c8d212db7028476034d0160a152e696'
	["smokekde"]='20b8db2cce9aad11047ba758e1e327ea6970427a'
	["smokeqt"]='7f6074c552a3e9a72ebbbc1683786d7cb479871a'
	["step"]='64463c38648dcb7d1727f42aad642ce00602eee4'
	["svgpart"]='62bf2bc578a84a7b585002d80cc2386b9be10817'
)
