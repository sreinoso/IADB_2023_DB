#!/bin/bash

export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export PATH=$PATH:$HADOOP_HOME/hbase/bin
export PATH=$PATH:$HADOOP_HOME/spark/bin:$HADOOP_HOME/spark/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
export SPARK_DIST_CLASSPATH=$(hadoop classpath)

export SPARK_HOME=$HADOOP_HOME/spark
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

cp /mnt/config/.bashrc /home/hadoop/.bashrc

sudo /etc/init.d/ssh start
ssh-keygen -q -f ~/.ssh/id_rsa -N "" && cat ~/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys

sudo apt-get update
sudo apt-get install python3 -y # Ojo! Python debe ser 3.10 https://bgasparotto.com/install-pyenv-ubuntu-debian
# wget https://archive.apache.org/dist/spark/spark-3.2.4/spark-3.2.4-bin-without-hadoop.tgz
cp /mnt/shared/spark-3.2.4-bin-without-hadoop.tgz .
tar -xzvf spark-3.2.4-bin-without-hadoop.tgz
mv spark-3.2.4-bin-without-hadoop /opt/hadoop/spark

cp /mnt/config/core-site.xml.tpl $HADOOP_HOME/etc/hadoop/core-site.xml
cp /mnt/config/hdfs-site.xml.tpl $HADOOP_HOME/etc/hadoop/hdfs-site.xml
cp /mnt/config/mapred-site.xml.tpl $HADOOP_HOME/etc/hadoop/mapred-site.xml
cp /mnt/config/yarn-site.xml.tpl $HADOOP_HOME/etc/hadoop/yarn-site.xml

hdfs namenode -format
start-dfs.sh
start-yarn.sh

hdfs dfs -mkdir /spark
hdfs dfs -put /mnt/shared/puertos.csv /spark
spark-shell
:' Comandos scala
val v1 = sc.textFile("/spark/puertos.csv")
v1.count()

val v2 = v1.filter(x => x contains "Barcelona")
v2.count()
'

spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --name "apli1" $SPARK_HOME/examples/jars/spark-examples_2.12-3.2.4.jar 5

spark-submit --master yarn --deploy-mode cluster --name "ContarPalabras6" --conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=/home/hadoop/.pyenv/shims/python3 --conf spark.executorEnv.PYSPARK_PYTHON=/home/hadoop/.pyenv/shims/python3  ContarPalabras.py /spark/quijote.txt /salida_spark_wc 

mkdir /home/spark && groupadd spark && useradd spark -g spark -d /home/spark -s /usr/bin/bash && chown spark:spark /home/spark 

# AS USER SPARK
# wget https://archive.apache.org/dist/spark/spark-3.2.4/spark-3.2.4-bin-hadoop3.2.tgz
tar -xzvf spark-3.2.4-bin-hadoop3.2.tgz
# cp /mnt/shared/spark-3.2.4-bin-hadoop3.2.tgz .
mv spark-3.2.4-bin-hadoop3.2 /home/spark/spark_standalone
cd ~/spark_standalone/sbin

./start-master.sh 

./start-worker.sh nodo1:7077

cd ~/spark_standalone/bin
./spark-shell
:' Comandos scala
val fichero = sc.textFile("../README.md")
fichero.count()
fichero.first()
val fichero1=fichero.filter(x => x contains "Spark")
'

cp ~/spark_standalone/conf/workers.template ~/spark_standalone/conf/workers
echo "nodo1" >> ~/spark_standalone/conf/workers
echo "nodo2" >> ~/spark_standalone/conf/workers
echo "nodo3" >> ~/spark_standalone/conf/workers

~/spark_standalone/sbin/start-workers.sh


tail -f /dev/null

