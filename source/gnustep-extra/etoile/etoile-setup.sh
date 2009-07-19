#!/bin/sh

##########################################
# Script to set etoile defaults          #
# Priyank Gosalia <priyankmg@gmail.com>  #
##########################################

source /etc/profile.d/GNUstep.sh

BUNDLES_DIR=`gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARY`/Bundles
BUNDLES_LST="($BUNDLES_DIR/Camaelon.themeEngine,$BUNDLES_DIR/EtoileMenus.bundle,$BUNDLES_DIR/EtoileBehavior.bundle)"

AZDOCK_VINDALOO="{Command = Vindaloo;Counter=1;Type=0}"
AZDOCK_TYPEWRITER="{Command = Typewriter;Counter=1;Type=0}"
AZDOCK_DICTREADER="{Command = DictionaryReader;Counter=1;Type=0}"
AZDOCK_SYSPREFS="{Command = SystemPreferences;Counter=1;Type=0}"
AZDOCK_FONTMANAGER="{Command = FontManager;Counter=1;Type=0}"
AZDOCK_APPS="($AZDOCK_TYPEWRITER,$AZDOCK_VINDALOO,$AZDOCK_DICTREADER,$AZDOCK_SYSPREFS,$AZDOCK_FONTMANAGER)"

echo "Setting Etoile defaults"

# Set default bundles
defaults write NSGlobalDomain GSAppKitUserBundles "$BUNDLES_LST"

# Set Nesedah as the default theme
defaults write Camaelon Theme "Nesedah"

# Set AZDock defaults
defaults write AZDock DockedApplications "$AZDOCK_APPS"

# Set default font
defaults write NSGlobalDomain NSFont 'DejaVuSans'
defaults write NSGlobalDomain NSBoldFont 'DejaVuSans-Bold'
defaults write NSGlobalDomain NSUserFixedPitchFont 'DejaVuSansMono'
defaults write NSGlobalDomain NSFontSize 10

# misc
defaults write NSGlobalDomain GSSuppressAppIcon YES
defaults write NSGlobalDomain NSUseRunningCopy YES
defaults write NSGlobalDomain GSFileBrowserHideDotFiles YES
defaults write NSGlobalDomain GSWorkspaceApplication "NotExist.app"
defaults write GWorkspace NoWarnOnQuit YES
defaults write GWorkspace no_desktop YES
