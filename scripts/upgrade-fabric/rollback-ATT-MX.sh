#!/bin/bash


k2fabric stop

rm -rf fabric
mv fabric_fabric-6.5.2_74-HF1 fabric

rm -rf apps
mv apps_fabric-6.5.2_74-HF1 apps

rm -rf config_fabric-6.5.2_74-HF1

k2fabric start

ll
