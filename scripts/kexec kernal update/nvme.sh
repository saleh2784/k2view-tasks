#!/bin/bash 

if [[ $(id -un) != 'root' ]]; then
  echo 'must be root'
  exit 1
fi
ERR_COUNT=0
grep -q 'will\ destroy' /root/cassandra_conf_nvme.sh
ERR_COUNT=$(( ERR_COUNT + $? ))
grep -q cassandra_conf_nvme.sh.out /etc/rc.d/rc.local
ERR_COUNT=$(( ERR_COUNT + $? ))
if [[ $ERR_COUNT -eq 0 ]]; then
  echo "ok to reboot"
else
  echo "ERROR: DO NOT REBOOT, fix scripts first"
fi
