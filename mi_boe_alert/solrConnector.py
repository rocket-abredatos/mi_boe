#!/usr/bin/python

import sys;
sys.path.append('/usr/local/lib/python2.7/site-packages/')

import sunburnt

class solrConnector:

    def __init__ (self):
	solr_interface = sunburnt.SolrInterface("http://localhost:8100", "schema.xml")	
	r=solr_interface.query("This").execute
	#print r.result

    def querySolr(kws):
    	print "pregunto por " + kws
    	return "resultado Solr"

