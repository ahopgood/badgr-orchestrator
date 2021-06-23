FROM badgr-server:latest
WORKDIR /badgr_server
ADD badgr-server-provision.sh .
RUN chmod 755 badgr-server-provision.sh
ENTRYPOINT ["bash", "-c", "/badgr_server/badgr-server-provision.sh"]