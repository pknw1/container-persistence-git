#!/bin/bash

if [ "$#" -eq "0" ]
then
	read -p 'Enter Container Label: ' label
else
	label="${1}"
fi
if [ "$label" = "" ]
then
	label=$(date +%s)
fi

docker build -t pknw1/config:${label} .
docker push pknw1/config:${label}
docker tag pknw1/config:${label} pknw1/config:latest
docker push pknw1/config:latest

exit 0
