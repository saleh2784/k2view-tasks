#!/bin/bash

stop-server

#############################################################################
## Transfer Keys and Certificates to All Cassandra and Fabric Nodes
#############################################################################

# scp keys.tar.gz cassandra@10.10.10.10:/opt/apps/cassandra/

## login to every node searately and run the following command:

mkdir -p $INSLATT_DIR/.cassandra_ssl && tar -zxvf keys.tar.gz -C $INSLATT_DIR/.cassandra_ssl


#############################################################################

sed -i "s@internode_encryption: none@internode_encryption: all@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@key_password: cassandra@key_password: Q1w2e3r4t5@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@keystore: conf/.keystore*@keystore: $INSLATT_DIR/.cassandra_ssl/cassandra.keystore@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# truststore:@truststore:@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@truststore: conf/.truststore*@truststore: $INSLATT_DIR/.cassandra_ssl/cassandra.truststore@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# protocol: TLS*@protocol: TLS@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@keystore_password: cassandra@keystore_password: Q1w2e3r4t5@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# truststore: conf/.truststore*@truststore: $INSLATT_DIR/.cassandra_ssl/cassandra.truststore@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# truststore_password: cassandra*@truststore_password: Q1w2e3r4t5@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@truststore_password: cassandra*@truststore_password: Q1w2e3r4t5@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# protocol: TLS*@protocol: TLS@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# require_client_auth: .*@require_client_auth: false@g" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@# store_type: JKS@store_type: JKS@g" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i '0,/enabled: false/! {0,/enabled: false/ s/enabled: false/enabled: true/}' $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e 's/# \(.*cipher_suites.*\)/\1/g' $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e 's/# \(.*native_transport_port_ssl:.*\)/\1/g' $CASSANDRA_HOME/conf/cassandra.yaml
sed -i '1,/cdc_enabled: false/ {0,/cdc_enabled: false/ s/cdc_enabled: false/cdc_enabled: true/}' $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@back_pressure_enabled: .*@back_pressure_enabled: true@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i "s@native_transport_port: .*@native_transport_port: 9142@" $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e 's/# \(.*native_transport_port_ssl:.*\)/\1/g' $CASSANDRA_HOME/conf/cassandra.yaml

#############################################################################

##  Cassandra CQLSHRC

mkdir ~/.cassandra
cp $INSTALL_DIR/cassandra/conf/cqlshrc.sample $INSTALL_DIR/.cassandra/cqlshrc

sed -i "s@\;\[ssl\]@\[ssl\]@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i '/^\[csv]/i factory = cqlshlib.ssl.ssl_transport_factory' $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@; certfile = .*@certfile = $INSLATT_DIR/.cassandra_ssl/cassandra_CLIENT.cer.pem@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@;validate = true@validate = true@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "105iversion = SSLv23" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@;userkey = .*@userkey = $INSLATT_DIR/.cassandra_ssl/cassandra_CLIENT.key.pem@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@;usercert = .*@usercert = $INSLATT_DIR/.cassandra_ssl/cassandra_CLIENT.cer.pem@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@port = .*@port = 9142@" $INSLATT_DIR/.cassandra/cqlshrc
sed -i "s@hostname = .*@hostname = $(hostname -I |awk {'print $1'})@" $INSLATT_DIR/.cassandra/cqlshrc

#############################################################################

# start the service :

cassandra

