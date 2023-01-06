#!/bin/bash

wget --no-check-certificate https://download.k2view.com/index.php/s/g9IZQIDKDwaULGo/download

tar -zxvf download && bash -l date && echo "run seeds"


######################################################################################

######################################################################################
echo "Run seds .........."

kserver1=$(hostname -I |awk {'print $1'})

if [ "$(hostname -I |awk {'print $1'})" == "$kserver1" ]; then echo 1 > $K2_HOME/zk_data/myid; fi
if [ "$(hostname -I |awk {'print $1'})" == "$kserver1" ]; then sed -i "s@broker.id=.@broker.id=1@" $CONFLUENT_HOME/server.properties ; fi

sed -i "s@log.retention.minutes=.*@log.retention.hours=48@" $CONFLUENT_HOME/server.properties
sed -i "s@advertised.listeners=.*@advertised.listeners=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@advertised.host.name=.*@advertised.host.name=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@listeners=PLAINTEXT:\/\/.*@listeners=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "s@zookeeper.connect=.*.@zookeeper.connect=$kserver1:2181@" $CONFLUENT_HOME/server.properties
echo "default.replication.factor=3" >> $CONFLUENT_HOME/server.properties
sed -i "s@log.dirs=.*@log.dirs=$K2_HOME/zk_data@" $CONFLUENT_HOME/server.properties
sed -i "s@dataDir=.*@dataDir=$K2_HOME/zk_data@" $CONFLUENT_HOME/zookeeper.properties
sed -i "s@server.1=.*@#server.1=$(hostname -I |awk {'print $1'}):2888:3888@" $CONFLUENT_HOME/zookeeper.properties
echo "server.1=$kserver1:2888:3888" >> $CONFLUENT_HOME/zookeeper.properties



######################################################################################

#Start Kafka and Zookeeper:

echo "Start Kafka and Zookeeper"

$K2_HOME/kafka/bin/zookeeper-server-start -daemon $K2_HOME/kafka/zookeeper.properties
sleep 5
$K2_HOME/kafka/bin/kafka-server-start -daemon $K2_HOME/kafka/server.properties


######################################################################################

# Verify the Kafka and Zookeeper are running:

sleep 5

jps

echo " check the brokers ids"

sleep 5

$CONFLUENT_HOME/bin/zookeeper-shell localhost:2181 <<< "ls /brokers/ids"

######################################################################################



