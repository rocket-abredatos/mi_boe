
import sys
sys.path.append('/home/opendata/alertSystem/install/MySQL-python-1.2.3/build/lib.linux-x86_64-2.7/')
sys.path.append('./')

import MySQLdb
from solrConnector import solrConnector


def sendmail(result, mail):
    print "sending " + result + " a la dir " + mail

def querySolr(kws):
    print "pregunto por " + kws
    return "resultado Solr"

db=MySQLdb.connect(host="localhost",user="miboe",passwd="miboe10pp",db="miboe")

db.query("""SELECT * from alertas""")

r=db.store_result()

data = r.fetch_row()

for entry in data:
    kws = entry[1]
    mail = entry[2]
    result = querySolr(kws)
    sendmail(result,mail)

solr=solrConnector()
