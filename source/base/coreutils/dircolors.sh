# Setup colors for 'ls' commands.
if [ "$SHELL" = "/bin/zsh" ]; then
 eval `dircolors -b`
elif [ "$SHELL" = "/bin/ash" ]; then
 eval `dircolors -c`
else
 eval `dircolors -b`
fi
