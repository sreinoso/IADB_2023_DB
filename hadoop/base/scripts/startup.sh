#!/bin/bash

/etc/init.d/ssh start

export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/

chown -R hadoop:hadoop /home/hadoop/
chown -R hadoop:hadoop /data
chown -R hadoop:hadoop /opt/hadoop

tail -f /dev/null