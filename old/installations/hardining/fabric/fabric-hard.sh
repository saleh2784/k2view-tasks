#!/bin/bash

# Fabric API/WS Hardening

## Run the following script on one of the Fabric nodes to generate the following key: k2vws.key
mkdir $K2_HOME/.ssl

keytool -genkey -noprompt \
        -keyalg RSA \
        -alias selfsigned \
        -alias alias1 \
        -dname "CN=k2view.com, OU=SU, O=k2view, L=k2v, S=k2v, C=TLV" \
        -keystore $K2_HOME/.ssl/k2vws.key \
        -storepass Q1w2e3r4t5 \
        -validity 760 \
        -keysize 4096 \
        -keypass Q1w2e3r4t5


## Copy the k2vws.key key to all Fabric nodes

tar -czvf k2vmws.tar.gz -C $K2_HOME/.ssl .
#scp k2vmws.tar.gz fabric@10.10.10.10:/opt/apps/fabric/
#mkdir -p $K2_HOME/.ssl && tar -zxvf k2vmws.tar.gz -C $K2_HOME/.ssl

## Configure Fabric to use TLS for API or WebUI

sed -i "s@^WEB_SERVICE_PORT=@#WEB_SERVICE_PORT=@" $K2_HOME/config/config.ini
sed -i "s@^#WEB_SERVICE_SECURE_PORT=.*@WEB_SERVICE_SECURE_PORT=9443@" $K2_HOME/config/config.ini
sed -i "s@^#WEB_SERVICE_CERT=.*@WEB_SERVICE_CERT=$K2_HOME/.ssl/k2vws.key@" $K2_HOME/config/config.ini
sed -i 's@^#WEB_SERVICE_CERT_PASSPHRASE=.*@WEB_SERVICE_CERT_PASSPHRASE=Q1w2e3r4t5@g' $K2_HOME/config/config.ini
echo "ENABLE_INTER_NODES_SSL=true" >> $K2_HOME/config/config.ini
chown fabric.fabric $K2_HOME/.ssl/k2vws.key

##Check access to Fabric Web UI via HTTPS
# https://10.10.10.10:9443/deploy

## Turn on TLS for the Fabric driver protocol
# SECURE=true








