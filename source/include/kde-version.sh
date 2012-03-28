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


_F_kdever_ver=4.8.1
_F_kdever_qt=4.8.0

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["analitza"]='94c175417126c578c38f29c348a8bb8f54cdfb45'
	["ark"]='57f032d3d3333ca6cede1f214e6d8e178bbe7cf7'
	["blinken"]='ff9f07ee59145a9993604fdef7f301c09c095775'
	["cantor"]='bc98d41262454de5aee65b124e7f93041ad639af'
	["filelight"]='24cd19b927221de2dafd2a1c3d5e8a72a41ec4b5'
	["gwenview"]='c549b0256140c6c466e3279cf12bdc6e6ee82960'
	["jovie"]='4ac647ac3823b6a4f01f839f3e11bca09d6353ee'
	["kaccessible"]='da137f22a8de55858a3ae80f4e95d89c18b50257'
	["kactivities"]='29979514848633da71780b342e7328063bd47d07'
	["kalgebra"]='79f4c85e93a1d270d9d7ba648b86d49fca42d6fb'
	["kalzium"]='914072b8a324e6966528e0047ea50c2a52736051'
	["kamera"]='98a54976430aa3061d14f5b71c6d5d896abc9baf'
	["kanagram"]='d41fa85f894fb0ada8757e4282a57102fda32006'
	["kate"]='d5bd513cd2bfefc2d345547115d0cb0a9d3e6143'
	["kbruch"]='477e508294b097d8367f80a65b1be7c60b1f3211'
	["kcalc"]='f119707ece800a2102eb881402a5bc289b2a55ea'
	["kcharselect"]='06888b54f8c139966f327dd1955c25c967d437fb'
	["kcolorchooser"]='b82a86ac95ca9b4c1dbd66b8164ce855232fec69'
	["kdeadmin"]='0ee44575bfb45159ced6d4d046b07323ebab00e7'
	["kdeartwork"]='31215ff41d01c8bf680578abe57b65648441a135'
	["kde-baseapps"]='bfbc51930a81ea272ddbb1fc9a9cefb9cf9a81d6'
	["kde-base-artwork"]='1be1650a851561b94051691ca1cb0f7e105e4a9d'
	["kdegames"]='bcf764fd1f2f8083c388c17f26b83eeac568b1d5'
	["kdegraphics-mobipocket"]='6ffef4612619ac433addee9fae7f49c05455863b'
	["kdegraphics-strigi-analyzer"]='2e951029c3874cd5f10a75dc4d88b653b76a3121'
	["kdegraphics-thumbnailers"]='a714f485f68202c8b6e2716cf426abd6d82c0dc7'
	["kdelibs"]='da4e13f63ac340619351e9a2f4211cce8ec4fdf8'
	["kdemultimedia"]='9de14f08c7f1649201be029b8e683a296cc75f52'
	["kdenetwork"]='e914a1d990ff42ec88cf37ffc897ae9df9b1fa45'
	["kdepim"]='93222d56f9adde015cb202a1ad3b194ac52e6bda'
	["kdepimlibs"]='ccc653df34fd8f5f8eddac9a9e14f0fa1ea82839'
	["kdepim-runtime"]='2e2e5f1dbfd1b54f0e2b71f9f23be2cfa94348f2'
	["kdeplasma-addons"]='dad77ee1f6ab341a327d694f670e15f160d77d7c'
	["kde-runtime"]='82b57dc38335716fb382a665b536a9aece4684d6'
	["kdesdk"]='5104445024047ae01099e7baa8e5b47a63b76198'
	["kdetoys"]='b0a1c26fa00795767c0d73ff3d25cc339cb005b8'
	["kde-wallpapers"]='daff0ab5f7f66d7eb1d71dcaffe0c291a3753b5f'
	["kdewebdev"]='c707886d79d9ba150c408326efccf24847d5dc38'
	["kde-workspace"]='675df4befd736e770e3029af8d38800c9018e888'
	["kdf"]='fb28f99b23819f3618a8857affdaad1957f8bd68'
	["kfloppy"]='78c5dfa1198d9c215ff2a22b82c4e3db2b7c0485'
	["kgamma"]='9829ed03f9faac64afafe83bb84eae0048929dfe'
	["kgeography"]='58b526d3a597cc2afff49f431a78864d36842ef2'
	["kgpg"]='40f5bd3f2d4bfeed56e519194c41049e14899e36'
	["khangman"]='102eb6edec5f2c6f6f9086c6fb2136a6550cdef1'
	["kig"]='05a5ee09be9955bb24e5fcb926eb5bb8f0b24459'
	["kimono"]='cecf979d52091a2baaabb7334750f8376d835b0a'
	["kiten"]='c2c165f4bc89bcbe3a6b49eb06231d4bf85132f0'
	["klettres"]='d26ced07799a849d42e0865c143515934bfb9446'
	["kmag"]='35686d11ecf5e2783b7518499300a715ef27108d'
	["kmousetool"]='8b3f0323602ab33a5749c7e5c75d50b62c352786'
	["kmouth"]='b4cecf89eea96892608fd125635ea9f9f7fee8be'
	["kmplot"]='04eadb4a030e594c9ea09b55142640345b1c36c4'
	["kolourpaint"]='7a6404f573671b8407a2cf4ec3543ab0883a7af2'
	["konsole"]='23490d929c6c3a56485e4c6585a1d10af9810651'
	["korundum"]='10788c362d209785ce800d70c3b8823af49cf16c'
	["kremotecontrol"]='684ad9b0393081a39b2c6badb2f411846e582bb2'
	["kross-interpreters"]='28a20608fedf726615fc6b97664a30a350e58540'
	["kruler"]='e551744f2e3f772450eb6fe21358067e9448799e'
	["ksaneplugin"]='6f59ab3630850d9ceee15e9d01cb1b6b6dedc9e9'
	["ksecrets"]='7ff7889da899dbac86ae63b0e25c2a8cde59fc32'
	["ksnapshot"]='3e8f0842d06d0fbb98dcebeba684847552fc02a9'
	["kstars"]='5453568396529c4767fb5485e1493d86bd0e6177'
	["ktimer"]='c16ace45eefe9d495086a08fb1c0144baec9572f'
	["ktouch"]='42598cddc04de3d7ec64ea88068b2313333e02fd'
	["kturtle"]='3a6a3828c44957644716608234a3813690d0c503'
	["kwallet"]='39c1d6720cd486e86179468b5606923bab73cb9e'
	["kwordquiz"]='954e49b9dea8e486f8316b9215e12d736e9b1448'
	["libkdcraw"]='80dd47457b9803240a3002ef42d96e201d9face8'
	["libkdeedu"]='ab9ed54dcb99f7cfe98623aa47434841f372a5a7'
	["libkexiv2"]='273d76f2414c2dc442ab8f9dc72578977aba0f0c'
	["libkipi"]='bc290e3354c206d7852433aac704fc96b3a55700'
	["libksane"]='20631624185f8bf26d7a8c2e7222731513e8a2ec'
	["marble"]='542da37f6ea2df21b331aea28cab810eb6802b78'
	["okular"]='ddf676820acf3615d1996bf40e82ebd5c9aa41d8'
	["oxygen-icons"]='cce20fe134b49ef39175c95cd058cb144c134ec1'
	["parley"]='65cb2a02e5da3d9f1f9bb5a2017743b116bce1cb'
	["perlkde"]='93e3b009c972a697aebf0450c4c07ff87a5c0461'
	["perlqt"]='119bbce5e82a47c8f70a8a124b73aa1cacf646ff'
	["printer-applet"]='c3002fea0382386256c3acaebd907a41db0ccc4e'
	["pykde4"]='b9ef35269d2e08578ba20d01822dbdbed72bffb8'
	["qtruby"]='b2532f9e9e04760fce5d9ac87768e6085f0c231b'
	["qyoto"]='32ad56ce6189ce691ed46b8494c4cb446dda6016'
	["rocs"]='b485fe77d48bb82d3b2e6d79337ba4898c06ae5d'
	["smokegen"]='6d43ed064730ff81e1844d0634c1b574bd4ffdb2'
	["smokekde"]='680a29725c4b04629befafcd6c74dbc8cc6238f6'
	["smokeqt"]='7af6089df0ffefe7a88600e43641dfd18da8e3e8'
	["step"]='5b8da2e1efe783e46042603d9ba87f1f464ba105'
	["superkaramba"]='934a62e3d82e92a99b9d070a2dd39634b7351cea'
	["svgpart"]='2332156b52c9f1a33cc0f0cb9d64f01aaf38f9bc'
	["sweeper"]='7a11a22397bbe5106118ed94942f27f546fad80b'
)
