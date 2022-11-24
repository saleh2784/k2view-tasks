#!/bin/bash

wget --no-check-certificate https://download.k2view.com/index.php/s/IqMl8VVsfg24aY8/download

tar -zxvf download && bash -l date &&

sed -i "s@K2_HOME=.*@K2_HOME=$(pwd)@" .bash_profile

bash -l date && echo "run seeds"

######################################################################################

######################################################################################
# Cassandra IP
cserver1=$(hostname -I |awk {'print $1'})
# Kafka IP
kserver1=$(hostname -I |awk {'print $1'})

cp -r $K2_HOME/fabric/config.template $K2_HOME/config

# update heap memory if you have minimume of 32G
## sed -i 's@-Xmx2G@-Xmx8G@' $INSLATT_DIR/config/jvm.options
## sed -i 's@-Xms2G@-Xms8G@' $INSLATT_DIR/config/jvm.options

cp config/adminInitialCredentials.template config/adminInitialCredentials
sed -i 's@user.*@k2consoleadmin/KW4RVG98RR9xcrTv@' config/adminInitialCredentials

sed -i 's@#REPLICATION_OPTIONS=.*@REPLICATION_OPTIONS={ '"'"'class'"'"' : '"'"'NetworkTopologyStrategy'"'"', '"'"DC1"'"' : 1}@' $K2_HOME/config/config.ini
sed -i "s@#HOSTS=.*@HOSTS=$cserver1@" $K2_HOME/config/config.ini
sed -i "s@#USER=.*@USER=k2admin@" $K2_HOME/config/config.ini


######################################################################################

 # In case of using Kafka + iidFinder, run also the following commands:

sed -i "s@#PASSWORD=.*@PASSWORD=Q1w2e3r4t5@" $K2_HOME/config/config.ini
sed -i "s@#MESSAGES_BROKER_TYPE=.*@MESSAGES_BROKER_TYPE=KAFKA@" $K2_HOME/config/config.ini
sed -i "s@#BOOTSTRAP_SERVERS=.*@BOOTSTRAP_SERVERS=$kserver1:9093@" $K2_HOME/config/config.ini
sed -i "s@HOSTS=.*@HOSTS=$cserver1@" $K2_HOME/config/iifConfig.ini
sed -i "s@#USER=.*@USER=k2admin@" $K2_HOME/config/iifConfig.ini
sed -i "s@#PASSWORD=.*@PASSWORD=Q1w2e3r4t5@" $K2_HOME/config/iifConfig.ini
sed -i "s@#KAFKA_BOOTSTRAP_SERVERS=.*@KAFKA_BOOTSTRAP_SERVERS=$kserver1:9093@" $K2_HOME/config/iifConfig.ini
sed -i "s@#ZOOKEEPER_BOOTSTRAP_SERVERS=.*@ZOOKEEPER_BOOTSTRAP_SERVERS=$kserver1:2181@" $K2_HOME/config/iifConfig.ini
sed -i 's@#IIF_REPLICATION_OPTIONS=.*@IIF_REPLICATION_OPTIONS={ '"'"'class'"'"' : '"'"'NetworkTopologyStrategy'"'"', '"'"DC1"'"' : 1}@' $K2_HOME/config/iifConfig.ini
sed -i "s@#BOOTSTRAP_SERVERS=.*@BOOTSTRAP_SERVERS=$kserver1:9093@" $K2_HOME/config/iifConfig.ini



######################################################################################

# Start Fabric:

k2fabric start && k2fabric status

######################################################################################

# Connect to the Fabric console with:

# fabric -u k2consoleadmin -p KW4RVG98RR9xcrTv

