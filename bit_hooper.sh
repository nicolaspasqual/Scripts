#!/usr/bin/env bash

#------------------------------------VARS--------------------------------------------

IMSI_LIST="/opt/bit-hooper/imsi_list.txt"
BIT_LOG="/opt/bit-hooper/bit_log.log"
#------------------------------------EXECUTION---------------------------------------
while read -r line
do 
imsi=$( echo "$line" | cut -d : -f 3)
country=$( echo "$line" | cut -d : -f 1)
operator=$( echo "$line" | cut -d : -f 2)
result_imsi=$(python /opt/bit-hooper/cli.py --auth --imsi "$imsi" --domain CS --number_of_vectors 1 -H 10.120.1.61 -P 2468 --technolog GSM | grep error: | cut -d : -f2) 
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k "dicovery.hooper" -v -s "Hooper_bit" -o '{"data":[{"{#IMSI}":"'$imsi':'$country':'$operator'","value":"1"}]}'
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k imsi.["$imsi:$country:$operator"] -v -s "Hooper_bit" -o $result_imsi
done < "$IMSI_LIST"