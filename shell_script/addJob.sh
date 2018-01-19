#!/bin/sh

#############################################################################
# Licensed Materials - Property of HCL*
# (C) Copyright HCL Technologies Ltd. 2017, 2018 All rights reserved.
# * Trademark of HCL Technologies Limited
#############################################################################

if [  $# -ne 6 ] 
then 
	echo 'Usage: '$0' <tws_host> <tws_user> <password> <job_name> <workstation_name> <task_string>'
	exit 1
fi

TWS_HOST=$1
TWS_USER=$2
PASSWORD=$3
JOB_NAME=$4
WORKSTATION_NAME=$5
TASK_STRING=$6

echo `curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"header": {"jobDefinitionKey": {"name": "'$JOB_NAME'","workstationName":"'$WORKSTATION_NAME'"},"description": "Added by REST API.","taskType": "UNIX","userLogin": "'$TWS_USER'"},"taskString": "'"$TASK_STRING"'","recoveryOption": "STOP"}' 'https://'$TWS_HOST':31116/twsd/model/jobdefinition'  --insecure -u $TWS_USER:$PASSWORD`
