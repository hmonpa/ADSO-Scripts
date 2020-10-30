#!/bin/bash
p=0
t=0
time=0
usage="Usage: BadUsers.sh [-p]"
usage2="Usage: BadUsers.sh [-t] [time (d/m/a)]"

# Detecciones de parametros: sin parametros, -p y -t
if [ $# -ne 0 ]; then
    if  [ $# -ge 1 ]; then
        if [ $1 == "-p" ]; then 
        	p=1
	elif  [ $1 == "-t" ] && [ $# -ne 2 ]; then
		echo $usage2; exit 1 
	elif  [ $1 == "-t" ] && [ $# -eq 2 ]; then
        t=1
		aux=$2

		# Pasar meses a dias (se asume que 1 mes = 30 dias)
		if [ ${aux: -1} == "m" ]; then
			time=$((${aux%"m"} * 30))

		# Pasar años a dias (se asume que 1 año = 365 días)
		elif [ ${aux: -1} == "a" ]; then
			time=$((${aux%"a"} * 365))

		# Simplemente dias
		else
			time=${aux%"d"}
		fi
			
	else
        echo $usage; exit 1
    fi
    fi
fi

for user in `cat /etc/passwd | cut -d: -f1`; do
    home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
    
    if [ -d $home ]; then
		num_fich=`find $home -type f -user $user | wc -l`
		# hace find de los archivos de tipo f de la variable user
		# wc -l cuenta el número de líneas
    else
		num_fich=0
    fi
 
    if [ $num_fich -eq 0 ] ; then
	
	if [ $p -eq 1 ]; then 					# Si hay flag -p
 
	   user_proc=`ps -u $user --no-headers | wc -l` 
 	    
	   if [ $user_proc -eq 0 ]; then
	        echo "$user"
	   fi

	
	elif [ $t -eq 1 ]; then					# Si hay flag -t

		user_print=0
		user_proc2=`lastlog -u $user -t $time | sed 1d | wc -l`
		
		# Comprobamos que no ha iniciado sesión en la franja de tiempo $time

		if [ $user_proc2 -eq 0 ]; then
			user_print=1
			echo "$user"
		fi
		
		# Para no sacar por pantalla dos veces el mismo usuario usamos user_print
		# La condicion de abajo comprobamos la modificacion de archivos en un intervalo de tiempo

		if [ $user_print -eq 0 ]; then
			num_fich=`find $home -type f -user $user -mtime $time | wc -l`
			if [ $num_fich -eq 0 ]; then
				echo "$user"
			fi
		fi
	
	
	else									# Si no hay ningun flag
	   echo "$user"	
	fi
    fi
done
