#!/bin/sh

#############################################################################
# Licensed Materials - Property of HCL*
# (C) Copyright HCL Technologies Ltd. 2017, 2018 All rights reserved.
# * Trademark of HCL Technologies Limited
#############################################################################

if [  $# -ne 6 ]
then
        echo 'Usage: '$0' <tws_host> <tws_user> <password> <job_name> <workstation_name> <job_stream_id>'
        exit 1
fi

TWS_HOST=$1
TWS_USER=$2
PASSWORD=$3
JOB_NAME=$4
WORKSTATION_NAME=$5
JS_ID=$6

echo `curl -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{}' 'https://'$TWS_HOST':31116/twsd/plan/current/job/'$WORKSTATION_NAME'%3B'$JS_ID'%3B'$JOB_NAME'/action/rerun'  --insecure -u $TWS_USER:$PASSWORD`
