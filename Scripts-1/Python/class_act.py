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
if len(sys.argv) != 3:
	print ('Usage: python ./class_act.py [ndies] [nom_usuario]')
else:
	#Declaramos los diferentes argumentos como variables del programa
	time=str(sys.argv[1])
	user=sys.argv[2]
	peso_final=0.0
	contador=0
	
	#Buscamos el nick de usuario. Si el usuario no tiene nombre, sacara el mismo nick.
	usernick = run_command("cat /etc/passwd | grep '"+ user +"' | cut -d: -f1")
	# Buscamos los ficheros de ese usuario que haya modificado.
	if usernick != "root":
		for fich in run_command("find /home/"+usernick+" -type f -user "+ usernick +" -mtime "+time).splitlines():
			#contador nos cuenta el numero de ficheros modificados
			contador=contador+1
			peso=run_command("du -bs "+ fich +" | cut -f1")

			#vamos sumando lo que ocupa cada archivo para saber la ocupacion final.
			peso_final=peso_final+int(peso)
	else:
		for fich in run_command("find /"+usernick+" -type f -user "+ usernick +" -mtime "+time).splitlines():
			#contador nos cuenta el numero de ficheros modificados
			contador=contador+1
			peso=run_command("du -bs "+fich+" | cut -f1")

			#vamos sumando lo que ocupa cada archivo para saber la ocupacion final.
			peso_final=peso_final+int(peso)
		
	#En este punto pasamos a hacer las conversiones para que nos saque las magnitudes adecuadas.
	if peso_final > 1000:
		#Comprobamos que podamos pasar a KB.
		peso_final=peso_final/1000
		peso_final=  round(peso_final, 2)
		if peso_final > 1024:
		#Comprobamos que podamos pasar a MB.
			peso_final=peso_final/1024
			peso_final=  round(peso_final, 2)
			if peso_final > 1024:
			#Comprobamos que podamos pasar a GB.
				peso_final=peso_final/1024
				peso_final=  round(peso_final, 2)
				print (user +" ("+ usernick +") "+ str(contador) +" ficheros modificados que ocupan "+ str(peso_final) +" GB")
			else:
				print (user +" ("+ usernick +") "+ str(contador) +" ficheros modificados que ocupan "+ str(peso_final) +" MB")
		else:
			print (user +" ("+ usernick +") "+ str(contador) +" ficheros modificados que ocupan "+ str(peso_final) +" KB")
	else:
		print (user +" ("+ usernick +") "+ str(contador) +" ficheros modificados que ocupan "+ str(peso_final) +" B")
