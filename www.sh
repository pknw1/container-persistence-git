#!/bin/bash

if [ "$#" -eq "0" ]
then
	read -p 'Enter Repo: ' repo
else
	repo="${1}"
fi
if [ "$repo" = "" ]
then
	repo=$(date +%s)
fi


if [ -d /www/${repo}/.git ]
then
        cd ${repo}
        git pull
	cd ..
else
	git clone git@gitlab.com:www-content/pknw1.gitlab.io.git /www/${repo}
fi

exit 0
