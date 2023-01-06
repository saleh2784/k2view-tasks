#!/bin/bash

## the current tombstone values :  ##
echo "Current values are :"
cat /opt/apps/cassandra/cassandra/conf/cassandra.yaml | grep tombstone_warn
cat /opt/apps/cassandra/cassandra/conf/cassandra.yaml | grep tombstone_failure

## change the tombstone values 
sed -i "s@tombstone_warn_threshold:.*@tombstone_warn_threshold: 100000@" /opt/apps/cassandra/cassandra/conf/cassandra.yaml
sed -i "s@tombstone_failure_threshold:.*@tombstone_failure_threshold: 500000@" /opt/apps/cassandra/cassandra/conf/cassandra.yaml

## check with cat ##
echo "New values are :"
cat /opt/apps/cassandra/cassandra/conf/cassandra.yaml | grep tombstone_warn
cat /opt/apps/cassandra/cassandra/conf/cassandra.yaml | grep tombstone_failure

## Validate the new values ##
new_val1="tombstone_warn_threshold: 100000"
new_val2="tombstone_failure_threshold: 500000"

VAL1=$(grep '^tombstone_warn' /opt/apps/cassandra/cassandra/conf/cassandra.yaml)
VAL2=$(grep '^tombstone_failure' /opt/apps/cassandra/cassandra/conf/cassandra.yaml)

if [[ "$new_val1" != "$VAL1" ]]; then
  echo "  ERROR: value '$VAL1' incorrect in cassandra.yaml, please fix" 
  exit 1
fi
if [[ "$new_val2" != "$VAL2" ]]; then
  echo "ERROR: value '$VAL2' incorrect in cassandra.yaml, please fix"
  exit 1
fi

echo "new values are ok"

sleep 5

## Stop Cassandra ##
echo "stop the cassandra service"
echo " waiting for stop cassandra ...................."

stop-server

# echo " waiting for stop cassandra ...................."

echo "check the service for cassandra: "

service=cassandra

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 2 ))
then
  echo "$service is still running!!!"
  exit 1
else
   echo "$service is stoped!!!"
fi

sleep 10

echo "start the cassandra service"

cassandra

sleep 15

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 2 ))
then
  echo "$service is running !!! "
  exit 1
else
   echo "$service is not running !!!"
fi

