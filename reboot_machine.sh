#!/usr/bin/env bash

###### Initialisation des variables ######

# IP de la machine à tester
IP='192.168.100.86'
# temps en s au bout duquel la machine testée doit avoir booté
boot_time=80
# temps de pause entre 2 reboots
wait_time=10
# variable nrs -> nbre de reboots souhaités
nrs=2000
# date/heure formattée pour entrée log
heure1="date +'%D-%H.%M.%S'"
# date/heure formattée pour nom de fichier
heure2="date +'%Hh%M'"
# nbre de boots réussis
OK=0
# nbre de boots ratés
NOK=0
# adaptateur USB <-> RS232
adapt=`ls /dev | grep ttyUSB`

##########  fichiers de logs #########
# répertoire des logs
logDir="/home/pi/logs_reboots" 
# fichier de log machine
log_machine="$logDir/log_reboot.txt"
# fichier temporaire de log console série
log_temp="$logDir/tmp_log_serial.txt"
# fichier daté de log console série
log_serial="$logDir/fail_boot_`date +'%Hh%M'`.txt"

# initialisation du GPIO 17 comme sortie
gpio mode 0 output
gpio write 0 0

# initialisation de l'adaptateur RS232/USB
chmod +rw $adapt

# fonction pour logguer la sortie console de l'équipement en cas de non démarrage
log_serial()
{	ttylog -b 115200 -d $adapt > $log_temp &
	sleep $1
  pkill ttylog
}

# fonction pour afficher les résultats en temps réel sur afficheur LCD 16x2
affichage()
{	python /home/pi/i2c_lcd/write2lcd.py $1 $2
}

echo "`$heure1` : Démarrage du script" >> $log_machine

for i in `seq 1 $nrs`
do
  affichage $i $NOK
  gpio write 0 1
  echo "`$heure1` : boot start" >> $log_machine
  log_serial $boot_time
#  sleep $boot_time
  test_ping=$(ping -n -c 1 $IP -W 1 | grep "0 received") #> /dev/null
  if [[ $test_ping = "" ]]
   then 
	 echo "`$heure1` : OK La machine testée a correctement booté" >> $log_machine
	 ((OK+=1))
	 else 
	 echo "`$heure1` : NOK boot FAIL ! see $logDir/fail_boot_`date +%Hh%M`.txt" >> $log_machine
	 cp $log_temp $logDir/fail_boot_`date +%Hh%M`.txt
	 ((NOK+=1))
  fi
  gpio write 0 0
  sleep $wait_time
done
echo "`$heure1` : nbre de boots réussis : $OK, nbre de boots manqués : $NOK" >> $log_machine

exit 0
