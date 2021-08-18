## container-persistence-git

launches a pair of containers modelled around the lsio containers and persistence via /config folder so that the container can be pulled and maintain persistence without needing local storage permanently

- config container shares mount with app container
- config container commit's changes on shutdown
- config container pulls changes on startup OR pulls config if missing



### Overview

```

  ┌───────────────────────────────────────────────────────────────┐
  │     ┌────────────────────────────┐         ┌────────────┐     │
  │  ┌──┤►~/.ssh                     │         │CONFIG      │     │
  │  │  │  /config ◄─────────volume moumt──────┤VOLUME      │     │
  │  │  └────────────────────────────┘         │            │     │
  │ ~/.ssh bind                                │            │     │
  │  │  ┌────────────────────────────┐         │config-$app │     │
  │  └──┤► ~/.ssh                    │         │            │     │
  │     │  /config ◄─────────volume mount─────►│            │     │
  │     │  ▲ │                       │         │            │     │
  │     └──┬─┼───────────────────────┘         └────────────┘     │
  └────────┼─┼────────────────────────────────────────────────────┘
  ┌────────┼─┼────────────────────────────────────────────────────┐
  │     ┌──┴─▼───────────────────────┐ startup pull               │
  │     │ config-$app repository     │ shutdown push              │
  │     └────────────────────────────┘                            │
  └───────────────────────────────────────────────────────────────┘

```

### Process Summary

1. Create private config repo on Github
2. update source for ~/.ssh 
3. docker-compose up -v
4. app-container depends_on config start
5. config-$app> config-$app/start.sh	
   config-$app> check if mount /config/.git exists
		* NO  : git clone repo config-$app /config
		* YES : git pull config from repo
   config-$app> wait and and check for TRAP SIGNAL
		* NO  : sleep 10 secs
		* YES : git add amd commit /config/*
6.	$app container starts without modifying Dockerfile



* on a new system, the volume will be created and populated with the current config 
* on an existing system, due to the VOLUME remaining after shutdown, it just re-mounts
* app startup waits on ` depends_on ` to wait for the sync to complete
* app shutdown waits fpr the config container to update git


### UPDATES

- ENV variables for repo base URL, git config details, mount point for volume added
- startup checks to ensure container shows as starting while cloning or pulling config
- set shutdown timer to 5 mins so config has time to sync
- removed Version=3 from docker-compose.yml for compatability with healthcheck conditons 
 

# TODO

* minimise layers on config
* change to abc user for runtime
* create repo if missing
* encFS fuse mount for data to encrypt
* refine docker-compose 
* refine terraform

##### notes

- yes first version is crap-ish; this is a work in progress
- this container mirrors previous incarnations using rclone and will merge for a configurable backend storage location
- LXC version for proxmox once all the bugs are ironed out
- still? send me some suggestions 
