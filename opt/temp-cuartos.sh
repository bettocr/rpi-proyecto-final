#!/bin/bash

# 
#	Realizado por: Roberto Arias (@bettocr)
#	
#	Obtiene la temperatura que proviene del arduino
#	realiza diferente funciones
#
#	Alertas si temperatura es mayor a TMAX o es critia en frio TMIN   
#	y twittea cuando la emperatura cambia en x grados.


TEMP=`cat /tmp/RFtemp0.txt`
TMP=`cat /tmp/cuarto1.txt`
FECHA=`date`
DIF=`echo $TMP-$TEMP | bc`
DATO=${#TEMP}		#cuantos caracteres contiene la variable
DATO1=${#TMP}
TMAX=29                #temperatura maxiama
TMIN=15		       #temperatura minima

logger -i  "Cuarto 1 TEMP "$TEMP" TMP "$TMP" DATO "$DATO" DIF "$DIF

if [ $DATO -ne 0 ] && [ $DATO1 -ne 0 ] ; then 
if [ $TEMP == $TMP ] ; then
		logger -i "Cuarto 1 sin cambios"$TEMP" "$TMP
	#	echo $FECHA" "$TEMP" "$HUME >> /home/pi/prueba.txt

else

                echo $FECHA" Cuarto 1 "$TEMP" " >> /home/pi/prueba.txt
                echo $TEMP > /tmp/cuarto1.txt
		echo "Temperatura Cuarto uno: "$TEMP" grados "" Temperatura anterior: "$TMP" grados  "  |iconv -f utf-8 -t iso-8859-1| festival --tts
		logger -i "Cuarto 1 con cambios"
		if [ $DIF -le -2 ] || [ $DIF -ge 2 ] ; then
			/opt/aviso.sh "Temperatura Oficina" "Aumento de mas de 2 Grados en la oficina. "$TEMP" Grados Centigrados"
			#ttytter -status="Room1 temperature  "$TEMP"º"
		        logger -i "mensaje pushover y twitter"
		fi
		if [ $TEMP -ge $TMAX ] && [ $FAN -eq 0 ] ; then

			/opt/aviso.sh "Temperatura Cuarto 1 "$TEMP" Grados"
			logger -i "Esta muy caliente "$TEMP
		fi
		if [ $TEMP -le $TMIN ] ; then
			/opt/aviso.sh "Temperatura Cuarto 1 "$TEMP" Grados"
                        logger -i "Esta muy frio "$TEMP
		fi

fi
fi
if [ $DATO1 -eq 0 ] ; then
	echo 0 > /tmp/cuarto1.txt
fi
