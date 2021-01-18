#!/bin/bash

#Es vol fer un script, packg.py que mostri informació sobre paquets del sistema.
#Ha de tenir l’opció d’introduir el tipus de paquet que es vol mostrar

usage="Usage ./packg.sh <nom_paquet>"
if [ $# -eq 1 ]; then
	namepackage=$1
	# Filtrado por nombre de paquete, borrando la columna 0, para poder filtrar en el bucle con el parámetro ^ y sólo dejar el paquete indicado
	contains_package="`dpkg -l | grep -w " $namepackage " | awk '{for(i=1; i<=NF; ++i) if(i!=1 && i!=4) printf "%s ", $i; print ""}'`"		
	
	for user in contains_package; do
		if [ "${#contains_package}" -ne 0 ]; then			# El paquete existe y está instalado
			onlypackage=$(echo "$contains_package" | grep "^$namepackage\>")
			echo "$onlypackage"

		else 				
			#route=`$(echo pwd)`									
			#searchpackage=`apt-get install --download-only $namepackage | tee $route/log.txt`	 			
			#view=$(cat $route/log.txt)
			#echo $view
			searchpackage=`apt list 2>/dev/null | cut -d" " -f1 | grep $namepackage`
			if [ "${#searchpackage}" -ne 0 ]; then									# El paquete existe pero no está instalado
				echo "El paquete existe, su nombre concreto es: "
				echo "$searchpackage"
			else																	# El paquete no existe
				echo "El paquete $namepackage no está en el repositorio de Linux"
			fi
		fi

	done
else
	echo $usage
fi