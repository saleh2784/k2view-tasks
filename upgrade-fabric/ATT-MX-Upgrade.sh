#!/bin/bash

## Stop fabric & iidfinder servers 
## first we need to stop the iidfider and fabric on all nodes 

echo "stop fabric & iid-finder"

#fabric/scripts/iid_finder_stop.sh

k2fabric stop

sleep 5

echo "started to backup the common DB ...."

# copy the common DB: we need to save them in the same directory "$K2_HOME/storage/common"

common_preffix="$K2_HOME"storage/common/

cp "$common_preffix"common.db "$common_preffix"acc_search.db
cp "$common_preffix"common.db "$common_preffix"sub_search.db

# cp "$K2_HOME"/storage/common/common.db "$K2_HOME"/storage/common/acc_search.db
# cp "$K2_HOME"/storage/common/common.db "$K2_HOME"/storage/common/sub_search.db

## Backup the config & fabric & apps

backup_suffix=$(k2fabric -version |awk '{print $2}'|head -n1)

echo "started to backup config & fabric & apps ...."

cp -r "config" "config_$backup_suffix"

mv "fabric" "$backup_suffix"

mv "apps" "apps_$backup_suffix"

#####################################################################
                # vaildation for exisit folders #
#####################################################################

CONFIG=config_fabric-6.5.2_74-HF1
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

# echo "started to downloding the fabric package ...."

# We have new package 6.5.9-HF4 :

# wget --no-check-certificate https://download.k2view.com/index.php/s/rvc1vNoO0M8bLIT/download 

# package 6.5.9-HF3
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


## Run the upgrade script ##
# $K2_HOME = opt/k2view


echo "started the upgrade ...."

export FABRIC_HOME=$K2_HOME

cd "$K2_HOME/fabric/upgrade/toV6.5.8" || exit

chmod +x iif_config_ini_IID_TOKEN_BINDER.sh

./iif_config_ini_IID_TOKEN_BINDER.sh "$FABRIC_HOME"/config/iifConfig.ini


##############################################################################
           # Need vaildation before we start the fabric 
           # 1. if the script run correctly 
           # 2. added the "security_profiles set<text>" in TABLE k2auth.roles
           # 3.IID_TOKEN_BINDER was set
##############################################################################


sleep 5
echo "starting the fabric ..................."
##Start the fabric :

k2fabric start

# sleep 3

##Start the iidfinder :

# echo "starting the iid_finder ..................."
# fabric/scripts/iid_finder.sh watchdog

## Run this command below in cqlsh : (cassandra node) NTC the table :

## echo "DESC k2auth.roles ;" |cqlsh -u cassandra -p cassandra --ssl




