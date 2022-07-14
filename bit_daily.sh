#!/usr/bin/env bash

#------------------------------------VARS--------------------------------------------

IMSI_LIST="/opt/bit-cdl/hotlist.csv"

#------------------------------------EXECUTION---------------------------------------

function send_zabbix {
    zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k "discovery.bit" -v -s "bit" -o '{"data":[{"{#IMSI}":"'$imsi':'$country':'$operator'","value":"1"}]}'
    zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k imsi.["$imsi:$country:$operator"] -v -s "bit" -o ["$result_imsi-$result_error"]
}


while read -r line
do 
    [ "$( echo $line | cut -d , -f 1)" = "country" ] && continue
    [ ! $line ] && continue

    country=$( echo "$line" | cut -d , -f 1)
    operator=$( echo "$line" | cut -d , -f 3)
    mcc=$( echo "$line" | cut -d , -f 2)
    mnc=$( echo "$line" | cut -d , -f 4)
    type=$( echo "$line" | cut -d , -f 5)
    imsi=$( echo "$line" | cut -d , -f 6)

    if [ "$type" = "LocationFromIMSI" ]; then 
        result_imsi=$(python /opt/bit-daily/cli.py -H 10.120.1.5 -P 2468  -T 240 --customer_id customer_test_id --unit_id unit_test_id --location_from_imsi  --imsi $imsi | grep error: | cut -d : -f2)
        result_error=$(python /opt/bit-daily/cli.py -H 10.120.1.5 -P 2468  -T 240 --customer_id customer_test_id --unit_id unit_test_id --location_from_imsi  --imsi $imsi | grep error_description: | cut -d : -f2)
    else
        result_imsi=$(python /opt/bit-daily/cli.py -H 10.120.1.5 -P 2468  -T 240 --customer_id customer_test_id --unit_id unit_test_id --location_from_imsi  --msisdn $imsi | grep error: | cut -d : -f2)
        result_error=$(python /opt/bit-daily/cli.py -H 10.120.1.5 -P 2468  -T 240 --customer_id customer_test_id --unit_id unit_test_id --location_from_imsi  --msisdn $imsi | grep error_description: | cut -d : -f2)
    fi    

send_zabbix

done < "$IMSI_LIST"
