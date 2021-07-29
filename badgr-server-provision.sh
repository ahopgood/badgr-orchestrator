#!/usr/bin/env bash
set -m

# Run uwsgi in background so we can run other commands
uwsgi --ini /badgr_server/uwsgi.ini &
# Wait for database to become available, this is a shitty hack for now
sleep 10
python /badgr_server/manage.py migrate
python /badgr_server/manage.py dist
python /badgr_server/manage.py collectstatic --noinput

# Bring uwsgi back to the foreground so the container doesn't grind to a halt
fg 1
