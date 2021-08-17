#!/bin/bash

## entrypoint script for container ENTRYPOINT
## need to add more try/catch for operations
## also uses global git config for now - need tp change that!

echo "$(date) config-startup">> /tmp/config-plex-running

deregister_runner() {
	echo "$(date) config-startup">> /tmp/config-plex-running
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
     mv /tmp/config-plex-running /tmp/config-plex-$(date +%s)
    exit
}




if [ -d /config/.git ]
then
	"$(date) config-pull">> /tmp/config-plex
	cd /config
	git pull -v 
	cd ..
	cat /tmp/config-plex >> /tmp/config-plex-logs && rm -f /tmp/config-plex
else
	echo "$(date) config-clone-repo">> /tmp/config-plex
	#git clone git@github.com:pknw1/${REPO}.git /config
	rm -rf /config/*
	git clone git@gitlab.com:pknw1-servers/ks2.pknw1.co.uk/container-configs/${REPO}.git /config
	cat /tmp/config-plex >> /tmp/config-plex-logs && rm -f /tmp/config-plex
fi

cd /config && chown -R 666:666 *

# list of signals from https://www-uxsup.csx.cam.ac.uk/courses/moved.Building/signals.pdf

trap deregister_runner SIGINT SIGQUIT SIGKILL SIGSTOP SIGTERM SIGABRT 

while true; do
    sleep 10
done
