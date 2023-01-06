#!/bin/bash

rm -rf $K2_HOME/.kafka_ssl
mkdir -p $K2_HOME/.kafka_ssl

PASSWORD=$1
KEY_STORE_PATH=$K2_HOME/.kafka_ssl
CA_Key="$KEY_STORE_PATH/ca-key.key"
CA_CRT="$KEY_STORE_PATH/ca-crt.crt"
Kafka_Server_Keystore="$KEY_STORE_PATH/kafka.server.keystore.jks"
Kafka_Server_CSR="$KEY_STORE_PATH/kafka.server.csr"
Kafka_Server_Signed_CRT="$KEY_STORE_PATH/kafka-server-signed.crt"
Kafka_Server_Truststore="$KEY_STORE_PATH/kafka.server.truststore.jks"
Kafka_Client_Keystore="$KEY_STORE_PATH/kafka.client.keystore.jks"
Kafka_Client_CSR="$KEY_STORE_PATH/kafka.client.csr"
Kafka_Client_Signed_CRT="$KEY_STORE_PATH/kafka-client-signed.crt"
Kafka_Client_Truststore="$KEY_STORE_PATH/kafka.client.truststore.jks"

## Server key setup

# Generate CA key

openssl req -new -x509 -keyout "$CA_Key" -out "$CA_CRT" -days 365 -subj '/CN=ca.k2view.ssl.kafka/OU=K2VIEW/O=K2VIEW/L=Israel/S=IL/C=IL' -passin pass:"$PASSWORD" -passout pass:"$PASSWORD"

# Create server keystore
keytool -genkey -noprompt -alias kafka -dname "CN=kafka,OU=K2VIEW,O=K2VIEW,L=Israel,S=IL,C=IL" -ext "SAN=dns:kafka,dns:localhost" -keystore "$Kafka_Server_Keystore" -keyalg RSA -storepass "$PASSWORD" -keypass "$PASSWORD"

# Create the certificate signing request (CSR)
keytool -keystore "$Kafka_Server_Keystore" -alias kafka -certreq -file "$Kafka_Server_CSR" -storepass "$PASSWORD" -keypass "$PASSWORD" -ext "SAN=dns:kafka,dns:localhost"

# Sign the server certificate with the certificate authority (CA)
openssl x509 -req -CA "$CA_CRT" -CAkey "$CA_Key" -in "$Kafka_Server_CSR" -out "$Kafka_Server_Signed_CRT" -days 9999 -CAcreateserial -passin pass:"$PASSWORD" -extensions v3_req -extfile <(cat <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = kafka
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = kafka
DNS.2 = localhost
EOF
)

# Sign and import the CA certificate into keystore
keytool -noprompt -keystore "$Kafka_Server_Keystore" -alias CARoot -import -file "$CA_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD"

# Sign and import the server certificate into keystore
keytool -noprompt -keystore "$Kafka_Server_Keystore" -alias kafka -import -file "$Kafka_Server_Signed_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD" -ext "SAN=dns:kafka,dns:localhost"

# Create truststore and import the CA certificate
keytool -noprompt -keystore "$Kafka_Server_Truststore" -alias CARoot -import -file "$CA_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD"





## Client key setup

# Create client keystore

keytool -genkey -noprompt -alias kafka -dname "CN=kafka,OU=K2VIEW,O=K2VIEW,L=Israel,S=Il,C=IL" -ext "SAN=dns:kafka,dns:localhost" -keystore "$Kafka_Client_Keystore" -keyalg RSA -storepass "$PASSWORD" -keypass "$PASSWORD"

# Create the certificate signing request (CSR)

keytool -keystore "$Kafka_Client_Keystore" -alias kafka -certreq -file "$Kafka_Client_CSR" -storepass "$PASSWORD" -keypass "$PASSWORD" -ext "SAN=dns:kafka,dns:localhost"

# Sign the client certificate with the certificate authority (CA)

openssl x509 -req -CA "$CA_CRT" -CAkey "$CA_Key" -in "$Kafka_Client_CSR" -out "$Kafka_Client_Signed_CRT" -days 9999 -CAcreateserial -passin pass:"$PASSWORD" -extensions v3_req -extfile <(cat <<EOF

[req]

distinguished_name = req_distinguished_name

x509_extensions = v3_req

prompt = no

[req_distinguished_name]

CN = kafka

[v3_req]

subjectAltName = @alt_names

[alt_names]

DNS.1 = kafka

DNS.2 = localhost

EOF

)

# Sign and import the CA certificate into keystore

keytool -noprompt -keystore "$Kafka_Client_Keystore" -alias CARoot -import -file "$CA_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD"

# Sign and import the client certificate into keystore

keytool -noprompt -keystore "$Kafka_Client_Keystore" -alias kafka -import -file "$Kafka_Client_Signed_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD" -ext "SAN=dns:kafka,dns:localhost"

# Create truststore and import the CA certificate

keytool -noprompt -keystore "$Kafka_Client_Truststore" -alias CARoot -import -file "$CA_CRT" -storepass "$PASSWORD" -keypass "$PASSWORD"