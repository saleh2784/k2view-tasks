#!/bin/bash

######################################################################################
                                    ## users ##
######################################################################################
echo "creating the users >>>>>>>>>>>>>>>"
mkdir -p /opt/apps
chmod 755 /opt/apps
useradd -m -d /opt/apps/fabric fabric
useradd -m -d /opt/apps/cassandra cassandra
useradd -m -d /opt/apps/kafka kafka

######################################################################################
echo "run seds >>>>>>>>>>>>>>>>>>>"

echo "root soft    nproc     unlimited" >> /etc/security/limits.conf
echo "cassandra - nofile 100000" >> /etc/security/limits.conf
echo "cassandra - nproc 50000" >> /etc/security/limits.conf
echo "fabric - nofile 100000" >> /etc/security/limits.conf
echo "fabric - nproc 50000" >> /etc/security/limits.conf
echo "kafka hard nofile 100000" >> /etc/security/limits.conf
echo "kafka soft nofile 100000" >> /etc/security/limits.conf
echo "kafka - nproc 50000" >> /etc/security/limits.conf
echo "kafka soft nofile 100000" >> /etc/security/limits.conf
echo "kafka - nproc 50000" >> /etc/security/limits.conf

######################################################################################

echo "## Added by K2view" >> /etc/sysctl.conf
echo "vm.max_map_count = 1048575" >> /etc/sysctl.conf
echo "fs.file-max = 1000000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 60" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 10" >> /etc/sysctl.conf

sysctl -p

echo "swith user to cassandra"

sudo su - cassandra &
cd /opt/apps/cassandra

echo "i'm connected to cassandra user " 

wget --no-check-certificate https://download.k2view.com/index.php/s/n7H7bZs2HMKKZF7/download -O saleh /opt/apps/cassandra/

su - cassandra -c "tar -zxvf /opt/apps/cassandra/saleh"


sed -i '11i\alias python='/usr/bin/python2.7'\' ~/.bash_profile
source ./.bash_profile
python --version

INSLATT_DIR=/opt/apps/cassandra

echo "run seeds >>>>>>>>>>>>>>>>>>>>>>>>>"

sed -i "s@INSLATT_DIR=.*@INSLATT_DIR=$(pwd)@" .bash_profile
rm -rf  cassandra/data && ln -s /opt/apps/cassandra/storage/  cassandra/data
sed -i 's@dc=.*@dc=DC1@' $INSLATT_DIR/cassandra/conf/cassandra-rackdc.properties
sed -i 's@cluster_name: .*@cluster_name: 'cassandra'@' $INSLATT_DIR/cassandra/conf/cassandra.yaml
sed -i s/seeds:.*/"seeds: $(hostname -I |awk {'print $1'})"/g $INSLATT_DIR/cassandra/conf/cassandra.yaml
sed -i s/listen_address:.*/"listen_address: $(hostname -I |awk {'print $1'})"/g $INSLATT_DIR/cassandra/conf/cassandra.yaml
sed -i s/broadcast_rpc_address:.*/"broadcast_rpc_address: $(hostname -I |awk {'print $1'})"/g $INSLATT_DIR/cassandra/conf/cassandra.yaml
sed -i 's@endpoint_snitch:.*@endpoint_snitch: GossipingPropertyFileSnitch@' $INSLATT_DIR/cassandra/conf/cassandra.yaml
sed -i 's@LOCAL_JMX=.*@LOCAL_JMX='no'@' $INSLATT_DIR/cassandra/conf/cassandra-env.sh
sed -i "s@-Djava.rmi.server.hostname=.*@-Djava.rmi.server.hostname=$(hostname -I |awk {'print $1'})\"@" $INSLATT_DIR/cassandra/conf/cassandra-env.sh
sed -i "s@-Dcom.sun.management.jmxremote.password.file=.*@-Dcom.sun.management.jmxremote.password.file=/opt/apps/cassandra/cassandra/conf/.jmxremote.password\"@" $INSLATT_DIR/cassandra/conf/cassandra-env.sh
chmod 777 $INSLATT_DIR/cassandra/conf/.jmxremote.password
echo "monitorRole QED" >> $INSLATT_DIR/cassandra/conf/.jmxremote.password > /dev/null
echo "controlRole R&D" >> $INSLATT_DIR/cassandra/conf/.jmxremote.password > /dev/null
echo "cassandra cassandra" >> $INSLATT_DIR/cassandra/conf/.jmxremote.password > /dev/null
echo "k2view Q1w2e3r4t5" >> $INSLATT_DIR/cassandra/conf/.jmxremote.password > /dev/null
chmod 400 $INSLATT_DIR/cassandra/conf/.jmxremote.password

