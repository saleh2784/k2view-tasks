#!/bin/bash

## Stop fabric & iidfinder servers 
## first we need to stop the iidfider and fabric on all nodes 

echo "stop fabric & iid-finder"

fabric/scripts/iid_finder_stop.sh

k2fabric stop

sleep 5

## Backup the config & fabric & apps

echo "started to backup config & fabric & apps ...."

cp -r "config" "config_$(k2fabric -version |awk '{print $2}'|head -n1)"

mv "fabric" "$(k2fabric -version |awk '{print $2}'|head -n1)"

mv "apps" "apps_$(k2fabric -version |awk '{print $2}'|head -n1)"

#####################################################################
                # vaildation for exisit folders #
#####################################################################
# k2fabric -version |awk '{print $2}'|head -n1

CONFIG=config_fabric-6.5.2_74-HF1-6.5.2_74-HF1
if [ -d "$CONFIG" ]; then
    echo "the folder $CONFIG ^^ exists ^^."
else
    echo "ERROR: the folder $CONFIG does not exist."
    exit 1
fi

FABRIC=fabric-6.5.2_74-HF1
if [ -d "$FABRIC" ]; then
    echo "the folder $FABRIC ^^ exists ^^."
else
    echo "ERROR: the folder $FABRIC does not exist."
    exit 1
fi
APPS=apps_fabric-6.5.2_74-HF1
if [ -d "$APPS" ]; then
    echo "the folder $APPS ^^ exists ^^."
else
    echo "ERROR: the folder $APPS does not exist."
    exit 1
fi

## Download the fabric backage 

echo "started to downloding the fabric package ...."

# We have new package :
# HF-4
# wget --no-check-certificate https://download.k2view.com/index.php/s/rvc1vNoO0M8bLIT/download 
# HF-3
# wget --no-check-certificate https://download.k2view.com/index.php/s/69viXSMGwZtUbrB/download 


## Untar the backage  "fabric & apps directoryes"

tar -zxvf download fabric apps

#NTC the export 

export FABRIC_HOME=$K2_HOME

echo "#############################################################"
echo " check the fabric & apps folders if are exists "
echo "#############################################################"

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

echo "#####################################"
echo "the new version is :"
k2fabric -version

sleep 3 

################################################################

# echo "is this env with hardening ? yes OR no "  
# read state

# if [ $state == "yes" ]
# then
#   sed -i 's/cqlsh -u$1 -p$2 $3 $4/cqlsh -u$1 -p$2 $3 $4 --ssl/' /opt/apps/fabric/fabric/upgrade/toV6.5.8/upgrade_script.sh
# else
#   echo "this env with hardening"
# fi
################################################################
# sed -i 's/cqlsh -u$1 -p$2 $3 $4/cqlsh -u$1 -p$2 $3 $4 --ssl/' /opt/apps/fabric/fabric/upgrade/toV6.5.8/upgrade_script.sh

## Run the upgrade script "just in the first node"

echo "started the upgrade ...."

export FABRIC_HOME=$K2_HOME/fabric

cd "$K2_HOME/fabric/upgrade/toV6.5.8" || exit

#chmod +x upgrade_script.sh

chmod +x iif_config_ini_IID_TOKEN_BINDER.sh

# without ssl NTC the user name & password & hostname & port
# i will add if condetion for the first ip if = the first ip 
# cqlsh -u k2admin -p Q1w2e3r4t5 --ssl
# 10.237.98.149 : 9160

./iif_config_ini_IID_TOKEN_BINDER.sh "$FABRIC_HOME"/config/iifConfig.ini


#./upgrade_script.sh cassandra cassandra 10.21.3.48 9042


# we need to think about the cqlsh how to excute it on the first caasandra 
# with ssl NTC the user name & password & hostname & port

#./upgrade_script.sh cassandra cassandra 10.0.50.53 9142 --ssl

##############################################################################
           # Need vaildation before we start the fabric 
           # 1. if the script run correctly 
           # 2. added the "security_profiles set<text>" in TABLE k2auth.roles
##############################################################################


sleep 5

## Start the fabric & iidfinder

k2fabric start

sleep 3

fabric/scripts/iid_finder.sh watchdog

## optional :

# echo "Do you want to start the fabric service ? yes OR no "  
# read -r state

# if [ "$state" == "yes" ]
# then
#   date
#   k2fabric start
# else
#   echo "You can run the fabric service later :) "
# exit
# fi

# echo "Do you want to start the iidfinder service ? yes OR no "  
# read -r statei

# if [ "$statei" == "yes" ]
# then
#   date
#   fabric/scripts/iid_finder.sh watchdog
# else
#   echo "You can run the iidfinder  service later :) "
# exit
# fi



## Run this command below in cqlsh : (cassandra node) NTV the table :
# without ssl
# echo "DESC k2auth.roles ;" |cqlsh -u cassandra -p cassandra
# with ssl
# echo "DESC k2auth.roles ;" |cqlsh -u cassandra -p cassandra --ssl




