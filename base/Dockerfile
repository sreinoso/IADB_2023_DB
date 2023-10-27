FROM debian:bookworm

WORKDIR /root

COPY hadoop-3.3.6.tar.gz /root/

RUN echo "Types: deb\nURIs: http://ftp.de.debian.org/debian\nSuites: sid\nComponents: main" >> /etc/apt/sources.list.d/debian.sources &&\
    apt-get update &&\
    apt-get install wget openjdk-8-jdk-headless vim openssh-client openssh-server net-tools inetutils-ping sudo -y &&\
    tar -xzvf hadoop-3.3.6.tar.gz &&\
    rm hadoop-3.3.6.tar.gz &&\
    mv hadoop-3.3.6 /opt/hadoop  &&\
    mkdir /home/hadoop && groupadd hadoop && useradd hadoop -g hadoop -d /home/hadoop -s /usr/bin/bash && chown hadoop:hadoop /home/hadoop &&\
    chown -R hadoop:hadoop /opt/hadoop/ &&\
    echo 'export HADOOP_HOME=/opt/hadoop\nexport PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin\nexport JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/' > /root/.bashrc &&\
    echo 'export HADOOP_HOME=/opt/hadoop\nexport PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin\nexport JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/' > /home/hadoop/.bashrc &&\
    chown hadoop:hadoop /home/hadoop/.bashrc &&\
    mkdir -m 777 /data &&\
    bash -c "/etc/init.d/ssh start" &&\
    echo "hadoop    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN echo "root:root" | chpasswd &&\
    echo "hadoop:hadoop" | chpasswd

COPY ./scripts/startup.sh /mnt/scripts/startup.sh

CMD ["/mnt/scripts/startup.sh"]
