#!/bin/bash

# need to backup the common storage
k2fabric stop
# rm -rf download
rm -rf fabric
rm -rf apps
mv fabric-6.5.4_96-HF2/ fabric
mv fabric-6.5.4_96-HF2/ fabric

fabric-6.5.2_74-HF1
rm -rf config_fabric-6.5.4_96-HF2/
mv apps_bk/ apps
k2fabric start
# k2fabric -version
ll
