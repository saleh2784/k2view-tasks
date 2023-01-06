#!/bin/bash


mkdir -p /opt/apps
chmod 755 /opt/apps
useradd -m -d /opt/apps/kafka kafka

######################################################################################

echo "root soft    nproc     unlimited" >> /etc/security/limits.conf
echo "cassandra - nofile 100000" >> /etc/security/limits.conf
echo "cassandra - nproc 50000" >> /etc/security/limits.conf
echo "fabric - nofile 100000" >> /etc/security/limits.conf
echo "fabric - nproc 50000" >> /etc/security/limits.conf
echo "kafka hard nofile 100000" >> /etc/security/limits.conf
echo "kafka soft nofile 100000" >> /etc/security/limits.conf
echo "kafka - nproc 50000" >> /etc/security/limits.conf
echo "kafka soft nofile 100000" >> /etc/security/limits.conf
echo "kafka - nproc 50000" >> /etc/security/limits.conf

######################################################################################

echo "## Added by K2view" >> /etc/sysctl.conf
echo "vm.max_map_count = 1048575" >> /etc/sysctl.conf
echo "fs.file-max = 1000000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 60" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 10" >> /etc/sysctl.conf
sysctl -p
