#!/bin/bash

## copy the key to other kafka nodes and fabric ##

# stop kafka
~/kafka/bin/kafka-server-stop -daemon ~/kafka/server.properties
# stop zookeeper
~/kafka/bin/zookeeper-server-stop -daemon ~/kafka/zookeeper.properties


## on the Fabric and other Kafka nodes use the following to extract

mkdir -p $K2_HOME/.kafka_ssl && tar -zxvf Kafka_keyz.tar.gz -C $K2_HOME/.kafka_ssl


## SASL Authentication 

echo "authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider" >> $CONFLUENT_HOME/zookeeper.properties


## create zookeeper_jaas.conf

echo \
'Server {
org.apache.zookeeper.server.auth.DigestLoginModule required
user_super="kafka"
user_kafka="kafka";
};

Client {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    username="kafka"
    password="kafka";
};' > $CONFLUENT_HOME/zookeeper_jaas.conf

## Start the ZooKeeper Service

export KAFKA_OPTS="-Djava.security.auth.login.config=$CONFLUENT_HOME/zookeeper_jaas.conf" && ~/kafka/bin/zookeeper-server-start -daemon ~/kafka/zookeeper.properties

## Note that the following steps must be applied for each node in cluster.
## SSL Authentication

sed -i "s@listeners=.*@listeners=SSL://$(hostname -I |awk {'print $1'}):9093@"  $CONFLUENT_HOME/server.properties 
sed -i "s@advertised.listeners=.*@advertised.listeners=PLAINTEXT:\/\/$(hostname -I |awk {'print $1'}):9093@" $CONFLUENT_HOME/server.properties
sed -i "32i security.inter.broker.protocol=SSL" $CONFLUENT_HOME/server.properties
sed -i "33i ssl.client.auth=required" $CONFLUENT_HOME/server.properties
sed -i 's/^advertised.listeners/#&/' $CONFLUENT_HOME/server.properties
sed -i 's/^advertised.host.name/#&/' $CONFLUENT_HOME/server.properties
sed -i "60i ssl.truststore.location=$K2_HOME/.kafka_ssl/kafka.server.truststore.jks" $CONFLUENT_HOME/server.properties
sed -i "61i ssl.truststore.password=Q1w2e3r4t5" $CONFLUENT_HOME/server.properties
sed -i "62i ssl.keystore.location=$K2_HOME/.kafka_ssl/kafka.server.keystore.jks" $CONFLUENT_HOME/server.properties
sed -i "63i ssl.keystore.password=Q1w2e3r4t5" $CONFLUENT_HOME/server.properties
sed -i "64i ssl.key.password=Q1w2e3r4t5" $CONFLUENT_HOME/server.properties
sed -i "65i ssl.endpoint.identification.algorithm=" $CONFLUENT_HOME/server.properties

## kafka_server_jaas.conf

echo \
'KafkaServer {
    org.apache.kafka.common.security.plain.PlainLoginModule required
    username="kafka"
    password="kafka"
    user_kafkabroker="kafka"
    user_client1="kafka";
};

Client {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    username="kafka"
    password="kafka";
};' > $CONFLUENT_HOME/kafka_server_jaas.conf

## Start the Kafka Server

export KAFKA_OPTS="-Djava.security.auth.login.config=$CONFLUENT_HOME/kafka_server_jaas.conf" && ~/kafka/bin/kafka-server-start -daemon ~/kafka/server.properties













