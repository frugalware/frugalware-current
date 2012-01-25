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


_F_kdever_ver=4.8.0
_F_kdever_qt=4.8.0

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["analitza"]='2681b114deab6f3fd215e0348e34c63116ddd31c'
	["ark"]='99756e0896938371d6d7036fb3d5d0d152de29c3'
	["blinken"]='7283a49de949e15f9c9ab06dfa133012a4090a7c'
	["cantor"]='b0ef9cb3c25e4909b6855317425e9d9f12697dff'
	["filelight"]='d0e628ba95f60b7c67ad10e4f6ab14d0e24fc8f5'
	["gwenview"]='ea1bc5dec79fb0810fc4629e8cf023c78f12ef0b'
	["jovie"]='aef47e440183323c5a62d3f45aaece7215817917'
	["kaccessible"]='16451b090fe1ed345b5c1d3426bf0123eda08859'
	["kactivities"]='ac64d13f767c06bfcf2040fcdf94a78410ad035d'
	["kalgebra"]='45903803c0c0f3e05c30e7543ee3ebc891b60e4b'
	["kalzium"]='0d4f9d3a148052c93068d4c2c0ed22969ac05202'
	["kamera"]='1693f435764124651d17579449aa4bfadff3701b'
	["kanagram"]='85daff6309edf72f93fe0f692413216313c98dbd'
	["kate"]='01cfffa6e905103c1b23d4006ba5a26844cc97aa'
	["kbruch"]='0f602d0dd1355dbf84c26f813458bdeb0508f4f8'
	["kcalc"]='b832aadd21906a7bdad323b8f1cbfb59bf1b7c63'
	["kcharselect"]='0f4ffe3469c45317b7b76b66755e14df333835a3'
	["kcolorchooser"]='84ab09ba2e0dbe8077a91d3496b6c65f54b636fc'
	["kdeadmin"]='a7cf29130bd83615bdc01f54a465cef8c492c527'
	["kdeartwork"]='08c6e127ad1931a13ea1dde25189a49de089fa89'
	["kde-baseapps"]='25151b551793164c5eb1cb303d3031e63a6122e3'
	["kdegames"]='714a775811dae11ca85ce1113d673894b0afdcdd'
	["kdegraphics-mobipocket"]='86ae995f7278f14e1169335b24fe7a61069c39a2'
	["kdegraphics-strigi-analyzer"]='9c607105f30c13e83fac3430649696a19e1c4d7b'
	["kdegraphics-thumbnailers"]='acaf1e7f44c3e65619ece032b9165ade65e418b5'
	["kdelibs"]='5e4744405734e6c3ce572ef7d16054390692b38a'
	["kdemultimedia"]='210bfd435c8e6f52aa78ab46f9487a159ab2ac83'
	["kdenetwork"]='51ea55dbcbece59535af61f7450e8ac2aa1db28b'
	["kdepim"]='61509f42a96193ae2a9b9f8560dccb73d739f356'
	["kdepimlibs"]='22409015a8047e3a78711093e3363775e8434fba'
	["kdepim-runtime"]='1cf75a92ddd0c18891163cd9d7f2290afae17472'
	["kdeplasma-addons"]='0049d6977cb89f303468813811f3fde2807fd8db'
	["kde-runtime"]='5e1e98535529a67f8d20e8c76d051c81604d7064'
	["kdesdk"]='2c55ed17350cb5eba4213007614e4c587feb94b9'
	["kdetoys"]='4d583cf52d10462a71df8eba907c07453f844cb2'
	["kde-wallpapers"]='95ccd9845d2ff935089e895a9ae0360561aff9d5'
	["kdewebdev"]='8919c3a272a954c19a4c0a742e3e686e29650aa4'
	["kde-workspace"]='4c471b159315b084c65196b0c93c34981a9105c5'
	["kdf"]='cc7b1450624b14ca740b64edd5b8fb54faca491e'
	["kfloppy"]='5f1ea4bf5e145ce3eb8cc136ac36c57675ad489c'
	["kgamma"]='ff86fb416475aefa69d58c3c69f5426b32ea63ae'
	["kgeography"]='07d77cd5182e0594273aa713ad62134232868c08'
	["kgpg"]='4edbfa73c62fdd99f87b5b42dd7f1330dc8f5986'
	["khangman"]='2deaab70f8ed414a4ddb21aeb91627dac74986a6'
	["kig"]='141a4c9230ab134dcf7016c2880357d9e52b8f69'
	["kimono"]='b46842ce2b3c1aa3620277a461c3d127843d6a4d'
	["kiten"]='4068f2bcca69150a9b340a6d47ec4902d9dbacc9'
	["klettres"]='9d2c13dd14db79451db8afdc184f264b1ba29d81'
	["kmag"]='7f281e2ac07aeb8d31249e6e0b27661a87f98a0c'
	["kmousetool"]='121fce8fd61772d044a48885918d2c0b500bb646'
	["kmouth"]='43ff583d0628005087c948362b1e64dc4d359d88'
	["kmplot"]='914151c41fba93cb1d0cd659fb3e392c0de1b5f8'
	["kolourpaint"]='2d8c32fb16a8b4f479906557b5eb88c519e2c08e'
	["konsole"]='f99abc20fd0042be62e48308f334b66a6a3135d7'
	["korundum"]='635ebd224ec2775e93ddf395c2e4d2ba838130df'
	["kremotecontrol"]='6a4d7eede9736aa14213db082ceec5a2132c89c5'
	["kross-interpreters"]='2b2ac36b1597e180c1e3923c00f4ca465bd99a03'
	["kruler"]='e453a29c327e13458c32abd86ce7b98454b859f2'
	["ksaneplugin"]='0110854a69395bc4402caf2b91fc3cf44a4200ad'
	["ksecrets"]='13852c77b7aa76286f1108024650cb61fbc2d24e'
	["ksnapshot"]='a95584fd44401d130815c1ec79c21532197dbef8'
	["kstars"]='249f80cdd5198c5c22ce75cea4d1718d5865a3c9'
	["ktimer"]='647cd73338d3304efbd9bd5ce79f4b9d3e094836'
	["ktouch"]='e1e1338e67c0c02c4573a4aa95a721c8f674f2c6'
	["kturtle"]='3da036991fed5840fb45d033efe0082570e804d9'
	["kwallet"]='84828abdbaa0c0719adfc3829fb9decf1ec0f87b'
	["kwordquiz"]='34eec78fe68aef8b7166ca6cca84ed58290484b9'
	["libkdcraw"]='4c613177ec8cfe1436e5fb7f3b61bbb306d13f71'
	["libkdeedu"]='ca40cfa3ac019ab986ca062a1c7a8be5c3b366af'
	["libkexiv2"]='4536ffd3df63a8dcf68bf8ab221ba0c09be417c6'
	["libkipi"]='1eccc5b6dda059eee10b2ae3e0ef6a47953eb084'
	["libksane"]='417e0e65d3045548a29a9acdcbe1b0511a42295a'
	["marble"]='6c3c6b03c9d8e92730d6955adcbdb5de42fda43d'
	["okular"]='c112a490cd1245041c9d81b9377838fd0de4d60c'
	["oxygen-icons"]='cd893bb4060957e4ceff39c46e01cec82746163e'
	["parley"]='800eea4d6339da608cc720b5d6186de9a43b70ce'
	["perlkde"]='e9c46cec78f42a29befbc26dfa428d6a28027754'
	["perlqt"]='db11f9625d6c531d9b4cf0d50c36e405600a7717'
	["printer-applet"]='6d6f6afb89ac43c6f1c9393592d8645480530662'
	["pykde4"]='cf204efebc1eda6de7f4405dbf5037bdaffd30e9'
	["qtruby"]='9b8e9ab4926929909861f6557dea908d328a1dd2'
	["qyoto"]='3e5abc08b5a097e332449f15c50975402934d60a'
	["rocs"]='d29daa9633e2ba6e2d3e0c7155ade752216a8969'
	["smokegen"]='9b4f0af954e845eecea8e7ed388e01cffb8974d2'
	["smokekde"]='04f01d14cfc395fcf675b7a22202b41351f471f9'
	["smokeqt"]='9ad56f1441c92b6d24b7e9ec19fe62da34820731'
	["step"]='08fff354effdc6f10e3b55ab011f8393a19de9fd'
	["superkaramba"]='1b3375814012333ddbf7d9031647fc678ba1162a'
	["svgpart"]='bd432a31976cb64c41035382a8133332aa184c2a'
	["sweeper"]='213abfd1d192acf619603e66c2f6e83e323e22e6'
)
