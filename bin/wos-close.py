#!/usr/bin/env python

# wos-close.py - given a Web of Science session identifier, close a session

# Eric Lease Morgan <emorgan@nd.edu>
# January 11, 2019 - based on good work by Lisa Stienbarger and Mark Dehmlow


# configure
ENVELOPE     = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:auth="http://auth.cxf.wokmws.thomsonreuters.com"><soapenv:Header/><soapenv:Body><auth:closeSession/></soapenv:Body></soapenv:Envelope>'
AUTHENTICATE = 'http://search.webofknowledge.com/esti/wokmws/ws/WOKMWSAuthenticate'

# require
import requests as ua
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <sid>\n" )
	exit()
	
# get input
sid = sys.argv[ 1 ]

# initialize
header = { 'Cookie': sid }

# close & done
closeresponse = ua.post( AUTHENTICATE, headers=header, data=ENVELOPE )
sys.stderr.write( closeresponse.text )
sys.stderr.write( '\n' )
exit()




