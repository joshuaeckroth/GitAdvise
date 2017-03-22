import subprocess

#run the perl script and get its output
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

#show the initial state to the user, and ask for a goal or ask to read from file
print "Initial File States:\n" + readableState + "\n"
print "A goal state looks like this:"
print "state('file', state), state('file2', state2)"
print "Right now, not explicitly specifying goal states for all files may lead to unwanted results\n"

#ask about using the goal file
print "Use goal file to load goal state(yes/no)?"
response = ''
while response != "yes" and response != "no":
	response = raw_input()	

#load goal state or ask for it depending on response
goalState = ''
if response == "yes":
	#file actions here
	file = open("GoalState", "w+", 0)
	#process to do here
	#go through each line in the user readable state,
	#count the length of each line
	#find the longest line, and pad the 
	#file header to that length
	#example file header in GoalState_template
	#once this is done, assemble the user readable data
	#into the header format, then check the header
	#just made with the existing header in the file,
	#if they match, the repo status hasn't changed since
	#the last run, if it has changed, update the file

	#copy all lines below the header, replace the file,
	#then reinsert the copied  lines back into the file

	print file.name
	print "Goal file not supported yet"
	quit()
else:
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
if plan == "":
	print "Plan error, unable to acheive goal"
	quit()
if plan == "[]\n":
	print "Goal state is equal to initial state"
	quit()


