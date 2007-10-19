from xml.dom import minidom
import sys, codecs

def sort_authors(a, b):
	return cmp(a.getElementsByTagName("name")[0].firstChild.toxml(), b.getElementsByTagName("name")[0].firstChild.toxml())

xmldoc = minidom.parse(sys.argv[1])
out = codecs.open(sys.argv[2], "w", "utf-8")
authors = []
for i in xmldoc.getElementsByTagName('author'):
	authors.append(i)
authors.sort(sort_authors)
for i in authors:
	if unicode("active") == i.getElementsByTagName("status")[0].firstChild.toxml():
		out.write("%s " % i.getElementsByTagName("name")[0].firstChild.toxml())
		out.write("(%s) " % i.getElementsByTagName("nick")[0].firstChild.toxml())
		out.write("<%s>\n" % i.getElementsByTagName("email")[0].firstChild.toxml())
		for j in i.getElementsByTagName("role"):
			out.write("\t* %s\n" % j.firstChild.toxml())
