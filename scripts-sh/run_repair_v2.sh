#!/bin/bash

## varibles ## 
#cqlsh
USER_AAF="cassandra" ## $(cat /opt/app/cassandra/conf/AAFConnection.properties|grep ^aaf_id|sed -E 's/.*=(.*)/\1/')
PASS_AAF="cassandra" ## $(cat /opt/app/cassandra/conf/AAFConnection.properties|grep ^aaf_pass|sed -E 's/.*=(.*)/\1/')
HOST="localhost"
PORT=9042 ## 9142 with ssl
CQLSH="cqlsh -u $USER_AAF -p $PASS_AAF $HOST $PORT" ## cqlsh --ssl -u "$USER_AAF" -p "$PASS_AAF" $(hostname -f)
# nodetool 
USER_TOOL="cassandra" # $(awk '{print $1}' /etc/cassandra/jmxremote.password)
PASS_TOOL="cassandra" # /etc/cassandra/jmxremote.password
NODETOOL="nodetool -u $USER_TOOL -pw $PASS_TOOL" # nodetool -Dcom.sun.jndi.rmiURLParsing=legacy --ssl -u $(awk '{print $1}' /etc/cassandra/jmxremote.password) -pwf /etc/cassandra/jmxremote.password -h $HOSTNAME
# NODETOOL="nodetool -Dcom.sun.jndi.rmiURLParsing=legacy --ssl -u $USER_TOOL -pwf $PASS_TOOL -h $HOST"  ## for Prod
# others
HOME="$K2_HOME"  # NTC the $HOME in DTV
LOGS_PATH="$HOME"/cassandra/logs/repair/  ## path for the lod
keyspace=$("echo" "select * from system_schema.keyspaces;" | $CQLSH | grep "NetworkTopologyStrategy" | awk '{print $1}')
kfile="$HOME"/cassandra/logs/repair/keyspace.txt
DATE_N=$(date +"%y-%m-%d*%H:%M:%p")
LOGFILE="$HOME"/cassandra/logs/repair/"$DATE_N""-"

## Usage ##
usage() {
  
  echo "********************************************************************************************************"
  echo     "Usage: $0 [-k Keyspace(Mandatory)] [-s skip (Option)] [-l list keyspaces] [-h help] " 1>&2
  echo "********************************************************************************************************"
  echo ""
  echo "Usage: $0 [-l] Show the keyspaces" 1>&2
  echo ""
  echo ""
  echo "if you want to run the repair on all keyspaces use :"
  echo "Usage: $0 -k all " 1>&2
  echo ""
  echo "if you want to run the repair on a specific keyspace or more use :"
  echo "Usage: $0 -k keyspace-name" 1>&2
  echo ""
  echo "if you want to run the repair on more keyspaces use: "
  echo "Usage: $0 -k "\"keyspace1 keyspace2 keyspace3"\"" 1>&2
  echo ""
  echo "if you want to run all keyspaces except specific keyspace use: (it will skip the keyspace that you set)"
  echo "Usage: $0 -s keyspace-name " 1>&2
  echo ""
  echo "if you want to skip more keyspaces use: "
  echo "Usage: $0 -s "\"keyspace1 keyspace2 keyspace3"\" " 1>&2
  echo ""
}
# Function: Exit with error ##
exit_abnormal() {
  usage
  exit 1
}
## Function nodetool
run_nodetool() {

  echo "*********************************************************************"
  echo "           Repair are running on ($ak keyspaces)                  "
  echo "*********************************************************************"
  echo ""
  echo ">>>>>>> Repair Start <<<<<<<"
  echo ""
  echo "$(date) <<<< Repair is started for keyspace (( $ak )) >>>> "
  $NODETOOL repair "$ak" -j 4 -pr -local -seq >>"$LOGFILE""$ak".log
  echo "$(date) ** Repair is done in keyspace ** (( $ak )) **"
  echo ""
  echo ">>>>>>> Repair Done <<<<<<<"
  echo ""
  echo "-----------------------------------------------------" 
}

## Print a help message when the first input blank ##
if [ $# -eq 0 ] 
then
   usage
fi
# create folder repair ##

cd "$HOME"/cassandra/logs && mkdir -p repair ||  exit

# copy the list of the keyspace into keyspace.txt ##
echo "$keyspace" >"$LOGS_PATH"keyspace.txt

## getopts arguments ##
while getopts ":k:s:hl" opt; do
case ${opt} in
k)ks=$OPTARG
while IFS= read -r ak
  do
    if [ "$ks" == "all" ] ## run all keyspaces ##
    then
      run_nodetool
    elif [[ "$ks" == *"$ak"* ]] ## run specific keyspace ##
    then
      run_nodetool  
    fi
done < "$kfile"

echo "<<< the logs path is under : $LOGS_PATH >>>"
;;
s)skip=$OPTARG
while IFS= read -r ak
do
    if [[ "$skip" == *"$ak"* ]] ## skip specific keysapce ##
    then
        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        echo ""
        echo "skipping keyspace : ($ak)"
        echo ""
        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        continue 
    fi
        run_nodetool

done < "$kfile"

echo "<<< the logs path is under : $LOGS_PATH >>>"
;;
## list keysapces ##
l )
echo "**************************************************"
echo "list of the keyspaces in the Cassandra cluster :"
echo "**************************************************"
echo ""
echo "$keyspace"
echo ""
echo "**************************************************"
;;
h )
usage
;;
\? ) #For invalid option
echo ""
echo "Invalid option: $OPTARG , You have to use: [-k] or [-s] or [-h] or [-l]"
;;
: )
echo "Invalid option: $OPTARG requires an argument" 1>&2
echo "Usage: $0 [-h] for help" 1>&2
;;
esac
done
shift $((OPTIND -1))

# Check if the keyspace is exists 
#     if grep -Fx "$ke" $kfile
#     then
#         echo ""$ke" in the list"
#     else
#         echo "the kespace "$ke" is not found in the cassandra !!!! "
#         exit
#     fi

