import subprocess
cmd = ['perl', 'InitialState']
process = subprocess.Popen(cmd,  stdout=subprocess.PIPE)
process.wait()
print process.returncode
#for line in iter(process.stdout.readline, b''): print line
print process.stdout.read()
initialState = process.stdout.read()

#todo
#modify the perl script to find initial state in a format for prolog


#now tell prolog to find the plan
cmd = ['swipl', '-s', 'gitplanner.pl']
process = subprocess.Popen(cmd,  stdout=subprocess.PIPE)
process.wait()
print process.returncode
print process.stdout.read()


