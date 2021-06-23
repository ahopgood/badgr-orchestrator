# badgr-orchestrator
An example to orchestrate badgr ui, badgr api and dependencies

Required projects
* [badgr-ui](https://github.com/ahopgood/badgr-ui) (forked to provide a dockerised version)
* [badgr-server](https://github.com/concentricsky/badgr-server.git) (official - for now)

## Building Images
### Badgr UI
### Badgr Server
* Navigate to the root of the `badgr-server` project
* To build the server image run:
    * `docker build -f .docker/Dockerfile.prod.api . -t badgr-server:$(date "+%Y%m%d-%H%M")`
    * `docker build -f .docker/Dockerfile.prod.api . -t badgr-server:latest`  
* To build the nginx server image run:
    * `docker build -f .docker/Dockerfile.nginx . -t badgr-nginx:$(date "+%Y%m%d-%H%M")`  
    * `docker build -f .docker/Dockerfile.nginx . -t badgr-nginx:latest`
* For **each image** this provides you with a specific timestamped version and a latest version.    
* The docker compose file will use the `latest` version by default.

## Setting up the `.env` file

## Running the stack
```
docker-compose up -d
```
### Badgr Server
If using the original `badgr-server` image you will need to run the following commands to get the service up and running:
```
docker-compose -f docker-compose.yml exec api python /badgr_server/manage.py migrate
docker-compose -f docker-compose.yml exec api python /badgr_server/manage.py dist
docker-compose -f docker-compose.yml exec api python /badgr_server/manage.py collectstatic
```
If you use the `Dockerfile` in this project you can ignore the above commands.

## TO-DO
* Move credentials for MySQL into an `.env` file
* Test running with a newer version of MySQL `5.7.x`
* Is memcached needed?
* ~~Remove need for the `init.sql` file - set the database name via environmental variables.~~
* ~~Add relative location for the `init.sql` based on a value in the `.env` file.~~ redundant due to above.
* Bundle `docker build` commands into a single helper script
    * Source variables from the `.env` file for project locations
    * Turn the `date` call into a single variable to ensure **all** generated images are tagged with the same date and time
* As all services are on the same user specified network I'm not convinced they need to expose ports? 
* Explore making only the badgr server `app.sock ` file a single file volume we can share with nginx instead of the entirety of the server's application directory
    * Seems this isn't possible with [named volumes](https://github.com/moby/moby/issues/38851)

### Badgr-Server TO-DO
* Externalise properties as environment variables
    * db name
    * db username
    * db password
* ~~Can we pre-run the badger server commands as part of the `command` block?~~
    * No but we can bundle them into a bash script
