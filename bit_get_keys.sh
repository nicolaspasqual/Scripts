#!/usr/bin/env bash

#------------------------------------VARS--------------------------------------------

IMSI_LIST="/opt/bit-get-keys/imsi_list.txt"
BIT_LOG="/opt/bit-get-keys/bit_log.log"
MAIL="/opt/bit-get-keys/mail.txt"
TARGET_MAIL="Ofir.Shvietski@cognyte.com,sasson.setty@cognyte.com,nicolas.pasqual@cognyte.com"
SOURCE_MAIL="devops.br@cognyte.com"
SUBJECT_MAIL="BIT KEYS"
SERVER_MAIL="10.120.1.20:25"
MINWAIT=0
MAXWAIT=86000

#------------------------------------EXECUTION---------------------------------------
sleep $((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))

function send_zabbix {
    zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k "discovery.keys" -v -s "Get_keys_bit" -o '{"data":[{"{#IMSI}":"'$imsi':'$country':'$operator':'$tecnology'","value":"1"}]}'
    zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k imsi.["$imsi:$country:$operator:$tecnology"] -v -s "Get_keys_bit" -o ["$result_imsi-$result_error"]
}

function send_mail {
    sendemail -f "$SOURCE_MAIL" -t "$TARGET_MAIL" -u "$SUBJECT_MAIL" -s "$SERVER_MAIL"
}

function create_mail {
    if [ $result_imsi = 0 ] ; then continue
    else
    echo " COUNTRY: $country - IMSI: $imsi - TECNOLOGY: $tecnology - OPERATOR: $operator - RESULT: Error[$result_imsi] - DESCRIPTION: $result_error " >> $MAIL
    echo " " >> $MAIL
    fi
}

rm -rf $MAIL

while read -r line
do 
    [ "$( echo $line | cut -c 1)" = "#" ] && continue
    [ ! $line ] && continue

    country=$( echo "$line" | cut -d , -f 1)
    operator=$( echo "$line" | cut -d , -f 2)
    mcc=$( echo "$line" | cut -d , -f 3)
    mnc=$( echo "$line" | cut -d , -f 4)
    tecnology=$( echo "$line" | cut -d , -f 5)
    imsi=$( echo "$line" | cut -d , -f 6)
    result_imsi=$(python /opt/bit-get-keys/cli.py --auth --imsi "$imsi" --domain CS --number_of_vectors 1 -H 10.120.1.61 -P 2468 --technolog $tecnology --mcc $mcc --mnc $mnc | grep error: | cut -d : -f2)
    result_error=$(python /opt/bit-get-keys/cli.py --auth --imsi "$imsi" --domain CS --number_of_vectors 1 -H 10.120.1.61 -P 2468 --technolog $tecnology --mcc $mcc --mnc $mnc | grep error_description: | cut -d : -f2)

create_mail
send_zabbix

done < "$IMSI_LIST"

send_mail < "$MAIL"

