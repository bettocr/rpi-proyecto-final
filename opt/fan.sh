#!/bin/bash

# 
#	Realizado por: Roberto Arias (@bettocr)
#	
#	Permite encender y apagar los abanicos conectados al relay
#	en el Puerto 6 wiringPI 2.
#
#	ejemplo encendido: ./fan.sh 1    
#	ejemplo apagado: ./fan.sh 0

if [ $1 -eq 1 ] ; then  
	gpio mode 6 out
	gpio write 6 1 
else
	gpio write 6 0
	gpio reset 
fi