echo " seds done >>>>>>>>>>>>>>>>>>>>>>>>> "
echo ""
echo "<<<<<<<<<<< start cassandra service >>>>>>>>>>>>"

su - cassandra -c "cassandra > /dev/null "

sleep 40
# wait 40 sec until cassandra is up then create the user k2admin 

echo ""
echo "creating user k2admin >>>>>>>>>>>>"
echo ""
echo "create user k2admin with password 'Q1w2e3r4t5' superuser;" |cqlsh -u cassandra -p cassandra

##Check cassandra status 

echo ""
echo " check the status node >>>>>>>>>>>>"

nodetool -u cassandra -pw cassandra status

######################################################################################
                                    ## kafka ##
######################################################################################

echo "logout from cassandra"
logout

sudo su - kafka &
cd /opt/apps/kafka/

# tar -zxvf download && bash -l date && echo "run seeds" & echo "hi"  & ddg

su - kafka -c "wget --no-check-certificate https://download.k2view.com/index.php/s/g9IZQIDKDwaULGo/download /opt/apps/kafka/"

su - kafka -c "tar -zxvf download && bash -l date && date "
echo "run seds >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

K2_HOME=/opt/apps/kafka
CONFLUENT_HOME=/opt/apps/kafka/kafka

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

echo " seds Done >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ""
echo "Starting Zookeeper and Kafka service :"
echo ""
su - kafka -c "$K2_HOME/kafka/bin/zookeeper-server-start -daemon $K2_HOME/kafka/zookeeper.properties"
sleep 10
su - kafka -c "$K2_HOME/kafka/bin/kafka-server-start -daemon $K2_HOME/kafka/server.properties"


# echo " check the brokers ids"
sleep 5
su - kafka -c "jps"
su - kafka -c "$CONFLUENT_HOME/bin/zookeeper-shell localhost:2181 <<< 'ls /brokers/ids'"

echo "logout from kafka user"
# exit
logout

######################################################################################
                                    ## fabric ##
######################################################################################

sudo su - fabric &
cd /opt/apps/fabric/

su - fabric -c "wget --no-check-certificate https://download.k2view.com/index.php/s/IqMl8VVsfg24aY8/download"

su - fabric -c "tar -zxvf download "
# && bash -l date &&"

sed -i "s@K2_HOME=.*@K2_HOME=$(pwd)@" .bash_profile

bash -l date && echo "run seeds >>>>>>>>>>>>>>>>>>>>>>>>>>>"

K2_HOME=/opt/apps/fabric

echo "<<<<<<<< run seeds >>>>>>>>>>"

# Cassandra IP
cserver1=$(hostname -I |awk {'print $1'})
# Kafka IP
kserver1=$(hostname -I |awk {'print $1'})

su - fabric -c "cp -r $K2_HOME/fabric/config.template $K2_HOME/config"

su - fabric -c "cp config/adminInitialCredentials.template config/adminInitialCredentials"
sed -i 's@user.*@k2consoleadmin/KW4RVG98RR9xcrTv@' config/adminInitialCredentials

sed -i 's@#REPLICATION_OPTIONS=.*@REPLICATION_OPTIONS={ '"'"'class'"'"' : '"'"'NetworkTopologyStrategy'"'"', '"'"DC1"'"' : 1}@' $K2_HOME/config/config.ini
sed -i "s@#HOSTS=.*@HOSTS=$cserver1@" $K2_HOME/config/config.ini
sed -i "s@#USER=.*@USER=k2admin@" $K2_HOME/config/config.ini

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

echo "seds Done >>>>>>>>>>>>>>>>>>>"

echo "Starting Fabric >>>>>>>>>"
echo ""
su - fabric -c "k2fabric start && k2fabric status"

# fabric -u k2consoleadmin -p KW4RVG98RR9xcrTv

