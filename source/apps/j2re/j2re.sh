export J2REDIR=/usr/lib/java/jre
export PATH=$PATH:$J2REDIR/bin
export MANPATH=$MANPATH:$J2REDIR/man
export CLASSPATH=$CLASSPATH:$J2REDIR/lib
if [ ! -f /etc/profile.d/j2sdk.sh ]; then
        export JAVA_HOME=$J2REDIR
fi
