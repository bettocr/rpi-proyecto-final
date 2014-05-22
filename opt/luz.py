#!/usr/bin/env python

#	Realizado por: Roberto Arias (@bettocr)
#	
#	Permite encender y apagar luces leds
#	

import RPi.GPIO as GPIO, time, os      

GPIO.setmode(GPIO.BCM)
on = 0 # luces encendidas
MAX=5200 # luminocidad maxima antes de encender el led, entre mayor mas oscuro
PIN=23   # pin al relay
PINRC=24 #pin que lee la photocell

GPIO.setup(PIN,GPIO.OUT)
def RCtime (RCpin):
        reading = 0
        GPIO.setup(RCpin, GPIO.OUT)
        GPIO.output(RCpin, GPIO.LOW)
        time.sleep(0.1)

        GPIO.setup(RCpin, GPIO.IN)
        
        while (GPIO.input(RCpin) == GPIO.LOW):
                reading += 1
        return reading

while True:                                     
        #print RCtime(24)     
	luz = RCtime(PINRC)
	if luz > MAX:
	 	GPIO.output(PIN,True)
		on = 1
        
	if luz < MAX and on == 1:
		GPIO.output(PIN,False)
		
		on = 0
	
	
