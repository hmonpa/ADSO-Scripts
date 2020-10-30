# El script debe calcular el espacio utilizado por cada usuario del sistema
# Si sobrepasa el espacio pasado en el parámetro [max_permès], se tendrá que escribir un mensaje en el .profile del usuario en cuestión
# para informarle de que debe borrar o comprimir algunos de sus ficheros
#!/bin/bash

# Variables globales

usage="Usage: ocupacio.sh [max_permès]"
# Sólo es válido con un parámetro
if [ $# -eq 1 ]; then
    tamany=$1
    #echo ${tamany: -1} 
    #echo $((${tamany%"G"}))
    
    # afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de l'usuari
    for user in `cat /etc/passwd | cut -d: -f1`; do 
        home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
        if [ -d $home ]; then
            # hace find de los usuarios de la variable $home, que tienen archivos de tipo f en la variable user
            # wc -l cuenta el número de líneas

            if [ ${tamany: -1} == "G" ]; then
                #echo "$tamany"
                ocupacio=`du -hs $user | cut -f1`          # Gigabytes
                echo $ocupacio
            elif [ ${tamany: -1} == "M" ]; then
                ocupacio=`du -ms $user | cut -f1`          # Megabytes

            elif [ ${tamany: -1} == "K" ]; then
                ocupacio=`du -ks $user | cut -f1`          # Kilobytes

            else
                ocupacio=`du -bs $user | cut -f1`          # Bytes
            fi
            #echo $ocupacio
            if [ $ocupacio >= $((${tamany%"G"})) ]; then
                echo "hola"
                #echo "$user $ocupacio ${tamany: -1}"
            fi

            #echo "$user"
        fi
   
    done
else
    echo $usage; exit 1
fi

