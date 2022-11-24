#!/bin/bash
echo "Download cassandra version  3.11.9"

wget --no-check-certificate https://download.k2view.com/index.php/s/n7H7bZs2HMKKZF7/download

tar -zxvf download

sed -i '11i\alias python='/usr/bin/python2.7'\' ~/.bash_profile
source ./.bash_profile
# verified the Python version 
python --version
bash -l

######################################################################################
#dc=DC1
#cluster_name = cassandra
######################################################################################
sleep 5

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
echo "monitorRole QED" >> ~/cassandra/conf/.jmxremote.password
echo "controlRole R&D" >> ~/cassandra/conf/.jmxremote.password
echo "cassandra cassandra" >> ~/cassandra/conf/.jmxremote.password
echo "k2view Q1w2e3r4t5" >> ~/cassandra/conf/.jmxremote.password
chmod 400 ~/cassandra/conf/.jmxremote.password

sleep 5
######################################################################################
echo "start cassandra service"

cassandra 


######################################################################################

# echo "create user k2admin"

# echo "create user k2admin with password 'Q1w2e3r4t5' superuser;" |cqlsh -u cassandra -p cassandra

#######################################################################################

#Check cassandra's status 

nodetool -u cassandra -pw cassandra status
