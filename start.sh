#!/bin/bash

deregister_runner() {
	echo $(pwd)
echo shutdiwn
     echo $(date) >> config/updates.txt
     cd config
     git config --global user.email "you@example.com"
     git config --global user.name "Your Name"
     git add .
     git commit -m "$(date)"
     git push
    exit
}


if [ -d /config/.git ]
then
	cd config
	git pull
	cd ..
else
	git clone git@github.com:pknw1/${REPO}.git /config
fi

trap deregister_runner SIGINT SIGQUIT SIGTERM

while true; do
	echo $REPO
    sleep 10
done
