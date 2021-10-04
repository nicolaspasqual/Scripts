#!/bin/bash
 
#--------------------------------VARIABLES--------------------------------------------------


CONTAINER_ID="/opt/scripts/node_exporter/containers_ID.txt"
CONTAINER_VERSION="/opt/scripts/node_exporter/versão_id.txt"
PROM="/opt/scripts/node_exporter/container.prom" 


#--------------------------------EXECUTION----------------------------------------------------
rm $PROM
docker ps -a --format "{{.ID}}" > $CONTAINER_ID
docker container inspect $(cat $CONTAINER_ID) | jq -r '.[].Config.Image' > $CONTAINER_VERSION

while read -r line
do
echo "$line"
container=$( echo "$line" | cut -d : -f1 )
version=$( echo "$line" | cut -d : -f2 )
echo "running_containers{name="$container",version="$version"} 1" >> $PROM
done < $CONTAINER_VERSION