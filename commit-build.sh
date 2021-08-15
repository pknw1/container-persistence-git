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

git add . && git commit -m "${label}" && git push 
exec ./build.sh $label

exit 0
