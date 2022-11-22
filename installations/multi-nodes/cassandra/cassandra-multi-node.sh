#!/bin/bash

# mkdir -p /opt/apps

# chmod 755 /opt/apps

# useradd -m -d /opt/apps/cassandra cassandra

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

wget --no-check-certificate https://download.k2view.com/index.php/s/sCysXmOvIq3Ureq/download

tar -zxvf download

sed -i '11i\alias python='/usr/bin/python2.7'\' ~/.bash_profile
source ./.bash_profile
# verified the Python version 
python --version

######################################################################################
#dc=DC1
#cluster_name = cassandra
#seed = 10.0.50.51
######################################################################################

sed -i "s@INSLATT_DIR=.*@INSLATT_DIR=$(pwd)@" .bash_profile 

sed -i 's@dc=.*@dc=DC1@'  $INSLATT_DIR/cassandra/conf/cassandra-rackdc.properties 

sed -i 's@cluster_name: .*@cluster_name: 'cassandra'@'  $INSLATT_DIR/cassandra/conf/cassandra.yaml 

sed -i s/seeds:.*/"seeds: \"10.0.50.51\""/g $INSLATT_DIR/cassandra/conf/cassandra.yaml 

sed -i s/listen_address:.*/"listen_address: $(hostname -I |awk {'print $1'})"/g $INSLATT_DIR/cassandra/conf/cassandra.yaml 

sed -i s/broadcast_rpc_address:.*/"broadcast_rpc_address: $(hostname -I |awk {'print $1'})"/g $INSLATT_DIR/cassandra/conf/cassandra.yaml 

sed -i 's@endpoint_snitch:.*@endpoint_snitch: GossipingPropertyFileSnitch@'  $INSLATT_DIR/cassandra/conf/cassandra.yaml 

sed -i 's@LOCAL_JMX=.*@LOCAL_JMX='no'@'  $INSLATT_DIR/cassandra/conf/cassandra-env.sh 

sed -i "s@-Djava.rmi.server.hostname=.*@-Djava.rmi.server.hostname=$(hostname -I |awk {'print $1'})\"@"  $INSLATT_DIR/cassandra/conf/cassandra-env.sh 

sed -i "s@-Dcom.sun.management.jmxremote.password.file=.*@-Dcom.sun.management.jmxremote.password.file=$INSLATT_DIR/cassandra/conf/.jmxremote.password\"@" $INSLATT_DIR/cassandra/conf/cassandra-env.sh 

sed -i "s@num_tokens:.*@num_tokens: 16@" $INSLATT_DIR/cassandra/conf/cassandra.yaml 

######################################################################################

cassandra 

######################################################################################

###Check dc name & run these commands below on one node! 

###Check number of the replication 

echo "create user k2admin with password 'Q1w2e3r4t5' superuser;" |cqlsh -u cassandra -p cassandra 

echo "ALTER KEYSPACE system_auth WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'DC1': '3'};" | cqlsh -ucassandra -pcassandra 

echo "ALTER KEYSPACE system_distributed WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'DC1': '3'};" | cqlsh -ucassandra -pcassandra 

echo "ALTER KEYSPACE system_traces WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'DC1': '3'};" | cqlsh -ucassandra -pcassandra 

echo "CREATE KEYSPACE keyspace_with_replication_factor_3 WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1': 3} AND durable_writes = true;"|cqlsh -u cassandra -p cassandra 


 
#Check cassandra's status 

nodetool -u cassandra -pw cassandra status


#run on 3 nodes 

#nodetool -u  cassandra -pw  cassandra repair 