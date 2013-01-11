if [ -r "$HOME/.inputrc" ]; then
	INPUTRC="$HOME/.inputrc"
else
	INPUTRC="/etc/inputrc"
fi
export INPUTRC
