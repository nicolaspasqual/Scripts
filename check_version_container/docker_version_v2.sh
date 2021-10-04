#!/bin/bash
 
#--------------------------------VARIABLES--------------------------------------------------

CONTAINER_ID="/opt/scripts/node_exporter/containers_ID.txt"
CONTAINER_VERSION="/opt/scripts/node_exporter/versão_id.txt"
PROM="/opt/scripts/node_exporter/container.prom" 

#---------------------------------TEST---------------------------------------------------------
#As pasta do script existem? 
if [ ! -d "/opt/scripts/node_exporter" ]; then
  mkdir /opt/scripts
  mkdir /opt/scripts/node_exporter
fi

#--------------------------------EXECUTION----------------------------------------------------

rm $PROM
docker ps -a --format "{{.ID}}" > $CONTAINER_ID
docker container inspect $(cat $CONTAINER_ID) | jq -r '.[].Config.Image' > $CONTAINER_VERSION

while read -r line
do
container=$( echo "$line" | cut -d : -f1 )
version=$( echo "$line" | cut -d : -f2 )
echo "running_containers{name="\"$container"\",version="\"$version"\"} 1" >> $PROM
done < $CONTAINER_VERSION
chown -R node_exporter:node_exporter /opt/scripts/node_exporter/*
