#!/bin/bash

# Es vol comprovar quan un usuari executa un programa determinat. Per aixo es demana fer
# un script en bash que mostri cada cert temps el numero de processo que està executant
# l'usuari. Quan l'usuari executi el programa determinat com a paràmetre d'entrada, el script ha
# de finalitzar mostrant l'hora de finalització.

# Cada cierto tiempo en mi caso serán 2 segundos

# b) Realitza el script en bash
usage="Usage ./execute.sh proces"

if [ $# -eq 1 ]; then
	user=`whoami`
	#echo $user
	proces=$1
	id_proces=`ps -u $user | grep "$proces" | awk '{print $1}'`
	h=`date +"%H:%M"`
	if [ "${#id_proces}" -eq 0 ]; then
	 	watch -n 2 -g 'ps -u $user | grep '$proces'; ps -u $user --no-headers | wc -l'
	 	echo "El proceso $proces se ha empezado a ejecutar a las $h"
	else
		echo "Proceso $proces actualmente en ejecución"
	fi
else
	echo $usage; exit 1
fi

# # a) Explica amb format pseudocodi com faràs el script
# Si (NumElementos == 1){
# 	DetecciónUsuario
# 	Proceso = Arg1
# 	Id_Proceso = PID del proceso pasado por parámetro
# 	h = Hora actual
# 	Si (proceso pasado por parámetro no se está ejecutando)
# 		MostrarCada2Seg NumProcesosUsuario y ComprobarLaNoEjecuciónProceso
# 		(... cuando hay un cambio en esta comprobación, deja de MostrarCada2Seg)
# 		Imprime que el proceso se ha empezado a ejecutar a la hora actual
# 	Si no
# 		El proceso pasado por parámetro ya está en ejecución
# }
# Si no{
# 	ImprimeUsoCorrectoScript
# }