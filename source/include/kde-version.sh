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


_F_kdever_ver=4.7.0
_F_kdever_qt=4.7.3

# Must be done in 2 lines else bash barfs on the floor
declare -gA _F_kdever_sha1sums
_F_kdever_sha1sums=(
	["blinken"]='8d6677b0c1b98bbb631730152e9edc1352af76c2'
	["cantor"]='2ab29119e2289d697cc0f623cbdd90933697c1de'
	["gwenview"]='30058dc40ea6ae8e3298facb9582d6bf91753d8b'
	["kalgebra"]='55def835948c6dff69ee87835c45630a1ae5cbc4'
	["kalzium"]='786890c54d8ea61841c2cfa4ca6b9c05492fae38'
	["kamera"]='4b8b0bd1bddba96fbc0c856d985ccb7419aa0d75'
	["kanagram"]='7d3d423960958cae8df7113f722d92428037ff8e'
	["kate"]='8a9685f58c9a7cc2c317ffc4f2bd18b76639a2cd'
	["kbruch"]='c3ca0d7a19787796faf8c7b96aeed46081613ac2'
	["kcolorchooser"]='d4be9b00eecb8c7a9aad45ed5861ad0ea0bc764f'
	["kdeaccessibility"]='69ecaa186edd07cfc391d6c630b6a95da602d3b1'
	["kdeadmin"]='792eaf403f1c95be0028145345ddd80a99cf3c15'
	["kdeartwork"]='b534a07ccd258135d72902a664198fd2bd22d508'
	["kde-baseapps"]='99f6b99039fbe41f470699232de703b4f4be802e'
	["kdegames"]='4921fc802f02d0f4b21b8c99cb2ac8c24867fe16'
	["kdegraphics-strigi-analyzer"]='2c2ff7e6b13ac1c073f112df9c794065d191e085'
	["kdegraphics-thumbnailers"]='6402d5a73d88ea4004aced3e68fc5e5c6454aaab'
	["kdelibs"]='2a7a59ac78a161c7c2393db89179449b495dd2db'
	["kdemultimedia"]='3ad5f6e806a0e8ea9f7c88697d6f605a112a9d21'
	["kdenetwork"]='e9e9d9c648d7d0e38852bc3417faa605bd62c1d1'
	["kdepim"]='d8a131d886b923b397a50439028ea45880aa9404'
	["kdepimlibs"]='b5296ef96b94cab5aeb39dabde466e28670c20bd'
	["kdepim-runtime"]='00286df86a64eecee64e6cf9199b69d87f62135e'
	["kdeplasma-addons"]='7a153131b84156ab33707c2ee21ffcf7021e099a'
	["kde-runtime"]='79c9b8323368f1a2a9b03830bd9ae02b2b20482b'
	["kdesdk"]='619e9e6255888c989997fa02a1b6b97220ae9f11'
	["kdetoys"]='2a4b3838293fedf9a814bf5ef8fbceba7460a8c5'
	["kdeutils"]='829eb0935ffd26fa4bb33b6e66841e3599f92c94'
	["kde-wallpapers"]='302f7ddb823e2b539236871567541c6b640880c3'
	["kdewebdev"]='bc11c574260f596d20317827f468778df9352037'
	["kde-workspace"]='cbc61a20013c746f424681020c29480c6249fd10'
	["kgamma"]='4534ea82e0d1f48414f1380e22d7aa8e7e50db98'
	["kgeography"]='5fa6bff0e67e11657d55435c3faffdfcaf318e1e'
	["khangman"]='41ca66dd44de19e073993cc192bf6caf512b23d0'
	["kig"]='a6f46c28c4da5de14e3e46c19c11bd2ccdb16abf'
	["kimono"]='3b9c6e12f5fdc57214db841b98bde90d8dbd40cf'
	["kiten"]='7caa8c13f6431d54eabc3a88f874f279134181c3'
	["klettres"]='1701b1c83856686b5123036dcf3c17643bf1ccc6'
	["kmplot"]='5123c7855497e6374dbd7211890cf9e69a4ee886'
	["kolourpaint"]='e6095508eac71201b19a63d416ff771b7bc5b9ab'
	["konsole"]='e1e9fef5cb222e9d9eaba17e227ac66aed3e19d6'
	["korundum"]='6f96a412077d3b198ee64c88e26fe60227e723c9'
	["kross-interpreters"]='bd31f249a63696b34e33fe8ccd4adde07f386806'
	["kruler"]='d77be8bc37dc684253b0f18952ad463908d55561'
	["ksaneplugin"]='2d1b61bad04d24f699ea64b203a112df15d37946'
	["ksnapshot"]='771002ae1b047ffc850060f128f11514a3349f89'
	["kstars"]='7ef3b53889aceb97b9452bf0b581a3aeefd243dc'
	["ktouch"]='b310e264e3fe8c96e2ceee233f364ae5cbd38048'
	["kturtle"]='d7bba4f06ac21b37bf32a84903ba6366a094ac1f'
	["kwordquiz"]='57064fa6044c65c13da69a8954598357b6499622'
	["libkdcraw"]='7c8d7ed8eb18c3f2951d451a2cf46dde9a336216'
	["libkdeedu"]='fbe1f3a7416d58bd4b0653280181da192e330214'
	["libkexiv2"]='ee5f524d02c7b1fb29767177890f556fa155c5fc'
	["libkipi"]='252a55484ee282ada6dd88e8ec4991b2ccdc74f3'
	["libksane"]='73a3f2c4619ccd8da7c362fc3832c1d52795933f'
	["marble"]='bbe08a57a33e06fceea3a51aed1406bc71ee02a9'
	["mobipocket"]='13e3c48a903411bc461f029564dd2e968dac719b'
	["okular"]='3fb935d79c2c24af9ea2874dbdb88f46d82154c2'
	["oxygen-icons"]='00e4c8a4db6f8aa8c5f00d8e7cc2dc27d2436664'
	["parley"]='b0925b3658656933410eaee701ec5f30eebee88e'
	["perlkde"]='cc4a9c1e966b3baae0f0b0b82224a9bef96bf7d7'
	["perlqt"]='a48f2f34374258793c7394914645cf2b8e597aaa'
	["pykde4"]='8f4cf7c9a99ee5b0fb2c7284518a129dced31c94'
	["qtruby"]='c42bf8eb7e237ce3b6ab061e30c8243d0e9ecae1'
	["qyoto"]='2d55a08882679f2693008741f53deabc57898487'
	["rocs"]='f7cb5e17d469e6f88851f1104145e3d02cff27c0'
	["smokegen"]='e6116d95aabe1fa00fb9126b582ad028765e56fc'
	["smokekde"]='c1cd38131c841f1f386bc270225fc5950db1c7a0'
	["smokeqt"]='7f0366cc6144ea684c571ed3876dd0eac6d72fb6'
	["step"]='134fe3b80f0ea1931a81cd82981ef5d683442518'
	["svgpart"]='1b6f7eccf84c0cb6f92a37d8f65cd6720ed2e72b'
)
