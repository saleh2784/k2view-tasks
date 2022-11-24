#!/bin/bash

# we need to run the cp to other nides without password , we will use the 
# generate public & private key 
# transfer the private key to the other cassandra & fabric nodes 
# copy the key in the same node . need the path for the key 

# cp keys.tar.gz -i k.pem cassandra@10.10.10.10:/opt/apps/cassandra/

cp keys.tar.gz cassandra@10.10.10.10:/opt/apps/cassandra/


pscp -pw 'MyPa$$word' username@servername:/somedir/somefile ~/somedest