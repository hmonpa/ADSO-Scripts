#!/bin/bash

# Es vol fer un script security.sh que detecti quant usuaris hi han al sistema amb
# privilegis de root. Per saber-ho , es necessari mirar el fitxer de passwords i comprovar
# quants usuaris pertanyen a l’usuari amb UID= 0 (superusuari)

usage="Usage ./security.sh"

if [ $# -eq 0 ]; then						# Num argumentos ha de ser 0 (no se le pasa nada a este script)
	n_superusers=`cat /etc/passwd | grep -w 0 | cut -d: -f3 | wc -l`
	

	n_superusers=$((${n_superusers}-1))		# Restamos el usuario root
	echo "Nom de supersuaris es $n_superusers format per:"

	noms_superusers=`cat /etc/passwd | grep -w 0 | cut -d: -f1`
	for user in $noms_superusers; do
		if [ $user != "root" ]; then
			echo $user
		fi
	done

else
	echo $usage
fi