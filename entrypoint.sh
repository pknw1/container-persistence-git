#!/bin/bash

echo "$(date) config-startup">> /tmp/${REPO}-running


## STARTUP CHECKS
# CONFIG target for the files to sync
# USER & EMAIL for git

if [ -z ${CONFIG} ]; then CONFIG="/config"; fi
if ! [[ "${CONFIG:0:1}" = '/' ]]; then CONFIG="/${CONFIG}"; fi
if [ -z ${EMAIL} ]; then EMAIL="configs@pkw1.co.uk"; fi
if [ -z ${BASE} ]; then BASE="git@gitlab.com:pknw1-servers/ks2.pknw1.co.uk/container-configs"; fi


echo "${BASE}"
exit
deregister_runner() {
     cd "${CONFIG}"
     echo $(date) >> ./shutdowns.txt
     if [ -f "${CONFIG}"/.git/index.lock ]
     then
	     rm -f "${CONFIG}"/.git/index.lock
     fi
     git config --global user.email "${EMAIL}"
     git config --global user.name "config"
     git add . -v && echo files added 
     git commit -m "$(date)" -v || echo "COMMIT FAILED"
     git push -v  || echo "PUSH FAILED"
    exit
}


if [ -d "${CONFIG}/.git" ]
then
	touch /tmp/${REPO}
	cd "${CONFIG}"
	git pull -v && rm /tmp/${REPO} 
	cd ..
else
	touch /tmp/${REPO}
	rm -rf "${CONFIG}"/*
	git clone "${BASE}/${REPO}.git" "${CONFIG}" && rm /tmp/${REPO}
fi

cd "${CONFIG}" && chown -R ${PUID}:${PGID} *

# list of signals from https://www-uxsup.csx.cam.ac.uk/courses/moved.Building/signals.pdf

trap deregister_runner SIGINT SIGQUIT SIGKILL SIGSTOP SIGTERM SIGABRT 

while true; do
    sleep 10
done
