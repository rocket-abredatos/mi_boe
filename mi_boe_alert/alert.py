from settings import dbhost,dbuser,dbpass,solrurl,path,mailuser,mailpass
import sys
sys.path.append(path)

import os
import MySQLdb
import commands
import subprocess
import re
import urllib2
import smtplib


arrayFields=['titulo','urlPDF']

def sendmail(result, mail):
    fromaddr = 'miboe.notifications@gmail.com'
    toaddrs  = mail
    msg = result.encode('utf-8')

    username = mailuser
    password = mailpass

    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(username,password)
    server.sendmail(fromaddr, toaddrs, msg)
    server.quit()


def querySolrHttp(kws, date):
        query=solrurl + '"' + kws.replace(" ","+") + '"'  + '+AND+fecha:['+ str(date) +'T00:00:00Z+TO+'+ str(date) +'T00:00:00Z]' + '&version=2.2&start=0&rows=50&indent=on&wt=python&fl=id,titulo,url,urlPDF'
        o= urllib2.urlopen(query)
        r = eval(o.read())
        return r

def getDate():
    date = commands.getoutput("date --rfc-3339=date")
    return date

def createMail(result,kws):
    mensaje=""
    for entry in result['response']['docs']:
	mensaje=mensaje+"\n\nResultado para la alerta \""+kws+"\"\n"
	for field in arrayFields:
            mensaje = mensaje + "\n\t*" + entry[field]
    return mensaje


db=MySQLdb.connect(host=dbhost,user=dbuser,passwd=dbpass,db="abredatos")

users = db.cursor()

users.execute("""SELECT id,email from users""")

user=users.fetchone()

while(user!=None):
    
    c=db.cursor()
    c.execute("""SELECT * from subscriptions WHERE user_id=""" + str(user[0]))

    mail=user[1]
    mensaje=""

    data = c.fetchone()
    flagp=False
    while(data!=None):
    	kws = data[2]
    	date = getDate()
    	result = querySolrHttp(kws, date)
    	if(result['response']['numFound']==0):
            print "ERROR"
    	else:
            mensaje=mensaje + "\n\n########################################\n\n" + createMail(result,kws)
	    flagp=True
        data=c.fetchone()

    if(flagp):
	sendmail(mensaje,mail)

    user=users.fetchone()
