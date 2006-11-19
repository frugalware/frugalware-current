export OPENREDIR=/usr/lib/java/jre
export MANPATH=$MANPATH:$OPENREDIR/man
export CLASSPATH=$CLASSPATH:$OPENREDIR/lib

# if you put "java=foo" (where foo != openjdk) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "openjdk" ]; then
	if [ ! -f /etc/profile.d/openjdk.sh ]; then
        	export JAVA_HOME=$OPENREDIR
	fi
	export PATH=$OPENREDIR/bin:$PATH
else
	export PATH=$PATH:$OPENREDIR/bin
fi
