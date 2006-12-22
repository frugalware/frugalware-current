export OPENJDKDIR=/usr/lib/java
export MANPATH=$MANPATH:$OPENJDKDIR/man
export CLASSPATH=$CLASSPATH:$OPENJDKDIR/lib

# if you put "java=foo" (where foo != openjdk) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "openjdk" ]; then
	export JAVA_HOME=$OPENJDKDIR
	export PATH=$OPENJDKDIR/bin:$PATH
else
	export PATH=$PATH:$OPENJDKDIR/bin
fi
