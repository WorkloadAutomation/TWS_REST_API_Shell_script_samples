#!/bin/sh

#############################################################################
# Licensed Materials - Property of HCL*
# (C) Copyright HCL Technologies Ltd. 2017, 2018 All rights reserved.
# * Trademark of HCL Technologies Limited
#############################################################################

if [  $# -lt 7 ] || [  $# -gt 8 ]
then
        echo 'Usage: '$0' <tws_host> <tws_user> <password> <job_name> <job_alias> <job_workstation_name> <job_stream_id> [<js_workstation_name>]'
        exit 1
fi

TWS_HOST=$1
TWS_USER=$2
PASSWORD=$3
JOB_NAME=$4
JOB_ALIAS=$5
JOB_WORKSTATION_NAME=$6
JS_ID=$7
JS_WORKSTATION_NAME=$6
echo $8
if [ ! -z "$8" ]
  then
    JS_WORKSTATION_NAME=$8
fi

FIRST=$(curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'How-Many: 1' -d '{ "filters": {"jobDefinitionFilter":{"jobDefinitionName": "'$JOB_NAME'","workstationName": "'$JOB_WORKSTATION_NAME'"}}}' 'https://'$TWS_HOST':31116/twsd/model/jobdefinition/header/query' --insecure -u $TWS_USER:$PASSWORD)

ID=`echo "$FIRST" | cut -d'"' -f4`
if [ -z "$ID" ]
   then
     echo "job not found"
     exit 1
fi

NOW=$(date --utc +%FT%T.%3NZ)

SECOND=`curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"jobDefinitionId": "'$ID'", "alias": "'$JOB_ALIAS'"}' 'https://'$TWS_HOST':31116/twsd/plan/current/jobstream/'$JS_WORKSTATION_NAME'%3B'$JS_ID'/action/submit_job' --insecure -u $TWS_USER:$PASSWORD`

if [[ "$SECOND" == *"exceptionName"* ]]
   then
     echo $SECOND
     exit 1
fi

echo `curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"job": '"$SECOND"'}' 'https://'$TWS_HOST':31116/twsd/plan/current/job/action/submit_ad_hoc_job'  --insecure -u $TWS_USER:$PASSWORD`
