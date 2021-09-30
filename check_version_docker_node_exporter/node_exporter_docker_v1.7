#!/bin/bash

#--------------------------------VARIABLES--------------------------------------------------

CONTAINER_ID="/opt/scripts/containers_ID.txt"
CONTAINER_VERSION="/opt/scripts/versão_id.txt"


#--------------------------------EXECUTION----------------------------------------------------
rm /var/lib/prometheus/node-exporter/*.prom

docker ps -a | cut -d ' ' -f1 > /opt/scripts/containers_ID.txt
sed -i 1d /opt/scripts/containers_ID.txt

docker inspect $(cat $CONTAINER_ID) | jq -r '.[].Config.Image' | sed 's/\./_/g;s/\:/_/g;s/\//_/g' > /opt/scripts/versão_id.txt

while read -r line
do
line2=$( echo "$line" | cut -d _ -f1)
touch /var/lib/prometheus/node-exporter/"$line2".prom
echo "# HELP to find docker version DOCKER metric docker_version
#TYPE docker_version
docker_version_"$line" 0" > /var/lib/prometheus/node-exporter/"$line2".prom
done < $CONTAINER_VERSION
