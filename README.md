# badgr-orchestrator
An example to orchestrate badgr ui, badgr api and dependencies

Required projects
* [badgr-ui](https://github.com/ahopgood/badgr-ui) (forked to provide a dockerised version)
* [badgr-server](https://github.com/concentricsky/badgr-server.git) (official - for now)

## Building Images
### Badgr UI
* Navigate to the root of the `badgr-ui` project
* To build the server image run:
    * `docker build . -t badgr-ui:$(date "+%Y%m%d-%H%M")`
    * `docker build . -t badgr-ui:latest`
### Badgr Server
* Navigate to the root of the `badgr-server` project
* To build the server image run:
    * `docker build -f .docker/Dockerfile.prod.api . -t badgr-server:$(date "+%Y%m%d-%H%M")`
    * `docker build -f .docker/Dockerfile.prod.api . -t badgr-server:latest`  
* To build the nginx server image run:
    * `docker build -f .docker/Dockerfile.nginx . -t badgr-nginx:$(date "+%Y%m%d-%H%M")`  
    * `docker build -f .docker/Dockerfile.nginx . -t badgr-nginx:latest`
* For **each image** this provides you with a specific timestamped version and a "latest" version.    
* The docker compose file will use the `latest` version by default.

## Setting up the `.env` file
* `BADGR_SERVER_PROJECT_LOCATION` is the location of your [badgr-server](https://github.com/concentricsky/badgr-server.git) project
    * This is used to build the badgr server docker images
    * This is required by the `build.sh` script
* `BADGR_UI_PROJECT_LOCATION` is the location of your [badgr-ui](https://github.com/ahopgood/badgr-ui) project
    * This is used to build the badgr ui docker images
    * This is required by the `build.sh` script
    
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
    * Perhaps try a shared volume container pattern?
        * Might be difficult due to how much is used by nginx:
            * `/badgr_server/mediafiles`
            * `/badgr_server/staticfiles`
            * `/badgr_server/app.sock`
* **badgr-ui**
    * ~~Add to the docker-compose file~~
    * ~~Add docker build steps to readme section~~
    * ~~Add docker build to the helper script~~
    * Verify port mapping is possible from any external port to internal port 4200
    * Make port a variable in the docker file so there is a single source of truth
    * Try to get the docker network dns to resolve to `badgr-server` for the API_BASE_URL environment variable.
* **Badgr-Server**
    * Externalise properties as environment variables
        * db name
        * db username
        * db password
    * ~~Can we pre-run the badger server commands as part of the `command` block?~~
        * No but we can bundle them into a bash script
