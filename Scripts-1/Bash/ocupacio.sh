# El script debe calcular el espacio utilizado por cada usuario del sistema
# Si sobrepasa el espacio pasado en el parámetro [max_permès], se tendrá que escribir un mensaje en el .profile del usuario en cuestión
# para informarle de que debe borrar o comprimir algunos de sus ficheros
#!/bin/bash

# Variables globales

usage="Usage: ocupacio.sh [max_permès (K/M/G)]"
usage2="Usage2: ocupacio.sh -g users [max_permès (K/M/G)]"
# Sólo es válido con un parámetro
if [ $# -eq 1 ]; then		# Se pasa un sólo argumento
    tamany=$1
    if [ ${tamany: -1} == "G" ]; then			# Gigabytes
		max=$((${tamany%"G"}*1000*1024*1024))
		#magn="GB"
	elif [ ${tamany: -1} == "M" ]; then			# Megabytes
		max=$((${tamany%"M"}*1000*1024))
		#magn="MB"
	elif [ ${tamany: -1} == "K" ]; then         # Kilobytes
		max=$((${tamany%"K"}*1000))
		#magn="KB"
	elif [ ${tamany: -1} == "B" ]; then    		# Bytes
		max=${tamany%"B"}
		#magn="B"
	else
		echo $usage; exit 1
	fi

    # afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de l'usuari
    for user in `cat /etc/passwd | cut -d: -f1`; do 
        home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
        if [ -d $home ]; then
			ocupacio=`du -bs $home 2>/dev/null | cut -f1`
			if [ $ocupacio > 0 ]; then

				if [ $ocupacio -gt $max ]; then
					var=$(echo $home | cut -d/ -f2)			# Devuelve el home en caso de ser el directorio home del usuario

					d=`date +"%d/%m/%Y"`
					h=`date +"%H:%M"`

					if [ "${#var}" -ne 0 ]; then			# Detección de usuarios con nombre en blanco tras el cut

						if [ $var == "home" ]; then			# Directorio de usuarios (aso, hector, maria...)
							echo "\"$d - $h: ALERTA: Reduce el espacio en disco!\"" >> "$home/.profile"
							echo "\"$d - $h: Este mensaje es sólo informativo, puedes borrarlo sin problema.\"" >> "$home/.profile"
						elif [ $var == "root" ]; then		# Directorio de root (root)
							echo "Necesitas permisos de administrador, si no lo eres, ejecuta "sudo su" "
							roo=$("echo \"$d - $h: ALERTA: Root reduce el espacio en disco!\"" 2>/dev/null)  >> "$home/.profile"
							echo "$roo"
							echo "\"$d - $h: Este mensaje es sólo informativo, puedes borrarlo sin problema.\"" >> "$home/.profile"
	
						else								# Directorio de usuarios propios del sistema (dev, daemon, bin...)
							continue
						fi

					fi
				fi
            fi
            if (( $ocupacio <= $max )); then
				i=0
				b=1
				while (($i<3)) && (($b==1)); do
					#echo "ocupacio: while $ocupacio"
					if (( ($ocupacio/1024)>=1 )); then
						ocupacio=$(($ocupacio/1024))
						#echo "ocupacio: $ocupacio"
						i=$(($i+1))
						#echo "i: $i"
					else
						b=0
					fi
				done

				if [ $i -eq 0 ]; then
					magn="B"
				elif [ $i -eq 1 ]; then
					magn="KB"
				elif [ $i -eq 2 ]; then
					magn="MB"
				elif [ $i -eq 3 ]; then
					magn="GB"
				fi
                echo "$user $ocupacio $magn"
            fi

        fi
   
    done
# Parte extendida con opción -g para Grupos

elif [ $# -eq 3 ]; then							# Se pasan 3 argumentos

	tamany=$3			# arg 3
	group=$2			# arg 2
	ocupacio_group=0	# variable inicializada a 0

    if [ ${tamany: -1} == "G" ]; then			# Gigabytes
		max=$((${tamany%"G"}*1000*1024*1024))
		#magn="GB"
	elif [ ${tamany: -1} == "M" ]; then			# Megabytes
		max=$((${tamany%"M"}*1000*1024))
		#magn="MB"
	elif [ ${tamany: -1} == "K" ]; then         # Kilobytes
		max=$((${tamany%"K"}*1000))
		#magn="KB"
	elif [ ${tamany: -1} == "B" ]; then    		# Bytes
		max=${tamany%"B"}
		#magn="B"
	else
		echo $usage; exit 1
	fi

	if [ $1 == "-g" ]; then
		us=`cat /etc/group | grep "^$group" | cut -d: -f3`				# Extrae el ID del grupo 
		#echo "Id del grupo $group: $us"
		users=`cat /etc/passwd | grep -w $us | cut -d: -f1`				# Identifica a los usuarios del grupo
		#echo "Usuarios del grupo $group: $users"

		for user in $users; do 	
		home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`			# Directorio home para cada usuario
		#echo `file -i $home`
		if [ -d $home ]; then
		
			ocupacio=`du -bs $home 2>/dev/null | cut -f1`

			if [ $ocupacio > 0 ]; then
			ocupacio_group=$((ocupacio_group+ocupacio))	
			
				if [ $ocupacio_group -gt $max ]; then					# Si la ocupación del grupo es superior a la pasada como parámetro
					var=$(echo $home | cut -d/ -f2)						# Devuelve el home en caso de ser el directorio home del usuario
			
					d=`date +"%d/%m/%Y"`
					h=`date +"%H:%M"`
					
					if [ "${#var}" -ne 0 ]; then		# Detección de usuarios con nombre en blanco tras el cut

						if [ $var == "home" ]; then		# Directorio de usuarios (aso, hector, maria...)
							echo "\"$d - $h: ALERTA: Reduce el espacio de tu grupo en disco!\"" >> "$home/.profile"
							echo "\"$d - $h: Este mensaje es sólo informativo, puedes borrarlo sin problema.\"" >> "$home/.profile"
	
						elif [ $var == "root" ]; then	# Directorio de root (root)
							echo "Necesitas permisos de administrador, si no lo eres, ejecuta "sudo su" "
							roo=`echo \"$d - $h: ALERTA: Root reduce el espacio en disco!\" 2>/dev/null `  >> "$home/.profile"
							#echo $roo
							echo "\"$d - $h: Este mensaje es sólo informativo, puedes borrarlo sin problema.\"" >> "$home/.profile"
					
						else							# Directorio de usuarios propios del sistema (dev, daemon, bin...)
							continue
						fi
					fi 
				# Print para el primer caso (ocupación de grupo mayor a la pasada por teclado)
				echo "$tamany es inferior al tamaño del grupo $group, por tanto, se ha enviado un mensaje al .profile de $user"

				elif (( $ocupacio_group <= $max )); then				# Si la ocupación del grupo es superior a la pasada por parámetro
					i=0
					b=1
					while (($i<3)) && (($b==1)); do						# Bucle para determinar que nomenclatura printear
						if (( ($ocupacio_group/1024)>=1 )); then
							ocupacio_group=$(($ocupacio_group/1024))
							i=$(($i+1))
						else
							b=0
						fi
					done

					if [ $i -eq 0 ]; then
						magn="B"
					elif [ $i -eq 1 ]; then
						magn="KB"
					elif [ $i -eq 2 ]; then
						magn="MB"
					elif [ $i -eq 3 ]; then
						magn="GB"
					fi
					# Print para el segundo caso (ocupación de grupo menor a la pasada por teclado)
					echo $group $ocupacio_group $magn
				fi
			fi
		fi		
		done
	fi
else							# No se pasan 1 ni 3 argumentos
    echo $usage; exit 1
fi