#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

@author: aso
"""

# El script debe sacar por pantalla, para cada interfície de red activa, su nombre y los paquetes transmitidos. Además, al final del todo el total de paquetes transmitidos.

#!/bin/bash

usage="Usage: net-out.sh"

import subprocess as sp
import sys

def run_command(command):
    process = sp.Popen(command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    retcode = process.wait()
    if retcode != 0:
        raise Exception("Problem running command: " + command)
    stdout, stderr = process.communicate()
    return stdout.decode('UTF-8').rstrip()


#interfaces=`ifconfig | cut -d" " -f1`
#packets=`ifconfig | grep TX | grep packets | cut -d" " -f11`

def mostra():
    
    interfaces = run_command("ifconfig | cut -d' ' -f1").splitlines()
    packets = run_command("ifconfig | grep TX | grep packets | cut -d' ' -f11").splitlines()
    
    packs = []

    for linea in packets:
        packs.append(int(linea))
	
    i = 0

    for inter in interfaces:
        if inter != "":
            print(inter+" "+str(packs[i]))
            i = i + 1

    suma = int(0)
    #max = len(packs)
    
    for e in packs:
    	suma = suma + e
    
    print("Total: "+str(suma))

# Sólo es válido con cero o un parámetro
if len(sys.argv) == 1:
	mostra()
elif len(sys.argv) == 2:
	t = sys.argv[1]
	while (True):
		mostra()
		run_command("sleep t")