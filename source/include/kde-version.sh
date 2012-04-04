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


_F_kdever_ver=4.8.2
_F_kdever_qt=4.8.1

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["analitza"]='bf76411269246581b09df98ca8ae33be200c4427'
	["ark"]='d39be864ed818dd49aeba84ca4c02c0e5813eadf'
	["blinken"]='c86a67b2e3506e2c56307871afc77e3e67a967d6'
	["cantor"]='53a13c3594ea82b87a421e96b408355eea76fa89'
	["filelight"]='76d8c729e259e2395258f6114e737b07b6671846'
	["gwenview"]='1c5293c258b5afeba5551bdd2029d83eb2ae7df3'
	["jovie"]='eac0fe5006b54914f17dd529a723da4964f59a0b'
	["kaccessible"]='bc5cd13decd2456c91fd6973be038e6fea0da256'
	["kactivities"]='e97d0b82661fd3d886b87d673d7a1191073af7ff'
	["kalgebra"]='560efe77d842c0410986b294323eabef6226e6ff'
	["kalzium"]='e685430d183339dd06e718c0dee3c6aacdd1536a'
	["kamera"]='45beaa52b384e80a3c66f15587abc2938b64c4f1'
	["kanagram"]='25f7733ddc451738575fe1af5a89833ab8295493'
	["kate"]='6bf4796574a003a4edadfb2029725805235bd086'
	["kbruch"]='92cc810935b3aeebe68a970720f4b418490488d8'
	["kcalc"]='f2bbed3d7f991a4cd0484cc4fafe8c04bd29d986'
	["kcharselect"]='527d28bf3bb22d38665a006ab835ff6d75f592a4'
	["kcolorchooser"]='0d1b46b7c90fc2910b3c7422469422efcebc39aa'
	["kdeadmin"]='2952e5111f5e71671384db40d305630bd50c01c0'
	["kdeartwork"]='828d8f36eb55bc93800a8d799b3cf20c22146021'
	["kde-baseapps"]='13dc2e6c8639feadc9a5a334d0720a60b1e3ccb6'
	["kdegames"]='9aeeccbc5f79f7f6b1e91bac41857ac3818cd989'
	["kdegraphics-mobipocket"]='60ea4e3e0e7030ed61c35761c5542d967cd161fc'
	["kdegraphics-strigi-analyzer"]='6b61e1a949d0de92d5f4f1a822fe6dcaaa52b03c'
	["kdegraphics-thumbnailers"]='cd6e99a6c0db6bda765c765356ba9bbd601fba0d'
	["kdelibs"]='f844ae0877880563361144d9577706064c3483e7'
	["kdemultimedia"]='8f54038cc68f91acef07fed711f83407c113b88b'
	["kdenetwork"]='a899a9ef1637612a5ec14bb3ff950f3ed565d60e'
	["kdepim"]='1c3a459ef4d76e1247ac47816bf2b7ea6e37908a'
	["kdepimlibs"]='038474d1c8a3d5c430f25823e25330fa464cfe40'
	["kdepim-runtime"]='4db39cfa14a41702591609a342962348a9250777'
	["kdeplasma-addons"]='1f9db32c724ce9aee6f46bc11a8d2fc073975657'
	["kde-runtime"]='d2931b8a7c744d6c2fc95d46b2195ed2cd253c00'
	["kdesdk"]='8c02ce158f42fa80b5f8536d885e3e232614bc7f'
	["kdetoys"]='d6414aadd77a4c84fdd1d72c32bc066251b30bde'
	["kde-wallpapers"]='f77598e4097dae3fcda524c9dc36b997cb9a91bf'
	["kdewebdev"]='34b229bf778109e0cbd10765c0bd7341f95cd46d'
	["kde-workspace"]='3cd36ed633def0db74ad872a0d6385bf06662121'
	["kdf"]='50754775bacf562ff53862b2005901501f8eb1c4'
	["kfloppy"]='abbbd2908caeade32912cff7db13a50199fae453'
	["kgamma"]='222c2f7f16bae3dd450b04225b88596f4817e3a6'
	["kgeography"]='795ddfb81e5f75d81b8eb332a07f58af85321197'
	["kgpg"]='ef4833daa82e277f2336e68c0d586cf180a1510f'
	["khangman"]='3e37d43965c190ccf5bc4c4485751dbe3139bda6'
	["kig"]='7532bb454d6379af2c0ff37819c76c6c1f20deac'
	["kimono"]='ffe572e5df8f8a5d2a6b94db8e460b603af711e6'
	["kiten"]='db608b5550281e8ca0097e3c4ed15abe6018a002'
	["klettres"]='2b107d5d4f07ab3a1364a5eb3cc5ba5a35b5ffa4'
	["kmag"]='5a88645d7af1f407e87fcd91911b1e94e4ffb271'
	["kmousetool"]='e0a66c42324d9ac09c3e85fea12a24a5ae2abb9b'
	["kmouth"]='f0192e531161544a803f8822b041d8c50ec9bb58'
	["kmplot"]='17c20bc1916be9be2510040302406f6fe861d878'
	["kolourpaint"]='1a51dce10d29f5694216d99cb7c9b0964181fe50'
	["konsole"]='4e9e9d373ce77160b098dbf4fe24b319e7942ff1'
	["korundum"]='59db0c58a26849aaf4c1839d175239f768257d5b'
	["kremotecontrol"]='2269320a9a33a29511c14c7e6c46bff22474076a'
	["kross-interpreters"]='dfee7d8098db258bcd26d447553775434d299113'
	["kruler"]='3db2efcc53a0ef1ba46d5f908f732da708b2b14c'
	["ksaneplugin"]='04a75bc260f0780a9c9dcbdd6b75418168ad5631'
	["ksecrets"]='53a13dfd7b6f97195a9519497cd48d3304e6e39d'
	["ksnapshot"]='373362717f42b5996883eb405a756c8a570ce128'
	["kstars"]='6447338ebed2f822c4c852bcfe50264ccaba2acb'
	["ktimer"]='4e92e995041043a8dcd62caf21ff91d602aaefdf'
	["ktouch"]='5f19f77d3d80058f70b7df2376ce339fda6239e0'
	["kturtle"]='e27f02ae08b8cb3e6be4c0ad971681be5d55db8e'
	["kwallet"]='3a9b13fff2c156fb642b2fff1f93180b4b564c20'
	["kwordquiz"]='4507a07bdf62e5af1ce14ba18523a44b065d090e'
	["libkdcraw"]='38708f1b223740ae105295cdaa6ee372e31c43bc'
	["libkdeedu"]='7c2bebb2d29793a1cab949382c19d2420398bf08'
	["libkexiv2"]='fe32631401be655d4692fec724743d5f623b880d'
	["libkipi"]='c2f788e05f5e6d52e10578ebd58a2b1dd8f65c89'
	["libksane"]='fe9376710687c2e9354bd5f8245755c53e2ad91c'
	["marble"]='f57f134976b27fd0622ba2a24e32128ab23f5494'
	["okular"]='174ff248e3a90246ee84d8aed4014d9864f9f807'
	["oxygen-icons"]='8c16ad0a660bce0a5cddca6bf16aecb65bb892ee'
	["parley"]='3b656361108b5c48e0c582c3ce724f6a439c7fe2'
	["perlkde"]='cfb7d44bd88a899aef56e6200b6a6ff34516a316'
	["perlqt"]='e9ccef109d2a2a7d10f43f87691356c44a733b54'
	["printer-applet"]='92ec65b744d9a303c85b8b2df57f83db1f31a95a'
	["pykde4"]='7d1a41e00794dba160ce8e2a3f750c9a4298ef15'
	["qtruby"]='86643ab8ea52f4a1abcefa3620cea62d2225f949'
	["qyoto"]='6d7b8dcac2a92b143bae0d329793864a7a23aa8f'
	["rocs"]='3e22d284ec0ba40bc82dfc5f3b58b4a5721a8c64'
	["smokegen"]='8ba52937f10fb83470e1fbd724d767ab90921c41'
	["smokekde"]='5cc24772b72c13555dd716ef7b6d77e81d826d79'
	["smokeqt"]='0d798ecfc7ec881871723e51ed1e4f32ef009c3a'
	["step"]='0620924f7683c29e855482af8822067722ced080'
	["superkaramba"]='5cddf45820903fe3f44873ceda907e100dbdc66b'
	["svgpart"]='f29c38a0d82d96140770a4a354d8087aaca9ddb8'
	["sweeper"]='ddb2eeb947e43e52e166cad962b5b4bddd5efd37'
)
