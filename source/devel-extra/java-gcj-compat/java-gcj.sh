# by default if both java-gcj-compat and j2re installed, the previous is the
# preferred one. if you put "java=foo" (where foo != gcj) to /etc/sysconfig/java,
# then this script won't touch the JAVA_HOME variable

[ -e /etc/sysconfig/java ] && source /etc/sysconfig/java
if [ -z "$java" -o "$java" == "gcj" ]; then
	export JAVA_HOME=/usr
fi
