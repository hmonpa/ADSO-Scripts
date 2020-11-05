#!/bin/bash

usage="Usage ./infouser.sh [usuario]"

#Comprobamos que el numero de argumentos sea 1.
if [ $# -ne 0 ]; then
	for user in `cat /etc/passwd | cut -d: -f1`;do

		# Condicion para que encuentre el usuario
		if [ $user == $1 ];then
			
			#Miramos que no sea root porque root de home es /root
			if [ $user != "root" ];then
				#Imprimimos toda la informacion del usuario.
				echo "Home: `cat /etc/passwd | grep "$user" | cut -d: -f6`"
				echo "Home size: `du -hs /home/$user | cut -f1`"
				echo -e "Other dirs: \c"

				#Comprueba los ficheros que tiene este usuario fuera de home
				for comp_ficheros in `ls /`;do
					contador_ficheros=`find . -type f -user $user | wc -l`
					if [ "$contador_ficheros" -gt 0 ];then
						echo -e "/$comp_ficheros \c"
					fi
				done
				echo -e "\nActive processes: `ps -u $user --no-headers | wc -l`"
				#Hacemos break para finalizar el bucle al encotrar el usuario.
				break				
			else
			#Imprimimos toda la informacion de root
				echo "Home: /root"
				echo "Home size: `du -hs /$user | cut -f1`"
				echo -e "Other dirs: \c"

				#Comprueba los ficheros que tiene este usuario fuera de home
				for comp_ficheros in `ls /`;do
					contador_ficheros=`find . -type f -user $user | wc -l`
					if [ "$contador_ficheros" -gt 0 ];then
						echo -e "/$comp_ficheros \c"
					fi
				done
				echo -e "\nActive processes: `ps -u $user --no-headers | wc -l`"
			fi
			#Hacemos break para finalizar el bucle al encotrar el usuario.
			break
		fi
	done	
else
	echo $usage
fi
