FROM dbhaddopbase:latest


COPY ./scripts/startup_spark.sh /mnt/scripts/startup_spark.sh
RUN chmod a+x /mnt/scripts/startup_spark.sh

USER hadoop
WORKDIR /home/hadoop

ENTRYPOINT ["/mnt/scripts/startup_spark.sh"]