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


_F_kdever_ver=4.8.4
_F_kdever_qt=4.8.2

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["analitza"]='d3b831730408078c31b686bc49c1d465de5e80da'
	["ark"]='1d0d311beb8beeee7f33a58baef7f95192eb69ac'
	["blinken"]='571e1f06270d38e56149a8770517bf892859e2eb'
	["cantor"]='8e284e632144a92f503092738d19843272d0412e'
	["filelight"]='3023e9daa8bc5271bed3f3c08076952bcaf75efd'
	["gwenview"]='6cc6da85f6e2c8c817c1402baace16eb58b7a423'
	["jovie"]='d9d829c09312bc6f962c36521629ba1bee8f1431'
	["kaccessible"]='d467fa3857b2c5a2aa3a5421b5d7c74fe3c7f981'
	["kactivities"]='3f42c18bae5a1d6bbd7fca471d8b4f9755875e06'
	["kalgebra"]='be0bcd290c61713a0365e9eab2ddc8d58f447f34'
	["kalzium"]='28ed27164680a28e478cc6e0a13c918bc2119dc2'
	["kamera"]='fc92327482bf1cd9b067667285ede00e3e464653'
	["kanagram"]='e897cc67ae046a4d7580f22a0ace534525fa6f1b'
	["kate"]='5a70b64c92892781d50781fcaac81ff352ec3ed9'
	["kbruch"]='40c24efddc30441a8de2ec315e1933ca429da14b'
	["kcalc"]='f1cb6cda210c67fd19eca387df2d2224393d45ef'
	["kcharselect"]='0e00a25ca3c813ab335cd12ff0ec4b1f22c8076c'
	["kcolorchooser"]='2f5ee55c86a503e458b1884939a62408bedbfc70'
	["kdeadmin"]='b825e40b29b4ae684265cb13b7935737d7ae6d68'
	["kdeartwork"]='c7e15538d3141af8673d16f498c6af7bff62a87f'
	["kde-baseapps"]='a1d6951b27c868c738a36dbd21702b658f3d6245'
	["kdegames"]='00a68215c3e8b41ec8b7949c5d82af8e54766e97'
	["kdegraphics-mobipocket"]='0c38ef851c054b0ee3689d41ff5f7f6fb3d83f67'
	["kdegraphics-strigi-analyzer"]='208dd945c1ecfaee97457585dc7a52916dd2318f'
	["kdegraphics-thumbnailers"]='57e753881f9ca78c4c188c49a3a1b258b92adb83'
	["kdelibs"]='35cd199a30d84eb37b2b213fed5ee3adf810ea49'
	["kdemultimedia"]='dac721e82308a6347d578361e25da7c466a26ba7'
	["kdenetwork"]='b3926c5cd929cec209421c2f1cb8659cc1c82458'
	["kdepim"]='aae8f027ab1ef75283d6e4b2bdf76c91d04087ea'
	["kdepimlibs"]='34f693ac71896d0d8653fc2a81323d1e91531bb2'
	["kdepim-runtime"]='3a375afb62b4ee01d491c4787b559132317aa983'
	["kdeplasma-addons"]='725d26e3aa59d02bc73a77b43e6aae92bc961254'
	["kde-runtime"]='557fada748de52e5275058c50ec3cf8a652c0001'
	["kdesdk"]='62c176ee3dda5bbc013db7d1033ff89c105e3fd1'
	["kdetoys"]='dd5f63f0e833135bac73a2e12692b1e6dd412f67'
	["kde-wallpapers"]='da11aa057c5b836ee026634bb61565244d614682'
	["kdewebdev"]='bab86ef6c04515a454298cee46eccb25e590f972'
	["kde-workspace"]='a732ceacf34dfb79c8ab243f17cd5a70b9183212'
	["kdf"]='c83f9659d693f27166519969f85c630fdeaa3d9c'
	["kfloppy"]='597e7d1fa546a898b4e46a9750632be8dc8a01a7'
	["kgamma"]='812a84564db52fb6a8b8e0e829eb762d479092ec'
	["kgeography"]='4637c5a792164d083f0ea05e6733160922d8c73b'
	["kgpg"]='4b201d0db0d97d258597b0b345848acec5bd0130'
	["khangman"]='aa544ba55833983bd21ebf594f2003a66b251901'
	["kig"]='dcbde5fbb34e0c569a2ef95a328cf69a924cd38e'
	["kimono"]='9c8e41ebcec01cede7987958bb4d7ce775587e45'
	["kiten"]='f7b5f9b6cbbda37c539f1ffce9bd905f0be3658e'
	["klettres"]='b5dc64cdd09f265cd7a84d0ee14a93ea4ae067be'
	["kmag"]='7b5b51422d4241d6303841805a04b2eace0c7a2d'
	["kmousetool"]='6667336267a3a65bf0b33a8454299558ad458108'
	["kmouth"]='104bb2c434deabbaa57326fe567fc90c4067f36c'
	["kmplot"]='07ada013e1a046afe3bb3542a2485b1ec0d4736e'
	["kolourpaint"]='1dc706ed29339df9fcc68ee606588941319bbf09'
	["konsole"]='a5900aa089a28fcaa69b45cfc7b46f556a38bd11'
	["korundum"]='ce722ea7c64ce90d11370e393a87cb067962853e'
	["kremotecontrol"]='2c967b6d5738d3947401d9055f0956dfd16b2ec2'
	["kross-interpreters"]='b5b73e10aa51377abe4da74eb98589fcc7eb83c4'
	["kruler"]='b3fb40888f6cf2ad419e1f30a97c2052ffbae1d7'
	["ksaneplugin"]='b7a3204ef27f04bffca0fd77d84bd46b236687b7'
	["ksecrets"]='d0fd2c601833cf1ffe52760472e22d667a6a6408'
	["ksnapshot"]='1cbd1ea468e7722feb8c96dd5f1f3a18bb91d4ef'
	["kstars"]='579cec66cfb172258d2967872a2b9c32d4514c75'
	["ktimer"]='39e117449beffa8e2a38f7b45f69965a71de3805'
	["ktouch"]='95e7712b9644d1b3491c988bc591d7c5b4e4d3b7'
	["kturtle"]='160972878f61c37575fb5953b88354fe174fe8ab'
	["kwallet"]='8c85c9de379f0e8ad8a3dffc2136c6b25c0fa4a9'
	["kwordquiz"]='ab6cf92bbedef4115951d3cc53a9f3b91ac11875'
	["libkdcraw"]='ba67432cb3353a55d57ae749b42919399dfda3e2'
	["libkdeedu"]='055fa35db3c482c61f8eab7d1912532823a88726'
	["libkexiv2"]='a3429dd70677498c890598cd1e3bf6a610669b77'
	["libkipi"]='d30ef671be8caf8eb9ead68de53cf187f0fcf88b'
	["libksane"]='5ac35d8478ccace1495ae42eb2169918cebc8d95'
	["marble"]='ec3cd41a1d333e9e3b34595adf6e4859315159b9'
	["okular"]='34ff243a4fa77400631aa44b31cbe54910f8091e'
	["oxygen-icons"]='4034b61585db7e8c03f3270d860aa7443f1a6193'
	["parley"]='bfc361363fa0cb866fd1d704b86d71401c1c4ea6'
	["perlkde"]='5d94e2f4d6a32cf4cc7ff1d577d925de53ec8dee'
	["perlqt"]='86a7706bff687f1721d0b17e9bde3aa36e0970fb'
	["printer-applet"]='451bb3d658a447c454918ea5b0299f1e85b8cfd2'
	["pykde4"]='e629d7a1d7d1aa1d1dd24769dc5412a60b6ac256'
	["qtruby"]='ce9f9b45d7e9edc839257a1f1c53b1e699503b47'
	["qyoto"]='8df3ad9630e8435e6af5af5809520662c95ee516'
	["rocs"]='991e5aa15e59cc432a9c9f140fe90bd47f8f8e15'
	["smokegen"]='5ff7d15ed1cdea07f455fbf1189885518cf43cb6'
	["smokekde"]='d028d68485bc32cfe6bc60dbd597d8f72c9e70ef'
	["smokeqt"]='bf2be3e7ccf8d451f001fd2f08c306fb7f72169a'
	["step"]='498d8243309388fa8b59cd968c0c92fc588eda11'
	["superkaramba"]='b013e4bd063790e5970cf798f247edb87d576900'
	["svgpart"]='3c202f0a58035c56e7e46a983c254a6284b97ee9'
	["sweeper"]='8a4dd11724ed14987981dfaa60e742cfd80ee6d9'
)
