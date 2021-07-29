FROM badgr-server:latest
WORKDIR /badgr_server
COPY badgr-server-provision.sh /badgr_server/
RUN chmod 755 badgr-server-provision.sh
COPY settings_local.prod.py /badgr_server/apps/mainsite/settings_local.py
ENTRYPOINT ["/bin/bash", "/badgr_server/badgr-server-provision.sh"]