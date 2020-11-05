import subprocess as sp
import os
import sys

#Defimos una funcion encargada de enviar comandos para facilitar la programacion en Python.
def run_command(command):
    process = sp.Popen(command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    retcode = process.wait()
    if retcode != 0:
        raise Exception("Problem running command: " + command)
    stdout, stderr = process.communicate()
    return stdout.decode('UTF-8').rstrip()

######################################### MAIN ##################################################

#Comprobamos que el numero de argumentos sea 1.
if len(sys.argv) > 1:
	for user in run_command("cat /etc/passwd | cut -d: -f1").splitlines():

		# Condicion para que encuentre el usuario
		if user == sys.argv[1]:
			
			#Miramos que no sea root porque root de home es /root
			if user != "root":
				#Imprimimos toda la informacion del usuario.

				#Buscamos home del usuario
				encuentra_home = run_command("cat /etc/passwd | grep "+ user + " | cut -d: -f6")
				print ("Home: "+ encuentra_home)
				
				#Buscamos lo que ocupa el usuario
				home_size= run_command("du -hs /home/"+ user +" | cut -f1")
				print ("Home size: "+ home_size)

				#Comprueba los ficheros que tiene este usuario fuera de home
				c=""
				for comp_ficheros in run_command("ls /").splitlines():
					contador_ficheros=run_command("find . -type f -user "+ user +" | wc -l")
					if int(contador_ficheros) != 0:
						c=c+" /"+comp_ficheros

				print ("Other dirs:"+c)

				#Buscamos los procesos que se esten ejecutando
				busca_procesos=run_command("ps -u "+ user +" --no-headers | wc -l")
				print ("Active processes: "+ busca_procesos)
				#Hacemos break para finalizar el bucle al encotrar el usuario.
				break				
			else:
			#Imprimimos toda la informacion de root
				print ("Home: /root")

				#Calculo de size
				home_size= run_command("du -hs /"+user+" | cut -f1")
				print ("Home size: "+home_size)

				c=""
				#Comprueba los ficheros que tiene este usuario fuera de home
				for comp_ficheros in run_command("ls /").splitlines():
					contador_ficheros=run_command("find . -type f -user "+ user +" | wc -l")
					if int(contador_ficheros) != 0:
						c=c+" /"+comp_ficheros

				print ("Other dirs:"+c)
			
				#Mostramos los procesos que estan activos.
				procesos_activos= run_command("ps -u "+ user +" --no-headers | wc -l")
				print ("Active processes: "+ procesos_activos)
			#Hacemos break para finalizar el bucle al encotrar el usuario.
				break
else:
	print ('Usage ./infouser.sh [usuario]')
