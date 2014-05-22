#!/bin/bash

# 
#	Realizado por: Roberto Arias (@bettocr)
#	
#	Obtiene la temperatura de modulo DTH11 y segun esta
#	realiza diferente funciones
#
#	Alertas si temperatura es mayor a TMAX    
#	y twittea cuando la emperatura cambia en x grados.


TEMP=`/usr/bin/dth11 | awk -F ",*" '{ print $2}'`
HUME=`/usr/bin/dth11 | awk -F ",*" '{ print $1}'`
TMP=`cat /tmp/dht11.txt` #temperatura anterior
FAN=`cat /tmp/fan`       #abanico encendido
FECHA=`date`
DIF1=`echo "$TMP-$TEMP" | bc`
DIF=${DIF1/\.*}
TEMP1=${TEMP/\.*}
TMP1=${TMP/\.*}
DATO=${#TEMP1}

TMAX=28                #temperatura maxiama

logger -i  "TEMP "$TEMP" TEMP1 "$TEMP1" TMP "$TMP1" DATO "$DATO" DIF "$DIF" DIF1 "$DIF1" fan "$FAN

if [ $DATO -ne 0  ] && [ $TEMP1 == $TMP1 ] ; then
		logger -i "DTH11 funciono"
	#	echo $FECHA" "$TEMP" "$HUME >> /home/pi/prueba.txt

else
	   if [ $DATO -ne 0 ] ; then
                echo $FECHA" "$TEMP" "$HUME >> /home/pi/prueba.txt
                echo $TEMP > /tmp/dht11.txt
		# /opt/aviso.sh "TEMPeratura" "Temperatura "$TEMP" Humedad "$HUME" Temperatura anterior "$TMP" fecha: "$FECHA
		#espeak -v es "Temperatura "$TEMP" Humedad "$HUME" Temperatura anterior "$TMP" " --stdout -a 300 -s 130| aplay
		echo "Temperatura: "$TEMP" grados centigrados, Humedad: "$HUME"%, Temperatura anterior: "$TMP" grados centigrados "  |iconv -f utf-8 -t iso-8859-1| festival --tts
		logger -i "DTH11 funciono"
		if [ $DIF -le -2 ] || [ $DIF -ge 2 ] ; then
			/opt/aviso.sh "Temperatura Oficina" "Aumento de mas de 2 Grados en la oficina. "$TEMP" Grados Centigrados"
			#ttytter -status="Office temperature  "$TEMP"ºC, Humidity "$HUM "%"
		logger -i "mensaje"
		fi
		if [ $TEMP1 -ge $TMAX ] && [ $FAN -eq 0 ] ; then
			#echo abanico
			#gpio mode 6 out
			#gpio write 6 1
			sudo /opt/fan.sh 1
			echo 1 > /tmp/fan
			/opt/aviso.sh "Temperatura Oficina" "La Temperatura oficina "$TEMP" Grados he encendio los abanidos del rack"
			logger -i "Aabanicos encendidos"
		fi
		if [ $TEMP1 -lt $TMAX ] ; then
			#gpio write 6 0 /opt/fan.sh 1 
			sudo /opt/fan.sh 0
			echo 0 > /tmp/fan
			logger -i "Abanicos Apagados"
			/opt/aviso.sh "Temperatura Oficinia" "apaga los abanicos"
		fi
	fi
fi
