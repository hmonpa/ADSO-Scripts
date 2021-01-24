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

#-----------------------------------MAIN---------------------------------------------------------
'''Para que se copie el prompt general para todos tienes que ser root y hacer cp -r /etc/skel/. [ruta de usuario]. De esta manera se crearan los archivos .profile y bashrc predeterminados para cada usuario.'''

if sys.argv[3]=='PO' and len(sys.argv) != 6:
	print ('Un usuario de tipo PO ha de pertenecer a PO, SM y ED')
	print ('Usage: python ./altauser.py [nom_usuario] [directorio] [grupo1 grupo2 ...]')
elif sys.argv[3]=='SM' and len(sys.argv) != 5:
	print ('Un usuario de tipo SM solo puede pertenecer a SM y ED')
	print ('Usage: python ./altauser.py [nom_usuario] [directorio] [grupo1 grupo2 ...]')
elif sys.argv[3]=='ED' and len(sys.argv) != 4:
	print ('Un usuario de tipo ED sólo puede pertenecer a su propio grupo')
	print ('Usage: python ./altauser.py [nom_usuario] [directorio] [grupo1 grupo2 ...]')
else:
	user = sys.argv[1]
	directorio = sys.argv[2]
	grupo1 = sys.argv[3]

	if grupo1 == 'PO' and sys.argv[4] == 'SM' and sys.argv[5] == 'ED':	# Es un PO
		os.mkdir('/home/PO/PO'+directorio)
		run_command('useradd '+user+' -m -s /bin/bash -d /home/PO/PO'+directorio)
		run_command('usermod -a -G PO,SM,ED '+user)
		run_command('chown '+user+' /home/PO/PO'+directorio)
		run_command('chgrp '+grupo1+' /home/PO/PO'+directorio)
		run_command('cp -r /etc/skel/. /home/ED/ED'+directorio+'/')
		run_command('chmod 750 /home/PO/PO'+directorio)

		f = open('/home/ED/ED'+directorio+'/.profile','w+')
		f.write('umask 000')
		f.close()

	elif grupo1 == 'SM' and sys.argv[4] == 'ED':				# Es un SM
		os.mkdir('/home/SM/SM'+directorio)
		run_command('useradd '+user+' -m -s /bin/bash -d /home/SM/SM'+directorio)
		run_command('usermod -a -G SM,ED '+user)
		run_command('chown '+user+' /home/SM/SM'+directorio)
		run_command('chgrp '+grupo1+' /home/SM/SM'+directorio)
		run_command('cp -r /etc/skel/. /home/ED/ED'+directorio+'/')
		run_command('chmod 750 /home/SM/SM'+directorio)

		f = open('/home/ED/ED'+directorio+'/.profile','w+')
		f.write('umask 000')
		f.close()
	elif grupo1 == 'ED':
		os.mkdir('/home/ED/ED'+directorio)
		run_command('useradd '+user+' -m -G ED -s /bin/bash -d /home/ED/ED'+directorio)
		run_command('chown '+user+' /home/ED/ED'+directorio)
		run_command('chgrp '+grupo1+' /home/ED/ED'+directorio)
		run_command('cp -r /etc/skel/. /home/ED/ED'+directorio+'/')
		run_command('chmod 750 /home/ED/ED'+directorio)

		f = open('/home/ED/ED'+directorio+'/.profile','w+')
		f.write('umask 000')
		f.close()

	print('Usuario '+user+' creado, deberás crear tu propia contrasena.')
