export JDK7DIR=/usr/lib/java
export MANPATH=$MANPATH:$JDK7DIR/man
export CLASSPATH=$CLASSPATH:$JDK7DIR/lib

# if you put "java=foo" (where foo != jdk7) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "jdk7" ]; then
	export JAVA_HOME=$JDK7DIR
	export PATH=$JDK7DIR/bin:$PATH
else
	export PATH=$PATH:$JDK7DIR/bin
fi
