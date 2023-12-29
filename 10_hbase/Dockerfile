FROM dbhaddopbase:latest


COPY ./scripts/startup_hbase.sh /mnt/scripts/startup_hbase.sh
RUN chmod a+x /mnt/scripts/startup_hbase.sh

USER hadoop
WORKDIR /home/hadoop

ENTRYPOINT ["/mnt/scripts/startup_hbase.sh"]