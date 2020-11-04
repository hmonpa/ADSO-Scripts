# Primer script en Bash
#!/bin/bash
p=0                                 # Variables globales

usage="Usage: BadUsers.sh [-p]"
# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p
if [ $# -ne 0 ]; then               # Si núm de parámetros diferente a 0
    if  [ $# -eq 1 ]; then          # Si Núm de parámetros igual a 1
        if [ $1 == "-p" ]; then     # Si parámetro 1 coincide con p   (El parámetro 0 es el propio script)
            p=1
        else
            echo $usage; exit 1     # Printea la variable usage por pantalla y sale del programa
        fi 	 
    else 
        echo $usage; exit 1
    fi
fi
echo "Usuaris invàlids: "
# afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de l'usuari
for user in `cat /etc/passwd | cut -d: -f1`; do 
    home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
    if [ -d $home ]; then
        num_fich=`find $home -type f -user $user | wc -l`
        # hace find de los usuarios de la variable $home, que tienen archivos de tipo f en la variable user
		# wc -l cuenta el número de líneas
    else
        num_fich=0
    fi
 
    if [ $num_fich -eq 0 ] ; then
        if [ $p -eq 1 ]; then           # si usamos el comando -p, muestra sólo los usuarios completamente invalidos

# afegiu una comanda per detectar si l'usuari te processos en execució, 
# si no te ningú la variable $user_proc ha de ser 0
            user_proc=`ps -u $user --no-headers | wc -l`
            
            if [ $user_proc -eq 0 ]; then
                echo "$user"
            fi
        else
            echo "$user"
        fi
    fi    
done
