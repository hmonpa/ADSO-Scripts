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

usage="Usage: ocupacio.sh [max_permès (K/M/G)]"
# Programa
if len(sys.argv) != 2 and (len(sys.argv) != 4):
    print(usage)
    exit()
elif len(sys.argv) == 2:        # Sólo hay un parámetro
    tamany=sys.argv[1]
    #letra=tamany[0:-1])
    letra=tamany[-1]
    valor=tamany[0:-1]
    #print(letra)
    if letra == "G":
        max = int(valor)*1000*1024*1024
        #print(max)
    elif letra == "M":
        max = int(valor)*1000*1024
    elif letra == "K":
        max = int(valor)*1000
    elif letra == "B":
        max = int(valor)
    else:
        print(usage)

    passwd = run_command("cat /etc/passwd | cut -d: -f1").splitlines()
    
    for user in passwd:
        home = run_command("cat /etc/passwd | grep '^" + user + "\>' | cut -d: -f6")
        #print(home)
        if str((os.path.exists((home)))) == "True":
            print(passwd)
            ocupacio = run_command("du -bs" + home + "2>/dev/null | cut -f1")
            
            if int(ocupacio) > 0:   ### PETA AQUI
                if ocupacio >= max:
                    print("hola que tal")  

    exit()
#elif len(sys.argv) == 3:        # Tres parámetros