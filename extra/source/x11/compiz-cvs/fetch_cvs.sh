_cvsroot=":pserver:anonymous:@anoncvs.freedesktop.org:/cvs/xorg"
_cvsmod="app/compiz"
cvs -z3 -d $_cvsroot co -f $_cvsmod
mv app/compiz compiz-cvs-`date +%Y%m%d`
rm -rf app
#tar -c compiz-cvs-`date +%Y%m%d` > compiz-cvs-`date +%Y%m%d`.tar
#bzip2 compiz-cvs-`date +%Y%m%d`.tar
