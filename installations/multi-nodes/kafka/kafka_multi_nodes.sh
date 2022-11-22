#!/bin/bash

####################
# run the commands below under the user root  
####################
# mkdir -p /opt/apps

# chmod 755 /opt/apps

# useradd -m -d /opt/apps/kafka kafka

######################################################################################

# echo "root soft    nproc     unlimited" >> /etc/security/limits.conf
# echo "cassandra - nofile 100000" >> /etc/security/limits.conf
# echo "cassandra - nproc 50000" >> /etc/security/limits.conf
# echo "fabric - nofile 100000" >> /etc/security/limits.conf
# echo "fabric - nproc 50000" >> /etc/security/limits.conf
# echo "kafka hard nofile 100000" >> /etc/security/limits.conf
# echo "kafka soft nofile 100000" >> /etc/security/limits.conf
# echo "kafka - nproc 50000" >> /etc/security/limits.conf
# echo "kafka soft nofile 100000" >> /etc/security/limits.conf
# echo "kafka - nproc 50000" >> /etc/security/limits.conf

######################################################################################

# echo "## Added by K2view" >> /etc/sysctl.conf
# echo "vm.max_map_count = 1048575" >> /etc/sysctl.conf
# echo "fs.file-max = 1000000" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_time = 60" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_intvl = 10" >> /etc/sysctl.conf
# sysctl -p

######################################################################################
## Kafka user
##############3

wget --no-check-certificate https://download.k2view.com/index.php/s/g9IZQIDKDwaULGo/download

tar -zxvf download bash -l


######################################################################################

######################################################################################

export kserver1=10.0.50.51
export kserver2=10.0.50.52
export kserver3=10.0.50.53

if [ "$(hostname -I |awk {'print $1'})" == "$kserver1" ]; then echo 1 > $K2_HOME/zk_data/myid; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver2" ]; then echo 2 > $K2_HOME/zk_data/myid; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver3" ]; then echo 3 > $K2_HOME/zk_data/myid; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver1" ]; then sed -i "s@broker.id=.@broker.id=1@" $CONFLUENT_HOME/server.properties ; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver2" ]; then sed -i "s@broker.id=.@broker.id=2@" $CONFLUENT_HOME/server.properties ; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver3" ]; then sed -i "s@broker.id=.@broker.id=3@" $CONFLUENT_HOME/server.properties ; fi

sed -i "s@log.retention.minutes=.*@log.retention.hours=48@" $CONFLUENT_HOME/server.properties
sed -i "s@advertised.listeners=.*@advertised.listeners=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@advertised.host.name=.*@advertised.host.name=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@listeners=PLAINTEXT:\/\/.*@listeners=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@zookeeper.connect=.*.@zookeeper.connect=$kserver1:2181,$kserver2:2181,$kserver3:2181@" $CONFLUENT_HOME/server.properties
echo "default.replication.factor=3" >> $CONFLUENT_HOME/server.properties
sed -i "s@log.dirs=.*@log.dirs=$K2_HOME/zk_data@" $CONFLUENT_HOME/server.properties
sed -i "s@dataDir=.*@dataDir=$K2_HOME/zk_data@" $CONFLUENT_HOME/zookeeper.properties
sed -i "s@server.1=.*@#server.1=$(hostname -I |awk {'print $1'}):2888:3888@" $CONFLUENT_HOME/zookeeper.properties
echo "server.1=$kserver1:2888:3888" >> $CONFLUENT_HOME/zookeeper.properties
echo "server.2=$kserver2:2888:3888" >> $CONFLUENT_HOME/zookeeper.properties
echo "server.3=$kserver3:2888:3888" >> $CONFLUENT_HOME/zookeeper.properties



######################################################################################

#Start Kafka and Zookeeper:

$K2_HOME/kafka/bin/zookeeper-server-start -daemon $K2_HOME/kafka/zookeeper.properties
sleep 10
$K2_HOME/kafka/bin/kafka-server-start -daemon $K2_HOME/kafka/server.properties




######################################################################################

# Verify the Kafka and Zookeeper are running:

$CONFLUENT_HOME/bin/zookeeper-shell localhost:2181 <<< "ls /brokers/ids"

######################################################################################

jps

