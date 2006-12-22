export J2SDKDIR=/usr/lib/java
export MANPATH=$MANPATH:$J2SDKDIR/man
export CLASSPATH=$CLASSPATH:$J2SDKDIR/lib

# if you put "java=foo" (where foo != j2sdk) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "j2sdk" ]; then
	export JAVA_HOME=$J2SDKDIR
	export PATH=$J2SDKDIR/bin:$PATH
else
	export PATH=$PATH:$J2SDKDIR/bin
fi
