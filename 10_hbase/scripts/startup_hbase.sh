#!/bin/bash

export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export PATH=$PATH:$HADOOP_HOME/hbase/bin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/


wget https://dlcdn.apache.org/hbase/2.5.6/hbase-2.5.6-bin.tar.gz

tar -xzvf hbase-2.5.6-bin.tar.gz

mv hbase-2.5.6 /opt/hadoop/hbase
cp /mnt/config/hbase.site.xml /opt/hadoop/hbase/conf/hbase-site.xml

tail -f /dev/null


put 'empleados','1','personal:nombre','Sergio'
put 'empleados','1','personal:apellidos','Perez Rodriguez'
put 'empleados','1','trabajo:cargo','jefe'

put 'empleados','2','trabajo:salario','5000'