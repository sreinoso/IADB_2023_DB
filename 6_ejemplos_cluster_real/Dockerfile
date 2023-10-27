FROM dbhaddopbase:latest


COPY ./scripts/startup_hadoop.sh /mnt/scripts/startup_hadoop.sh
RUN chmod a+x /mnt/scripts/startup_hadoop.sh

USER hadoop
WORKDIR /home/hadoop

ENTRYPOINT ["/mnt/scripts/startup_hadoop.sh"]