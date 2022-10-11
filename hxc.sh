#!/bin/sh
  
echo "<configuration>
<property>
  <name>fs.default.name</name>
  <value>hdfs://localhost:9000</value>
</property>
</configuration>" >> $HADOOP_INS/hadoop/etc/hadoop/core-site.xml


echo "<configuration>
<property>
  <name>dfs.replication</name>
  <value>1</value>
</property>

<property>
  <name>dfs.namenode.name.dir</name>
  <value>$HADOOP_HOME/data/namenode</value>
</property>

<property>
  <name>dfs.datanode.data.dir</name>
  <value>$HADOOP_HOME/data/datanode</value>
</property>
</configuration>" >> $HADOOP_INS/hadoop/etc/hadoop/hdfs-site.xml


echo "<configuration>
<property> 
  <name>mapreduce.framework.name</name> 
  <value>yarn</value> 
</property>
</configuration>" >> $HADOOP_INS/hadoop/etc/hadoop/mapred-site.xml


echo "<configuration>
<property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
</property>

<property>
  <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
  <value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>

<property>
  <name>yarn.resourcemanager.hostname</name>
  <value>127.0.0.1</value>
</property>

<property>
  <name>yarn.acl.enable</name>
  <value>0</value>
</property>

<property>
  <name>yarn.nodemanager.env-whitelist</name>   
  <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
</property>
</configuration>"  >> $HADOOP_INS/hadoop/etc/hadoop/yarn-site.xml
