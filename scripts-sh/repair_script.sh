#!/bin/bash

# How to run the script:

if [ "$1" == "" ] && [ "$2" == "" ];
then
    echo "README"
    echo ""
    echo " See below how to run the script :"
    echo ""
    echo " Please enter the node and the kespace in the script :"
    echo ""
    echo " ./[script_name] [node_to_start_from_arg] [keyspace_to_start_from_arg] "
    echo ""
    echo " Nodes : START_FROM_: NODE1(10.21.3.48) - NODE2(10.21.3.49) - NODE3(10.21.3.50) - ALLNODES "
    echo " Kespaces : START_FROM_: system_auth - system_distributed - k2batchprocess - k2auth - k2audit - k2_commons - ALLKEYSPACES  "
    echo ""
    echo " example : ./repair_script.sh ALLNODES ALLKEYSPACES "
    echo ""
    echo " second example : ./repair_script.sh START_FROM_NODE2 START_FROM_k2batchprocess "
    echo ""
exit 1
fi

# create folder for logs :

HOME="$K2_HOME"
REPAIR_D=$HOME/cassandra/logs/repair

if [ ! -d "$REPAIR_D" ];
then
  echo "the folder is doesn't exist. creating now.... "
  cd "$HOME"/cassandra/logs || exit
  mkdir repair
  echo "File created"
else
    echo "folder exist..."
fi

#Cassandra nodes :
node1=10.21.3.48
node2=10.21.3.49
node3=10.21.3.50

#Array with nodes :
ALLNODES=("$node1" "$node2" "$node3" )
START_FROM_NODE2=("$node2" "$node3") 
START_FROM_NODE3=("$node3")

#Keyspaces :
system_auth=system_auth
system_distributed=system_distributed
k2batchprocess=k2batchprocess
k2auth=k2auth
k2audit=k2audit          
k2_commons=k2_commons

#Array with Keyspaces :
ALLKEYSPACES=( "$system_auth" "$system_distributed" "$k2batchprocess" "$k2auth" "$k2audit" "$k2_commons" )
START_FROM_system_auth=( "$system_auth" "$system_distributed" "$k2batchprocess" "$k2auth" "$k2audit" "$k2_commons" )
START_FROM_system_distributed=( "$system_distributed" "$k2batchprocess" "$k2auth" "$k2audit" "$k2_commons" )
START_FROM_k2batchprocess=( "$k2batchprocess" "$k2auth" "$k2audit" "$k2_commons" )
START_FROM_k2auth=( "$k2auth" "$k2audit" "$k2_commons" )
START_FROM_k2audit=( "$k2audit" "$k2_commons" )
START_FROM_k2_commons=( "$k2_commons" )

#init array
CURRENT_NODES_ARR=$ALLNODES
CURRENT_KEYSPACE_ARR=$ALLKEYSPACES

#check argument: node to start repair from
if [ "$1" = "ALLNODES" ]; then
    CURRENT_NODES_ARR=("${ALLNODES[@]}")
elif [ "$1" = "START_FROM_NODE2" ]; then
    CURRENT_NODES_ARR=("${START_FROM_NODE2[@]}")
elif [ "$1" = "START_FROM_NODE3" ]; then
    CURRENT_NODES_ARR=("${START_FROM_NODE3[@]}")
else
    exit 1
fi

#check argument: keyspace to start repair from
if [ $2 = "ALLKEYSPACES" ]; then
    CURRENT_KEYSPACE_ARR=("${ALLKEYSPACES[@]}")
elif [ $2 = "START_FROM_system_auth" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_system_auth[@]}")
elif [ $2 = "START_FROM_system_distributed" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_system_distributed[@]}")
elif [ $2 = "START_FROM_k2batchprocess" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_k2batchprocess[@]}")
elif [ $2 = "START_FROM_k2auth" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_k2auth[@]}")
elif [ $2 = "START_FROM_k2audit" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_k2audit[@]}")
elif [ $2 = "START_FROM_k2_commons" ]; then
    CURRENT_KEYSPACE_ARR=("${START_FROM_k2_commons[@]}")
else
    exit 1
fi

#Array sizes
SIZE_CURRENT_NODES=$((${#CURRENT_NODES_ARR[@]}))
SIZE_CURRENT_KEYSPACES=$((${#CURRENT_KEYSPACE_ARR[@]}))
HOME="$K2_HOME"

#looping through the nodes
for ((i = 0; i < "$SIZE_CURRENT_NODES"; i++)); do
    currentNode=${CURRENT_NODES_ARR[$i]}
    echo "$(date) Running repair on node $currentNode"
    #looping through keyspaces
    for ((j = 0; j < "$SIZE_CURRENT_KEYSPACES"; j++)); do
        currentKeyspace=${CURRENT_KEYSPACE_ARR[$j]}
        
        #show the proccess repair keyspace on the screen 1 by 1 in loop
        echo "$(date) Repair started for keyspace $currentKeyspace "$" $currentNode"        
       
        #repair command on current node and ks
        nodetool -u cassandra -pw cassandra -h "$currentNode" repair "$currentKeyspace" -j 4 -pr -local -seq >>"$HOME"/cassandra/logs/repair/"$currentNode""-""$currentKeyspace".log
        echo "Repair done for $currentKeyspace"
    done
    
    #reinit with all keyspaces
    CURRENT_KEYSPACE_ARR=("${ALLKEYSPACES[@]}")
    SIZE_CURRENT_KEYSPACES=$((${#CURRENT_KEYSPACE_ARR[@]}))
    echo "$(date) Repair done for node $currentNode"
done