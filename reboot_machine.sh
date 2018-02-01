#!/usr/bin/env bash

###### Initialisation des variables ######

# fichier de log
log="/home/pi/log_reboot.txt"
# IP de la machine à tester
IP='192.168.100.12'
# temps en s au bout duquel la machine testée doit avoir booté
boot_time=10
# temps de pause entre 2 reboots
wait_time=5
# variable nrs -> nbre de reboots souhaités
nrs=20
# date/heure formattée
heure="date +'%D-%H.%M.%S'"
# nbre de boots réussis
OK=0
# nbre de boots ratés
NOK=0

# initialisation du GPIO 17 comme sortie
gpio mode 0 output

echo "`$heure` : Démarrage du script" >> $log

for i in `seq 1 $nrs`; do
  gpio write 0 1 # alim ON
  echo "`$heure` : boot start" >> $log
  sleep $boot_time
  test_ping=$(ping -n -c 1 $IP -W 1 | grep "0 received") > /dev/null
  if [[ $test_ping = "" ]]; then 
	echo "`$heure` : OK La machine testée a correctement booté" >> $log
	((OK+=1))
	else 
	echo "`$heure` : NOK boot FAIL !" >> $log
	((NOK+=1))
  fi
  gpio write 0 0 # alim OFF
  sleep $wait_time
done

echo "`$heure` : nbre de boots réussis : $OK, nbre de boots manqués : $NOK" >> $log

exit 0