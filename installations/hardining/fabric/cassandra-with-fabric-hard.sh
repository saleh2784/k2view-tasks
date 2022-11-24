#!/bin/bash

cp /tmp/keys.tar.gz /opt/apps/fabric


#tar -czvf keys.tar.gz -C opt/apps/fabric/.cassandra_ssl .
# copy to all Fabric nodes
# 172.27.0.102 represents IP address of each node
# scp keys.tar.gz fabric@172.27.0.102:/opt/apps/fabric/

# Set Fabric to connect to Cassandra

k2fabric stop

mkdir -p $K2_HOME/.cassandra_ssl && tar -zxvf keys.tar.gz -C $K2_HOME/.cassandra_ssl

## Edit the $K2_HOME/config/jvm.options file using the appropriate passwords and certification files:

sed -i "s@#SSL=false@SSL=true@" $K2_HOME/config/config.ini
sed -i "s@#PORT=$.*@PORT=9142@" $K2_HOME/config/config.ini
sed -i "s@^USER=.*@USER=k2admin@" $K2_HOME/config/config.ini
sed -i "s@^PASSWORD=.*@PASSWORD=Q1w2e3r4t5@" $K2_HOME/config/config.ini
sed -i 's@#-Djavax.net.ssl.keyStore=.*@-Djavax.net.ssl.keyStore=$K2_HOME/.cassandra_ssl/cassandra.keystore@g' $K2_HOME/config/jvm.options
sed -i 's@#-Djavax.net.ssl.keyStorePassword=.*@-Djavax.net.ssl.keyStorePassword=Q1w2e3r4t5@g' $K2_HOME/config/jvm.options
sed -i 's@#-Djavax.net.ssl.trustStore=.*@-Djavax.net.ssl.trustStore=$K2_HOME/.cassandra_ssl/cassandra.truststore@g' $K2_HOME/config/jvm.options
sed -i 's@#-Djavax.net.ssl.trustStorePassword=.*@-Djavax.net.ssl.trustStorePassword=Q1w2e3r4t5@g' $K2_HOME/config/jvm.options

k2fabric start


