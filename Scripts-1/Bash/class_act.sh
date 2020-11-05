#!/bin/bash

#Declaracion de Usage en caso de no ejecutar bien el programa
usage="Usage ./class_act.sh [ndias] [Nombre de usuario]"


#Comprobamos que tengan dos argumentos
if [ $# -eq 2 ]; then
	#Declaramos los diferentes argumentos como variables del programa
	time=$1
	user=$2
	peso_final=0
	contador=0
	
	#Buscamos el nick de usuario. Si el usuario no tiene nombre, sacara el mismo nick.
	usernick=`cat /etc/passwd | grep "$user" | cut -d: -f1`

	# Buscamos los ficheros de ese usuario que haya modificado.
	if [ $usernick != "root" ];then
		for fich in `find /home/$usernick -type f -user $usernick -mtime $time`;do
			#contador nos cuenta el numero de ficheros modificados
			contador=$(($contador+1))
			peso=`du -bs $fich | cut -f1`

			#vamos sumando lo que ocupa cada archivo para saber la ocupacion final.
			peso_final=$(($peso_final+$peso))
		done
	else
		for fich in `find /$usernick -type f -user $usernick -mtime $time`;do
			#contador nos cuenta el numero de ficheros modificados
			contador=$(($contador+1))
			peso=`du -bs $fich | cut -f1`

			#vamos sumando lo que ocupa cada archivo para saber la ocupacion final.
			peso_final=$(($peso_final+$peso))
		done
	fi
		
	#En este punto pasamos a hacer las conversiones para que nos saque las magnitudes adecuadas.
	if [ ${peso_final%.*} -gt 1000 ];then
		#Comprobamos que podamos pasar a KB.
		peso_final=`echo "scale=3; $peso_final/1000" | bc -l`
		if [ ${peso_final%.*} -gt 1024 ];then
		#Comprobamos que podamos pasar a MB.
			peso_final=`echo "scale=3; $peso_final/1024" | bc -l`
			if [ ${peso_final%.*} -gt 1024 ];then
			#Comprobamos que podamos pasar a GB
				peso_final=`echo "scale=3; $peso_final/1024" | bc -l`
				echo "$user ($usernick) $contador ficheros modificados que ocupan $peso_final GB"
			else
				echo "$user ($usernick) $contador ficheros modificados que ocupan $peso_final MB"
			fi
		else
			echo "$user ($usernick) $contador ficheros modificados que ocupan $peso_final KB"
		fi
	else
		echo "$user ($usernick) $contador ficheros modificados que ocupan $peso_final B"
	fi
else
	echo $usage
fi
