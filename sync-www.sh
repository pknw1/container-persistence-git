#!/bin/bash

if [ "$#" -eq "0" ]
then
	read -p 'Enter Repo: ' "repo"
else
	repo="${1}"
fi
if [ "$repo" = "" ]
then
	repo=$(date +%s)
fi


if [ -d /www/${repo}/.git ]
then
        cd /www/${repo}
        git pull
	cd ..
else
	git clone git@gitlab.com:www-content/${repo}.git /www/${repo}
fi

exit 0
