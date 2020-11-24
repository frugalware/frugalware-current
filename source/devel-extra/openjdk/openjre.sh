export OPENJREDIR=/usr/lib/jvm/java-15-openjdk/
export MANPATH=$MANPATH:$OPENJREDIR/man
export CLASSPATH=$CLASSPATH:$OPENJREDIR/lib

if [ ! -f /etc/profile.d/openjdk.sh ]; then
	export JAVA_HOME=$OPENJREDIR
fi

export PATH=$OPENJREDIR/bin:$PATH
