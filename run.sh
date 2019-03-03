#!/bin/bash

## SETTINGS ##
api_free_mobile_user='XXXXXXXXX'
api_free_mobile_pass='XXXXXXXXXXXX'
api_free_mobile_number='' #Optional

message=$'Alarm \nIntrusion detected \nDatetime : __datetime__\nCamera : __instanceName__\nImage : __pathToImage__'

path_to_image_directory='/data/'
https_enabled=false
port=80
## DO NOT MODIFY FOLLOWING LINES ##

# Get JSON Payload
JSON=$1

# We use Python to parse the JSON Object
timestamp=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['timestamp']")
microseconds=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['microseconds']")
token=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['token']")
instanceName=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['instanceName']")
regionCoordinates=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['regionCoordinates']")
numberOfChanges=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['numberOfChanges']")
pathToImage=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['pathToImage']")

# Format timestamp
datetime=`date -d @$timestamp`

# Generate image URL
prefix='https'
if [ "$https_enabled" = false ];
then prefix='http';
fi
IP=`curl https://ipinfo.io/ip`
pathToImage="$prefix://$IP:$port$path_to_image_directory$pathToImage"

# Template the message
message="${message/__datetime__/$datetime}"
message="${message/__timestamp__/$timestamp}"
message="${message/__microseconds__/$microseconds}"
message="${message/__token__/$token}"
message="${message/__instanceName__/$instanceName}"
message="${message/__regionCoordinates__/$regionCoordinates}"
message="${message/__numberOfChanges__/$numberOfChanges}"
message="${message/__pathToImage__/$pathToImage}"

# Send request to Free server
message_encoded=$(python -c "import urllib; print urllib.quote('''$message''')")
url="https://smsapi.free-mobile.fr/sendmsg?user=$api_free_mobile_user&pass=$api_free_mobile_pass&msg=$message_encoded"
status_code=$(curl --write-out %{http_code} --silent --output /dev/null $url)

# Check the status code of the response
if [ $status_code = 200 ] ; then
  echo "Message successfully sent to $api_free_mobile_number"
else
  echo "Error while sending message to $api_free_mobile_number"
fi
