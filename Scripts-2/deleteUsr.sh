#!/bin/bash

usage="Usage: deleteUsr.sh [usuari]"

if [ $# -ne 1 ]; then
	echo $usage
	exit 1
fi

chsh -s /usr/local/lib/no-login/desactiva.sh $1	# desactiva.sh es un tail script muy sencillo
echo "Se ha bloqueado el acceso al usuario $1"

if [ ! -d $HOME/backups ]; then
	mkdir $HOME/backups
fi 

dir_home=`cat /etc/passwd | grep "^$1\>" | cut -d: -f6`

if [ -d $dir_home ]; then
	tar -cvzf $HOME/backups/$1.tar.gz $dir_home
	rm -r $dir_home
else 
	echo "No existe el directorio $dir_home"
fi

find / -user $1 -exec rm -r "{}" \; 2> /dev/null

echo "eliminados todos los ficheros de $1"
