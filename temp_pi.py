#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  2 13:45:24 2017

@author: vduckit
"""
import subprocess
import time

while True: #boucle sans fin
    # on récupère la date et l'heure système
    proc = subprocess.Popen(['date +"%D-%T"'], stdout=subprocess.PIPE, shell=True)
    (out_date, err) = proc.communicate()
    
    # on récupère la mesure du capteur de température
    mesure = subprocess.Popen(["cat /sys/bus/w1/devices/28-000009315fe7/w1_slave"], stdout=subprocess.PIPE, shell=True)
    (out_mesure, err) = mesure.communicate()
    
    # on ne garde que la valeur de température
    long = len(out_mesure)
    for i in range(0,long):
        if out_mesure[i] == 't':
            temperature = float(out_mesure[i+2:]) / 1000
    
    # on écrit la date + la mesure dans le fichier de log                            
    #with open('/var/www/html/index.html', 'a') as f1:
    #    f1.write(str(out_date.rstrip()) + " : " + str(temperature) + '<br>')
    with open('/var/log/temPi.log', 'a') as f1:
        f1.write(str(out_date.rstrip()) + " : " + str(temperature))
    time.sleep(120)
