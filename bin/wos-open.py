#!/usr/bin/env python

# wos-open.py - return a Web of Science session id

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - based on good work by Lisa Stienbarger and Mark Dehmlow


# configure
ENVELOPE     = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:auth="http://auth.cxf.wokmws.thomsonreuters.com"><soapenv:Header/><soapenv:Body><auth:authenticate/></soapenv:Body></soapenv:Envelope>'
AUTHENTICATE = 'http://search.webofknowledge.com/esti/wokmws/ws/WOKMWSAuthenticate'
USERNAME     = 'NotreDame_HG'

# require
import base64
import requests as ua
import sys

# sanity check
if len( sys.argv ) !=2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <password>\n" )
	quit()

# stored username and password
authstring = USERNAME + ':' + sys.argv[ 1 ]

# encode authstring in base64, need to send as bytes, not character
encoded_authstring = base64.b64encode( bytes( authstring, 'utf-8') )

# HTTP HEADER -- decoded authstring
header = { 'Authorization':'Basic ' + encoded_authstring.decode('utf-8'), 'SOAPAction':'', 'content-type':'text/xml;charset=UTF-8' }

# authenticate
authenticationresponse = ua.post( AUTHENTICATE, headers=header, data=ENVELOPE )
sys.stdout.write( authenticationresponse.text )
sys.stdout.write( '\n' )

# get the session identifier
sid  = authenticationresponse.headers.get( 'Set-Cookie' )
sys.stdout.write( sid )
sys.stdout.write( '\n' )
exit()




