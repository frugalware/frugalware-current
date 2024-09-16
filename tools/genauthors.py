from xml.dom import minidom
import sys, codecs

def sort_authors(a):
	return a.getElementsByTagName("name")[0].firstChild.toxml()

xmldoc = minidom.parse(sys.argv[1])
out = codecs.open(sys.argv[2], "w", "utf-8")
authors = []
for i in xmldoc.getElementsByTagName('author'):
	authors.append(i)
authors.sort(key=sort_authors)
for i in authors:
	if str("active") == i.getElementsByTagName("status")[0].firstChild.toxml():
		out.write("%s " % i.getElementsByTagName("name")[0].firstChild.toxml())
		out.write("(%s) " % i.getElementsByTagName("nick")[0].firstChild.toxml())
		out.write("<%s>\n" % i.getElementsByTagName("email")[0].firstChild.toxml())
		for j in i.getElementsByTagName("role"):
			out.write("\t* %s\n" % j.firstChild.toxml())
