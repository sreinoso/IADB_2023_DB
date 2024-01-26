#!/bin/bash

export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/

echo "STARTING..." >> /tmp/log.txt;
function configMasterDatanodes(){
    hdfs namenode -format
    start-dfs.sh
    start-yarn.sh
    #######################
    ##### Practica ########
    #######################
    ejecutaPractica;
}

function ejecutaPractica(){

    mapred --daemon start historyserver
    hdfs dfs -mkdir /prueba
    hdfs dfs -put access_log /prueba 
    hdfs dfs -ls /prueba

    echo "export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar" >> ~/.bashrc
    source ~/.bashrc
    hadoop com.sun.tools.javac.Main ContarPalabras.java
    jar cf ContarPalabras.jar ContarPalabras*.class
    hadoop jar ContarPalabras.jar ContarPalabras /prueba/access_log /salida_java
    hdfs dfs -ls /salida_java

    hdfs dfs -mkdir /practicas
    hdfs dfs -put cite75_99.txt /practicas

    hadoop com.sun.tools.javac.Main MyJob.java
    jar cf MyJob.jar MyJob*.class
    hadoop jar MyJob.jar MyJob /practicas/cite75_99.txt /resultado7


    hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -input /practicas/cite75_99.txt -output /resultado7 -mapper 'cut -f 2 -d ,' -reducer 'uniq'

    hdfs dfs -cat /resultado7/part-r-0000

    hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -D mapred.reduce.tasks=0 -input /practicas/cite75_99.txt -output /resultado8 -mapper 'wc -l'
    hdfs dfs -ls /resultado8
    hdfs dfs -cat /resultado8/part-00000
    hdfs dfs -cat /resultado8/part-00001

    yarn node -list
    yarn node -list -showDetails

    yarn application -list
    # yarn application -status <ID>  # No ejecutao porque no tengo procesos running
    # yarn application -kill <ID>  # No ejecutao porque no tengo procesos running

    # yarn applicationattempt -list <ID>  # No ejecutao porque no tengo procesos running

    # yarn container -list <ID> # No ejecutao porque no tengo procesos running

    mapred queue -list

    ### Modificamos /opt/hadoop/etc/hadoop/capacity-scheduler.xml
    yarn rmadmin -refreshQueues


    hadoop jar MyJob.jar MyJob -Dmapred.job.queue.name='warehouse' /practicas/cite75_99.txt /resultado11
}
function configGenericDatanodes(){
    mkdir -p /data/
    sed -e 's/{REPLICATION_NODES}/'${REPLICATION_NODES}'/g' $CONFIG_PATH/hdfs-site.xml.tpl > /opt/hadoop/etc/hadoop/hdfs-site.xml
    sed -e 's/{name}/fs.defaultFS/g' -e 's/{node}/nodo1/g'  $CONFIG_PATH/core-site.xml.tpl > /opt/hadoop/etc/hadoop/core-site.xml
    cp $CONFIG_PATH/mapred-site.xml.tpl /opt/hadoop/etc/hadoop/mapred-site.xml
    cp $CONFIG_PATH/yarn-site.xml.tpl /opt/hadoop/etc/hadoop/yarn-site.xml
    cp $CONFIG_PATH/capacity-scheduler.xml.tpl /opt/hadoop/etc/hadoop/capacity-scheduler.xml
    echo $WORKER_NODES | tr "," "\n" > /opt/hadoop/etc/hadoop/workers
}

sudo /etc/init.d/ssh start

mkdir /home/hadoop/.ssh/
ln -s /mnt/shared/authorized_keys /home/hadoop/.ssh/authorized_keys

SHARED_NODE_PATH=/mnt/shared/$NODE_NAME
mkdir -p $SHARED_NODE_PATH
CERTIFICATE=$SHARED_NODE_PATH/id_rsa

if [[ ! -f $CERTIFICATE ]]; then
    ssh-keygen -q -f $CERTIFICATE -N "" && cat $CERTIFICATE.pub >> /home/hadoop/.ssh/authorized_keys
fi

cp $CERTIFICATE /home/hadoop/.ssh/id_rsa
cp $CERTIFICATE.pub /home/hadoop/.ssh/id_rsa.pub

echo "CONFIG GENERIC NODE" >> /tmp/log.txt;
configGenericDatanodes;
if $SINGLE_NODE; then 
    echo "CONFIG IN SINGLE NODE" >> /tmp/log.txt;
    configMasterDatanodes;
else 
    echo "CONFIG IN MULTI NODE" >> /tmp/log.txt;
    if $IS_MASTER; then 
        echo "CONFIGURING MASTER NODE" >> /tmp/log.txt;
        configMasterDatanodes;
    else 
        echo "CONFIGURING SLAVE NODE" >> /tmp/log.txt;
    fi
fi





tail -f /dev/null