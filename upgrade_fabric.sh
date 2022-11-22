#!/bin/bash

## Stop fabric & iidfinder servers

echo "stop fabric & iid-finder"

k2fabric stop

# fabric/scripts/iid_finder_stop.sh

sleep 10

## Backup the config & fabric & apps

echo "started to backup config & fabric & apps ...."

cp -r config config_$(k2fabric -version |awk '{print $2}'|head -n1)

mv fabric $(k2fabric -version |awk '{print $2}'|head -n1)

mv apps apps_bk

#####################################################################
    # Need vaildation for exisit folders before we run the script
#####################################################################

CONFIG=config_fabric-6.5.4_96-HF2
if [ -d "$CONFIG" ]; then
    echo "the folder $CONFIG ^^ exists ^^."
else
    echo "ERROR: the folder $CONFIG does not exist."
    exit 1
fi

FABRIC=fabric-6.5.4_96-HF2
if [ -d "$FABRIC" ]; then
    echo "the folder $FABRIC ^^ exists ^^."
else
    echo "ERROR: the folder $FABRIC does not exist."
    exit 1
fi
APPS=apps_bk
if [ -d "$APPS" ]; then
    echo "the folder $APPS ^^ exists ^^."
else
    echo "ERROR: the folder $APPS does not exist."
    exit 1
fi

#/opt/apps/fabric/

## back to the old names 
## mv fabric-6.5.4_96-HF2/ fabric
## rm -rf config_fabric-6.5.4_96-HF2/
## mv apps_bk/ apps

## Download the fabric backage 

echo "started to downloding the fabric package ...."


wget --no-check-certificate https://download.k2view.com/index.php/s/MqEoMNu9QuVnHeW/download 


## Untar the backage  "fabric & apps directoryes"

tar -zxvf download fabric apps

## Check the current version 

k2fabric -version

sleep 5 

## Run the upgrade script "just in the first node"

echo "started the upgrade ...."

cd /opt/apps/fabric/fabric/upgrade/toV6.5.8

chmod +x upgrade_script.sh

# without ssl NTC the user name & password & hostname & port

./upgrade_script.sh cassandra cassandra 10.21.3.48 9042

# with ssl NTC the user name & password & hostname & port

#./upgrade_script.sh cassandra cassandra 10.0.50.53 9142 --ssl

##############################################################################
           # Need vaildation before we start the fabric 
           # 1. if the script run correctly 
           # 2. added the "security_profiles set<text>" in TABLE k2auth.roles
##############################################################################

FABRIC_NEW=fabric
if [ -d "$FABRIC_NEW" ]; then
    echo "the folder $FABRIC_NEW ^^ exists ^^."
else
    echo "ERROR: the folder $FABRIC_NEW does not exist."
    exit 1
fi
APPS_NEW=apps
if [ -d "$APPS_NEW" ]; then
    echo "the folder $APPS_NEW ^^ exists ^^."
else
    echo "ERROR: the folder $APPS_NEW does not exist."
    exit 1
fi
sleep 10 

## Start the fabric & iidfinder

# k2fabric start
# fabric/scripts/iid_finder.sh watchdog

## optional :

echo "Do you want to start the fabric service ? yes OR no "  
read state

if [ $state == "yes" ]
then
  date
  k2fabric start
else
  echo "You can run the fabric service later :) "
exit
fi

echo "Do you want to start the iidfinder service ? yes OR no "  
read state

if [ $state == "yes" ]
then
  date
  fabric/scripts/iid_finder.sh watchdog
else
  echo "You can run the iidfinder  service later :) "
exit
fi



## Run this command below in cqlsh : (cassandra node) NTV the table :
# without ssl
# cat DESC k2auth.roles ; |cqlsh -u cassandra -p cassandra
# with ssl
# cat DESC k2auth.roles ; |cqlsh -u cassandra -p cassandra --ssl




