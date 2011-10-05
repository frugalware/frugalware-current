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


_F_kdever_ver=4.7.2
_F_kdever_qt=4.7.4

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["blinken"]='ec0418900c5d71d64f65407b898d740a5255ce08'
	["cantor"]='5cb978903868d3dbda7367fec21a02818f693d6b'
	["gwenview"]='ce1c3df9e9147d81ce250c41e7d9a328993d8632'
	["kalgebra"]='4507b93e67d953705f7fe5eccec10868971a79ca'
	["kalzium"]='3e750692964ca76da9ccbae5bdc263413a22a049'
	["kamera"]='354d45d8f62c66bef0bc04c6e6e2056060ca7f0b'
	["kanagram"]='0dd7dd66f87f99a5f0f2b4a7340c4690240c2478'
	["kate"]='467b0558f1f86d0b210abd2d78c94cbe63b8579d'
	["kbruch"]='db4959982db7a36fef61798978d8c885408a3e3f'
	["kcolorchooser"]='64bd726f1bbb1e771bc037d9929f0eba098d844d'
	["kdeaccessibility"]='7a2f7ea0e635f0ba79d7d54b118814bcefa4b6a1'
	["kdeadmin"]='c96ddd94a4903b035e73b3e958e6b189ca173fe9'
	["kdeartwork"]='a536d530e1f97d14f11ada47435f3e194e93beae'
	["kde-baseapps"]='b52937ad8e5e4be884cc76f265c19964f461ac2c'
	["kdegames"]='a84be8406fce38cf5b172c320904bb1cbe59e729'
	["kdegraphics-strigi-analyzer"]='6094f33788f619e316efad7bc3eb6178b1b28121'
	["kdegraphics-thumbnailers"]='281c84bcec1ce4b02148caf164c28fbc47d9b11b'
	["kdelibs"]='4b074633cbf69752fda96018514ee771efe8f18b'
	["kdemultimedia"]='2fc12558284fe95da63e24c73612846c6c1d31e1'
	["kdenetwork"]='59e9e3629dff0362cfa2a6d897c77bc9cfbe8d5c'
	["kdepim"]='41983556eb54a740a20d274878006ace5bc73c1c'
	["kdepimlibs"]='9ad72ec123c2837783e6836e8c79210c658d2536'
	["kdepim-runtime"]='f82886a63c48d718f30d60bd76ea7ac97f17a4c3'
	["kdeplasma-addons"]='e1504ed7e21da8982610f42e70c3028b77ede6f1'
	["kde-runtime"]='4d0b1883a2f65cc9472c4788c24e6b241f3b8828'
	["kdesdk"]='b6259b46fed642c35e1c1d1f90712084141ca441'
	["kdetoys"]='51213ffadf0326863aad82d9d581a2c9997dda58'
	["kdeutils"]='52ce9b6b5f2c20475f46b6f7378ca4c530df37b4'
	["kde-wallpapers"]='41398c918112e266c365c7269a6eb40795a2de19'
	["kdewebdev"]='82910da01dc84e86134d0dbae23b4bf66b565faa'
	["kde-workspace"]='afd37b2f583690e391828c1ceb7311e2e8d37c6f'
	["kgamma"]='3f8cf9bf169a0bc058d0de610bfa4910c54ef475'
	["kgeography"]='843322c2dd1131122abf03d226b87ec31217ed36'
	["khangman"]='24d3c41b0cf0aaf68ad053b0e701d7bc3df8bd0f'
	["kig"]='2234ddb85e8c52214f9fdb5eb25f9491e23c7d86'
	["kimono"]='2c2c331991e2b42101957ecfd13a18fbd4f86a68'
	["kiten"]='f6d76b2c15fdf47090db15303413114180358f39'
	["klettres"]='44a0fa094b90da19c5b0acc25da1150c0ff02b1a'
	["kmplot"]='dc496d88d6e062f7ecbf6f41187df95aa374fe9b'
	["kolourpaint"]='d4ec3e463ea3d50731e9fc87cc52eec50bc67ff8'
	["konsole"]='20150963cc5ebd2f2c13a617a37e018440e0f18c'
	["korundum"]='091cfd121e41d4edf38eab31e2dca65656e7349d'
	["kross-interpreters"]='7dba16c2e5e18c955d2fc40536d6a40bc4872cff'
	["kruler"]='acd3b77bf68fb409f456322d8a68a9d59d1014cb'
	["ksaneplugin"]='0a35cd7818089b31772dc974dc01a936e91c7d80'
	["ksnapshot"]='b6b3978639f7f3c06cf5b5653d9a367e38a70cec'
	["kstars"]='bc51179a16fc2337d1dacab4c1d291042fc0b69c'
	["ktouch"]='d5e0abd7defece0f455818c7bc53c50730419c46'
	["kturtle"]='cc86eb08310e8ff591ebb394d08ffc214c264206'
	["kwordquiz"]='f9450b1b7f539955e55877d96b37424c8abe576e'
	["libkdcraw"]='9e32ee20a1d201e55aacc5a1fb1de87ad50f3579'
	["libkdeedu"]='51f8ce8847b71674244f7620536939ba4f36d476'
	["libkexiv2"]='fbd158168c219cbe1009019d2a33376fca951a5e'
	["libkipi"]='a75cd016c2d9faa71b2867cb4b3eed40edfb3b85'
	["libksane"]='223182cf23fc29a10ff2f1ce7756aecf4258b41c'
	["marble"]='2b6353ff589d66dcf95a3eb79059275f620e03b2'
	["mobipocket"]='554dabf927e406aeff5e495b8eb7445a080d3195'
	["okular"]='5bc14efec8d00429a45a807a5bc839ffc783a10f'
	["oxygen-icons"]='0bb63c06b8b13c9061400099e4056bbd1ef0eb23'
	["parley"]='65fab5b04f2b0a3598c764ab138acb3c335cbb48'
	["perlkde"]='a355563b55dc2dd004373a39853af38cda0d005d'
	["perlqt"]='cde0c6b325e62d26ee6bd2f3f25d01e0563197c9'
	["pykde4"]='cc7844851110697f06da60cf4a1ee527eda76087'
	["qtruby"]='1d13c0dd79a2c90c9e964e23fee3573c9397bd4d'
	["qyoto"]='f002a31fcdcaa94af02bbf5e368e79463974e467'
	["rocs"]='19f2bf19dfe7a0787180c3fc9d1f32c14316f985'
	["smokegen"]='f2f605b2ca40403529b9065e745ebb1d9b7e0fcb'
	["smokekde"]='8874744db367dd5c9d7a8783f662b6283b69dc1f'
	["smokeqt"]='93bf50c340e5188f2432da97c5a3ff7e2928eb3e'
	["step"]='642f24c49990181ab2cc2d1ad974bcdc3d47ed46'
	["svgpart"]='fe17a4f801ef94356a6bbc629affadc28a203b72'
)
