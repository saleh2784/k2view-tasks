#!/bin/bash

## Stop fabric & iidfinder servers

echo "stop fabric & iid-finder"

k2fabric stop

# fabric/scripts/iid_finder_stop.sh

sleep 5

## Backup the config & fabric & apps

echo "started to backup config & fabric & apps ...."

cp -r "config" "config_fabric_bk"

mv "fabric" "fabric_bk"

mv "apps" "apps_bk"

#####################################################################
                # vaildation for exisit folders #
#####################################################################

# CONFIG=config_fabric-6.5.4_96-HF2
CONFIG="config_fabric_bk"

if [ -d "$CONFIG" ]; then
    echo "the folder $CONFIG ^^ exists ^^."
else
    echo "ERROR: the folder $CONFIG does not exist."
    exit 1
fi

# FABRIC=fabric-6.5.4_96-HF2
FABRIC="fabric_bk"
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

## Download the fabric backage 

echo "started to downloding the fabric package ...."


#wget --no-check-certificate https://download.k2view.com/index.php/s/MqEoMNu9QuVnHeW/download 


## Untar the backage  "fabric & apps directoryes"

tar -zxvf download fabric apps

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

## Run the upgrade script "just in the first node"

echo "started the upgrade ...."

export FABRIC_HOME=$K2_HOME


cd "$K2_HOME"/fabric/upgrade/toV6.5.8 || exit


chmod +x iif_config_ini_IID_TOKEN_BINDER.sh


./iif_config_ini_IID_TOKEN_BINDER.sh "$FABRIC_HOME"/config/iifConfig.ini


# without ssl NTC the user name & password & hostname & port

# ./upgrade_script.sh cassandra cassandra 10.21.3.48 9042

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

# fabric/scripts/iid_finder.sh watchdog

## optional :

# echo "Do you want to start the fabric service ? yes OR no "  
# read -r state

# if [ "$state" == "yes" ] || [ "$state" == "y" ]
# then
#   date
#   k2fabric start
# else
#   echo "You can run the fabric service later :) "
# exit
# fi

# echo "Do you want to start the iidfinder service ? yes OR no "  
# read -r statei

# if [ "$statei" == "yes" ] || [ "$statei" == "y" ]
# then
#   date
#   fabric/scripts/iid_finder.sh watchdog
# else
#   echo "You can run the iidfinder  service later :) "
# exit
# fi



## Run this command below in cqlsh : (cassandra node) NTV the table :
# without ssl
# cat DESC k2auth.roles ; |cqlsh -u cassandra -p cassandra
# with ssl
# cat DESC k2auth.roles ; |cqlsh -u cassandra -p cassandra --ssl




