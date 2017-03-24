import subprocess
import os.path

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

        #when reading the goal, convert all newlines into spaces

        #check if the file exists, if it doesn't, create it and
        #skip header check

        #check if file exists
        if os.path.isfile("GoalState"):
                #file exists, carry on
                file = open("GoalState", "r+", 0)
                goalHeader = ''
		numNewLines = 0 #count the number of lines that start with a newline
                for line in file:
                        if line[0] == "*":
                                goalHeader += line
                        else:
				if line[0] == "\n":
					numNewLines += 1
                                goalState += line

                #print goalState,
                #print goalHeader,

                #create header

                #find the longest filestate line, and see if it's longer than the longest hardcoded header line
                longestLength = 48
                for line in readableState.splitlines():
                        #print(line)
                        if len(line) > longestLength:
                                longestLength = len(line)
                        #print(longestLength)

                #add 2 to longest length to account for spaces to be added
                longestLength += 2

                newHeader = ''
                for i in range(0, longestLength+2): #add 2 to account for outer two *'s
                        newHeader += "*"
                newHeader += "\n"
                newHeader += "*" + "Initial File State:".center(longestLength) + "*" + "\n"

                #add status
                for line in readableState.splitlines():
                        newHeader += "*" + line.center(longestLength) + "*" + "\n"

                newHeader += "*" + " ".center(longestLength) + "*" + "\n"
                newHeader += "*" + "Write goal state below this header.".center(longestLength) + "*" + "\n"
                newHeader += "*" + "A goal state can look like:".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file1', status1), state('file2', status2)".center(longestLength) + "*" + "\n"
                newHeader += "*" + "and/or".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file1', status1),".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file2', status)".center(longestLength) + "*" + "\n"

                for i in range(0, longestLength+2): #add 2 to account for outer two *'s
                        newHeader += "*"
                newHeader += "\n"

                #print(newHeader)
                #print(goalHeader)
                #print(goalHeader[len(goalHeader)-1])

                #compare this header with the existing one
                if goalHeader == newHeader:
                        #headers are equal, nothing has changed, carry on with plan
                        #print("They ARE EQUAL")
                        goalState = goalState.replace("\n", " ")

                        #remove first n characters, were n is the number of lines that start with \n
                        goalState = goalState[numNewLines:]
                        #print(goalState)

                        #continue on to plan call

                else:
                        #headers are not equal, wipe file, insert new header, and reinsert previous goal state
                        #print("They are NOT EQUAL")

                        #reopen file in write only mode to wipe it
                        file.close()
                        file = open("GoalState", "w")
                        file.write(newHeader)
                        file.write(goalState)
                        file.close()

                        print("Goal file updated. Edit GoalState and re-run the planner.")
                        quit()
        else:
                #file doesn't exist, create it
                file = open("GoalState", "w", 0)
                #create header

                #find the longest filestate line, and see if it's longer than the longest hardcoded header line
                longestLength = 48
                for line in readableState.splitlines():
                        #print(line)
                        if len(line) > longestLength:
                                longestLength = len(line)
                        #print(longestLength)

                #add 2 to longest length to account for spaces to be added
                longestLength += 2

                newHeader = ''
                for i in range(0, longestLength+2): #add 2 to account for outer two *'s
                        newHeader += "*"
                newHeader += "\n"
                newHeader += "*" + "Initial File State:".center(longestLength) + "*" + "\n"

                #add status
                for line in readableState.splitlines():
                        newHeader += "*" + line.center(longestLength) + "*" + "\n"

                newHeader += "*" + " ".center(longestLength) + "*" + "\n"
                newHeader += "*" + "Write goal state below this header.".center(longestLength) + "*" + "\n"
                newHeader += "*" + "A goal state can look like:".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file1', status1), state('file2', status2)".center(longestLength) + "*" + "\n"
                newHeader += "*" + "and/or".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file1', status1),".center(longestLength) + "*" + "\n"
                newHeader += "*" + "state('file2', status)".center(longestLength) + "*" + "\n"

                for i in range(0, longestLength+2): #add 2 to account for outer two *'s
                        newHeader += "*"
                newHeader += "\n"
                file.write(newHeader)

                print "Goal file created. Edit GoalState and re-run the planner."
                quit()



        #for line in file:
        #       print line
        #print "Goal file not supported yet"
        #quit()
else:
        print "Specify Goal State:"
        goalState = raw_input()

planArgument = "findplanexternal([" + initialState + "], [" + goalState + "], FinalRepo, FinalActions, FinalExplanations)"
#print planArgument
#now tell prolog to find the plan
#example call
#swipl -s gitplanner.pl -t "findplan([state('a.txt', untracked)], [state('a.txt', addedToIndex)], FinalRepo, FinalActions, FinalExplanations)" --quiet

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



