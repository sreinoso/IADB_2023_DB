#!/bin/bash

export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/

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

mkdir -p /data/
sed -e 's/{REPLICATION_NODES}/1/g' $CONFIG_PATH/hdfs-site.xml.tpl > /opt/hadoop/etc/hadoop/hdfs-site.xml
sed -e 's/{name}/fs.defaultFS/g' -e 's/{node}/nodo1/g'  $CONFIG_PATH/core-site.xml.tpl > /opt/hadoop/etc/hadoop/core-site.xml


jps

cat > /opt/hadoop/etc/hadoop/mapred-site.xml <<- END 
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>
</configuration>
END

cat > /opt/hadoop/etc/hadoop/yarn-site.xml <<- END
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
        <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>localhost</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
            <value>org.apache.hadoop.mapred.ShuffleHandler</value>
        </property>
        <property>
            <name>yarn.resourcemanager.bind-host</name>
            <value>0.0.0.0</value>
        </property>
        <property>
            <name>yarn.application.classpath</name>
            <value>/opt/hadoop/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*</value>
        </property>
</configuration>
END

cat > /tmp/ContarPalabras.java <<- END 

import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class ContarPalabras {

    public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
        
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }


    public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
            
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        
        Configuration conf = new Configuration();

        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if(otherArgs.length != 2) {
            System.err.println("Usage: wordcount <in> <out>");
            System.exit(2);
        }

        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCount.class);
        job.setMapperClass(TokenizerMapper.class);
        
        // job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
END

hdfs namenode -format

start-dfs.sh
start-yarn.sh


wget -O quijote.txt https://www.gutenberg.org/ebooks/2000.txt.utf-8
hdfs dfs -mkdir /libros
hdfs dfs -put quijote.txt /libros
hdfs dfs -ls /libros

ls /opt/hadoop/share/hadoop/mapreduce
jar tf /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar

hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /libros /salida_libros

hdfs dfs -ls /salida_libros
hdfs dfs -get /salida_libros/part-r-00000 /tmp/contaquijote.txt

more /tmp/contaquijote.txt 

echo "export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar " >> ~/.bashrc
source ~/.bashrc


cat > /tmp/ContarPalabras.java <<- END 

import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class ContarPalabras {

    public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
        
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }


    public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
            
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        
        Configuration conf = new Configuration();

        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if(otherArgs.length != 2) {
            System.err.println("Usage: wordcount <in> <out>");
            System.exit(2);
        }

        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(ContarPalabras.class);
        job.setMapperClass(TokenizerMapper.class);
        
        // job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
END

hadoop com.sun.tools.javac.Main /tmp/ContarPalabras.java
cd /tmp
jar cf ContarPalabras.jar ContarPalabras*.class

mapred --daemon start historyserver
hdfs dfs -mkdir /temporal
hdfs dfs -put /mnt/config/access_log /temporal

hadoop jar ContarPalabras.jar ContarPalabras /temporal/access_log /salida_java


tail -f /dev/null