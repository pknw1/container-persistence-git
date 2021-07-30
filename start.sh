#!/bin/bash

## entrypoint script for container ENTRYPOINT
## need to add more try/catch for operations
## also uses global git config for now - need tp change that!

deregister_runner() {
     cd config
     echo $(date) >> ./shutdowns.txt
     git config --global user.email "configs@pknw1.co.uk"
     git config --global user.name "config"
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

# list of signals from https://www-uxsup.csx.cam.ac.uk/courses/moved.Building/signals.pdf

trap deregister_runner SIGINT SIGQUIT SIGTERM SIGABRT 

while true; do
    sleep 10
done
