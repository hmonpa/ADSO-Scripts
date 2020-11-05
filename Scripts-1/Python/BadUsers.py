import subprocess as sp
import sys
import os


def run_command(command):
    process = sp.Popen(command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    retcode = process.wait()
    if retcode != 0:
        raise Exception("Problem running command: " + command)
    stdout, stderr = process.communicate()
    return stdout.decode('UTF-8').rstrip()

p = 0
t = 0
time = 0
usage = "Usage: BadUsers.sh [-p]"
usage2 = "Usage: BadUsers.sh [-t][time (d/m/a)]"

if len(sys.argv) != 0 and len(sys.argv) >= 2:
    if sys.argv[1] == "-p":
        p = 1
    elif sys.argv[1] == "-t" and len(sys.argv) != 3:
        print(usage2)
        exit(1)
    elif sys.argv[1] == "-t" and len(sys.argv) == 3:
        t = 1
        aux = sys.argv[2]
        if aux[-1] == "m":
            time = int(aux[0 : -1]) * 30
        elif aux[-1] == "a":
            time = int(aux[0 : -1]) * 365
        else:
            time = int(aux[0 : -1])
    else:
        print(usage)
        exit(1)
for user in run_command("cat /etc/passwd | cut -d: -f1").splitlines():
    home = run_command("cat /etc/passwd | grep '^" + user + "\>' | cut -d: -f6")
    if str(os.path.exists(home)) == "True":
        num_fich = run_command("find " + home + " -type f -user " + user + " | wc -l")
    else:
        num_fich = 0
    if int(num_fich) == 0:
        if p == 1:
            user_proc = run_command("ps -u" + user + "--no-headers | wc -l")
            if int(user_proc) == 0:
                print(user)
        elif t == 1:
            user_print = 0
            user_proc2 = run_command("lastlog -u " + user + " -t " + str(time) + " | sed 1d | wc -l")
            if int(user_proc2) == 0:
                user_print = 1
                print(user)
            if user_print == 0:
                num_fich = run_command("find " + home + " -type f -user " + user + " -mtime " + str(time) + " | wc -l")
                if int(num_fich) == 0:
                    print(user)
        else:   
            print(user)
