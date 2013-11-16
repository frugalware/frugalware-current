export OPENJREDIR=/usr/lib/jvm/java-7-openjdk/jre
export MANPATH=$MANPATH:$OPENJREDIR/man
export CLASSPATH=$CLASSPATH:$OPENJREDIR/lib

# if you put "java=foo" (where foo != openjdk) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "openjdk" ]; then
	if [ ! -f /etc/profile.d/openjdk.sh ]; then
        	export JAVA_HOME=$OPENJREDIR
	fi
	export PATH=$OPENJREDIR/bin:$PATH
else
	export PATH=$PATH:$OPENJREDIR/bin
fi
