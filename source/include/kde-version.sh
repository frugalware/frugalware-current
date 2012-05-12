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


_F_kdever_ver=4.8.3
_F_kdever_qt=4.8.1

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["analitza"]='bec5927a68028b74193afb6e7f2a36f97ba25543'
	["ark"]='9ff1fff082f53f31d0d31f2570005ae551fd2164'
	["blinken"]='66b94eb99a9e2075465fd60d8e5635d4b064ecb9'
	["cantor"]='e4aba48e30a4bee444f7e01eab807619908cd903'
	["filelight"]='1d1a8141b50e0eef2f2c8c13c6060ff11aab130e'
	["gwenview"]='be5fd73872be0e46a99b8d5b1c54e1e0328350c8'
	["jovie"]='d8ec774abfc4ec4f8e43103365b37ef99f62aa3f'
	["kaccessible"]='50b2c1b5df4652c7ba078820d1e073ef14c8b9ee'
	["kactivities"]='de382701c5a9f8c04de78124a4b2c19f3707656c'
	["kalgebra"]='bea6a48ff5ae650e95fd443134dced3b08b169d5'
	["kalzium"]='33629c565b82c755af0b73746c675ac44c234028'
	["kamera"]='af58ef6b0762bd6e3bd75f7914c6ba575c205ba8'
	["kanagram"]='36036b57bec5896945e5edaeb183120df4b90ed1'
	["kate"]='100fcc86de792d3418ea0f9995233bdd8871d7f9'
	["kbruch"]='6cbb2ef86950e306bb4824e190e7689f8dacca2e'
	["kcalc"]='36c4c46ba05911dd174c7d1fa8526430d932c84f'
	["kcharselect"]='a4196b6ef1f665fabd2ba91f040b2f858c58f397'
	["kcolorchooser"]='08595a7388abc65b96fd91a874d5cedeb889c217'
	["kdeadmin"]='6de6dd896c43fa6825e569b1c1eea522454e152c'
	["kdeartwork"]='fa2dd6f3a1b9e82564b1250be003577c4ef77185'
	["kde-baseapps"]='593053e7fdd50b32e6f9264edf2a69e499ddc0a6'
	["kdegames"]='eea3a13a9e713d387b48d30c615b68336945eac5'
	["kdegraphics-mobipocket"]='97a19a437e53f1b0ec538d7d35bbf25605e6845e'
	["kdegraphics-strigi-analyzer"]='8e0cbcbd36b1ac5fdfb7665bc456a87dd3ba59ef'
	["kdegraphics-thumbnailers"]='3a7839030e1e49addfdb275acfa1c0288aa95431'
	["kdelibs"]='50633efa4ea2a133e51bf55286ff754c46f2eae2'
	["kdemultimedia"]='8f2b9181d5ccab5a9efd62f2778cf6c2b88abb3e'
	["kdenetwork"]='9da87317c6a10243d6fff8c121c04146415f65cd'
	["kdepim"]='1d40a820fc343bd6c492e937b9da2e7226cd3e78'
	["kdepimlibs"]='453badec44fa2fd8b551fc9f8df2d51c88930dca'
	["kdepim-runtime"]='f1c6691522113887dc5f098678ccbbacfecb9390'
	["kdeplasma-addons"]='64bda8ca1d68ab07596d8eaa6381255d815346bc'
	["kde-runtime"]='500ada503708aa89e2cbfa3ddb6353c3d350d96f'
	["kdesdk"]='e7366cd627fd8324d89e7854361be8a141d030c1'
	["kdetoys"]='b3050335f3f6b95dfc293cbbd999e21d9ff4f967'
	["kde-wallpapers"]='0ade3e66f1e10813fe4113989b3b99eb2df5bece'
	["kdewebdev"]='481863c8a59b48613b0823c16cfff8566d03f5ae'
	["kde-workspace"]='23dbd023f76769ba6ea77dbc11314eca504ad3d2'
	["kdf"]='3c4a05df8daa526f89c2b7d4a6a66dacbd4a92cc'
	["kfloppy"]='e507d66f29df3ded849be74c609ce13a38e78b60'
	["kgamma"]='bfb32bbe49cd715390d24e3705d23171fdf0e2c9'
	["kgeography"]='70a5577a5303fd8d97efbc06220bd896ec00574f'
	["kgpg"]='70a99932697bd7bf37c3991c24831c9ef94f1302'
	["khangman"]='75d0147a2e374b8940cf472550ca7f45a5c63587'
	["kig"]='f7bd8d16cbb98ca44868df7bfd6b7a9e608c9ff4'
	["kimono"]='b509d3511204d858049009c827a5ffe395296124'
	["kiten"]='8d94c45907a18db22117801ab1773cc43afb8c23'
	["klettres"]='e0156053117b07bf0a81a4258f7cce6f0ba4f60e'
	["kmag"]='20a72ae6eaf120bdc6449f8bf048688ade5c584a'
	["kmousetool"]='95f888155714dbec9a886ab86c247eb695ea2999'
	["kmouth"]='2bf8356df5207de3a7c95a931070fb6b2d0fba6f'
	["kmplot"]='c34c93266fd00d7c9b0d6f16625dbed13dba2a20'
	["kolourpaint"]='2030505b4169448914ef693f88874f3f323fb49c'
	["konsole"]='f9dff6e2d66c7533474146b6a4b19112f866796b'
	["korundum"]='e949fae573d1399e67830c3eef0ebaa853905026'
	["kremotecontrol"]='38eec5beac2b62086d21c9e97ee549af913db844'
	["kross-interpreters"]='1191563f2a925a261b40d61b62f1d1b7e01238aa'
	["kruler"]='baf3015a781e4389e9fa66067906e18765322132'
	["ksaneplugin"]='d6c5588bb2e5b45aecb0de1b37775e22b7cd696c'
	["ksecrets"]='e5a2526af64a340abbf1423760e1ceb2eae3189f'
	["ksnapshot"]='7b90bba6e11aff524ed759e7c7043fc97116b92c'
	["kstars"]='3c06bfb4f1e84565ac4de8126cfe47111217c995'
	["ktimer"]='232555ab5630219b3ced8486f4493ca61eb99f51'
	["ktouch"]='f098df93bb5c3dfd349104d168f3fcb1eb73ffb6'
	["kturtle"]='6f8c102e4bf41c9e214b5f71bd79f56f5651c1dc'
	["kwallet"]='b99a380bdb864d3eb6461e9a8627963fe4c1a4b8'
	["kwordquiz"]='65adea1b68f1f4d7ff36ef70bdd29fafc0e36e9e'
	["libkdcraw"]='99fc4a00fe77df18aca53a8bdd0cfca79cab6e8b'
	["libkdeedu"]='6d7ce71dea0a4ee16cdec8cfaf3b6dbd64c3eaa0'
	["libkexiv2"]='6b7c6833479faa29916d3cc294a15f78c154c438'
	["libkipi"]='1646eca0521524eabcc8c1c97d8d2f85ff181cac'
	["libksane"]='ccacaec0d1a46689cdf5f5294f14b442d0f4317b'
	["marble"]='d33d73d757b14a42640176b994ad5930ebc1df30'
	["okular"]='7c43076df3e9d6217e2a5cbb8ef6d8af89f8ae37'
	["oxygen-icons"]='6057679500867f2438b65692c4073b0d51894554'
	["parley"]='4a524209b19dcb174f4ce4258b4ec85adfa19ccb'
	["perlkde"]='bfc1c3a86789832cf7747dfc854d586d86c10a99'
	["perlqt"]='d0d0d5da1fd9c50bd19ff2bb49d6a71a2d97759f'
	["printer-applet"]='5cf271932fbb67812edc889e74db799891e0291c'
	["pykde4"]='e88ef838b492802f401b0242205e87149c19d032'
	["qtruby"]='aa88b382034cb66f283c200a10c04d3ba2170492'
	["qyoto"]='7d20a80fef76d4cdfb8d03a66e07b82074df69b0'
	["rocs"]='772a80277edb483d4e189595a1723a2d1877d8d4'
	["smokegen"]='0ea29388a8a8116e8b4fa7fe6e8a0b270e99cdcd'
	["smokekde"]='b02b4b12dd5a23b2a87787bdde4491161d6a4e8d'
	["smokeqt"]='a1f5e5ed2a8ea94bf785771b2b43bf2dcb3b7808'
	["step"]='2356c87aa3faec080a4963fc69a4d07c2d44a67d'
	["superkaramba"]='9376f27c311d3e9c6f21719eb7d0b2ccc893908e'
	["svgpart"]='53d69e810acbad5d1cb606a74cf218e3ceccd876'
	["sweeper"]='ad2c9ec51458e1615714e81cd5907f5d2393984f'
)
