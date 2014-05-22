#!/usr/bin/env sh

# 
#	Realizado por: Roberto Arias (@bettocr)
#	
#	Permite enviar un aviso a moviles por medio
#	del API de PushOver
#



URL="https://api.pushover.net/1/messages.json"
API_KEY="SU-API-KEY"
USER_KEY="SU-USER-KEY"
DEVICE="all"
SOUND="magic"
PRIORITY="0"

TITLE="${1}"
MESSAGE="${2}"

curl \
  	-F "token=${API_KEY}" \
        -F "user=${USER_KEY}" \
        -F "device=${DEVICE}" \
        -F "title=${TITLE}" \
        -F "message=${MESSAGE}" \
        -F "sound=${SOUND}" \
        -F "priority=${PRIORITY}" \
"${URL}" > /dev/null 2>&1
ttytter -status="Send an Alert Message by pushover"
