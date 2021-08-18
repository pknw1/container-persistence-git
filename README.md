# container-persistence-git

launches a pair of containers modelled around the lsio containers and persistence via /config folder so that the container can be pulled and maintain persistence without needing local storage permanently


- config container shares mount with app container
- config container commit's changes on shutdown
- config container pulls changes on startup OR pulls config if missing

# UPDATES

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
