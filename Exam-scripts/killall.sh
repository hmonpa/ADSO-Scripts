#!/bin/bash

# Aquest script elimina tots els processos que s’anomenen proces
# Utilitza la comanda kill -9 PID per matar un procés.

# b) Realitza el bash-script
usage="Usage ./killall.sh proces"
if [ $# -eq 1 ]; then
	proces=$1
	id_proces=`ps -A | grep "$proces" | awk '{print $1}'`
	
	if [ "${#id_proces}" -eq 0 ]; then
		echo "Este proceso no está ejecutandose, o no existe"; exit 1
	else 
		echo "Se procede a matar al proceso con PID $id_proces"
		echo "-----------------------------------------"
		kill -9 $id_proces 2>/dev/null 
	fi

	name_proces=`ps -A | grep "$proces" | awk '{print $1, $4}'`
	if [ "${#name_proces}" -eq 0 ]; then
		echo "Se ha matado al proceso correctamente"
	else
		echo "El proceso $id_proces aún sigue vivo: "
		echo $name_proces
	fi
else
	echo $usage
fi

# a) Explica amb format pseudocodi com faràs el script

# Si (NombreElems == 1){
# 	NomProces = Arg1
# 	PIDProces = Comando ps -A, filtrado por NomProces y cortado en la primera columna
# 	Si IdProces != 0 (Devuelve algo){
# 		Se avisa de que se va a matar al proceso IdProces por pantalla
#		MatarProceso()
# 		
# 	}
# 	Si no (IdProces no devuelve ningún argumento){
# 		Se muestra por pantalla que el proceso no se esta ejecutando
# 	}
# 	Finalmente,
# 	Si (Proceso no existe){
# 		Se muestra por pantalla que se le ha matado correctamente
# 	}
# 	Si no{
# 		Se vuelve a mostrar el PID y el nombre del proceso
# 	}
# }
# Si no{
# 	MostraUtilitzacioCorrecta
# }