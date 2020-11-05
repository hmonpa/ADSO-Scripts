# El script debe sacar por pantalla, para cada interfície de red activa, su nombre y los paquetes transmitidos. Además, al final del todo el total de paquetes transmitidos.

#!/bin/bash

usage="Usage: net-out.sh"

#interfaces=`ifconfig | cut -d" " -f1`
#packets=`ifconfig | grep TX | grep packets | cut -d" " -f11`

mostra() {
	p=0
	declare -a packs
	while IFS= read -r line || [[ -n "$line" ]]; do
		#echo "$line"
		packs[$p]="$line"
		p=$(($p+1))
	done < <(ifconfig | grep TX | grep packets | cut -d" " -f11)

	i=0
	espacio=""
	while IFS= read -r int || [ -n "$int" ]; do
		if [[ "$int" != "$espacio" ]]; then
			#inter[$i]=$int
			echo "$int ${packs[$i]}"
			i=$(($i+1))
		fi
	done < <(ifconfig | cut -d" " -f1)

	suma=0
	for e in "${packs[@]}"; do
		suma=$(("$suma"+"$e"))
	done

	echo "Total: $suma"
}

# Sólo es válido con cero o un parámetro
if [ $# -eq 0 ]; then
	mostra
elif [ $# -eq 1 ]; then
	t=$1
	while true; do
		mostra
		sleep $t
	done
fi

