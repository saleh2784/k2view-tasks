#!/bin/bash

####################
# run the commands below under the user root  
####################
# mkdir -p /opt/apps

# chmod 755 /opt/apps

# useradd -m -d /opt/apps/kafka kafka

######################################################################################

# echo "root soft    nproc     unlimited" >> /etc/security/limits.conf
# echo "cassandra - nofile 100000" >> /etc/security/limits.conf
# echo "cassandra - nproc 50000" >> /etc/security/limits.conf
# echo "fabric - nofile 100000" >> /etc/security/limits.conf
# echo "fabric - nproc 50000" >> /etc/security/limits.conf
# echo "kafka hard nofile 100000" >> /etc/security/limits.conf
# echo "kafka soft nofile 100000" >> /etc/security/limits.conf
# echo "kafka - nproc 50000" >> /etc/security/limits.conf
# echo "kafka soft nofile 100000" >> /etc/security/limits.conf
# echo "kafka - nproc 50000" >> /etc/security/limits.conf

######################################################################################

# echo "## Added by K2view" >> /etc/sysctl.conf
# echo "vm.max_map_count = 1048575" >> /etc/sysctl.conf
# echo "fs.file-max = 1000000" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_time = 60" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_keepalive_intvl = 10" >> /etc/sysctl.conf
# sysctl -p

######################################################################################
## Kafka user
##############3

wget --no-check-certificate https://download.k2view.com/index.php/s/IqMl8VVsfg24aY8/download
tar -zxvf download bash -l


sed-i "s @K2_HOME=.*@K2_HOME=$(pwd)@".bash_profile
bash -l 


cserver1=10.0.50.51
cserver2=10.0.50.52
cserver3=10.0.50.53

kserver1=10.0.50.51
kserver2=10.0.50.52
kserver3=10.0.50.53

cp -r $K2_HOME/fabric/config.template $K2_HOME/config

sed -i 's@-Xmx2G@-Xmx8G@' $K2_HOME/config/jvm.options
sed -i 's@-Xms2G@-Xms8G@' $K2_HOME/config/jvm.options

sed -i 's@#REPLICATION_OPTIONS=.*@REPLICATION_OPTIONS={ '"'"'class'"'"' : '"'"'NetworkTopologyStrategy'"'"', '"'"DC1"'"' : 3}@' $K2_HOME/config/config.ini
sed -i "s@#HOSTS=.*@HOSTS=$cserver1,$cserver2,$cserver3@" $K2_HOME/config/config.ini
sed -i "s@#USER=.*@USER=k2admin@" $K2_HOME/config/config.ini
sed -i "s@#PASSWORD=.*@PASSWORD=Q1w2e3r4t5@" $K2_HOME/config/config.ini
sed -i "s@#MESSAGES_BROKER_TYPE=.*@MESSAGES_BROKER_TYPE=KAFKA@" $K2_HOME/config/config.ini
sed -i "s@#BOOTSTRAP_SERVERS=.*@BOOTSTRAP_SERVERS=$kserver1:9093,$kserver2:9093,$kserver3:9093@" $K2_HOME/config/config.ini
sed -i "s@HOSTS=.*@HOSTS=$cserver1,$cserver2,$cserver3@" $K2_HOME/config/iifConfig.ini
sed -i "s@#USER=.*@USER=k2admin@" $K2_HOME/config/iifConfig.ini
sed -i "s@#PASSWORD=.*@PASSWORD=Q1w2e3r4t5@" $K2_HOME/config/iifConfig.ini
sed -i "s@#KAFKA_BOOTSTRAP_SERVERS=.*@KAFKA_BOOTSTRAP_SERVERS=$kserver1:9093,$kserver2:9093,$kserver3:9093@" $K2_HOME/config/iifConfig.ini
sed -i "s@#ZOOKEEPER_BOOTSTRAP_SERVERS=.*@ZOOKEEPER_BOOTSTRAP_SERVERS=$kserver1:2181,$kserver2:2181,$kserver3:2181@" $K2_HOME/config/iifConfig.ini
sed -i 's@#IIF_REPLICATION_OPTIONS=.*@IIF_REPLICATION_OPTIONS={ '"'"'class'"'"' : '"'"'NetworkTopologyStrategy'"'"', '"'"DC1"'"' : 3}@' $K2_HOME/config/iifConfig.ini
sed -i "s@#BOOTSTRAP_SERVERS=.*@BOOTSTRAP_SERVERS=$kserver1:9093,$kserver2:9093,$kserver3:9093@" $K2_HOME/config/iifConfig.ini



cp $K2_HOME/config/adminInitialCredentials.template  $K2_HOME/config/adminInitialCredentials
sed -i 's@user.*@k2consoleadmin/KW4RVG98RR9xcrTv@'  $K2_HOME/config/adminInitialCredentials



k2fabric start && k2fabric status
