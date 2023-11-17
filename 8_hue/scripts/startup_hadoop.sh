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
    ejecutaPracticaHive;
    ejecutaPractica;
}

function ejecutaPracticaHive(){
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
}

function ejecutaPractica(){
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/libpython2.7-minimal_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/python2.7-minimal_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/python2.7_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/libpython2.7-stdlib_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/libf/libffi/libffi7_3.3-6_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/r/readline/libreadline8_8.1-1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/r/readline/readline-common_8.1-1_all.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/libpython2.7_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/python2.7-dev_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/p/python2.7/libpython2.7-dev_2.7.18-8+deb11u1_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/e/expat/libexpat1-dev_2.2.10-2+deb11u5_amd64.deb
    wget http://ftp.es.debian.org/debian/pool/main/e/expat/libexpat1_2.2.10-2+deb11u5_amd64.deb

    sudo dpkg -i libpython2.7-minimal_2.7.18-8+deb11u1_amd64.deb && rm libpython2.7-minimal_2.7.18-8+deb11u1_amd64.deb
    sudo dpkg -i python2.7-minimal_2.7.18-8+deb11u1_amd64.deb && rm python2.7-minimal_2.7.18-8+deb11u1_amd64.deb
    sudo dpkg -i libssl1.1_1.1.1w-0+deb11u1_amd64.deb && rm libssl1.1_1.1.1w-0+deb11u1_amd64.deb
    sudo dpkg -i libffi7_3.3-6_amd64.deb && rm libffi7_3.3-6_amd64.deb
    sudo dpkg -i readline-common_8.1-1_all.deb && rm readline-common_8.1-1_all.deb 
    sudo dpkg -i libreadline8_8.1-1_amd64.deb && rm libreadline8_8.1-1_amd64.deb 
    sudo dpkg -i libpython2.7-stdlib_2.7.18-8+deb11u1_amd64.deb && rm libpython2.7-stdlib_2.7.18-8+deb11u1_amd64.deb
    sudo dpkg -i python2.7_2.7.18-8+deb11u1_amd64.deb && rm python2.7_2.7.18-8+deb11u1_amd64.deb 
    sudo dpkg -i libpython2.7_2.7.18-8+deb11u1_amd64.deb && rm libpython2.7_2.7.18-8+deb11u1_amd64.deb
    sudo dpkg -i libexpat1-dev_2.2.10-2+deb11u5_amd64.deb && rm libexpat1-dev_2.2.10-2+deb11u5_amd64.deb
    sudo dpkg -i libexpat1_2.2.10-2+deb11u5_amd64.deb && rm libexpat1_2.2.10-2+deb11u5_amd64.deb
    sudo dpkg -i libpython2.7-dev_2.7.18-8+deb11u1_amd64.deb && rm libpython2.7-dev_2.7.18-8+deb11u1_amd64.deb
    sudo dpkg -i python2.7-dev_2.7.18-8+deb11u1_amd64.deb && rm python2.7-dev_2.7.18-8+deb11u1_amd64.deb

    sudo apt --fix-broken install
    sudo apt-get update -y
    sudo apt-get install git ant gcc g++ libffi-dev libkrb5-dev libmysqlclient-dev libsasl2-dev libsasl2-modules-gssapi-mit libsqlite3-dev libssl-dev libxml2-dev libxslt-dev make maven libldap2-dev python-dev-is-python3 libgmp3-dev build-essential autoconf libtool pkg-config libgle3 libxml2 libfl-dev zlib1g-dev curl libbz2-dev libreadline-dev wget curl llvm xz-utils tk-dev liblzma-dev mysql-client -y

    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 16

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"

    git clone https://github.com/cloudera/hue.git

    cd hue
    git checkout release-4.11.0
    git cherry-pick 7a9100d4a7f38eaef7bd4bd7c715ac1f24a969a8
    git cherry-pick e67c1105b85b815346758ef1b9cd714dd91d7ea3
    git clean -fdx

    make apps
    # tar -xzvf /mnt/shared/hue.tar.gz # Para agilizar cuando se tenga 
    # cp -rf /mnt/shared/hue /home/hadoop/ # Para agilizar cuando se tenga 
    export PATH=$PATH:/home/hadoop/hue/build/env/bin

    hue runserver 0.0.0.0:8888
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