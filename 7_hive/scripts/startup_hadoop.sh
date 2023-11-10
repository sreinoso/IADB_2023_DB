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

    wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
    tar -xvf apache-hive-3.1.3-bin.tar.gz
    mv apache-hive-3.1.3-bin /opt/hadoop/hive
    echo "export HIVE_HOME=/opt/hadoop/hive" >> ~/.bashrc
    echo 'export PATH=$PATH:$HIVE_HOME/bin' >> ~/.bashrc
    source ~/.bashrc
    cat $HIVE_HOME/conf/hive-default.xml.template > $HIVE_HOME/conf/hive-default.xml 
    cat $HIVE_HOME/conf/hive-exec-log4j2.properties.template > $HIVE_HOME/conf/hive-exec-log4j2.properties   
    cat $HIVE_HOME/conf/hive-log4j2.properties.template > $HIVE_HOME/conf/hive-log4j2.properties
    cat $HIVE_HOME/conf/beeline-log4j2.properties.template > $HIVE_HOME/conf/beeline-log4j2.properties
    cat $HIVE_HOME/conf/hive-env.sh.template > $HIVE_HOME/conf/hive-env.sh
    echo 'export HADOOP_HOME=/opt/hadoop' >> $HIVE_HOME/conf/hive-env.sh
    echo 'export HIVE_CONF_DIR=/opt/hadoop/hive/conf' >> $HIVE_HOME/conf/hive-env.sh
    hdfs dfs -mkdir /tmp
    hdfs dfs -chmod g+w /tmp
    hdfs dfs -mkdir -p /user/hive/warehouse
    hdfs dfs -chmod g+w /user/hive/warehouse
    cp $CONFIG_PATH/hive-site.xml.tpl $HIVE_HOME/conf/hive-site.xml
    ls $HIVE_HOME/lib/guava*
    ls /opt/hadoop/share/hadoop/common/lib/guava*
    mv $HIVE_HOME/lib/guava-19.0.jar $HIVE_HOME/lib/guava-19.0.jar.bak && cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/
    mkdir $HIVE_HOME/bbdd
    cd $HIVE_HOME/bbdd
    schematool -dbType derby -initSchema

    # Despues del sql...
    hdfs dfs -ls /user/hive/warehouse/ejemplo.db
    hiveserver &
    !connect jdbc:hive2://nodo1:10000


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