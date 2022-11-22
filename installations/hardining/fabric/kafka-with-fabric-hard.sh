#!/bin/bash

## after we copied the key to the fabric nodes ##


## on the Fabric nodes use the following to extract

mkdir -p $K2_HOME/.kafka_ssl && tar -zxvf Kafka_keyz.tar.gz -C $K2_HOME/.kafka_ssl


# Connect Fabric to Kafka in TLS mode

k2fabric stop

# Configure Fabric connections to Kafka with SSL support.

sed -i s/#SSL_ENABLED=.*/SSL_ENABLED=true/g $K2_HOME/config/config.ini
sed -i s/#SSL_ENABLED=.*/SSL_ENABLED=true/g $K2_HOME/config/config.ini
sed -i s/#SECURITY_PROTOCOL=.*/SECURITY_PROTOCOL=SSL/g $K2_HOME/config/config.ini
sed -i "s@#TRUSTSTORE_LOCATION=.*@TRUSTSTORE_LOCATION=$K2_HOME/.kafka_ssl/kafka.client.truststore.jks@" $K2_HOME/config/config.ini
sed -i s/#TRUSTSTORE_PASSWORD=.*/TRUSTSTORE_PASSWORD=Q1w2e3r4t5/g $K2_HOME/config/config.ini
sed -i "s@#KEYSTORE_LOCATION=.*@KEYSTORE_LOCATION=$K2_HOME/.kafka_ssl/kafka.client.keystore.jks@" $K2_HOME/config/config.ini
sed -i s/#KEYSTORE_PASSWORD=.*/KEYSTORE_PASSWORD=Q1w2e3r4t5/g $K2_HOME/config/config.ini
sed -i s/#KEY_PASSWORD=.*/KEY_PASSWORD=Q1w2e3r4t5/g $K2_HOME/config/config.ini
sed -i s@#ENDPOINT_IDENTIFICATION_ALGORITHM=@ENDPOINT_IDENTIFICATION_ALGORITHM=@g $K2_HOME/config/config.ini

# Start Fabric
k2fabric start











