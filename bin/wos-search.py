#!/usr/bin/env python

# wos-search.py - given a session id, a NetID, and an author's name, search Web of Science and output NetID, WOS identifier, and DOI

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - based on good work by Lisa Stienbarger and Mark Dehmlow


# configure
NAMESPACES = { 'ns2': 'http://woksearchlite.v3.wokmws.thomsonreuters.com', 'soap': 'http://schemas.xmlsoap.org/soap/envelope/' }
SEARCH     = 'http://search.webofknowledge.com/esti/wokmws/ws/WokSearchLite'

# require
from lxml import etree
import requests as ua
import sys

# sanity check
if len( sys.argv ) < 4 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <sid> <netid> <author>\n" )
	quit()

# get the simple input
sid   = sys.argv[ 1 ]
netid = sys.argv[ 2 ]

# build the author query
author = []
for i in range( 3, len( sys.argv ) ) : author.append( sys.argv[ i ] )
author = " ".join( author )

# initialize
header = { 'Cookie': sid }

# search
query    = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:woksearchlite="http://woksearchlite.v3.wokmws.thomsonreuters.com"><soapenv:Header/><soapenv:Body><woksearchlite:search><queryParameters><databaseId>WOS</databaseId><userQuery>AU=(' + author + ')</userQuery><editions><collection>WOS</collection><edition>SCI</edition></editions><queryLanguage>en</queryLanguage></queryParameters><retrieveParameters><firstRecord>1</firstRecord><count>0</count></retrieveParameters></woksearchlite:search></soapenv:Body></soapenv:Envelope>'
response = ua.post( SEARCH, headers=header, data=query )

results = response.text
sys.stderr.write( "  Query response: " + results )
sys.stderr.write( '\n' )

# extract 
dom = etree.fromstring( results )
queryid      = dom.xpath( '/soap:Envelope/soap:Body/ns2:searchResponse/return/queryId/text()', namespaces=NAMESPACES )[ 0 ]
recordsfound = int( dom.xpath( '/soap:Envelope/soap:Body/ns2:searchResponse/return/recordsFound/text()', namespaces=NAMESPACES )[ 0 ] )

if recordsfound > 0 : 

	soapretrieve  = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:retrieve xmlns:ns2="http://woksearchlite.v3.wokmws.thomsonreuters.com"><queryId>' + queryid + '</queryId><retrieveParameters><firstRecord>1</firstRecord><count>100</count></retrieveParameters></ns2:retrieve></soap:Body></soap:Envelope>'
	queryresponse = ua.post( SEARCH, headers=header, data=soapretrieve)

	results = queryresponse.text
	sys.stderr.write( "  Search response: " + results )
	sys.stderr.write( '\n' )
	
	# parse the xml file into an etree structure
	dom = etree.fromstring( results )

	# process each found record
	for record in dom.xpath( '//records' ) :
	
		# get wosid; it always has a value
		wosid = record.xpath( './uid' )
		wosid = wosid[ 0 ].text
	
		# get doi; it doesn't always have a value
		doi = []
		doi = record.xpath( './other[label/text() = "Identifier.Doi"]/value/text()' )
		if len( doi ) > 0 : doi = doi[ 0 ]
		else :
			doi = record.xpath( './other[label/text() = "Identifier.Xref_Doi"]/value/text()' )
			if len( doi ) > 0 : doi = doi[ 0 ]
			else : doi = ''
	
		# output
		print( '\t'.join( [ netid, wosid, doi ] ) )

# done
exit()


