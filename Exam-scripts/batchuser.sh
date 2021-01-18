#!/bin/bash

usage="Usage ./batchuser.sh VALOR"
if [ $# -eq 1 ]; then
	valor=$1
	ruta=/root/batch
	es_num='^[0-9]+$'
	if ! [[ $valor =~ $es_num ]]; then
	   echo "Error: Introduce un valor entero!" >&2; exit 0
	fi
	# Contiene el uptime pasado a decimal (convirtiendo la coma en un punto)
	var=`uptime | awk '{print $9}' | cut -d , -f 1,2`
	var=${var/,/.}
	
	valor="${valor}.0"
	#echo "$valor > $var" | bc
	if [ "`echo "${var} < ${valor}" | bc`" -eq 1 ]; then
		echo "El valor introducido es mayor al System Load Average :)"
	else
		for sc in $ruta/*.sh;
		do
				bash "$sc"
		done
		#bash /root/batch/hola.sh
		echo "Los scripts ejecutados han sido: "
		
		run-parts --list --regex '^h.*sh$' $ruta
	fi

else
	echo $usage
fi