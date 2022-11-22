#!/bin/bash

k2fabric stop
rm -rf download
rm -rf fabric
rm -rf apps
mv fabric-6.5.4_96-HF2/ fabric
rm -rf config_fabric-6.5.4_96-HF2/
mv apps_bk/ apps
k2fabric start

