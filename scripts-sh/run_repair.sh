#!/bin/bash
## varibles 
USER_AAF="cassandra" ## $(cat /opt/app/cassandra/conf/AAFConnection.properties|grep ^aaf_id|sed -E 's/.*=(.*)/\1/')
PASS_AAF="cassandra" ## $(cat /opt/app/cassandra/conf/AAFConnection.properties|grep ^aaf_pass|sed -E 's/.*=(.*)/\1/')
HOST="localhost"
PORT=9042 ## 9142 with ssl
CQLSH="cqlsh -u $USER_AAF -p $PASS_AAF $HOST $PORT" ## cqlsh --ssl -u "$USER_AAF" -p "$PASS_AAF" $(hostname -f)
USER_TOOL="cassandra" # $(awk '{print $1}' /etc/cassandra/jmxremote.password)
PASS_TOOL="cassandra" # /etc/cassandra/jmxremote.password
NODETOOL="nodetool -u $USER_TOOL -pw $PASS_TOOL" # nodetool -Dcom.sun.jndi.rmiURLParsing=legacy --ssl -u $(awk '{print $1}' /etc/cassandra/jmxremote.password) -pwf /etc/cassandra/jmxremote.password -h $HOSTNAME
# NODETOOL="nodetool -Dcom.sun.jndi.rmiURLParsing=legacy --ssl -u $USER_TOOL -pwf $PASS_TOOL -h $HOST"
HOME="$K2_HOME"
REPAIR_D=$HOME/cassandra/logs/repair
LOGS_PATH="$HOME"/cassandra/logs/repair/
kespace=$("echo" "select * from system_schema.keyspaces;" | $CQLSH | grep "NetworkTopologyStrategy" | awk '{print $1}')
kfile="$HOME"/cassandra/logs/repair/kespace.txt
DATE_N=$(date +"%y-%m-%d*%H:%M:%p")
LOGFILE="$HOME"/cassandra/logs/repair/"$DATE_N""-"

## Function: Print a help message.
usage() {
  echo "Usage: $0 [-k Keyspace(Mandatory)] [-s skip (Option)] [-h help(Option)]" 1>&2
  echo "if you want to run the repair on all kesapese you will use $0 -k all "
  echo "Usage: $0 [-k all] " 1>&2
  echo "if you want to run the repair on specific kesapese or more you will use $0 -k name-kespase -k name-kespace -k name-kespace " 1>&2
  echo "Usage: $0 [-k kespace-name (spicific kespace or more)]" 1>&2
  echo "if you want to run repair on all kesapese without one kespaces or more you will use $0 -s name-kespase "
  echo "Usage: $0 [-s kespace-name] ( all keyspaces without this kespace - just 1 kespace )" 1>&2
  echo "Usage: $0 <<< the logs repair path is under : <<< "$LOGS_PATH" >>> "
  echo "Usage: $0 [-h] for help" 1>&2
  echo ""
  echo "****************************************"
  echo "list of the kespaces in the current node :"
  echo "****************************************"
  echo "$kespace"
  echo "****************************************"
}
## Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

## Print a help message when the first input blank
if [ "$1" == "" ]
then
    usage
fi

# create folder repair 
if [ ! -d "$REPAIR_D" ];
then
  cd "$HOME"/cassandra/logs || exit
  mkdir repair
fi

## copy the kespaces list into the kespace.txt 
echo "$kespace" >"$LOGS_PATH"kespace.txt


# echo "hello $@" that mean i can print any argummnet ulimted 
# cat $kfile | while read line

# getopts arguments k,s,h
while getopts "k:s:h" opt; do
case $opt in
k) ke=$OPTARG
if [ "$ke" == "all" ]
then 
  echo "*********************************************************************"
  echo "           repair are running in $OPTARG kespaces                  "
  echo "*********************************************************************"
  #for line in $(cat $kfile)
  while IFS= read -r line
  do
    for i in $line
      do
        echo ""
        echo "****************************************"
        echo "repair start >>>>>>>>>."
        echo "$(date) <<<< Repair started for: $i >>>> "
        $NODETOOL repair "$i" -j 4 -pr -local -seq >>"$LOGFILE""$i".log
        echo "$(date) ** Repair is done in keyspace ** (( $i )) **"
        echo "****************************************"
        echo ""
      done
done < "$kfile"

echo "^^^^^^^^^^ <<< the logs path is under : $LOGS_PATH >>> ^^^^^^^^^^ "

##########################################################################################################

elif [ "$ke" = "$ke" ]
then
    if grep -Fxq "$ke" "$kfile"
    then

        echo " <<<<<starting repair >>>>> "
        echo ""
    else
        echo "the kespace $ke is not found in the cassandra !!!! "
        exit
    fi
        echo "***********************************************************************************"
        echo "............ repair are running in kespace: $ke ............"
        echo "***********************************************************************************"
        echo ""
        # echo "*********************"
        echo "$(date) <<<< Repair started in keyspace $ke ....... >>>> "
        $NODETOOL repair "$ke" -j 4 -pr -local -seq >>"$LOGFILE""$ke".log
        echo "$(date) ** Repair is done in keyspace ** (( $ke )) **"
        # echo "*********************"
        echo ""
else
   usage   
fi
##########################################################################################################
;;
s)skip=$OPTARG 
echo "skip"
for w in $(cat $kfile)
do
    if [ "$skip" == "$w" ]
    then
      continue
    fi
    echo "$(date) <<<< Repair started in keyspace ""$w"" ....... >>>> "
    $NODETOOL repair "$w" -j 4 -pr -local -seq >>"$LOGFILE""$w".log
    echo "$(date) ** Repair is done in keyspace ** (( ""$w"" )) **"
done
;;
h) # help
echo "help"
usage
;;
\? ) #For invalid option
echo "You have to use: [-k] or [-s] or [-h]"
echo ""
usage
;;
esac
done


