export J2REDIR=/usr/lib/java/jre
export MANPATH=$MANPATH:$J2REDIR/man
export CLASSPATH=$CLASSPATH:$J2REDIR/lib

# if you put "java=foo" (where foo != j2sdk) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable
[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" = "j2sdk" ]; then
	if [ ! -f /etc/profile.d/j2sdk.sh ]; then
		export JAVA_HOME=$J2REDIR
	fi
	export PATH=$J2REDIR/bin:$PATH
else
	export PATH=$PATH:$J2REDIR/bin
fi
