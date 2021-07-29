#!/usr/bin/env bash

# 0. Create datetime variable
TIMESTAMP=$(date "+%Y%m%d-%H%M")
# 1. Load .env file
source .env
# 2. Build badgr-server - tagged with latest and datetime
docker build -f ${BADGR_SERVER_PROJECT_LOCATION}/.docker/Dockerfile.prod.api ${BADGR_SERVER_PROJECT_LOCATION} -t badgr-server:${TIMESTAMP} -t badgr-server:latest

# 3. Build alex-badr-server - tagged with latest and datetime
docker build . -t alex-badgr-server:latest -t alex-badgr-server:${TIMESTAMP}

# 4. Build nginx - tagged with latest and datetime
docker build -f ${BADGR_SERVER_PROJECT_LOCATION}/.docker/Dockerfile.nginx ${BADGR_SERVER_PROJECT_LOCATION} -t badgr-nginx:${TIMESTAMP} -t badgr-nginx:latest

# 5. Build badgr-ui  - tagged with latest and datetime
docker build -f ${BADGR_UI_PROJECT_LOCATION}/Dockerfile ${BADGR_UI_PROJECT_LOCATION} -t badgr-ui:${TIMESTAMP} -t badgr-ui:latest
