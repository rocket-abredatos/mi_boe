import sys
sys.path.append('/home/opendata/alertSystem/install/MySQL-python-1.2.3/build/lib.linux-x86_64-2.7/')

import os
import MySQLdb
import commands
import subprocess
import re
import urllib2

mailFields={'titulo':1}

def sendmail(result, mail):
    print "sending " + result + " a la dir " + mail
    os.system('python mailSender.py '+ mail + '\'' + result.encode('utf-8') + '\'')


def querySolrHttp(kws, date):
        date='2011-05-05'
        query='http://188.40.66.148:8090/solr/select/?q=' + kws + '+AND+fecha:['+ date +'T00:00:00Z+TO+'+ date +'T00:00:00Z]' + '&version=2.2&start=0&rows=2&indent=on&wt=python&fl=id,titulo'
        print query
        o= urllib2.urlopen(query)
        r = eval(o.read())
        return r

def getDate():
    date = commands.getoutput("date --rfc-3339=date")
    print date
    return date

def createMail(result):
    mensaje=""
    for entry in result['response']['docs']:
	mensaje=mensaje+"\nRESULTADO"
	for field in entry:
	    if(field in mailFields):
	        print "FIELD"
	        print field
	        mensaje = mensaje + "\n\t*" + entry[field] 
	    else:
		print "DESCARTO"
		print field
		if(field==id):
		    id=entry[field]
		    if(result['highlighting'][id]!=None):
			hl = result['highlighting'][id]
			mensaje=mensaje + "\n\t*" + hl
    print "mensaje"
    print mensaje
    return mensaje


db=MySQLdb.connect(host="localhost",user="miboe",passwd="miboe10pp",db="miboe")

c=db.cursor()
c.execute("""SELECT * from alertas""")

data = c.fetchone()

while(data!=None):
    kws = data[1]
    mail = data[2]
    date = getDate()
    result = querySolrHttp(kws, date)
    if(result['response']['numFound']==0):
	print "ERROR"
    else:
	mensaje=createMail(result)
        for field in result:
	    print field
	sendmail(mensaje,mail)
    data=c.fetchone()
