#!/bin/bash

# Begin settings
# Get the Production API key/secret from https://developer.godaddy.com/keys/.
# Ensure its for Production as first time its created for Test.
key=[my key]
secret=[my secret]

# Domain to update.
domain=[domain with no www]

# Record name, as seen in the DNS setup page, default @.
name=@

headers="Authorization: sso-key $key:$secret"

#echo $headers

result=$(curl -s -X GET -H "$headers" \
 "https://api.godaddy.com/v1/domains/skyslab.info/records/A/$name")

dnsIp=$(echo $result | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#echo "dnsIp:" $dnsIp

# Get public ip address there are several websites that can do this.
ret=$(curl -s GET "http://ipinfo.io/json")
#echo $ret
currentIp=`dig a myip.opendns.com @resolver1.opendns.com +short`
#echo "currentIp:" $currentIp

 if [ "dnsIp" != $currentIp ];
 then
#       echo "Ips are not equal"
        request='[{"data":"'$currentIp'","ttl":3600}]'
#       echo $request
        nresult=$(curl -i -s -X PUT \
 -H "$headers" \
 -H "Content-Type: application/json" \
 -d $request "https://api.godaddy.com/v1/domains/skyslab.info/records/A/$name")
#       echo $nresult
fi
