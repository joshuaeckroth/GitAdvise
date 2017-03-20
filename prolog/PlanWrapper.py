import subprocess
cmd = ['perl', 'InitialState']
process = subprocess.Popen(cmd,  stdout=subprocess.PIPE)
process.wait()
#print process.returncode
#for line in iter(process.stdout.readline, b''): print line
#print process.stdout.read()
initialState, readableState = process.stdout.read().split("||||||")
if initialState == "":
	print "No files have a status, this is currently unsupported"
	quit()

#todo
#modify the perl script to find initial state in a format for prolog
#initial state grabbed

#show the initial state to the user, and ask for a goal
print "Initial File States:\n" + readableState + "\n"
print "A goal state looks like this:"
print "state('file', state), state('file2', state2)"
print "Right now, not explicitly specifying goal states for all files may lead to unwanted results\n"
print "Specify Goal State:"

goalState = raw_input()

planArgument = "findplanexternal([" + initialState + "], [" + goalState + "], FinalRepo, FinalActions)"
#print planArgument
#now tell prolog to find the plan
#example call
#swipl -s gitplanner.pl -t "findplan([state('a.txt', untracked)], [state('a.txt', addedToIndex)], FinalRepo, FinalActions)" --quiet

cmd = ['swipl', '-s', 'gitplanner.pl', '-t', planArgument, '--quiet']
process = subprocess.Popen(cmd,  stdout=subprocess.PIPE)
process.wait()
#print process.returncode
#print process.stdout.read()
plan = process.stdout.read()
print
print "Plan:"
print plan,

