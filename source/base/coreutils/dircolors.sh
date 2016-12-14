# Setup colors for 'ls' commands.
if [ "$SHELL" = "/bin/zsh" ]; then
 eval `dircolors -z`
elif [ "$SHELL" = "/bin/ash" ]; then
 eval `dircolors -s`
else
 eval `dircolors -b`
fi
