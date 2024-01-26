<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
  <property>
    <name>dfs.replication</name>
    <value>{REPLICATION_NODES}</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>/data/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>/data/datanode</value>
  </property>

  <!-- NUEVO -->
  <property>
      <name>dfs.nameservices</name>
      <value>ha-cluster</value>
  </property>

  <property>
      <name>dfs.ha.namenodes.ha-cluster</name>
      <value>nodo1,nodo2</value>
  </property>

  <property>
      <name>dfs.permissions</name>
      <value>false</value>
  </property>

  <property>
      <name>dfs.namenode.rpc-address.ha-cluster.nodo1</name>
      <value>nodo1:9000</value>
  </property>

  <property>
      <name>dfs.namenode.rpc-address.ha-cluster.nodo2</name>
      <value>nodo2:9000</value>
  </property>

  <property>
      <name>dfs.namenode.http-address.ha-cluster.nodo1</name>
      <value>nodo1:50070</value>
  </property>

  <property>
      <name>dfs.namenode.http-address.ha-cluster.nodo2</name>
      <value>nodo2:50070</value>
  </property>

  <property>
      <name>dfs.namenode.shared.edits.dir</name>
      <value>qjournal://nodo3:8485;nodo2:8485;nodo1:8485/ha-cluster</value>
  </property>

  <property>
      <name>dfs.journalnode.edits.dir</name>
      <value>/data/jn</value>
  </property>

  <property>
      <name>dfs.client.failover.proxy.provider.ha-cluster</name>
      <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
  </property>

  <property>
      <name>dfs.ha.automatic-failover.enabled</name>
      <value>true</value>
  </property>

  <property>
      <name>ha.zookeeper.quorum</name>
      <value>nodo1:2181,nodo2:2181,nodo3:2181</value>
  </property>

  <property>
      <name>dfs.ha.fencing.methods</name>
      <value>sshfence</value>
  </property>

  <property>
      <name>dfs.ha.fencing.ssh.private-key-files</name>
      <value>/home/hadoop/.ssh/id_rsa</value>
  </property>

<!--
    <property>
        <name>dfs.replication</name>
        <value>{REPLICATION_NODES}</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/data/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/data/datanode</value>
    </property>
    <property>
        <name>dfs.webhdfs.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>dfs.nameservices</name>
        <value>ha-cluster</value>
    </property>
    <property>
        <name>dfs.ha.namenodes.ha-cluster</name>
        <value>nodo1,nodo2</value>
    </property>
    <property>
        <name>dfs.permissions</name>
        <value>false</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.ha-cluster.nodo1</name>
        <value>nodo1:9000</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.ha-cluster.nodo2</name>
        <value>nodo2:9000</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.ha-cluster.nodo1</name>
        <value>nodo1:50070</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.ha-cluster.nodo2</name>
        <value>nodo2:50070</value>
    </property>
    <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://nodo3:8485;nodo2:8485;nodo1:8485/ha-cluster</value>
    </property>
    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/data/jn</value>
    </property>
    <property>
        <name>dfs.client.failover.proxy.provider.ha-cluster</name>
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    </property>
    <property>
        <name>dfs.client.automatic-failover.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>ha.zookeeper.quorum</name>
        <value>nodo1:2181,nodo2:2181,nodo3:2181</value>
    </property>
    <property>
        <name>dfs.ha.fencing.methods</name>
        <value>sshfence</value>
    </property>
    <property>
        <name>dfs.ha.fencing.ssh.private-key-files</name>
        <value>/home/hadoop/.ssh/id_rsa</value>
    </property>
    -->
</configuration>