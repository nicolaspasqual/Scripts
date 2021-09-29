#!/bin/bash
 
#--------------------------------VARIAVEIS--------------------------------------------------
 
CONTAINER_ID="/opt/scripts/containers_ID.txt"
CONTAINER_VERSION="/opt/scripts/versão_id.txt"
 
#--------------------------------EXECUÇÃO----------------------------------------------------
 
docker ps -a --format "{{.ID}}" > /opt/scripts/containers_ID.txt
 
docker container inspect $(cat $CONTAINER_ID) | jq -r '.[].Config.Image' | sed 's/\./_/;s/\./_/;s/\:/_/' > /opt/scripts/versão_id.txt
 
while read -r linha 
do 
touch /var/lib/prometheus/node-exporter/"$linha".prom
echo "# HELP to find docker version DOCKER metric docker_version
#TYPE docker_version
docker_version_"$linha" 0" > /var/lib/prometheus/node-exporter/"$linha".prom
done < /opt/scripts/versão_id.txt