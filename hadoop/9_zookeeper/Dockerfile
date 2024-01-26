FROM dbhaddopbase:latest


COPY ./scripts/startup_zookeeper.sh /mnt/scripts/startup_zookeeper.sh
RUN chmod a+x /mnt/scripts/startup_zookeeper.sh

USER hadoop
WORKDIR /home/hadoop

ENTRYPOINT ["/mnt/scripts/startup_zookeeper.sh"]