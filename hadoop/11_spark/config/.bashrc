export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export PATH=$PATH:$HADOOP_HOME/hbase/bin
export PATH=$PATH:$HADOOP_HOME/spark/bin:$HADOOP_HOME/spark/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
export SPARK_DIST_CLASSPATH=$(hadoop classpath)

export SPARK_HOME=$HADOOP_HOME/spark
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"