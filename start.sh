#!/bin/bash

## entrypoint script for container ENTRYPOINT
## need to add more try/catch for operations
## also uses global git config for now - need tp change that!

echo "$(date) config-startup">> /tmp/${REPO}-running

deregister_runner() {
     cd /config
     echo $(date) >> ./shutdowns.txt
     if [ -f /config/.git/index.lock ]
     then
	     rm -f /config/.git/index.lock
     fi
     git config --global user.email "configs@pknw1.co.uk"
     git config --global user.name "config"
     git add . -v && echo files added || echo fail
     git commit -m "$(date)" -v || echo fail
     git push -v  || echo fail
    exit
}


if [ -d /config/.git ]
then
	touch /tmp/${REPO}
	cd /config
	git pull -v && rm /tmp/${REPO} 
	cd ..
else
	touch /tmp/${REPO}
	rm -rf /config/*
	git clone git@gitlab.com:pknw1-servers/ks2.pknw1.co.uk/container-configs/${REPO}.git /config && rm /tmp/${REPO}
fi

cd /config && chown -R 666:666 *

# list of signals from https://www-uxsup.csx.cam.ac.uk/courses/moved.Building/signals.pdf

trap deregister_runner SIGINT SIGQUIT SIGKILL SIGSTOP SIGTERM SIGABRT 

while true; do
    sleep 10
done
