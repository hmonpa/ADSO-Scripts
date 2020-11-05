# coding=utf-8
import subprocess as sp
import sys
import os


# Función run_command
def run_command(command):
    process = sp.Popen(command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    retcode = process.wait()
    if retcode != 0:
        raise Exception("Problem running command: " + command)
    stdout, stderr = process.communicate()
    return stdout.decode('UTF-8').rstrip()

################################ MAIN #################################################

# Sólo es válido con un parámetro

if len(sys.argv) == 1:		# Se pasa un sólo argumento
    tamany=sys.argv[1]
    #letra=tamany[0:-1])
    letra=tamany[-1]
    valor=tamany[0:-1]
    if letra == "G":
        maxim = int(valor)*1000*1024*1024
    elif letra == "M":
        maxim = int(valor)*1000*1024
    elif letra == "K":
        maxim = int(valor)*1000
    elif letra == "B":
        maxim = int(valor)
    else:
        print("Usage: ocupacio.sh [max_permès (K/M/G)]")

    # afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de l'usuari
    for user in run_command("cat /etc/passwd | cut -d: -f1").splitlines():
        home = run_command("cat /etc/passwd | grep '^" + user + "\>' | cut -d: -f6")
        if str((os.path.exists((home)))) == "True":
			ocupacio=run_command("du -bs "+ home +" 2>/dev/null | cut -f1")
			if int(ocupacio) > 0:
				if int(ocupacio) > maxim:
					var=run_command("echo "+ home+" | cut -d/ -f2")			# Devuelve el home en caso de ser el directorio home del usuario

					d=run_command("date +'%d/%m/%Y'")
					h=run_command("date +'%H:%M'")

					if len(var) == 0:			# Detección de usuarios con nombre en blanco tras el cut

						if var == "home":			# Directorio de usuarios (aso, hector, maria...)
							run_command("echo '\n'"+d+" - "+h+": ALERTA: Reduce el espacio en disco!\"' >> '$home/.profile'")
							run_command("echo '\n'"+d+" - "+h+": Este mensaje es sólo informativo, puedes borrarlo sin problema.\n' >> '$home/.profile'")
						elif var == "root":		# Directorio de root (root)
							print ("Necesitas permisos de administrador, si no lo eres, ejecuta "sudo su" ")
							roo=run_command("echo \n"+d+" - "+h+": ALERTA: Root reduce el espacio en disco!\n 2>/dev/null  >> '$home/.profile'")
							print roo
							run_command("echo \n"+d" - "+h+": Este mensaje es sólo informativo, puedes borrarlo sin problema.\n  >> '$home/.profile'")
	
				         	else:								# Directorio de usuarios propios del sistema (dev, daemon, bin...)
							continue

            if ocupacio <= maxim:
			i=0
			b=1
			while i<3 and b==1:
				#echo "ocupacio: while $ocupacio"
				if ocupacio/1024 >= 1:
					ocupacio=ocupacio/1024
					#echo "ocupacio: $ocupacio"
					i=i+1
					#echo "i: $i"
				else:
					b=0

			if i == 0:
				magn="B"
			elif i == 1:
				magn="KB"
			elif i == 2:
				magn="MB"
			elif i -eq 3:
				magn="GB"
                print (user+" "+ocupacio+" "+magn)

# Parte extendida con opción -g para Grupos

elif len(sys.argv) == 4:						# Se pasan 3 argumentos

	tamany=sys.argv[3]			# arg 3
	group=sys.argv[2]			# arg 2
	ocupacio_group=0	# variable inicializada a 0

        if tamany[-1] == "G":			# Gigabytes
		maxim=int(tamany[0:-1])*1000*1024*1024
		#magn="GB"
	elif tamany[-1] == "M":		# Megabytes
		maxim=int(tamany[0:-1])*1000*1024
		#magn="MB"
	elif tamany[-1] == "K":         # Kilobytes
		maxim=int(tamany[0:-1])*1000
		#magn="KB"
	elif tamany[-1] == "B":  		# Bytes
		maxim=int(tamany[0:-1])
		#magn="B"
	else:
		print ("Usage: ocupacio.sh [max_permès (K/M/G)]") 
		exit 1

	if sys.argv[1] == "-g":
		us=run_command("cat /etc/group | grep ^"+group+" | cut -d: -f3")				# Extrae el ID del grupo 
		#echo "Id del grupo $group: $us"
		users=run_command("cat /etc/passwd | grep -w "+us+" | cut -d: -f1")				# Identifica a los usuarios del grupo
		#echo "Usuarios del grupo $group: $users"

		for user in users:	
			home=run_command("cat /etc/passwd | grep ^"+user+"\> | cut -d: -f6")			# Directorio home para cada usuario
			#echo `file -i $home`
			if str((os.path.exists((home)))) == "True":
		
				ocupacio=run_command("du -bs "+home+" 2>/dev/null | cut -f1")

				if int(ocupacio) > 0:
					ocupacio_group=ocupacio_group+int(ocupacio)	
			
					if ocupacio_group > maxim:					# Si la ocupación del grupo es superior a la pasada como parámetro
						var=run_command("echo "+ home+" | cut -d/ -f2")						# Devuelve el home en caso de ser el directorio home del usuario
			
					d=run_command("date +'%d/%m/%Y'")
					h=run_command("date +'%H:%M'")
					
					if len(var) == 0:		# Detección de usuarios con nombre en blanco tras el cut

						if var == "home":		# Directorio de usuarios (aso, hector, maria...)
							run_command("echo '\n'"+d+" - "+h+": ALERTA: Reduce el espacio en disco!\"' >> '$home/.profile'")
							run_command("echo '\n'"+d+" - "+h+": Este mensaje es sólo informativo, puedes borrarlo sin problema.\n' >> '$home/.profile'")
	
						elif var == "root":	# Directorio de root (root)
							print ("Necesitas permisos de administrador, si no lo eres, ejecuta "sudo su" ")
							roo=run_command("echo \n"+d+" - "+h+": ALERTA: Root reduce el espacio en disco!\n 2>/dev/null  >> '$home/.profile'")
							print roo
							run_command("echo \n"+d" - "+h+": Este mensaje es sólo informativo, puedes borrarlo sin problema.\n  >> '$home/.profile'")
					
						else:						# Directorio de usuarios propios del sistema (dev, daemon, bin...)
							continue
				# Print para el primer caso (ocupación de grupo mayor a la pasada por teclado)
				print (tamany+" es inferior al tamaño del grupo "+group+", por tanto, se ha enviado un mensaje al .profile de "+user)

				elif ocupacio_group <= maxim:				# Si la ocupación del grupo es superior a la pasada por parámetro
					i=0
					b=1
					while i<3 and b==1:						# Bucle para determinar que nomenclatura printear
						if ocupacio_group/1024>=1:
							ocupacio_group=ocupacio_group/1024
							i=i+1
						else:
							b=0

					if i == 0:
						magn="B"
					elif i == 1:
						magn="KB"
					elif i -eq 2:
						magn="MB"
					elif i -eq 3:
						magn="GB"
					# Print para el segundo caso (ocupación de grupo menor a la pasada por teclado)
					print (group+" "+ocupacio_group+" "+magn)

else:							# No se pasan 1 ni 3 argumentos
    print ("Usage: ocupacio.sh [max_permès (K/M/G)]"); exit 1
