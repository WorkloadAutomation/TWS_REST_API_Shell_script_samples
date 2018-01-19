#!/bin/sh

#############################################################################
# Licensed Materials - Property of HCL*
# (C) Copyright HCL Technologies Ltd. 2017, 2018 All rights reserved.
# * Trademark of HCL Technologies Limited
#############################################################################

if [  $# -lt 5 ] || [  $# -gt 6 ]
then
        echo 'Usage: '$0' <tws_host> <tws_user> <password> <js_name> <workstation_name> [<js_alias>]'
        exit 1
fi

TWS_HOST=$1
TWS_USER=$2
PASSWORD=$3
JOBSTREAM_NAME=$4
WORKSTATION_NAME=$5
JS_ALIAS=
if [ ! -z "$6" ]
  then
    JS_ALIAS=', "alias":"'$6'"'
fi

FIRST=`curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'How-Many: 1' -d '{"filters": { "jobstreamFilter": { "jobStreamName":"'$JOBSTREAM_NAME'","workstationName": "'$WORKSTATION_NAME'"}}}' https://$TWS_HOST:31116/twsd/model/jobstream/header/query --insecure -u $TWS_USER:$PASSWORD`

ID=$(echo $FIRST | cut -d'"' -f4)
NOW=$(date --utc +%FT%T.%3NZ)

echo `curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"inputArrivalTime": "'$NOW'" '"$JS_ALIAS"'}' 'https://'$TWS_HOST':31116/twsd/plan/current/jobstream/'$ID'/action/submit_jobstream' --insecure -u $TWS_USER:$PASSWORD`
