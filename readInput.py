# script python qui scrute une entrée numérique et compte les fronts montants 
# pendant 15minutes. A l'origine pour compter le nombre de fois qu'une LED
# s'allume sur la carte HNC0037 (Lumiplan, carte de chaînage vidéo)
# auteur : vivien, décembre 2017

import time
import subprocess
from RPi import GPIO
b1=17
nbre=0

GPIO.setmode(GPIO.BCM)
GPIO.setup(b1, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.add_event_detect(b1, GPIO.RISING, bouncetime=10)

proc = subprocess.Popen(['date +"%D-%T"'], stdout=subprocess.PIPE, shell=True)
(out_date, err) = proc.communicate()

timeout = time.time() + 900   # 15 minutes from now

with open('/home/pi/countRed.log', 'a') as f1:
	f1.write("script started at :" + out_date.rstrip() + "\n")

while time.time() < timeout:
        if GPIO.event_detected(b1):
        	nbre += 1
#	print nbre
	time.sleep(0.04)

proc = subprocess.Popen(['date +"%D-%T"'], stdout=subprocess.PIPE, shell=True)
(out_date, err) = proc.communicate()

with open('/home/pi/countRed.log', 'a') as f1:
	f1.write("number counted : " + str(nbre) + "\n")
	f1.write("script stopped at :" + out_date.rstrip() + "\n")
