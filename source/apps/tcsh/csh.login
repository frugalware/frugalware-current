# /etc/csh.login: This file contains login defaults used by csh and tcsh.

# Set up some environment variables:
if ($?prompt) then
	umask 022
	set cdpath = ( /var/spool )
	set notify
	set history = 100
        setenv MANPATH /usr/local/man:/usr/man:/usr/X11R6/man
	setenv MINICOM "-c on"
	setenv HOSTNAME "`cat /etc/HOSTNAME`"
	setenv LESS "-M"
	setenv LESSOPEN "|lesspipe.sh %s"
	set path = ( $path /usr/X11R6/bin /usr/games )
endif

# If the user doesn't have a .inputrc, use the one in /etc.
if (! -r "$HOME/.inputrc") then
	setenv INPUTRC /etc/inputrc
endif

# I had problems with the backspace key installed by 'tset', but you might want
# to try it anyway, instead to the 'setenv term.....' below it.
# eval `tset -sQ "$term"`
# setenv term linux
# if ! $?TERM setenv TERM linux
# Set to "linux" for unknown term type:
if ("$TERM" == "") setenv TERM linux
if ("$TERM" == "unknown") setenv TERM linux

# Set default POSIX locale:
setenv LC_ALL POSIX

# Set the default shell prompt:
set prompt = "%n@%m:%~%# "

# Set up the LS_COLORS environment variable for color ls output:
eval `dircolors -t`

# Notify user of incoming mail.  This can be overridden in the user's
# local startup file (~/.login)
biff y

# Append any additional csh scripts found in /etc/profile.d/:
if ( -d /etc/profile.d ) then
        set nonomatch
        foreach file ( /etc/profile.d/*.csh )
                if ( -r $file ) then
                        source $file
                endif
        end
        unset file nonomatch
endif

# For non-root users, add the current directory to the search path:
if (! "$uid" == "0") set path = ( $path . )

